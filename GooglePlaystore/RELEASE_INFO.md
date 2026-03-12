# Google Play Store Release Information

This folder contains the necessary files and information for uploading the app to the Google Play Store.

## 📱 Build Information
- **App Version**: `1.2.8`
- **Build Number**: `23`

## ⚠️ Key Mismatch?
I've verified that the certificate in `/Users/yuvi/YDev/Publish/upload_cert.der` is a **perfect match** for the SHA1 fingerprint Google Play expects (`E8:DD...D7:B1`).

However, since we only have the public certificate (`.der`) and not the private key file (`.jks`), we must still request a reset.

### How to Reset:
1. Go to the **Google Play Console**.
2. Select your app -> **Setup** -> **App integrity**.
3. Go to the **App signing** tab.
4. Click **Request upload key reset**.
5. Upload the **new** `upload_certificate.pem` file found in `android/app/upload_certificate.pem` (NOT the `.der` file).

## 🔐 Signing Credentials

> [!IMPORTANT]
> **DO NOT LOSE THESE DETAILS.** You will need them for every future update to the Play Store.

- **Keystore File**: `android/app/upload-keystore.jks`
- **Alias**: `upload`
- **Store Password**: `password123`
- **Key Password**: `password123`

## 📦 Build Artifacts

- **App Bundle (AAB)**: `build/app/outputs/bundle/release/app-release.aab`
- **APK (for testing)**: `build/app/outputs/flutter-apk/app-release.apk`

## 🛠 Build Commands

To build a new production App Bundle, run:
```bash
export JAVA_HOME=/Users/yuvi/YDev/ND/AP/prv_p/jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH
flutter build appbundle --release
```

## 📝 Troubleshooting

If you lose this file or the keystore, you will need to request a key reset from the Google Play Console (if Play App Signing is enabled).
