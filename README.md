<<<<<<< HEAD
<<<<<<< HEAD
# 🚕 SmartGo – Smart Transportation App

---

## COMPLETE FOLDER STRUCTURE

```
smartgo_app/
├── lib/
│   ├── main.dart                        ← App entry, auth router, splash
│   ├── constants/
│   │   └── app_constants.dart           ← Colors, theme, Supabase config
│   ├── models/
│   │   ├── user_model.dart              ← AppUser data class
│   │   ├── vehicle_model.dart           ← Vehicle data class
│   │   └── booking_model.dart           ← Booking data class
│   ├── services/
│   │   ├── supabase_service.dart        ← All DB operations (CRUD)
│   │   └── auth_provider.dart           ← Auth state (Provider)
│   ├── widgets/
│   │   └── widgets.dart                 ← BlueButton, TileCards, Inputs
│   └── screens/
│       ├── login_screen.dart            ← 🚕 + SmartGo + Phone + Login btn
│       ├── register_screen.dart         ← Create Account form
│       ├── home_screen.dart             ← Dashboard with all options
│       ├── location_screen.dart         ← Enter Locations screen
│       ├── select_vehicle_screen.dart   ← Available Vehicles list
│       ├── payment_screen.dart          ← Payment methods + UPI dialog
│       ├── booking_success_screen.dart  ← Confirmation screen
│       ├── my_bookings_screen.dart      ← Booking history
│       ├── sos_screen.dart              ← Emergency SOS
│       ├── feedback_screen.dart         ← Rate & review
│       └── profile_screen.dart          ← User profile & sign out
├── pubspec.yaml
└── supabase_schema.sql                  ← Complete DB schema + seed data
```

---

## TECHNOLOGY STACK

| Layer       | Technology              | Purpose                          |
|-------------|-------------------------|----------------------------------|
| Frontend    | Flutter 3.x             | Cross-platform mobile UI         |
| State Mgmt  | Provider                | Auth state management            |
| Backend     | Supabase                | Auth + REST API + Realtime       |
| Database    | PostgreSQL (Supabase)   | Users, Vehicles, Bookings, SOS   |
| Cloud       | Supabase Cloud          | Hosting, Auth, Storage           |
| Language    | Dart 3.x                | All Flutter code                 |

---

## DATABASE TABLES

| Table          | Columns                                        |
|----------------|------------------------------------------------|
| smartgo_users  | id, full_name, phone, service_type, experience |
| vehicles       | id, driver_name, phone, type, fare, available  |
| bookings       | id, user_id, vehicle_id, fare, payment, status |
| feedback       | id, user_id, message, rating                   |
| sos_alerts     | id, user_id, location, message, status         |

---

## STEP-BY-STEP SETUP & RUN GUIDE

---

### PHASE 1 — Extract the Project

1. Download and extract the ZIP file
2. Move the `smartgo_app` folder to your Desktop
3. Avoid paths with spaces (e.g. "My Projects")

---

### PHASE 2 — Install Flutter (one-time, ~20 minutes)

**Step 1:** Go to https://docs.flutter.dev/get-started/install  
**Step 2:** Choose your OS (Windows / macOS / Linux)  
**Step 3:** Download Flutter SDK zip  
**Step 4:** Extract to a permanent location:
- Windows: `C:\flutter`
- Mac: `/Users/YourName/flutter`

**Step 5 (Windows only) — Add to PATH:**
1. Search "Environment Variables" in Start Menu
2. System Variables → Path → Edit → New
3. Type: `C:\flutter\bin`
4. Click OK on all dialogs

**Step 6 — Verify:**
```bash
flutter --version
```
You should see: `Flutter 3.x.x • channel stable`

---

### PHASE 3 — Install Android Studio (for emulator)

**Step 1:** Download from https://developer.android.com/studio  
**Step 2:** Install with default settings  
**Step 3:** After opening, click "More Actions" → SDK Manager  
**Step 4:** Install:
- Android SDK (API 33 or higher)
- Android Emulator
- Android SDK Build-Tools

**Step 5 — Create a Virtual Device:**
1. Click "More Actions" → Virtual Device Manager
2. Click "Create Device"
3. Choose: Pixel 6 → Next
4. Choose: API 33 (download if needed) → Next → Finish
5. Click ▶ Play button to start the emulator

---

### PHASE 4 — Install VS Code

1. Download from https://code.visualstudio.com
2. Install with default settings
3. Open VS Code → Extensions (left sidebar)
4. Search "Flutter" → Install (by Dart Code team)
5. Search "Dart" → Install

---

### PHASE 5 — Set Up Supabase (free, ~10 minutes)

**Step 1:** Go to https://app.supabase.com and sign up (free)

**Step 2:** Click "New project"
- Name: `smartgo`
- Password: choose something strong (save it!)
- Region: pick nearest to you
- Click "Create new project"
- Wait ~2 minutes

**Step 3:** Run the SQL Schema
1. Click "SQL Editor" in left sidebar
2. Click "+ New query"
3. Open `supabase_schema.sql` with Notepad/TextEdit
4. Copy ALL content → Paste into SQL Editor
5. Click green "Run" button
6. You should see: **"Success. No rows returned"**

**Step 4:** Get your API keys
1. Click "Settings" (gear icon, bottom left)
2. Click "API"
3. Copy these two values:
   - **Project URL** (like `https://abcxyz.supabase.co`)
   - **anon/public key** (long JWT string starting with `eyJ...`)

---

### PHASE 6 — Configure the Flutter App

**Step 1:** Open VS Code → File → Open Folder → select `smartgo_app`

**Step 2:** Open: `lib/constants/app_constants.dart`

**Step 3:** Replace the placeholder values:
```dart
// BEFORE:
const String supabaseUrl     = 'https://YOUR_PROJECT_ID.supabase.co';
const String supabaseAnonKey = 'YOUR_ANON_KEY_HERE';

// AFTER (use your actual values):
const String supabaseUrl     = 'https://abcxyz123.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6...';
```

**Step 4:** Press Ctrl+S (Windows) or Cmd+S (Mac) to save

---

### PHASE 7 — Install Dependencies & Run

**Step 1:** Open terminal in VS Code: Terminal → New Terminal

**Step 2:** Make sure you are inside the smartgo_app folder:
```bash
cd smartgo_app
```

**Step 3:** Install packages:
```bash
flutter pub get
```
Wait ~1 minute. You should see "Got dependencies!"

**Step 4:** Check your devices:
```bash
flutter devices
```
You should see your Android emulator listed.

**Step 5:** Run the app:
```bash
flutter run
```
Or for Chrome browser:
```bash
flutter run -d chrome
```

The app will build and launch in ~60 seconds.

---

## HOW TO USE THE APP

1. **Launch** → Splash screen with 🚕 SmartGo
2. **Register** → tap "Register" → fill Full Name, Phone, Type of Service
3. **Login** → enter your phone number → tap Login
4. **Dashboard** → see all options: Find Transport, Bookings, SOS, Feedback
5. **Book a Ride:**
   - Tap "Find Transport"
   - Enter "From" location (e.g. Nambur)
   - Enter "To" location (e.g. Guntur)
   - Tap "Show Available Vehicles"
   - See: Bus ₹25, Car ₹50, Bike ₹20, Shared Auto ₹15
   - Tap "Book" on your preferred vehicle
   - Choose payment (UPI / PhonePe / Google Pay / Card)
   - See success confirmation
6. **SOS** → tap SOS Alert → Enter location → Send SOS Alert
7. **Feedback** → Rate stars → Write comments → Submit
8. **Profile** → View details → Sign Out

---

## COMMON ERRORS & FIXES

| Error | Solution |
|-------|----------|
| `flutter: command not found` | Re-add Flutter to PATH, restart VS Code |
| `No devices found` | Start Android emulator first, or run `flutter config --enable-web` |
| `Gradle build failed` | Run `flutter clean` then `flutter pub get` again |
| `Supabase connection failed` | Check your URL and anon key in `app_constants.dart` |
| `SDK not found` | Open Android Studio → SDK Manager → install Android SDK API 33 |
| `Dart SDK version error` | Run `flutter upgrade` to get latest version |
| `pub get failed` | Check internet connection, run `flutter pub cache repair` |

---

## ANDROID MANIFEST (add internet permission)

In `android/app/src/main/AndroidManifest.xml`, make sure this line exists:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

---

## FEATURES IMPLEMENTED

| Feature | Status | Screen |
|---------|--------|--------|
| Phone login | ✅ | login_screen.dart |
| User registration | ✅ | register_screen.dart |
| Vehicle listing | ✅ | select_vehicle_screen.dart |
| Route entry | ✅ | location_screen.dart |
| Fare display | ✅ | select_vehicle_screen.dart |
| Payment (UPI/Card/PhonePe) | ✅ | payment_screen.dart |
| Booking confirmation | ✅ | booking_success_screen.dart |
| Booking history | ✅ | my_bookings_screen.dart |
| SOS / Emergency | ✅ | sos_screen.dart |
| Feedback & Rating | ✅ | feedback_screen.dart |
| User profile | ✅ | profile_screen.dart |
| Supabase Auth | ✅ | auth_provider.dart |
| Supabase DB | ✅ | supabase_service.dart |
| Real-time updates | ✅ | Supabase Realtime |

---


=======
=======
#SmartGo App

SmartGo – Transportation App for Rural Areas

Overview:

SmartGo is a mobile application developed using Flutter and Supabase to provide efficient and affordable transportation services in rural areas. It connects passengers with available drivers and enables easy booking and management of rides.


Features:

👤 User Registration & Login (Passenger & Driver)
🚘 Vehicle Availability
🗺️ Route Selection
💰 Fare Estimation
📞 Driver Contact
🔔 Notifications
📊 Booking Management


Technologies Used:

Frontend:Flutter
Backend:Supabase
Database:PostgreSQL


 Setup Instructions:

1. Clone the Repository
git clone https://github.com/your-username/smartgo_app.git
cd smartgo_app

2. Install Dependencies: flutter pub get

3. Setup Supabase
* Create a project in Supabase
* Run the SQL schema
* Copy:
  * SUPABASE_URL
  * ANON_KEY

4. Configure Project
Open:
lib/services/supabase_service.dart
Replace:
const String supabaseUrl = 'YOUR_URL';
const String supabaseKey = 'YOUR_KEY';

5. Run the App
flutter run

 Screens
 =========

* Login Screen
* Registration Screen
* Home Dashboard
* Booking Screen

