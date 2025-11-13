import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';

// Your Firebase config from Firebase Console
const firebaseConfig = {
  apiKey: 'AIzaSyAZH9ZtSip0bIr0tjIKF6-XlkjYdaXSCM4',
  authDomain: 'todolistapp-dc921.firebaseapp.com',
  projectId: 'todolistapp-dc921',
  storageBucket: 'todolistapp-dc921.appspot.com',  // Corrected this line
  messagingSenderId: '156605416369',
  appId: '1:156605416369:web:fe0472f19b9a215dbb3390',
  measurementId: 'G-H4S26DR8ZH',
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

export { db };

