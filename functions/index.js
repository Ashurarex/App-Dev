const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const cors = require('cors');

admin.initializeApp();
const db = admin.firestore();
const auth = admin.auth();

const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

// Auth middleware
const authenticate = async (req, res, next) => {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({ error: 'Unauthorized' });
    }

    const token = authHeader.split('Bearer ')[1];

    try {
        const decodedToken = await auth.verifyIdToken(token);
        req.userId = decodedToken.uid;
        req.user = decodedToken;
        next();
    } catch (error) {
        res.status(401).json({ error: 'Invalid token' });
    }
};

// Health check
app.get('/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// ==================== HABITS ENDPOINTS ====================

// Get all habits for authenticated user
app.get('/habits', authenticate, async (req, res) => {
    try {
        const snapshot = await db.collection('habits')
            .where('userId', '==', req.userId)
            .get();

        const habits = [];
        snapshot.forEach(doc => {
            const data = doc.data();
            habits.push({
                id: doc.id,
                ...data,
                createdAt: data.createdAt?.toDate?.()?.toISOString() || data.createdAt
            });
        });

        // Sort by createdAt (newest first)
        habits.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

        res.json(habits);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get single habit
app.get('/habits/:id', authenticate, async (req, res) => {
    try {
        const doc = await db.collection('habits').doc(req.params.id).get();

        if (!doc.exists) {
            return res.status(404).json({ error: 'Habit not found' });
        }

        const data = doc.data();

        // Verify ownership
        if (data.userId !== req.userId) {
            return res.status(403).json({ error: 'Forbidden' });
        }

        res.json({
            id: doc.id,
            ...data,
            createdAt: data.createdAt?.toDate?.()?.toISOString() || data.createdAt
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Create habit
app.post('/habits', authenticate, async (req, res) => {
    try {
        const { title, notes, frequency } = req.body;

        if (!title || title.trim() === '') {
            return res.status(400).json({ error: 'Title is required' });
        }

        const habitData = {
            userId: req.userId,
            title: title.trim(),
            notes: notes || '',
            completed: false,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            frequency: frequency || 'daily',
            completedDates: [],
            streak: 0
        };

        const docRef = await db.collection('habits').add(habitData);
        const doc = await docRef.get();
        const data = doc.data();

        res.status(201).json({
            id: doc.id,
            ...data,
            createdAt: data.createdAt?.toDate?.()?.toISOString() || new Date().toISOString()
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Update habit
app.put('/habits/:id', authenticate, async (req, res) => {
    try {
        const docRef = db.collection('habits').doc(req.params.id);
        const doc = await docRef.get();

        if (!doc.exists) {
            return res.status(404).json({ error: 'Habit not found' });
        }

        const data = doc.data();

        // Verify ownership
        if (data.userId !== req.userId) {
            return res.status(403).json({ error: 'Forbidden' });
        }

        const updates = {};
        if (req.body.title !== undefined) updates.title = req.body.title;
        if (req.body.notes !== undefined) updates.notes = req.body.notes;
        if (req.body.completed !== undefined) updates.completed = req.body.completed;
        if (req.body.frequency !== undefined) updates.frequency = req.body.frequency;
        if (req.body.completedDates !== undefined) {
            updates.completedDates = req.body.completedDates;
            updates.streak = calculateStreak(req.body.completedDates);
        }

        await docRef.update(updates);
        const updatedDoc = await docRef.get();
        const updatedData = updatedDoc.data();

        res.json({
            id: updatedDoc.id,
            ...updatedData,
            createdAt: updatedData.createdAt?.toDate?.()?.toISOString() || updatedData.createdAt
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Toggle habit completion
app.post('/habits/:id/toggle', authenticate, async (req, res) => {
    try {
        const docRef = db.collection('habits').doc(req.params.id);
        const doc = await docRef.get();

        if (!doc.exists) {
            return res.status(404).json({ error: 'Habit not found' });
        }

        const data = doc.data();

        // Verify ownership
        if (data.userId !== req.userId) {
            return res.status(403).json({ error: 'Forbidden' });
        }

        const date = req.body.date || new Date().toISOString().split('T')[0];
        let completedDates = data.completedDates || [];

        const dateIndex = completedDates.indexOf(date);

        if (dateIndex > -1) {
            // Remove date (uncomplete)
            completedDates = completedDates.filter(d => d !== date);
        } else {
            // Add date (complete)
            completedDates.push(date);
        }

        const streak = calculateStreak(completedDates);

        await docRef.update({
            completedDates,
            streak
        });

        const updatedDoc = await docRef.get();
        const updatedData = updatedDoc.data();

        res.json({
            id: updatedDoc.id,
            ...updatedData,
            createdAt: updatedData.createdAt?.toDate?.()?.toISOString() || updatedData.createdAt
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Delete habit
app.delete('/habits/:id', authenticate, async (req, res) => {
    try {
        const docRef = db.collection('habits').doc(req.params.id);
        const doc = await docRef.get();

        if (!doc.exists) {
            return res.status(404).json({ error: 'Habit not found' });
        }

        const data = doc.data();

        // Verify ownership
        if (data.userId !== req.userId) {
            return res.status(403).json({ error: 'Forbidden' });
        }

        await docRef.delete();
        res.status(204).send();
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// ==================== USER ENDPOINTS ====================

// Get user settings
app.get('/users/settings', authenticate, async (req, res) => {
    try {
        const doc = await db.collection('users').doc(req.userId).get();

        if (!doc.exists) {
            return res.json({
                userId: req.userId,
                displayName: null,
                accentColorValue: null,
                avatarIconCodePoint: null,
                avatarColorValue: null
            });
        }

        res.json({
            userId: req.userId,
            ...doc.data()
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Update user settings
app.put('/users/settings', authenticate, async (req, res) => {
    try {
        const updates = {};
        if (req.body.displayName !== undefined) updates.displayName = req.body.displayName;
        if (req.body.accentColorValue !== undefined) updates.accentColorValue = req.body.accentColorValue;
        if (req.body.avatarIconCodePoint !== undefined) updates.avatarIconCodePoint = req.body.avatarIconCodePoint;
        if (req.body.avatarColorValue !== undefined) updates.avatarColorValue = req.body.avatarColorValue;

        await db.collection('users').doc(req.userId).set(updates, { merge: true });

        const doc = await db.collection('users').doc(req.userId).get();
        res.json({
            userId: req.userId,
            ...doc.data()
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get premium status
app.get('/users/premium', authenticate, async (req, res) => {
    try {
        const doc = await db.collection('users').doc(req.userId).get();

        if (!doc.exists) {
            return res.json({
                userId: req.userId,
                isPremium: false,
                premiumPlan: null,
                premiumExpiry: null
            });
        }

        const data = doc.data();
        res.json({
            userId: req.userId,
            isPremium: data.isPremium || false,
            premiumPlan: data.premiumPlan || null,
            premiumExpiry: data.premiumExpiry?.toDate?.()?.toISOString() || data.premiumExpiry || null
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Update premium status
app.put('/users/premium', authenticate, async (req, res) => {
    try {
        const updates = {};
        if (req.body.isPremium !== undefined) updates.isPremium = req.body.isPremium;
        if (req.body.premiumPlan !== undefined) updates.premiumPlan = req.body.premiumPlan;
        if (req.body.premiumExpiry !== undefined) {
            updates.premiumExpiry = admin.firestore.Timestamp.fromDate(new Date(req.body.premiumExpiry));
        }

        await db.collection('users').doc(req.userId).set(updates, { merge: true });

        const doc = await db.collection('users').doc(req.userId).get();
        const data = doc.data();

        res.json({
            userId: req.userId,
            isPremium: data.isPremium || false,
            premiumPlan: data.premiumPlan || null,
            premiumExpiry: data.premiumExpiry?.toDate?.()?.toISOString() || data.premiumExpiry || null
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Helper function to calculate streak
function calculateStreak(completedDates) {
    if (!completedDates || completedDates.length === 0) return 0;

    const sortedDates = completedDates
        .map(d => new Date(d))
        .sort((a, b) => b - a);

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);

    const mostRecent = new Date(sortedDates[0]);
    mostRecent.setHours(0, 0, 0, 0);

    // Check if streak is still active
    if (mostRecent < yesterday) {
        return 0;
    }

    let streak = 1;
    let expectedDate = new Date(mostRecent);
    expectedDate.setDate(expectedDate.getDate() - 1);

    for (let i = 1; i < sortedDates.length; i++) {
        const currentDate = new Date(sortedDates[i]);
        currentDate.setHours(0, 0, 0, 0);

        if (currentDate.getTime() === expectedDate.getTime()) {
            streak++;
            expectedDate.setDate(expectedDate.getDate() - 1);
        } else {
            break;
        }
    }

    return streak;
}

// Export the Express app as a Firebase Cloud Function
exports.api = functions.https.onRequest(app);
