# TryOut Flutter App

A Flutter starter for the TryOut AI virtual try-on project.

## Current status
- Premium dark navy/purple UI starter.
- Home, Try On, My Looks and Profile tabs.
- Local camera/gallery image selection for person and garment photos.
- No remote inference or paid GPU server.
- **Real AI try-on is not integrated yet.** The Generate action intentionally explains this rather than fabricating an output.

## Requirements
- Flutter stable SDK compatible with Dart >=3.3
- Android Studio / Android SDK
- Physical Android device recommended for 4GB RAM benchmarking

## Run
```sh
cd tryout_app
flutter pub get
flutter analyze
flutter test
flutter run
```

## Next milestone
Audit candidate model code, pretrained weights, commercial-use licenses, Android runtime compatibility and peak memory. Do not enable generation until genuine inference has been validated on a physical 4GB Android phone.

Never commit signing keys, API secrets, private user photos, or model weights whose licenses prohibit redistribution.
