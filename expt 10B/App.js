import React, { useEffect, useState } from 'react';
import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View, TextInput, TouchableOpacity, FlatList, Alert } from 'react-native';
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, addDoc, onSnapshot, deleteDoc, doc, updateDoc, serverTimestamp, query, orderBy } from 'firebase/firestore';

// TODO: Replace with your Firebase config
const firebaseConfig = {
  apiKey: "AIza...REPLACE...",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project-id.appspot.com",
  messagingSenderId: "1234567890",
  appId: "1:1234567890:web:abcdef123456"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

export default function App() {
  const [text, setText] = useState('');
  const [todos, setTodos] = useState([]);
  const todosRef = collection(db, 'todos');

  useEffect(() => {
    const q = query(todosRef, orderBy('createdAt', 'desc'));
    const unsub = onSnapshot(q, (querySnapshot) => {
      const list = [];
      querySnapshot.forEach(docSnap => {
        list.push({ id: docSnap.id, ...docSnap.data() });
      });
      setTodos(list);
    }, (err) => {
      console.error('Firestore onSnapshot error:', err);
      Alert.alert('Error', 'Unable to load tasks from Firestore.');
    });
    return () => unsub();
  }, []);

  const addTodo = async () => {
    if (!text.trim()) return;
    try {
      await addDoc(todosRef, { text: text.trim(), done: false, createdAt: serverTimestamp() });
      setText('');
    } catch (e) {
      console.error(e);
      Alert.alert('Error', 'Failed to add task.');
    }
  };

  const toggleDone = async (item) => {
    try {
      const d = doc(db, 'todos', item.id);
      await updateDoc(d, { done: !item.done });
    } catch (e) {
      console.error(e);
      Alert.alert('Error', 'Failed to update task.');
    }
  };

  const removeTodo = async (id) => {
    try {
      await deleteDoc(doc(db, 'todos', id));
    } catch (e) {
      console.error(e);
      Alert.alert('Error', 'Failed to delete task.');
    }
  };

  const renderItem = ({ item }) => (
    <View style={styles.item}>
      <TouchableOpacity onPress={() => toggleDone(item)} style={{flex:1}}>
        <Text style={[styles.itemText, item.done && styles.done]}>{item.text}</Text>
        <Text style={styles.meta}>{item.done ? 'Done' : ''}</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={() => removeTodo(item.id)} style={styles.delBtn}>
        <Text style={{color:'#fff'}}>Delete</Text>
      </TouchableOpacity>
    </View>
  );

  return (
    <View style={styles.container}>
      <Text style={styles.title}>ToDo List — Firestore</Text>
      <View style={styles.inputRow}>
        <TextInput value={text} onChangeText={setText} placeholder="Add a task" style={styles.input} />
        <TouchableOpacity onPress={addTodo} style={styles.addBtn}>
          <Text style={{color:'#fff'}}>Add</Text>
        </TouchableOpacity>
      </View>
      <FlatList data={todos} keyExtractor={item => item.id} renderItem={renderItem} style={{width:'100%'}} />
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex:1, backgroundColor:'#fff', alignItems:'center', paddingTop:60, paddingHorizontal:16 },
  title: { fontSize:20, fontWeight:'700', marginBottom:12 },
  inputRow: { flexDirection:'row', width:'100%', marginBottom:12 },
  input: { flex:1, borderWidth:1, borderColor:'#ddd', borderRadius:8, paddingHorizontal:12, height:48 },
  addBtn: { marginLeft:8, backgroundColor:'#2563eb', height:48, paddingHorizontal:16, borderRadius:8, justifyContent:'center' },
  item: { flexDirection:'row', alignItems:'center', padding:12, borderRadius:8, backgroundColor:'#f7f7f8', marginBottom:8 },
  itemText: { fontSize:16 },
  meta: { fontSize:12, color:'#666' },
  done: { textDecorationLine:'line-through', color:'#999' },
  delBtn: { backgroundColor:'#ef4444', paddingHorizontal:10, paddingVertical:6, borderRadius:6, marginLeft:8 }
});
