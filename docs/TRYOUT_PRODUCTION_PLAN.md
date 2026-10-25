# TryOut — Production Build Plan

## Goal
Build TryOut as a Flutter Android app with a premium dark navy/black UI and purple-blue accents. Primary target: Android devices with 4 GB RAM. The product goal is genuine AI virtual try-on without paid GPU inference servers.

## Important feasibility gate
Do not claim on-device virtual try-on works until a real model produces a result on a physical 4 GB Android device. First audit model code, pretrained weights, runtime compatibility, RAM/latency, and licenses for commercial use. Do not use models or weights with non-commercial-only terms in a monetized app unless a separate commercial license is obtained.

## Milestones
1. Repository and Flutter project audit; preserve existing work and do not overwrite unrelated app files.
2. UI implementation: splash/onboarding, home, person photo picker/camera, garment picker, processing, result, styles, saved looks, save/share, profile/settings.
3. On-device AI proof of concept: compare Mobile-VTON and other candidates; verify commercial license and Android runtime compatibility. No fake or sample outputs.
4. 4 GB device benchmark: peak RAM, inference time, output quality, crashes/thermal behavior, offline inference.
5. Integrate the verified model into Flutter through a supported runtime/native Android bridge.
6. QA: permissions, image validation, low-memory handling, cancellation, accessibility, privacy, deletion, offline flow.
7. Release preparation: app icon/assets, versioning, signing instructions, Android App Bundle/APK build instructions, release checklist.

## Product constraints
- No paid GPU server or remote inference API.
- Keep user photos on-device for the core try-on workflow.
- Cloud sync, account, analytics and purchases are optional and must not be required for local inference.
- Never fake AI results. If the selected model cannot meet 4 GB device constraints, document the limitation and propose alternatives.
- Do not claim production-ready status until builds, tests and device benchmarks pass.

## Definition of done
- Flutter project builds successfully.
- Main UI screens are implemented consistently with the approved visual reference.
- Actual model inference is integrated and tested on a physical 4 GB Android phone, or the blocker is documented honestly.
- Automated tests and manual QA report are provided.
- Clear instructions are provided for building a signed release APK/AAB; signing secrets are never committed.
