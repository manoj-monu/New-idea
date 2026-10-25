# TryOut On-Device AI — Feasibility Findings (2026-10-25)

## Goal
Flutter Android app, genuine virtual try-on running locally on the user's phone, no paid GPU server, commercial release possible.

## Confirmed target device
- OPPO Reno8 T 5G (model CPH2505), confirmed from the user's About device screenshot.
- Qualcomm Snapdragon 695 5G.
- 8 GB physical RAM + 8 GB RAM expansion (storage-backed virtual RAM; do not count as equivalent to physical RAM).
- 128 GB storage, about 119 GB used in the screenshot; free space is low and should be cleared before testing/downloading model assets.
- Target-device benchmark must be run on this exact device, not inferred from RAM figures alone.

## Candidate A — Mobile-VTON
- Official code: https://github.com/tmllab/2026_CVPR_Mobile-VTON
- The official repository states that code and checkpoints are under CC BY-NC-SA 4.0.
- This is non-commercial; do not ship in a monetized app without separate written permission.
- The paper's device demonstration uses Xiaomi 17 Pro Max / Snapdragon 8 Gen 5 / Hexagon NPU, and reports around 80 seconds for a 1024x768 output. This does not prove operation on generic Android phones.
- Supplement: https://openaccess.thecvf.com/content/CVPR2026/supplemental/Wan_Mobile-VTON_High-Fidelity_On-Device_CVPR_2026_supplemental.pdf

## Candidate B — FASHN VTON v1.5
- Model research page: https://fashn.ai/research/vton-1-5
- The model is published under Apache 2.0, which is commercially permissive subject to license obligations.
- However, published model information describes roughly 972M parameters / about 2GB of weights and consumer GPU inference. It is not established as a 4GB Android on-device model and is not a practical direct fit for this target without substantial research/porting.
- Do not treat it as mobile-ready just because its license allows commercial use.

## Decision
At this audit, no candidate is both verified as (a) commercially usable including weights/dependencies and (b) proven to run on a the OPPO Reno8 T 5G (Snapdragon 695, 8 GB physical RAM). Therefore do not wire in an unverified model or fabricate a result.

## Required next steps
1. Obtain written commercial permission for Mobile-VTON or find another fully commercially usable on-device VTON model.
2. Check all code, weights, base model, helper model, and data licenses.
3. Determine whether the full inference pipeline can be converted to a supported Android runtime (LiteRT / ONNX Runtime Mobile / native runtime) without losing required operators or quality.
4. Test on an the user's actual OPPO Reno8 T 5G: peak RAM, latency, thermal behavior, repeat runs, output quality, airplane-mode operation.
5. Integrate through a native Flutter platform channel only after these checks pass.

## Current app state
The Flutter starter has local person/garment photo selection and UI tabs. Real on-device inference is not integrated. The Generate action intentionally explains this limitation instead of displaying a fake result.


## Direction after device confirmation
The target is now the OPPO Reno8 T 5G, not a generic 4 GB RAM phone. Do not ship cloud API generation as the primary path because the user explicitly requires on-device inference. The recently added backend/API integration is only a separate experimental scaffold and is not evidence of local AI support.

The next viable engineering milestone is to identify a fully commercially licensed model and complete dependency/weight license audit, then test conversion/runtime compatibility for Snapdragon 695 (CPU/GPU/NPU support must be measured; do not assume NPU access). The device has only about 9 GB storage free in the screenshot, so free storage before attempting to download multi-GB weights or build artifacts. No on-device inference has yet been implemented or validated.
