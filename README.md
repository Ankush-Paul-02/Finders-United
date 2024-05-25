# Finders United

An app where users can report lost items and help others find them. The app uses geolocation and photo uploads to assist in the retrieval process, fostering a sense of community support.

## Features

- **Upload Found Items**: Users can upload details and images of found items.
- **Claim Lost Items**: Users can search and claim their lost items.
- **Chat Notifications**: Users receive chat notifications when a claim request is made.
- **Location Access**: The app uses geocoding and geolocation to provide precise location information for found items.
- **User Authentication**: Secure user authentication using Firebase.

## Technologies Used

- **Flutter**: The framework for building the app.
- **Firebase**: Backend services including authentication, real-time database, and storage.
- **Provider**: State management solution.
- **Geocoding & Geolocation**: For accessing and displaying location data.

## Getting Started

### Prerequisites

- Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
- Firebase Project: [Firebase Console](https://console.firebase.google.com/)
- Android Studio or Visual Studio Code: Recommended IDEs

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/your-repo/finders-united.git
   cd finders-united
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Set up Firebase:**
    - Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
    - Add an Android/iOS app to your Firebase project.
    - Download the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) and place them in the respective directories:
        - `android/app/google-services.json`
        - `ios/Runner/GoogleService-Info.plist`

4. **Configure Firebase in your Flutter project:**
   Ensure you have the following dependencies in your `pubspec.yaml`:

```yaml
name: finders_united
description: "An app where users can report lost items and help others find them. The app could use geolocation and photo uploads to assist in the retrieval process, fostering a sense of community support."
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.3.1 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  velocity_x: ^4.1.2
  sizer: ^2.0.15
  google_fonts: ^6.2.1
  provider: ^6.1.2
  lottie: ^3.1.0
  pinput: ^4.0.0
  firebase_core: ^2.30.1
  firebase_auth: ^4.19.4
  cloud_firestore: ^4.17.2
  firebase_storage: ^11.7.4
  image_picker: ^1.1.0
  permission_handler: ^11.3.1
  dotted_border: ^2.1.0
  geolocator: ^11.0.0
  http: ^1.2.1
  geocoding: ^3.0.0
  uuid: ^4.4.0
  shimmer: ^3.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
    - assets/animation/
```

### Running the App

1. **Run the app:**
   ```sh
   flutter run
   ```

2. **Build for release:**
   Follow the official Flutter documentation for [building and releasing your app](https://flutter.dev/docs/deployment).

## App Structure

```plaintext
lib/
├── main.dart
├── firebase_options.dart
├── core/
│   ├── common/
│   │   ├── common_row_item_info.dart
│   │   ├── custom_send_message_text_field.dart
│   │   ├── custom_text_field.dart
│   │   └── gradient_button.dart
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── database_constants.dart
│   └── utils/
│       ├── image_picker_util.dart
│       └── show_snack_bar.dart
├── feature/
│   ├── auth/
│   │   └── screen/
│   │       ├── login_screen.dart
│   │       └── otp_screen.dart
│   ├── bookmark/
│   │   └── screen/
│   │       └── bookmark_screen.dart
│   ├── chat/
│   │   └── screen/
│   │       ├── chat_screen.dart
│   │       └── chat_users_screen.dart
│   ├── home/
│   │   ├── screen/
│   │   │   ├── all_recent_items_screen.dart
│   │   │   ├── home.dart
│   │   │   ├── home_screen.dart
│   │   ├── widgets/
│   │   │   ├── custom_category_title_button.dart
│   │   │   ├── home_header.dart
│   │   │   └── recent_post_card.dart
│   ├── item/
│   │   └── screen/
│   │       ├── item_category_screen.dart
│   │       └── item_screen.dart
│   ├── models/
│   │   ├── message_model.dart
│   │   ├── user_model.dart
│   │   └── found_item_model.dart
│   ├── profile/
│   │   └── screen/
│   │       ├── profile_screen.dart
│   │       └── widgets/
│   │           └── profile_text_field.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── bottom_nav_bar_provider.dart
│   │   ├── chat_provider.dart
│   │   └── item_provider.dart
│   ├── search/
│   │   └── screen/
│   │       └── search_screen.dart
│   ├── splash/
│   │   └── screen/
│   │       └── splash_screen.dart
│   └── upload/
│       └── screen/
│           └── found_item_upload_screen.dart
```

## Firebase Configuration

Ensure your Firebase rules are set up correctly to allow authenticated users to read and write data.

### Firestore Rules

```json
service cloud.firestore {
  match /databases/{database}/documents {
    match /items/{item} {
      allow read, write: if request.auth != null;
    }
    match /users/{user} {
      allow read, write: if request.auth != null && request.auth.uid == user;
    }
  }
}
```

### Storage Rules

```json
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Usage

1. **Register/Login**: Users can register or log in using their email and password.
2. **Upload Found Items**: Users can upload items they have found with relevant details and images.
3. **Search and Claim**: Users can search for their lost items and make claim requests.
4. **Chat**: Once a claim request is made, users can chat to arrange the return of the item.

## Contact

If you have any questions or feedback, please feel free to reach out to us at ankushpaulclg2002@gmail.com.

## Acknowledgments

Created by Ankush Paul, organization Devmare by Ankush.

Thank you for using the Finders United app!