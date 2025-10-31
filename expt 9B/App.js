import React, { useEffect, useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, FlatList, StyleSheet, KeyboardAvoidingView, Platform } from 'react-native';
import { initDB, getTodos, addTodo, toggleTodo, deleteTodo } from './src/database';

export default function App() {
  const [todos, setTodos] = useState([]);
  const [input, setInput] = useState('');

  useEffect(() => {
    initDB();
    loadTodos();
  }, []);

  const loadTodos = () => {
    getTodos(data => setTodos(data));
  };

  const handleAdd = () => {
    if (!input.trim()) return;
    addTodo(input.trim(), () => {
      setInput('');
      loadTodos();
    });
  };

  const handleToggle = (id, done) => {
    toggleTodo(id, done, loadTodos);
  };

  const handleDelete = (id) => {
    deleteTodo(id, loadTodos);
  };

  const renderItem = ({ item }) => (
    <View style={styles.todoItem}>
      <TouchableOpacity onPress={() => handleToggle(item.id, item.done)} style={{ flex: 1 }}>
        <Text style={[styles.todoText, item.done ? styles.done : null]}>{item.title}</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={() => handleDelete(item.id)} style={styles.delBtn}>
        <Text style={styles.delText}>✕</Text>
      </TouchableOpacity>
    </View>
  );

  return (
    <KeyboardAvoidingView style={styles.container} behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
      <Text style={styles.title}>📝 ToDoListSQLite</Text>
      <View style={styles.inputRow}>
        <TextInput
          style={styles.input}
          placeholder="Add new task..."
          value={input}
          onChangeText={setInput}
        />
        <TouchableOpacity style={styles.addButton} onPress={handleAdd}>
          <Text style={styles.addText}>Add</Text>
        </TouchableOpacity>
      </View>

      <FlatList
        data={todos}
        keyExtractor={item => item.id.toString()}
        renderItem={renderItem}
        contentContainerStyle={styles.list}
      />
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f7f7fb', padding: 20, paddingTop: 60 },
  title: { fontSize: 24, fontWeight: '700', textAlign: 'center', marginBottom: 16 },
  inputRow: { flexDirection: 'row', marginBottom: 16 },
  input: { flex: 1, borderWidth: 1, borderColor: '#ddd', borderRadius: 8, padding: 10, backgroundColor: '#fff' },
  addButton: { marginLeft: 10, backgroundColor: '#6c63ff', paddingHorizontal: 14, justifyContent: 'center', borderRadius: 8 },
  addText: { color: '#fff', fontWeight: '700' },
  list: { paddingBottom: 60 },
  todoItem: { flexDirection: 'row', alignItems: 'center', backgroundColor: '#fff', padding: 12, marginBottom: 8, borderRadius: 8, elevation: 2 },
  todoText: { fontSize: 16 },
  done: { textDecorationLine: 'line-through', color: '#888' },
  delBtn: { paddingHorizontal: 8 },
  delText: { color: '#ff5252', fontSize: 18 }
});
