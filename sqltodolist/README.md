# React To-Do App with SQLite Storage

## Overview
This project is a React-based To-Do application that enables users to manage tasks efficiently. It uses SQLite as a lightweight, file-based local database to store task data persistently within the app environment.

## Features
- Add, edit, and delete tasks with a clean, intuitive UI.
- Task data is saved and retrieved from an embedded SQLite database.
- Offline-capable since SQLite works locally without needing an external server.
- Responsive design for usability on various devices.

## Setup Instructions
1. Clone the repository.
2. Install dependencies using `npm install` or `yarn`.
3. Ensure SQLite database is accessible within the app environment (via node modules or appropriate wrapper).
4. Start the React app with `npm start` or `yarn start`.
5. Interact with the app to add or manage tasks, which will be saved to SQLite locally.

## Technology Stack
- React.js for frontend interface.
- SQLite for local persistent task storage.
- Node.js environment for SQLite integration.

## Notes
SQLite is a self-contained, serverless database engine ideal for desktop and light web applications, providing efficient local data storage without requiring a separate database server setup.


