# trip

Create trip plan

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# 署名確認
## apkの確認
```shell
cd ~/Library/Android/sdk/build-tools/33.0.0
./apksigner verify --print-certs -v hoge.apk
```

## keystoreの確認
```shell
keytool -list -v -alias jozu_trip -keystore android/keystore/trip.jks
```

## ビルド

dummy_keyには、GoogleApiConsoleで作成したGoogleMap用のAPIキーを指定します。

### android
```
flutter build appbundle --dart-define=GOOGLE_API_KEY=dummy_key
```

### ios
```
flutter build ipa --dart-define=GOOGLE_API_KEY=dummy_key
```