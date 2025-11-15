import React, { useState } from "react";
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, Alert } from "react-native";
import { LinearGradient } from "expo-linear-gradient";
import { auth } from "../firebaseConfig";
import { signOut } from "firebase/auth";

export default function Dashboard({ navigation }) {
  // Example fitness stats (replace with real data)
  const [steps, setSteps] = useState(7500);
  const [calories, setCalories] = useState(320);
  const [distance, setDistance] = useState(5.2); // kilometers
  const [activeMinutes, setActiveMinutes] = useState(45);

  const handleSignOut = async () => {
    try {
      await signOut(auth);
      navigation.replace("Login"); // Redirect to login after sign out
    } catch (error) {
      Alert.alert("Sign Out Error", error.message);
    }
  };

  return (
    <LinearGradient colors={["#00c6ff", "#0072ff"]} style={styles.container}>
      <ScrollView contentContainerStyle={styles.contentContainer}>
        <Text style={styles.title}>Welcome to Fitness Tracker</Text>

        <View style={styles.statCard}>
          <Text style={styles.statLabel}>Steps</Text>
          <Text style={styles.statValue}>{steps.toLocaleString()}</Text>
        </View>

        <View style={styles.statCard}>
          <Text style={styles.statLabel}>Calories Burned</Text>
          <Text style={styles.statValue}>{calories} kcal</Text>
        </View>

        <View style={styles.statCard}>
          <Text style={styles.statLabel}>Distance Covered</Text>
          <Text style={styles.statValue}>{distance} km</Text>
        </View>

        <View style={styles.statCard}>
          <Text style={styles.statLabel}>Active Minutes</Text>
          <Text style={styles.statValue}>{activeMinutes} mins</Text>
        </View>

        <Text style={styles.info}>
          Track your daily fitness activities and stay healthy. Keep pushing your limits!
        </Text>

        <TouchableOpacity style={styles.signOutButton} onPress={handleSignOut}>
          <Text style={styles.signOutText}>Sign Out</Text>
        </TouchableOpacity>
      </ScrollView>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  contentContainer: {
    padding: 20,
    alignItems: "center",
  },
  title: {
    fontSize: 24,
    fontWeight: "bold",
    marginBottom: 25,
    color: "#fff",
  },
  statCard: {
    backgroundColor: "#1E3C72",
    width: "90%",
    padding: 20,
    borderRadius: 15,
    marginBottom: 20,
    shadowColor: "#000",
    shadowOpacity: 0.25,
    shadowRadius: 6,
    shadowOffset: { width: 0, height: 2 },
    elevation: 5,
    alignItems: "center",
  },
  statLabel: {
    color: "#A0C4FF",
    fontSize: 16,
  },
  statValue: {
    color: "#fff",
    fontSize: 36,
    fontWeight: "bold",
    marginTop: 10,
  },
  info: {
    color: "#D1D5DB",
    fontSize: 16,
    marginTop: 50,
    textAlign: "center",
    paddingHorizontal: 20,
  },
  signOutButton: {
    backgroundColor: "#ff4d4d",
    padding: 15,
    borderRadius: 15,
    marginTop: 40,
    width: "90%",
    alignItems: "center",
  },
  signOutText: {
    color: "#fff",
    fontWeight: "bold",
    fontSize: 18,
  },
});
