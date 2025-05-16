# Firebase Authentication Setup Guide

## Prerequisites
- Flutter installed on your development machine
- A Firebase account
- This Flutter project

## Steps to Set Up Firebase Authentication

### 1. Create a Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click on "Add project"
3. Follow the prompts to create a new project
4. Once created, navigate to your new project dashboard

### 2. Register Your App with Firebase

#### For Android:
1. In the Firebase Console, click "Add app" and select Android
2. Enter your app's package name (found in `android/app/build.gradle` as `applicationId`)
3. Follow the remaining steps, including downloading the `google-services.json` file
4. Place the `google-services.json` file in the `android/app/` directory of your Flutter project

#### For iOS:
1. In the Firebase Console, click "Add app" and select iOS
2. Enter your app's Bundle ID (found in Xcode under the General tab of your project's target settings)
3. Follow the remaining steps, including downloading the `GoogleService-Info.plist` file
4. Open your Flutter project in Xcode by opening the `ios/Runner.xcworkspace` file
5. Drag the `GoogleService-Info.plist` file into the Runner directory in Xcode, ensuring "Copy items if needed" is checked
6. Update the `CFBundleURLSchemes` in `ios/Runner/Info.plist` with your Firebase client ID

### 3. Enable Authentication Methods
1. In the Firebase Console, navigate to "Authentication" from the left sidebar
2. Click "Get started" if prompted
3. Under "Sign-in method", enable "Email/Password"
4. Click "Save"

### 4. Initialize Firebase in Your App
This has already been done in the Flutter code by:
- Adding Firebase SDK dependencies in `pubspec.yaml`
- Initializing Firebase in `main.dart` with `Firebase.initializeApp()`
- Setting up authentication services in `lib/services/auth_service.dart`

### 5. Test Your Authentication
1. Run your Flutter app
2. Try signing up with a new email and password
3. Try logging in with the created credentials
4. Test the logout functionality

## Troubleshooting
- If you encounter any issues, check the Firebase documentation: https://firebase.flutter.dev/docs/overview
- Ensure all configuration files are in the correct locations
- Verify that you've enabled the Email/Password sign-in method in Firebase console

## Additional Resources
- [FlutterFire Documentation](https://firebase.flutter.dev/docs/overview)
- [Firebase Authentication Documentation](https://firebase.google.com/docs/auth) 