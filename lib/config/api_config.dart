class ApiConfig {
  // Firebase Cloud Functions URLs
  // Local emulator: http://localhost:5001/habit-tracker-93de7/us-central1/api
  // Production: https://us-central1-habit-tracker-93de7.cloudfunctions.net/api
  
  static const String firebaseFunctionsUrl = 
      'http://localhost:5001/habit-tracker-93de7/us-central1/api';
  
  // Set to true to use REST API instead of direct Firebase access
  // When true, the app will use Firebase Cloud Functions REST API
  // When false, the app will use direct Firebase SDK (Firestore)
  static const bool useRestApi = false;
}
