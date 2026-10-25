# TryOut On-Device AI — Feasibility Findings (2026-10-25)

## Important result
The leading research candidate, Mobile-VTON, demonstrates on-device inference in its paper, but the official repository states that both code and checkpoints use **CC BY-NC-SA 4.0**. That is a non-commercial license and is not suitable for a monetized Play Store app without separate written permission from the rights holders.

Sources:
- Official repository: https://github.com/tmllab/2026_CVPR_Mobile-VTON
- Official README (license section): https://github.com/tmllab/2026_CVPR_Mobile-VTON/blob/main/README.md
- CVPR 2026 supplementary material describes testing on Xiaomi 17 Pro Max / Snapdragon 8 Gen 5, with about 80 seconds for a 1024x768 result: https://openaccess.thecvf.com/content/CVPR2026/supplemental/Wan_Mobile-VTON_High-Fidelity_On-Device_CVPR_2026_supplemental.pdf

## 4GB target warning
The published device result uses a flagship Snapdragon 8 Gen 5 / Hexagon NPU, not a generic 4GB RAM Android phone. It does **not** establish compatibility with the user's target devices. A physical-device benchmark is required.

## Current engineering decision
- Do not package Mobile-VTON weights or code into TryOut for commercial release unless written commercial permission is obtained.
- Do not use DM-VTON or another non-commercially licensed candidate in a monetized app without permission.
- Do not fake the try-on result.
- Keep the Generate button honest until a commercially usable model has passed a physical 4GB Android test.

## Next steps
1. Find a VTON model whose code and weights allow commercial use, or obtain written commercial permission for a suitable model.
2. Confirm Android runtime conversion support (LiteRT, ONNX Runtime Mobile, or a custom native runtime).
3. Benchmark model size, peak memory, inference latency, output quality, and thermal behavior on a real 4GB device.
4. Integrate the validated model behind a native Flutter platform channel.
5. Only then enable local generation and release testing.

## Current app state
The Flutter starter supports local photo selection and has UI tabs. Actual on-device virtual try-on inference is not integrated. The current message on Generate is intentional to avoid presenting a fake AI result as real.
