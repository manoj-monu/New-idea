# TryOut virtual try-on backend

This server keeps the FASHN API key off the Android app and proxies real virtual try-on requests.

## Configure

- Node.js 20+
- Set `FASHN_API_KEY` as a server environment secret (never put it in Flutter or commit it).
- Deploy this service behind HTTPS on a production host.
- Set Flutter's `TRYOUT_API_BASE_URL` to the deployed HTTPS origin at build time.

## Endpoints

- `GET /health` — health check.
- `POST /api/try-on` — JSON body: `personImage` and `garmentImage` as image data URIs. Returns `{ "imageUrl": "..." }` after generation.

## Important production requirements

This is an integration scaffold, not a deployed production service. Before public release, add authenticated users, per-user rate limits and quotas, abuse protection, request timeouts, structured monitoring, and an explicit photo-consent/privacy flow. Do not log image payloads or API secrets. Configure the host's request-size and timeout limits to support image processing.

The API uses FASHN's `tryon-v1.6` model in balanced mode. Confirm the provider's current endpoint contract, credits, privacy/data-retention terms, and billing before launch.
