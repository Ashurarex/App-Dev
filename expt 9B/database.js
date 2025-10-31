import * as SQLite from 'expo-sqlite';
const db = SQLite.openDatabase('todolist.db');

export const initDB = () => {
  db.transaction(tx => {
    tx.executeSql(
      `CREATE TABLE IF NOT EXISTS todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        done INTEGER DEFAULT 0,
        created_at TEXT
      );`
    );
  }, (err) => {
    console.log('DB init error', err);
  });
};

export const addTodo = (title, cb) => {
  db.transaction(tx => {
    tx.executeSql('INSERT INTO todos (title, done, created_at) VALUES (?, ?, ?);', [title, 0, new Date().toISOString()], (_, result) => {
      cb && cb(result);
    }, (txObj, error) => {
      console.log('Insert error', error);
    });
  });
};

export const getTodos = (cb) => {
  db.transaction(tx => {
    tx.executeSql('SELECT * FROM todos ORDER BY id DESC;', [], (_, { rows }) => {
      cb && cb(rows._array);
    });
  });
};

export const toggleTodo = (id, done, cb) => {
  db.transaction(tx => {
    tx.executeSql('UPDATE todos SET done = ? WHERE id = ?;', [done ? 0 : 1, id], (_, result) => {
      cb && cb(result);
    });
  });
};

export const deleteTodo = (id, cb) => {
  db.transaction(tx => {
    tx.executeSql('DELETE FROM todos WHERE id = ?;', [id], (_, result) => {
      cb && cb(result);
    });
  });
};
