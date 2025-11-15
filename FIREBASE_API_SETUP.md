# Firebase Cloud Functions REST API Setup

This guide shows how to expose your existing Firebase backend through a REST API using Firebase Cloud Functions.

## Overview

Your app already uses Firebase Authentication and Firestore. This REST API layer sits on top of your existing Firebase backend, allowing external access via HTTP endpoints while maintaining all your existing data and authentication.

## Setup

### 1. Install Firebase CLI

```bash
npm install -g firebase-tools
```

### 2. Login to Firebase

```bash
firebase login
```

### 3. Initialize Firebase Functions (if not already done)

```bash
firebase init functions
```

Select:
- Use an existing project (select your project)
- JavaScript or TypeScript (JavaScript recommended)
- Install dependencies with npm

### 4. Install Dependencies

```bash
cd functions
npm install
```

### 5. Update API URL in Flutter App

Edit `lib/services/api_service.dart` and update the `baseUrl`:

```dart
// For local testing with emulator:
static const String baseUrl = 'http://localhost:5001/YOUR_PROJECT_ID/us-central1/api';

// For production:
static const String baseUrl = 'https://us-central1-YOUR_PROJECT_ID.cloudfunctions.net/api';
```

Replace `YOUR_PROJECT_ID` with your actual Firebase project ID.

## Testing Locally

### 1. Start Firebase Emulators

```bash
firebase emulators:start
```

This will start:
- Functions emulator on port 5001
- Emulator UI on port 4000

### 2. Test the API

The API will be available at:
```
http://localhost:5001/YOUR_PROJECT_ID/us-central1/api
```

Test with curl:
```bash
# Health check
curl http://localhost:5001/YOUR_PROJECT_ID/us-central1/api/health
```

### 3. Get Firebase ID Token

To test authenticated endpoints, you need a Firebase ID token. You can get this from your Flutter app:

```dart
final user = FirebaseAuth.instance.currentUser;
final token = await user?.getIdToken();
print('Token: $token');
```

Then use it in your requests:
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:5001/YOUR_PROJECT_ID/us-central1/api/habits
```

## Deploying to Production

### 1. Deploy Functions

```bash
firebase deploy --only functions
```

### 2. Update Flutter App

Update the `baseUrl` in `lib/services/api_service.dart` to use the production URL:

```dart
static const String baseUrl = 'https://us-central1-YOUR_PROJECT_ID.cloudfunctions.net/api';
```

### 3. Test Production API

Your API will be live at:
```
https://us-central1-YOUR_PROJECT_ID.cloudfunctions.net/api
```

## API Endpoints

All endpoints (except `/health`) require Firebase Authentication token in the `Authorization` header:

```
Authorization: Bearer <firebase-id-token>
```

### Health Check
```
GET /api/health
```

### Habits

```
GET    /api/habits              - Get all user habits
GET    /api/habits/:id          - Get single habit
POST   /api/habits              - Create new habit
PUT    /api/habits/:id          - Update habit
POST   /api/habits/:id/toggle   - Toggle habit completion
DELETE /api/habits/:id          - Delete habit
```

### User Settings

```
GET    /api/users/settings      - Get user settings
PUT    /api/users/settings      - Update user settings
```

### Premium Status

```
GET    /api/users/premium       - Get premium status
PUT    /api/users/premium       - Update premium status
```

## Using the API in Flutter

### Example: Get All Habits

```dart
import 'package:habit_tracker/services/api_service.dart';

final apiService = ApiService();

try {
  final habits = await apiService.getHabits();
  print('Habits: $habits');
} catch (e) {
  print('Error: $e');
}
```

### Example: Create a Habit

```dart
final newHabit = Habit(
  userId: FirebaseAuth.instance.currentUser!.uid,
  title: 'Exercise',
  notes: '30 minutes daily',
  frequency: 'daily',
);

try {
  final created = await apiService.createHabit(newHabit);
  print('Created habit: ${created.id}');
} catch (e) {
  print('Error: $e');
}
```

### Example: Toggle Habit Completion

```dart
try {
  final updated = await apiService.toggleHabitCompletion(
    habitId,
    date: '2025-11-15', // optional, defaults to today
  );
  print('Streak: ${updated.streak}');
} catch (e) {
  print('Error: $e');
}
```

## Authentication Flow

The API uses Firebase Authentication tokens:

1. User signs in with Firebase Auth (email/password, Google, etc.)
2. Flutter app gets the Firebase ID token: `await user.getIdToken()`
3. API service automatically includes token in requests
4. Cloud Function verifies token with `admin.auth().verifyIdToken()`
5. Request is processed with authenticated user context

## Security

- All endpoints (except health check) require authentication
- Users can only access their own data
- Ownership is verified on every request
- Firebase Security Rules still apply to direct Firestore access
- CORS is enabled for web access

## Cost Considerations

Firebase Cloud Functions pricing:
- **Free tier**: 2M invocations/month, 400K GB-seconds, 200K CPU-seconds
- **Paid tier**: $0.40 per million invocations

For most apps, the free tier is sufficient. Monitor usage in Firebase Console.

## Monitoring

### View Logs

```bash
firebase functions:log
```

### Firebase Console

Monitor function execution, errors, and performance:
1. Go to Firebase Console
2. Select your project
3. Navigate to Functions section

## Troubleshooting

### CORS Issues

If you encounter CORS errors, the API already includes CORS middleware. Ensure your Flutter app is making requests with proper headers.

### Authentication Errors

- Verify the token is being sent: Check network requests in browser DevTools
- Token might be expired: Firebase tokens expire after 1 hour
- Refresh token: Call `await user.getIdToken(true)` to force refresh

### Function Not Found

- Ensure functions are deployed: `firebase deploy --only functions`
- Check function name matches: Should be `api`
- Verify project ID in URL

### Local Emulator Issues

- Ensure emulators are running: `firebase emulators:start`
- Check correct port: Default is 5001
- Use correct URL format: `http://localhost:5001/PROJECT_ID/REGION/FUNCTION_NAME`

## Next Steps

1. Test locally with emulators
2. Deploy to production
3. Update Flutter app with production URL
4. Monitor usage and performance
5. Add rate limiting if needed
6. Consider caching strategies
7. Implement webhook endpoints for external integrations

## Advantages of This Approach

✓ Uses your existing Firebase backend
✓ No data migration needed
✓ Firebase Auth integration
✓ Automatic scaling
✓ Built-in monitoring
✓ Easy deployment
✓ Secure by default
✓ RESTful API for external access
