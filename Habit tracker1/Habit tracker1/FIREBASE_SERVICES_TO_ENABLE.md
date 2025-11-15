# Firebase Services to Enable - Based on Your Code

Based on your code analysis, here are the **exact services** you need to enable:

## ✅ Required Services

### 1. **Firebase Authentication** 🔐
**Location in code:** `lib/services/auth_service.dart`

**What your app uses:**
- ✅ Email/Password sign-up (line 22-29)
- ✅ Email/Password sign-in (line 34-41)
- ✅ Google Sign-In (line 52-99)
- ⚠️ Phone Auth (line 104-118) - *Optional, scaffold only*

**Enable in Firebase Console:**
1. Go to **Authentication** → Click **"Get started"**
2. Go to **"Sign-in method"** tab
3. Enable **Email/Password**:
   - Click on "Email/Password"
   - Toggle **"Enable"** to ON
   - Click **"Save"**
4. Enable **Google**:
   - Click on "Google"
   - Toggle **"Enable"** to ON
   - Enter a **Project support email** (your email)
   - Click **"Save"**
5. (Optional) Enable **Phone**:
   - Only if you plan to use phone authentication
   - Click on "Phone"
   - Toggle **"Enable"** to ON
   - Click **"Save"**

---

### 2. **Cloud Firestore Database** 💾
**Location in code:** `lib/services/firestore_service.dart`

**What your app uses:**
- ✅ Create habits (line 9-13)
- ✅ Read/Stream habits (line 15-17)
- ✅ Update habits (line 19-21)
- ✅ Delete habits (line 23-25)
- Collection name: `habits`

**Enable in Firebase Console:**
1. Go to **Firestore Database** → Click **"Create database"**
2. Choose **"Start in test mode"** (for development)
   - ⚠️ **Important**: This allows read/write for 30 days
   - For production, you'll need security rules (see below)
3. Select a **location** (choose closest to your users)
   - Examples: `us-central`, `europe-west`, `asia-southeast1`
4. Click **"Enable"**
5. Wait for database creation (~1 minute)

**Set Security Rules (After enabling):**
Go to **Firestore Database** → **Rules** tab and paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own habits
    match /habits/{habitId} {
      allow read, write: if request.auth != null 
        && request.auth.uid == resource.data.userId;
    }
  }
}
```

Click **"Publish"** to save rules.

---

## 📋 Quick Checklist

- [ ] **Authentication** → Get started
- [ ] **Email/Password** → Enable
- [ ] **Google** → Enable (with support email)
- [ ] **Firestore Database** → Create database
- [ ] **Firestore Rules** → Set security rules
- [ ] Test app: `flutter run -d chrome`

---

## 🎯 Step-by-Step Instructions

### Step 1: Enable Authentication
1. Open https://console.firebase.google.com/
2. Select project: **habit-tracker-93de7**
3. Click **"Authentication"** in left sidebar
4. Click **"Get started"** button
5. Go to **"Sign-in method"** tab

### Step 2: Enable Email/Password
1. Click on **"Email/Password"**
2. Toggle **"Enable"** switch to ON
3. Click **"Save"**

### Step 3: Enable Google Sign-In
1. Click on **"Google"**
2. Toggle **"Enable"** switch to ON
3. Enter **Project support email** (your email address)
4. Click **"Save"**

### Step 4: Enable Firestore
1. Click **"Firestore Database"** in left sidebar
2. Click **"Create database"** button
3. Select **"Start in test mode"**
4. Click **"Next"**
5. Choose location (e.g., `us-central`)
6. Click **"Enable"**

### Step 5: Set Security Rules
1. In Firestore Database, go to **"Rules"** tab
2. Replace the rules with the code above
3. Click **"Publish"**

---

## ✅ Verification

After enabling, test your app:

```bash
flutter run -d chrome
```

**What to test:**
1. ✅ Create account with email/password → Should work
2. ✅ Sign in with email/password → Should work
3. ✅ Sign in with Google → Should work
4. ✅ Create a habit → Should save to Firestore
5. ✅ View habits → Should load from Firestore

---

## 📝 Summary

**Required Services:**
1. ✅ **Firebase Authentication** (Email/Password + Google)
2. ✅ **Cloud Firestore Database**

**Optional:**
- Phone Authentication (code is ready but not required)

That's it! Just these 2 services and your app will be fully functional! 🎉

