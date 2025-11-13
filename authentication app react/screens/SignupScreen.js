import React, { useState } from "react";
import { LinearGradient } from 'expo-linear-gradient';
import { auth } from "../firebaseConfig";



import { View, Text, TextInput, TouchableOpacity, StyleSheet, ScrollView } from "react-native";

import { createUserWithEmailAndPassword, updateProfile } from "firebase/auth";

export default function SignupScreen({ navigation }) {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleSignup = () => {
    createUserWithEmailAndPassword(auth, email, password)
      .then((userCredential) => {
        updateProfile(userCredential.user, { displayName: name })
          .then(() => {
            navigation.replace("Dashboard");
          });
      })
      .catch((err) => setError(err.message));
  };

  return (
    <LinearGradient colors={["#f7971e", "#ffd200"]} style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContainer}>
        <Text style={styles.title}>Create Account</Text>
        {error != "" && <Text style={styles.error}>{error}</Text>}

        <TextInput placeholder="Name" style={styles.input} onChangeText={setName} />
        <TextInput placeholder="Email" style={styles.input} onChangeText={setEmail} />
        <TextInput placeholder="Password" style={styles.input} secureTextEntry onChangeText={setPassword} />

        <TouchableOpacity style={styles.button} onPress={handleSignup}>
          <Text style={styles.buttonText}>Sign Up</Text>
        </TouchableOpacity>
      </ScrollView>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  scrollContainer: { padding: 20, justifyContent: "center" },
  title: { fontSize: 24, fontWeight: "bold", textAlign: "center", marginBottom: 15, color: "#fff" },
  input: {
    backgroundColor: "#fff",
    marginVertical: 8,
    padding: 12,
    borderRadius: 8,
  },
  button: {
    backgroundColor: "#ff5722",
    padding: 15,
    marginVertical: 8,
    borderRadius: 8,
  },
  buttonText: { color: "#fff", fontSize: 16, textAlign: "center" },
  error: { color: "red", textAlign: "center", marginVertical: 10 },
});
