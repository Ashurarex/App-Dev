# auth_react native APK

**React Native Expo Firebase Authentication App**
This React Native app built with Expo Go demonstrates comprehensive Firebase Authentication integration supporting multiple sign-in methods. Upon successful authentication, users are directed to a fitness tracker dashboard to monitor their health and workouts.

**Features**
User registration and login via email/password
Google account sign-in integration
Guest/anonymous login option
Forgot password functionality with email reset
Phone number authentication with OTP verification
Persistent user sessions
Clean and intuitive UI/UX optimized for mobile devices
Fitness tracker dashboard accessible only after authentication

**Getting Started**
Prerequisites
Node.js and npm installed
Expo CLI installed globally (npm install -g expo-cli)
Firebase project set up with Authentication enabled

**Firebase Setup**
Create a Firebase project in the Firebase Console.
Enable these Authentication providers:
Email/Password
Google
Phone
Anonymous

**Configure OAuth redirect URIs for Google sign-in.**
Obtain Firebase config credentials for your web app (since Expo Go uses web SDK).
Add config to your React Native app's Firebase initialization.

**Installation**
Clone the repo and install dependencies:

bash
git clone : The repository
cd : To the directory
npm install
Running the App
Launch your app on emulator or device:

bash
expo start
Use Expo Go to open the project on your mobile device.

**Usage**
Register a new user with email and password.
Sign in via email/password, Google account, or anonymously as guest.
Reset forgotten password through email.
Authenticate via phone number by sending and verifying OTP.
After login, users are redirected to the fitness tracker dashboard.

**Fitness Tracker Dashboard**
Displays user's fitness metrics: steps, calories burned, heart rate, workout logs.
Allows tracking of daily exercise goals and progress.
Provides UI for starting/stopping workouts, viewing history, and analytics.
Accessible only post-authentication ensuring user data security.

**Code Overview**
firebaseConfig.js: Firebase initialization with project credentials.
screens/: Contains screens including Login, Register, ForgotPassword, PhoneAuth, GuestLogin, and Dashboard.

**Dependencies**
expo
firebase (Firebase JS SDK)
react-native
react-navigation
expo-google-auth-session
@react-native-async-storage/async-storage

Other supporting UI and utility packages

**Notes**
React Native Expo Go apps use Firebase Web SDK for Authentication.
Phone authentication requires real device or proper testing setup with Firebase.
OAuth flows for Google require correct redirect URIs configured in Firebase.

Guest login provides temporary access but data may be lost on logout.

**Contributing**
Contributions welcome! Fork, make improvements, and submit a pull request.
