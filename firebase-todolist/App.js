import { addDoc, collection, deleteDoc, doc, getDocs } from 'firebase/firestore';
import { useEffect, useState } from 'react';
import { ActivityIndicator, Alert, Button, FlatList, StyleSheet, Text, TextInput, View } from 'react-native';
import { db } from './firebaseconfig';

export default function App() {
  console.log('App component is rendering...');
  const [task, setTask] = useState('');
  const [tasks, setTasks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [firebaseError, setFirebaseError] = useState(null);

  // Simple test to ensure the component renders
  console.log('App state:', { task, tasks: tasks.length, loading, firebaseError });

  const tasksCollection = collection(db, 'tasks');

  const fetchTasks = async () => {
    try {
      setLoading(true);
      setFirebaseError(null);
      console.log('Attempting to fetch tasks from Firebase...');
      const data = await getDocs(tasksCollection);
      console.log('Tasks fetched successfully:', data.docs.length);
      setTasks(data.docs.map(doc => ({ id: doc.id, ...doc.data() })));
    } catch (error) {
      console.error('Fetch Error:', error);
      setFirebaseError(error.message);
      Alert.alert('Fetch Error', error.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    console.log('App mounted, fetching tasks...');
    fetchTasks();
  }, []);

  const addTask = async () => {
    if (task.trim().length === 0) return;
    try {
      await addDoc(tasksCollection, { 
        task: task.trim(),
        createdAt: new Date().toISOString()
      });
      setTask('');
      await fetchTasks();
    } catch (error) {
      console.error('Add Task Error:', error);
      Alert.alert('Add Task Error', error.message);
    }
  };

  const deleteTask = async (id) => {
    try {
      await deleteDoc(doc(db, 'tasks', id));
      await fetchTasks();
    } catch (error) {
      console.error('Delete Task Error:', error);
      Alert.alert('Delete Task Error', error.message);
    }
  };

  if (loading) {
    return (
      <View style={[styles.container, styles.centerContent]}>
        <ActivityIndicator size="large" color="#007AFF" />
        <Text style={styles.loadingText}>Loading tasks...</Text>
      </View>
    );
  }

  // Fallback if Firebase fails
  if (!db) {
    return (
      <View style={[styles.container, styles.centerContent]}>
        <Text style={styles.errorText}>Firebase connection failed</Text>
        <Text style={styles.noTaskText}>Please check your Firebase configuration</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Text style={styles.title}>My Todo List</Text>
      <Text style={styles.subtitle}>App is working! Firebase: {db ? '✅' : '❌'}</Text>
      {firebaseError && (
        <Text style={styles.errorText}>Error: {firebaseError}</Text>
      )}
      <TextInput
        placeholder="Enter a new task..."
        value={task}
        onChangeText={setTask}
        style={styles.input}
        onSubmitEditing={addTask}
        returnKeyType="done"
      />
      <Button title="Add Task" onPress={addTask} />
      {tasks.length === 0 ? (
        <Text style={styles.noTaskText}>No tasks yet. Add one above!</Text>
      ) : (
        <FlatList
          data={tasks}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => (
            <View style={styles.taskContainer}>
              <Text style={styles.taskText}>{item.task}</Text>
              <Button title="Delete" onPress={() => deleteTask(item.id)} color="#ff4444" />
            </View>
          )}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { 
    padding: 20, 
    marginTop: 50, 
    flex: 1,
    backgroundColor: '#f5f5f5'
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
    marginBottom: 10,
    color: '#333'
  },
  subtitle: {
    fontSize: 14,
    textAlign: 'center',
    marginBottom: 20,
    color: '#666'
  },
  input: {
    borderColor: '#ddd',
    borderWidth: 1,
    padding: 15,
    marginBottom: 15,
    borderRadius: 8,
    backgroundColor: 'white',
    fontSize: 16
  },
  taskContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
    backgroundColor: 'white',
    padding: 15,
    borderRadius: 8,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 1,
    },
    shadowOpacity: 0.1,
    shadowRadius: 2,
    elevation: 2,
  },
  taskText: {
    flex: 1,
    fontSize: 16,
    color: '#333',
    marginRight: 10
  },
  noTaskText: {
    marginTop: 40,
    textAlign: 'center',
    fontSize: 16,
    color: '#666',
    fontStyle: 'italic'
  },
  centerContent: {
    justifyContent: 'center',
    alignItems: 'center'
  },
  loadingText: {
    marginTop: 10,
    fontSize: 16,
    color: '#666'
  },
  errorText: {
    color: '#ff4444',
    textAlign: 'center',
    marginBottom: 10,
    fontSize: 14
  },
});
