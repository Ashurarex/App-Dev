import React, { useEffect, useState } from "react";
import {
  View,
  Text,
  TextInput,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Alert,
  ActivityIndicator, // Added for better loading feedback
} from "react-native";
import * as WebBrowser from "expo-web-browser";
import * as Google from "expo-auth-session/providers/google";
import * as AuthSession from "expo-auth-session";
import { LinearGradient } from "expo-linear-gradient";
import {
  signInWithEmailAndPassword,
  signInAnonymously,
  sendPasswordResetEmail,
  signInWithCredential,
  GoogleAuthProvider,
  signInWithPhoneNumber, // Keep this for phone auth, though it needs extra setup (Recaptcha)
} from "firebase/auth";
import { auth } from "../firebaseConfig"; // ✅ make sure this file exports a valid initialized Firebase app

// Essential for Expo's web browser-based authentication
WebBrowser.maybeCompleteAuthSession();

export default function LoginScreen({ navigation }) {
  // 🧠 States
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [phone, setPhone] = useState("");
  const [otp, setOtp] = useState("");
  const [confirm, setConfirm] = useState(null);
  const [loading, setLoading] = useState(false);

  // 1. ✅ Create redirect URI (Uses Expo's secure proxy for login return)

  // 2. ✅ Configure Google Auth (FIXED CONFIGURATION)
 const proxyOwner = "rahul199";
const proxySlug = "auth_react"; 

const redirectUri = `https://auth.expo.dev/@${proxyOwner}/${proxySlug}`;

// You can still log the result to ensure it's correct
console.log("Forced Redirect URI =>", redirectUri);


// And ensure your Google.useAuthRequest looks like this:
const [request, response, promptAsync] = Google.useAuthRequest({
    webClientId:
      "108233868945-sglo70ghdkcfj02cbb537gahllui8l52.apps.googleusercontent.com",
    // ... other client IDs
    androidClientId: "108233868945-8ngt4ftdl74ib4p7pou2qv47t12p5a3v.apps.googleusercontent.com",
    redirectUri: redirectUri, // Use the new forced URI
});

  console.log("Redirect URI =>", redirectUri);

  // 3. ✅ Handle Google sign-in response
  useEffect(() => {
    if (response?.type === "success") {
      const { authentication } = response;
      if (authentication?.idToken) {
        const credential = GoogleAuthProvider.credential(authentication.idToken);
        (async () => {
          try {
            setLoading(true);
            // Sign in to Firebase using the ID Token from Google
            await signInWithCredential(auth, credential);
            navigation.replace("Dashboard");
          } catch (error) {
            console.error("Firebase Sign-In Error:", error);
            Alert.alert("Google Login Failed", "Check your Firebase/Google Cloud settings: " + error.message);
          } finally {
            setLoading(false);
          }
        })();
      } else {
         Alert.alert("Google Login Failed", "Could not retrieve ID Token from Google response.");
      }
    } else if (response?.type === 'error') {
        Alert.alert("Google Login Canceled/Error", response.error?.message || "An unknown error occurred during Google sign-in.");
    }
  }, [response]);

  // ✅ Email login
  const handleEmailLogin = async () => {
    if (!email || !password) {
      Alert.alert("Error", "Please enter email and password.");
      return;
    }
    try {
      setLoading(true);
      await signInWithEmailAndPassword(auth, email, password);
      navigation.replace("Dashboard");
    } catch (error) {
      Alert.alert("Login Error", error.message);
    } finally {
      setLoading(false);
    }
  };

  // ⚠️ Phone OTP: Requires reCAPTCHA verification on web/Expo, which is a complex setup.
  // The code structure here is fine, but it needs an active reCAPTCHA verifier to work.
  const handleSendOTP = async () => {
    if (!phone || !phone.startsWith("+")) {
      Alert.alert("Invalid Phone", "Use +[country code][number] format");
      return;
    }
    // ... Phone login logic remains the same (requires reCAPTCHA setup)
    Alert.alert("Note", "Phone Auth requires reCAPTCHA setup for web/Expo.");
  };
  
  const handleVerifyOTP = async () => {
      // ... OTP verification logic remains the same
  };


  // ✅ Guest Login
  const handleGuestLogin = async () => {
    try {
      setLoading(true);
      await signInAnonymously(auth);
      navigation.replace("Dashboard");
    } catch (error) {
      Alert.alert("Guest Login Error", error.message);
    } finally {
      setLoading(false);
    }
  };

  // ✅ Forgot Password
  const handleForgotPassword = async () => {
    if (!email) {
      Alert.alert("Enter Email", "Please enter your email to reset password.");
      return;
    }
    try {
      setLoading(true);
      await sendPasswordResetEmail(auth, email);
      Alert.alert("Password Reset", "Password reset email sent successfully.");
    } catch (error) {
      Alert.alert("Reset Password Error", error.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <LinearGradient colors={["#89f7fe", "#66a6ff"]} style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContainer}>
        <Text style={styles.title}>Fitness Tracker Login</Text>
        
        {loading && (
          <ActivityIndicator 
            size="large" 
            color="#fff" 
            style={{ marginBottom: 10 }}
          />
        )}

        <TextInput
          placeholder="Email"
          style={styles.input}
          onChangeText={setEmail}
          keyboardType="email-address"
          value={email}
          autoCapitalize="none"
        />

        <TextInput
          placeholder="Password"
          style={styles.input}
          secureTextEntry
          onChangeText={setPassword}
          value={password}
        />

        <TouchableOpacity
          style={styles.button}
          onPress={handleEmailLogin}
          disabled={loading}
        >
          <Text style={styles.buttonText}>Login</Text>
        </TouchableOpacity>

        <TouchableOpacity
          onPress={() => navigation.navigate("Signup")}
          style={styles.link}
        >
          <Text style={styles.linkText}>Create New Account</Text>
        </TouchableOpacity>
        
        {/* --- GOOGLE LOGIN --- */}
        <TouchableOpacity
          style={styles.buttonGoogle}
          disabled={!request || loading}
          onPress={() => promptAsync()}
        >
          <Text style={styles.buttonText}>Login with Google</Text>
        </TouchableOpacity>
        {/* -------------------- */}


        <TextInput
          placeholder="Phone Number (+countrycode)"
          style={styles.input}
          keyboardType="phone-pad"
          onChangeText={setPhone}
          value={phone}
        />

        <TouchableOpacity
          style={styles.button}
          onPress={handleSendOTP}
          disabled={loading}
        >
          <Text style={styles.buttonText}>Send OTP</Text>
        </TouchableOpacity>

        {confirm && (
          <>
            <TextInput
              placeholder="Enter OTP"
              style={styles.input}
              keyboardType="number-pad"
              onChangeText={setOtp}
              value={otp}
            />
            <TouchableOpacity
              style={styles.button}
              onPress={handleVerifyOTP}
              disabled={loading}
            >
              <Text style={styles.buttonText}>Verify OTP</Text>
            </TouchableOpacity>
          </>
        )}

        <TouchableOpacity
          style={styles.guestButton}
          onPress={handleGuestLogin}
          disabled={loading}
        >
          <Text style={styles.guestText}>Continue as Guest</Text>
        </TouchableOpacity>

        <TouchableOpacity
          onPress={handleForgotPassword}
          style={styles.link}
          disabled={loading}
        >
          <Text style={styles.linkText}>Forgot Password?</Text>
        </TouchableOpacity>
      </ScrollView>
    </LinearGradient>
  );
}

// ✅ Styles
const styles = StyleSheet.create({
  container: { flex: 1 },
  scrollContainer: {
    padding: 40,
    alignItems: "center",
    justifyContent: "flex-start",
  },
  title: {
    fontSize: 28,
    fontWeight: "bold",
    marginBottom: 30,
    color: "#fff",
  },
  input: {
    backgroundColor: "#fff",
    width: "100%",
    padding: 15,
    borderRadius: 10,
    marginVertical: 12,
    fontSize: 16,
  },
  button: {
    backgroundColor: "#4caf50",
    width: "100%",
    padding: 15,
    borderRadius: 10,
    marginVertical: 12,
  },
  buttonGoogle: {
    backgroundColor: "#db4437",
    width: "100%",
    padding: 15,
    borderRadius: 10,
    marginVertical: 12,
  },
  buttonText: {
    color: "#fff",
    textAlign: "center",
    fontSize: 17,
    fontWeight: "600",
  },
  link: {
    alignSelf: "flex-start",
    marginVertical: 12,
  },
  linkText: {
    color: "#fff",
    fontWeight: "bold",
    fontSize: 14,
    textDecorationLine: "underline",
  },
  guestButton: {
    marginTop: 20,
  },
  guestText: {
    color: "#fff",
    fontWeight: "500",
  },
});