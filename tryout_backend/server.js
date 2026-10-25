import express from "express";

const app = express();
const port = Number(process.env.PORT || 8080);
const apiKey = process.env.FASHN_API_KEY;

app.disable("x-powered-by");
app.use(express.json({ limit: "35mb" }));

app.get("/health", (_req, res) => res.json({ ok: true, service: "tryout-vton" }));

app.post("/api/try-on", async (req, res) => {
  if (!apiKey) return res.status(503).json({ error: "AI provider is not configured on the server." });
  const { personImage, garmentImage } = req.body ?? {};
  if (typeof personImage !== "string" || typeof garmentImage !== "string" ||
      !personImage.startsWith("data:image/") || !garmentImage.startsWith("data:image/")) {
    return res.status(400).json({ error: "Send personImage and garmentImage as image data URIs." });
  }
  if (personImage.length > 30 * 1024 * 1024 || garmentImage.length > 30 * 1024 * 1024) {
    return res.status(413).json({ error: "Each image must be smaller than 30 MB." });
  }
  try {
    const start = await fetch("https://api.fashn.ai/v1/run", {
      method: "POST",
      headers: { Authorization: `Bearer ${apiKey}`, "Content-Type": "application/json" },
      body: JSON.stringify({
        model_name: "tryon-v1.6",
        inputs: {
          model_image: personImage,
          garment_image: garmentImage,
          mode: "balanced",
          num_samples: 1
        }
      })
    });
    const started = await start.json().catch(() => ({}));
    if (!start.ok || !started.id) {
      return res.status(start.status >= 400 && start.status < 600 ? start.status : 502)
        .json({ error: started.error || "AI provider could not start generation." });
    }

    const deadline = Date.now() + 150000;
    while (Date.now() < deadline) {
      await new Promise(resolve => setTimeout(resolve, 2500));
      const poll = await fetch(`https://api.fashn.ai/v1/status/${encodeURIComponent(started.id)}`, {
        headers: { Authorization: `Bearer ${apiKey}` }
      });
      const state = await poll.json().catch(() => ({}));
      if (!poll.ok) return res.status(502).json({ error: state.error || "Could not check AI generation status." });
      if (state.status === "completed" && Array.isArray(state.output) && state.output[0]) {
        return res.json({ imageUrl: state.output[0] });
      }
      if (state.status === "failed" || state.error) {
        return res.status(502).json({ error: state.error || "AI generation failed." });
      }
    }
    return res.status(504).json({ error: "Generation timed out. Please try again." });
  } catch (error) {
    console.error("Try-on request failed:", error?.message || error);
    return res.status(502).json({ error: "Could not reach the AI provider. Please try again." });
  }
});

app.listen(port, "0.0.0.0", () => console.log(`TryOut backend listening on ${port}`));
