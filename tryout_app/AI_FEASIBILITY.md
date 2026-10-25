# TryOut On-Device AI Feasibility Gate

## Target
Android, 4 GB RAM, Flutter, no paid GPU inference server.

## Do not enable fake generation
The current UI deliberately does not pretend to generate a try-on image. A genuine model integration is a separate milestone.

## Required model audit
For each candidate, record:
- Repository URL, commit/tag, license for code and weights
- Whether commercial use and redistribution are allowed
- Model architecture and weight size
- Required framework/runtime and supported Android operators
- Input resolution and expected output
- Peak RAM including app, preprocessing, model weights, activations, and output tensors
- Actual inference time on a physical 4 GB RAM phone
- Thermal behavior and repeat-run stability
- Offline inference confirmation

## Candidate investigation
- Mobile-VTON: investigate official repository and paper; do not assume 4 GB feasibility from the word “mobile” or parameter count.
- DM-VTON and other distilled VTON projects: verify each exact repository and weight license before commercial use. Non-commercial-only licenses are not acceptable for a monetized app without separate written permission.
- LiteRT or ONNX Runtime Mobile may be considered only if the model architecture can be converted and supported operators are available. Conversion must be validated against original model outputs.

## Acceptance criteria
1. Real output depends on both supplied person and garment images.
2. No network request is required for inference.
3. Runs without out-of-memory errors on a physical 4 GB device.
4. Benchmark includes peak RAM, latency, output quality, and device details.
5. Commercial license review is documented.

If no candidate meets the requirements, report the blocker honestly rather than shipping a fake result.
