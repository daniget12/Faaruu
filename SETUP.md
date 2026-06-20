# Baafata Faaruu — Setup Guide

## 1. Firebase Setup (Events Only)

### Step 1: Create Firebase Project
1. Go to https://console.firebase.google.com
2. Click "Add project" → name it `baafata-faaruu`
3. Disable Google Analytics (optional) → Create project

### Step 2: Add Android App
1. Click the Android icon in Firebase Console
2. Package name: `com.example.baafata_faaruu` (match your actual package name in android/app/build.gradle)
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

### Step 3: Enable Firestore
1. In Firebase Console → Firestore Database → Create database
2. Start in **production mode**
3. Choose a region closest to Ethiopia (e.g., `europe-west1`)

### Step 4: Enable Storage
1. Firebase Console → Storage → Get started
2. Start in production mode

---

## 2. Firestore Security Rules

Go to Firestore → Rules → Paste this:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /events/{eventId} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

---

## 3. Storage Security Rules

Go to Storage → Rules → Paste this:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /event_images/{imageId} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

---

## 4. Admin Guide — How to Post an Event

### Upload Event Image:
1. Firebase Console → Storage → `event_images/` folder
2. Click Upload → choose your image
3. After upload, click the image → copy the **Download URL**

### Create Event in Firestore:
1. Firebase Console → Firestore → `events` collection
2. Click "Add document" → Auto ID
3. Add these fields:

| Field       | Type      | Value                        |
|-------------|-----------|------------------------------|
| title       | string    | e.g. "Timkat Ayyaana"        |
| description | string    | Full description text        |
| imageUrl    | string    | Paste the Storage URL here   |
| date        | timestamp | Select the event date        |
| createdAt   | timestamp | Today's date                 |

4. Click **Save** — the event appears in the app immediately.

---

## 5. Flutter Project Setup

```bash
# Install dependencies
flutter pub get

# Run on connected Android device
flutter run

# Build release APK
flutter build apk --release
```

### android/build.gradle — add in dependencies:
```groovy
classpath 'com.google.gms:google-services:4.4.0'
```

### android/app/build.gradle — add at bottom:
```groovy
apply plugin: 'com.google.gms.google-services'
```

Also set minSdkVersion to 21:
```groovy
defaultConfig {
    minSdkVersion 21
    ...
}
```

### android/app/src/main/AndroidManifest.xml — add internet permission:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

---

## 6. Project Structure

```
lib/
├── main.dart
├── data/
│   └── mezmur_data.dart        ← 169 hymns, fully offline
├── models/
│   ├── mezmur.dart
│   ├── event.dart
│   └── note.dart
├── screens/
│   ├── home_screen.dart        ← bottom nav + mezmur list
│   ├── detail_screen.dart      ← full hymn text with font size control
│   ├── events_screen.dart      ← Firebase events feed
│   ├── notes_screen.dart       ← local notes list
│   ├── add_note_screen.dart    ← add/edit note
│   └── about_screen.dart       ← developer info + contacts
├── services/
│   └── firebase_service.dart   ← events stream only
├── db/
│   └── note_database.dart      ← SQLite for notes
└── widgets/
    └── mezmur_card.dart
```

---

## Features Summary

- **Mezmur tab**: 169 hymns, fully offline, searchable, sorted (Oromo A-Z first, then others)
- **Detail screen**: formatted text with indent/continuation markers, font size +/- buttons
- **Events tab**: Firebase stream, card UI, offline-friendly error message
- **Notes tab**: SQLite, swipe-to-delete, edit, persistent
- **About tab**: Telegram, phone, email buttons
