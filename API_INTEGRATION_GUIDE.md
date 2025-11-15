# REST API Integration Guide

This guide explains how to use the REST API backend with your Habit Tracker Flutter app.

## Overview

The app now supports two backend options:
1. **Firebase** (default) - Cloud-based backend with authentication and Firestore
2. **REST API** - Custom Node.js/Express backend with JWT authentication

## Backend Setup

### 1. Install Dependencies

```bash
cd backend
npm install
```

### 2. Configure Environment

Create a `.env` file in the `backend` directory:

```bash
cp .env.example .env
```

Edit `.env`:
```
PORT=3000
JWT_SECRET=your-super-secret-jwt-key-change-this
NODE_ENV=development
```

### 3. Start the Server

```bash
# Production mode
npm start

# Development mode (with auto-reload)
npm run dev
```

The API will be available at `http://localhost:3000`

## Flutter App Configuration

### 1. Install HTTP Package

The `http` package has been added to `pubspec.yaml`. Run:

```bash
flutter pub get
```

### 2. Configure API URL

Edit `lib/config/api_config.dart`:

```dart
class ApiConfig {
  // For local development:
  static const String baseUrl = 'http://localhost:3000/api';
  
  // For Android emulator:
  // static const String baseUrl = 'http://10.0.2.2:3000/api';
  
  // For production:
  // static const String baseUrl = 'https://your-api-domain.com/api';
  
  // Toggle between Firebase and REST API
  static const bool useRestApi = true; // Set to true to use REST API
}
```

### 3. Platform-Specific URLs

- **iOS Simulator**: `http://localhost:3000/api`
- **Android Emulator**: `http://10.0.2.2:3000/api`
- **Physical Device**: `http://YOUR_COMPUTER_IP:3000/api` (find your IP with `ipconfig` on Windows or `ifconfig` on Mac/Linux)

## Using the API Service

### Authentication

```dart
import 'package:habit_tracker/services/api_service.dart';

final apiService = ApiService();

// Sign up
try {
  final result = await apiService.signUp('user@example.com', 'password123');
  print('Token: ${result['token']}');
  print('User: ${result['user']}');
} catch (e) {
  print('Error: $e');
}

// Sign in
try {
  final result = await apiService.signIn('user@example.com', 'password123');
  print('Token: ${result['token']}');
} catch (e) {
  print('Error: $e');
}
```

### Habit Management

```dart
// Get all habits
final habits = await apiService.getHabits();

// Create a habit
final newHabit = Habit(
  userId: 'user-id',
  title: 'Exercise',
  notes: '30 minutes daily',
  frequency: 'daily',
);
final created = await apiService.createHabit(newHabit);

// Update a habit
habit.title = 'Updated Title';
final updated = await apiService.updateHabit(habit);

// Toggle completion
final toggled = await apiService.toggleHabitCompletion(
  habit.id,
  date: '2025-11-15', // optional
);

// Delete a habit
await apiService.deleteHabit(habit.id);
```

### User Settings

```dart
// Get settings
final settings = await apiService.getUserSettings();

// Update settings
await apiService.updateUserSettings(
  displayName: 'John Doe',
  accentColorValue: 4284513675,
);
```

### Premium Status

```dart
// Get premium status
final premium = await apiService.getPremiumStatus();

// Update premium status
await apiService.updatePremiumStatus(
  isPremium: true,
  premiumPlan: 'monthly',
  premiumExpiry: DateTime.now().add(Duration(days: 30)),
);
```

## API Endpoints Reference

### Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/signup` | Create new account |
| POST | `/api/auth/signin` | Sign in to account |

### Habits (Authenticated)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/habits` | Get all user habits |
| GET | `/api/habits/:id` | Get single habit |
| POST | `/api/habits` | Create new habit |
| PUT | `/api/habits/:id` | Update habit |
| POST | `/api/habits/:id/toggle` | Toggle completion |
| DELETE | `/api/habits/:id` | Delete habit |

### User (Authenticated)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/users/settings` | Get user settings |
| PUT | `/api/users/settings` | Update user settings |
| GET | `/api/users/premium` | Get premium status |
| PUT | `/api/users/premium` | Update premium status |

## Switching Between Firebase and REST API

To switch backends, update `lib/config/api_config.dart`:

```dart
// Use REST API
static const bool useRestApi = true;

// Use Firebase
static const bool useRestApi = false;
```

Then modify your services to check this flag and use the appropriate backend.

## Production Deployment

### Backend Deployment Options

1. **Heroku**
   ```bash
   heroku create your-app-name
   heroku config:set JWT_SECRET=your-secret
   git push heroku main
   ```

2. **DigitalOcean App Platform**
   - Connect your GitHub repo
   - Set environment variables
   - Deploy

3. **AWS EC2 / Elastic Beanstalk**
   - Set up Node.js environment
   - Configure security groups
   - Deploy application

4. **Vercel / Railway / Render**
   - Connect repository
   - Configure environment
   - Auto-deploy on push

### Database Integration

For production, replace the in-memory database with a real database:

**MongoDB Example:**
```bash
npm install mongoose
```

```javascript
// db.js
const mongoose = require('mongoose');

mongoose.connect(process.env.MONGODB_URI);

const userSchema = new mongoose.Schema({
  email: String,
  password: String,
  createdAt: Date
});

const habitSchema = new mongoose.Schema({
  userId: String,
  title: String,
  notes: String,
  completed: Boolean,
  createdAt: Date,
  frequency: String,
  completedDates: [String],
  streak: Number
});

module.exports = {
  User: mongoose.model('User', userSchema),
  Habit: mongoose.model('Habit', habitSchema)
};
```

**PostgreSQL Example:**
```bash
npm install pg sequelize
```

## Security Considerations

1. **Use HTTPS in production**
2. **Set strong JWT_SECRET**
3. **Implement rate limiting**
4. **Add input validation**
5. **Use environment variables**
6. **Enable CORS properly**
7. **Implement refresh tokens**
8. **Add request logging**

## Testing the API

Use tools like Postman, Insomnia, or curl:

```bash
# Sign up
curl -X POST http://localhost:3000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Get habits (replace TOKEN with actual token)
curl -X GET http://localhost:3000/api/habits \
  -H "Authorization: Bearer TOKEN"
```

## Troubleshooting

### Connection Issues

- **Android Emulator**: Use `10.0.2.2` instead of `localhost`
- **iOS Simulator**: Use `localhost`
- **Physical Device**: Use your computer's IP address
- **Firewall**: Ensure port 3000 is not blocked

### CORS Issues

The backend includes CORS middleware. If you still have issues, check the CORS configuration in `server.js`.

### Token Issues

- Tokens expire after 7 days
- Store tokens securely using `shared_preferences` or `flutter_secure_storage`
- Implement token refresh logic for better UX

## Next Steps

1. Implement token persistence in Flutter app
2. Add error handling and retry logic
3. Implement offline support with local caching
4. Add real-time updates (WebSockets or polling)
5. Integrate with a production database
6. Deploy backend to cloud platform
7. Add monitoring and logging
8. Implement automated tests
