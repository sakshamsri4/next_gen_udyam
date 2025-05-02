# Google Sign-In Setup Guide

This guide explains how to properly configure Google Sign-In for your Next Gen Udyam Flutter app.

## Prerequisites

- Firebase project created
- Flutter project set up with Firebase
- Android Studio or Command Line tools installed

## Steps to Configure Google Sign-In

### 1. Generate SHA-1 Certificate Fingerprint

#### Using Android Studio:

1. Open Android Studio
2. Click on "Gradle" in the right sidebar
3. Navigate to Tasks > android > signingReport
4. Double-click on signingReport
5. Look for the SHA-1 fingerprint in the output

#### Using Command Line (Mac/Linux):

```bash
cd android
./gradlew signingReport
```

#### Using Command Line (Windows):

```bash
cd android
gradlew signingReport
```

### 2. Add SHA-1 to Firebase Console

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click on the gear icon (⚙️) next to "Project Overview" and select "Project settings"
4. Go to the "Your apps" section
5. Select your Android app
6. Click "Add fingerprint"
7. Paste your SHA-1 fingerprint and click "Save"

### 3. Download Updated google-services.json

1. After adding the SHA-1 fingerprint, click "Download google-services.json"
2. Replace the existing google-services.json files in your project:
   - `android/app/google-services.json` (main)
   - `android/app/src/development/google-services.json` (development flavor)
   - `android/app/src/staging/google-services.json` (staging flavor)
   - `android/app/src/production/google-services.json` (production flavor)

### 4. Enable Google Sign-In in Firebase Console

1. In the Firebase Console, go to "Authentication"
2. Click on the "Sign-in method" tab
3. Find "Google" in the list and click "Edit"
4. Toggle the "Enable" switch to on
5. Add your support email
6. Click "Save"

### 5. Verify OAuth Client Configuration

After completing the steps above, check your google-services.json file. It should contain an OAuth client entry with client_type: 1 (Android client type). For example:

```json
"oauth_client": [
  {
    "client_id": "123456789-abcdefghijklmnopqrstuvwxyz.apps.googleusercontent.com",
    "client_type": 1,
    "android_info": {
      "package_name": "com.udyam.nextgen.next_gen.dev",
      "certificate_hash": "your_sha1_fingerprint_here"
    }
  },
  {
    "client_id": "123456789-abcdefghijklmnopqrstuvwxyz.apps.googleusercontent.com",
    "client_type": 3
  }
]
```

### 6. Test Google Sign-In

1. Run your app in development mode
2. Try signing in with Google
3. If you encounter any issues, check the logs for detailed error messages

## Troubleshooting

### Error Code 10

If you see "ApiException: 10", it typically means:
- SHA-1 fingerprint is missing in Firebase console
- Package name mismatch between app and Firebase configuration
- OAuth client configuration is incorrect

### Other Common Issues

1. **Multiple SHA-1 Fingerprints**: You may need different SHA-1 fingerprints for debug and release builds
2. **Package Name Mismatch**: Ensure the package name in your app matches the one in Firebase console
3. **Missing Dependencies**: Make sure all required dependencies are properly installed
4. **Web Configuration**: For web, ensure you've added the correct client ID in index.html

## Additional Resources

- [Firebase Authentication Documentation](https://firebase.google.com/docs/auth)
- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [Firebase Flutter Setup](https://firebase.google.com/docs/flutter/setup)
