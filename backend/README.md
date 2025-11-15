# Habit Tracker REST API

A REST API backend for the Habit Tracker Flutter app.

## Setup

1. Install dependencies:
```bash
cd backend
npm install
```

2. Create `.env` file:
```bash
cp .env.example .env
```

3. Update `.env` with your configuration:
```
PORT=3000
JWT_SECRET=your-secret-key-here
NODE_ENV=development
```

4. Start the server:
```bash
npm start
# or for development with auto-reload
npm run dev
```

## API Endpoints

### Authentication

#### Sign Up
```
POST /api/auth/signup
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

#### Sign In
```
POST /api/auth/signin
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

### Habits (Requires Authentication)

All habit endpoints require `Authorization: Bearer <token>` header.

#### Get All Habits
```
GET /api/habits
```

#### Get Single Habit
```
GET /api/habits/:id
```

#### Create Habit
```
POST /api/habits
Content-Type: application/json

{
  "title": "Exercise",
  "notes": "30 minutes daily",
  "frequency": "daily"
}
```

#### Update Habit
```
PUT /api/habits/:id
Content-Type: application/json

{
  "title": "Updated title",
  "notes": "Updated notes",
  "frequency": "weekly"
}
```

#### Toggle Habit Completion
```
POST /api/habits/:id/toggle
Content-Type: application/json

{
  "date": "2025-11-15"  // optional, defaults to today
}
```

#### Delete Habit
```
DELETE /api/habits/:id
```

### User Settings (Requires Authentication)

#### Get User Settings
```
GET /api/users/settings
```

#### Update User Settings
```
PUT /api/users/settings
Content-Type: application/json

{
  "displayName": "John Doe",
  "accentColorValue": 4284513675,
  "avatarIconCodePoint": 59470,
  "avatarColorValue": 4280391411
}
```

### Premium Status (Requires Authentication)

#### Get Premium Status
```
GET /api/users/premium
```

#### Update Premium Status
```
PUT /api/users/premium
Content-Type: application/json

{
  "isPremium": true,
  "premiumPlan": "monthly",
  "premiumExpiry": "2026-11-15T00:00:00.000Z"
}
```

## Data Models

### Habit
```json
{
  "id": "uuid",
  "userId": "uuid",
  "title": "string",
  "notes": "string",
  "completed": false,
  "createdAt": "ISO8601 date",
  "frequency": "daily|weekly|custom",
  "completedDates": ["2025-11-15", "2025-11-14"],
  "streak": 2
}
```

## Notes

- This implementation uses in-memory storage for development
- For production, integrate a real database (MongoDB, PostgreSQL, etc.)
- Add rate limiting and additional security measures for production
- Consider implementing refresh tokens for better security
