import React, { useState, useEffect } from 'react';
import { StyleSheet, Text, View, TextInput, Button, FlatList, TouchableOpacity } from 'react-native';
import * as SQLite from 'expo-sqlite';

// Initialize database using the modern API
const db = SQLite.openDatabaseSync('TodoDatabase.db');

export default function App() {
  const [task, setTask] = useState('');
  const [taskItems, setTaskItems] = useState([]);
  const [dbStatus, setDbStatus] = useState('Initializing...');
  const [lastOperation, setLastOperation] = useState('');

  useEffect(() => {
    createTable();
    fetchTasks();
  }, []);

  const createTable = () => {
    try {
      db.execSync(`
        CREATE TABLE IF NOT EXISTS tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          task TEXT, 
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
      `);
      setDbStatus('✅ Database Connected');
      setLastOperation('Table created/verified');
      console.log('✅ Database table created/verified successfully');
    } catch (error) {
      setDbStatus('❌ Database Error');
      setLastOperation('Failed to create table');
      console.error('❌ Error creating table: ', error);
    }
  };

  const fetchTasks = () => {
    try {
      const result = db.getAllSync('SELECT * FROM tasks ORDER BY created_at DESC;');
      console.log(`📋 Fetched ${result.length} tasks from database`);
      setTaskItems(result);
      setLastOperation(`Fetched ${result.length} tasks from database`);
    } catch (error) {
      setLastOperation('Error fetching tasks');
      console.error('❌ Error fetching tasks: ', error);
    }
  };

  const handleAddTask = () => {
    if (task.trim()) {
      const taskText = task.trim();
      console.log(`➕ Adding task: "${taskText}"`);
      
      try {
        const result = db.runSync('INSERT INTO tasks (task) VALUES (?);', [taskText]);
        if (result.changes > 0) {
          console.log('✅ Task added successfully');
          setLastOperation(`Added task: "${taskText}"`);
          fetchTasks();
          setTask('');
        } else {
          setLastOperation('Failed to add task');
          console.warn('⚠️ Task was not added - no rows affected');
        }
      } catch (error) {
        setLastOperation('Error adding task');
        console.error('❌ Error adding task: ', error);
      }
    } else {
      setLastOperation('Cannot add empty task');
      console.warn('⚠️ Cannot add empty task');
    }
  };

  const handleRemoveTask = (id) => {
    console.log(`🗑️ Deleting task with ID: ${id}`);
    
    try {
      const result = db.runSync('DELETE FROM tasks WHERE id = ?;', [id]);
      if (result.changes > 0) {
        console.log('✅ Task deleted successfully');
        setLastOperation(`Deleted task ID: ${id}`);
        fetchTasks();
      } else {
        setLastOperation('Failed to delete task');
        console.warn('⚠️ Task was not deleted - no rows affected');
      }
    } catch (error) {
      setLastOperation('Error deleting task');
      console.error('❌ Error deleting task: ', error);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>To-Do List</Text>
      
      {/* Database Status Section */}
      <View style={styles.statusContainer}>
        <View style={styles.statusRow}>
          <Text style={styles.statusLabel}>Database:</Text>
          <Text style={styles.statusValue}>{dbStatus}</Text>
        </View>
        <View style={styles.statusRow}>
          <Text style={styles.statusLabel}>Tasks Count:</Text>
          <Text style={styles.statusValue}>{taskItems.length}</Text>
        </View>
        <View style={styles.statusRow}>
          <Text style={styles.statusLabel}>Last Operation:</Text>
          <Text style={styles.statusValue}>{lastOperation}</Text>
        </View>
      </View>

      <View style={styles.inputContainer}>
        <TextInput
          style={styles.input}
          placeholder="Enter task"
          value={task}
          onChangeText={text => setTask(text)}
        />
        <Button title="Add" onPress={handleAddTask} />
      </View>

      <Text style={styles.sectionTitle}>Tasks ({taskItems.length})</Text>
      
      <FlatList
        data={taskItems}
        keyExtractor={item => item.id.toString()}
        renderItem={({ item }) => (
          <TouchableOpacity onPress={() => handleRemoveTask(item.id)}>
            <View style={styles.taskItem}>
              <Text style={styles.taskText}>{item.task}</Text>
              <Text style={styles.taskId}>ID: {item.id}</Text>
              {item.created_at && (
                <Text style={styles.taskDate}>
                  Created: {new Date(item.created_at).toLocaleString()}
                </Text>
              )}
            </View>
          </TouchableOpacity>
        )}
        ListEmptyComponent={
          <View style={styles.emptyContainer}>
            <Text style={styles.emptyText}>No tasks yet. Add one above!</Text>
          </View>
        }
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 50,
    paddingHorizontal: 20,
    backgroundColor: '#fff'
  },
  title: {
    fontSize: 24,
    marginBottom: 20,
    fontWeight: 'bold',
    textAlign: 'center'
  },
  statusContainer: {
    backgroundColor: '#f0f8ff',
    padding: 15,
    borderRadius: 8,
    marginBottom: 20,
    borderWidth: 1,
    borderColor: '#e0e0e0'
  },
  statusRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 5
  },
  statusLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: '#333'
  },
  statusValue: {
    fontSize: 14,
    color: '#666',
    flex: 1,
    textAlign: 'right'
  },
  inputContainer: {
    flexDirection: 'row',
    marginBottom: 20
  },
  input: {
    flex: 1,
    borderColor: '#999',
    borderWidth: 1,
    paddingHorizontal: 10,
    marginRight: 10,
    borderRadius: 4
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
    color: '#333'
  },
  taskItem: {
    padding: 15,
    backgroundColor: '#f9f9f9',
    borderBottomColor: '#ddd',
    borderBottomWidth: 1,
    borderRadius: 5,
    marginBottom: 5
  },
  taskText: {
    fontSize: 16,
    fontWeight: '500',
    color: '#333',
    marginBottom: 5
  },
  taskId: {
    fontSize: 12,
    color: '#666',
    fontStyle: 'italic'
  },
  taskDate: {
    fontSize: 12,
    color: '#888',
    marginTop: 2
  },
  emptyContainer: {
    padding: 40,
    alignItems: 'center'
  },
  emptyText: {
    fontSize: 16,
    color: '#999',
    fontStyle: 'italic'
  }
});
