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

📱 Screens

* Login Screen
* Registration Screen
* Home Dashboard
* Booking Screen
