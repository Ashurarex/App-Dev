import { initializeApp } from "firebase/app";
import {
  getAuth,
  initializeAuth,
  getReactNativePersistence,
  browserLocalPersistence,
} from "firebase/auth";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { Platform } from "react-native";

// ✅ Correct Firebase config
const firebaseConfig = {
  apiKey: "AIzaSyDAiVfsMumED2qWPxzxxnV1Rao1wwR1wB0",
  authDomain: "authreact-aed2f.firebaseapp.com",
  projectId: "authreact-aed2f",
  storageBucket: "authreact-aed2f.appspot.com", // fixed
  messagingSenderId: "108233868945",
  appId: "1:108233868945:web:d0e1d0b43973f785cbe130",
  measurementId: "G-J0GWYTJPDX",
};

// Initialize Firebase app
const app = initializeApp(firebaseConfig);

// Initialize auth properly depending on platform
let auth;
if (Platform.OS === "web") {
  auth = getAuth(app);
} else {
  auth = initializeAuth(app, {
    persistence: getReactNativePersistence(AsyncStorage),
  });
}

export { auth };
export default app;
