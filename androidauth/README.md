# auth_Android studio 

Android Studio Firebase Authentication App
This Android app built using Java in Android Studio integrates Firebase Authentication with multiple sign-in methods. After successful authentication, users are directed to a fitness tracker dashboard to monitor their health metrics and workouts.

**Features**
User registration and login via email/password
Google Sign-In integration
Guest/anonymous login optio
Forgot password feature with email reset link
Phone number authentication with OTP verification
User session management and persistence

Fitness tracker dashboard displayed after authentication
Material Design based UI optimized for Android devices

**Getting Started**
Prerequisites
Android Studio installed (latest stable version recommended)
Java Development Kit (JDK) installed
Firebase project created with Authentication enabled

**Firebase Setup**
Go to Firebase Console and create a new project.
Enable these Authentication providers:
Email/Password
Google
Phone
Anonymous

Register your Android app in Firebase and download google-services.json.

Place google-services.json in your Android app module (app/) folder.

Add Firebase SDK dependencies in your build.gradle files as per Firebase Android setup documentation.

Configure OAuth client ID for Google Sign-In in the Firebase Console.

**Installation**
Clone or download the project repository.
Open the project in Android Studio.
Sync Gradle to download required dependencies.

**Running the App**
Run the app on an Android emulator or physical device using Android Studio’s run configuration.

**Usage**
Sign up new users using email and password.
Log in using email/password, Google account, or anonymously as a guest.
Password reset via email for forgotten passwords.
Phone number login utilizing OTP verification.
Post login, users are routed to a fitness tracker dashboard.

**Fitness Tracker Dashboard**
Displays key fitness data such as:
Step counts
Calories burned
Heart rate
Workout history and progress charts
Navigation to track workouts, set goals, and view analytics.
Accessible only to authenticated users ensuring data security and privacy.

**Code Structure**
MainActivity.java: Handles user authentication and navigation.
DashboardActivity.java: Displays fitness tracker dashboard after login
UI layouts under res/layout for login, register, forgot password, phone auth, and dashboard screens.

GoogleSignInClient for Google authentication integration.

Proper session and user state management using Firebase Auth listeners.

**Dependencies**
com.google.firebase:firebase-auth
com.google.android.gms:play-services-auth
AndroidX libraries for UI and navigation

**Notes**
Google Sign-In requires SHA-1 and SHA-256 keys uploaded in Firebase.
Phone authentication requires real device or configured phone number testing in Firebase.
Guest login provides temporary access without data persistence after logout.
Follow best practices for secure authentication and user data handling.

**Contributing**
Feel free to fork this repo and submit pull requests with improvements or fixes.
