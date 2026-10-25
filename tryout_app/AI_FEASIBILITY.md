# TryOut On-Device AI — Feasibility Findings (2026-10-25)

## Goal
Flutter Android app, 4GB RAM target, genuine virtual try-on, no paid GPU server, commercial release possible.

## Candidate A — Mobile-VTON
- Official code: https://github.com/tmllab/2026_CVPR_Mobile-VTON
- The official repository states that code and checkpoints are under CC BY-NC-SA 4.0.
- This is non-commercial; do not ship in a monetized app without separate written permission.
- The paper's device demonstration uses Xiaomi 17 Pro Max / Snapdragon 8 Gen 5 / Hexagon NPU, and reports around 80 seconds for a 1024x768 output. This does not prove operation on generic 4GB RAM phones.
- Supplement: https://openaccess.thecvf.com/content/CVPR2026/supplemental/Wan_Mobile-VTON_High-Fidelity_On-Device_CVPR_2026_supplemental.pdf

## Candidate B — FASHN VTON v1.5
- Model research page: https://fashn.ai/research/vton-1-5
- The model is published under Apache 2.0, which is commercially permissive subject to license obligations.
- However, published model information describes roughly 972M parameters / about 2GB of weights and consumer GPU inference. It is not established as a 4GB Android on-device model and is not a practical direct fit for this target without substantial research/porting.
- Do not treat it as mobile-ready just because its license allows commercial use.

## Decision
At this audit, no candidate is both verified as (a) commercially usable including weights/dependencies and (b) proven to run on a physical 4GB Android phone. Therefore do not wire in an unverified model or fabricate a result.

## Required next steps
1. Obtain written commercial permission for Mobile-VTON or find another fully commercially usable on-device VTON model.
2. Check all code, weights, base model, helper model, and data licenses.
3. Determine whether the full inference pipeline can be converted to a supported Android runtime (LiteRT / ONNX Runtime Mobile / native runtime) without losing required operators or quality.
4. Test on an actual 4GB RAM Android phone: peak RAM, latency, thermal behavior, repeat runs, output quality, airplane-mode operation.
5. Integrate through a native Flutter platform channel only after these checks pass.

## Current app state
The Flutter starter has local person/garment photo selection and UI tabs. Real on-device inference is not integrated. The Generate action intentionally explains this limitation instead of displaying a fake result.
