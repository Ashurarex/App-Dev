const express = require('express');
const { body, validationResult } = require('express-validator');
const { v4: uuidv4 } = require('uuid');
const authMiddleware = require('../middleware/auth');
const db = require('../db');

const router = express.Router();

// All routes require authentication
router.use(authMiddleware);

// Get all habits for user
router.get('/', (req, res) => {
    const habits = db.habits
        .filter(h => h.userId === req.userId)
        .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

    res.json(habits);
});

// Get single habit
router.get('/:id', (req, res) => {
    const habit = db.habits.find(h => h.id === req.params.id && h.userId === req.userId);

    if (!habit) {
        return res.status(404).json({ error: 'Habit not found' });
    }

    res.json(habit);
});

// Create habit
router.post('/',
    [
        body('title').trim().notEmpty(),
        body('frequency').optional().isIn(['daily', 'weekly', 'custom'])
    ],
    (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const habit = {
            id: uuidv4(),
            userId: req.userId,
            title: req.body.title,
            notes: req.body.notes || '',
            completed: false,
            createdAt: new Date().toISOString(),
            frequency: req.body.frequency || 'daily',
            completedDates: [],
            streak: 0
        };

        db.habits.push(habit);
        res.status(201).json(habit);
    }
);

// Update habit
router.put('/:id',
    [
        body('title').optional().trim().notEmpty(),
        body('frequency').optional().isIn(['daily', 'weekly', 'custom'])
    ],
    (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const habitIndex = db.habits.findIndex(
            h => h.id === req.params.id && h.userId === req.userId
        );

        if (habitIndex === -1) {
            return res.status(404).json({ error: 'Habit not found' });
        }

        const habit = db.habits[habitIndex];

        // Update fields
        if (req.body.title !== undefined) habit.title = req.body.title;
        if (req.body.notes !== undefined) habit.notes = req.body.notes;
        if (req.body.completed !== undefined) habit.completed = req.body.completed;
        if (req.body.frequency !== undefined) habit.frequency = req.body.frequency;
        if (req.body.completedDates !== undefined) {
            habit.completedDates = req.body.completedDates;
            habit.streak = calculateStreak(habit.completedDates);
        }

        db.habits[habitIndex] = habit;
        res.json(habit);
    }
);

// Toggle habit completion for a date
router.post('/:id/toggle', (req, res) => {
    const habitIndex = db.habits.findIndex(
        h => h.id === req.params.id && h.userId === req.userId
    );

    if (habitIndex === -1) {
        return res.status(404).json({ error: 'Habit not found' });
    }

    const habit = db.habits[habitIndex];
    const date = req.body.date || new Date().toISOString().split('T')[0];

    const dateIndex = habit.completedDates.indexOf(date);

    if (dateIndex > -1) {
        // Remove date (uncomplete)
        habit.completedDates.splice(dateIndex, 1);
    } else {
        // Add date (complete)
        habit.completedDates.push(date);
    }

    habit.streak = calculateStreak(habit.completedDates);
    db.habits[habitIndex] = habit;

    res.json(habit);
});

// Delete habit
router.delete('/:id', (req, res) => {
    const habitIndex = db.habits.findIndex(
        h => h.id === req.params.id && h.userId === req.userId
    );

    if (habitIndex === -1) {
        return res.status(404).json({ error: 'Habit not found' });
    }

    db.habits.splice(habitIndex, 1);
    res.status(204).send();
});

// Helper function to calculate streak
function calculateStreak(completedDates) {
    if (completedDates.length === 0) return 0;

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

module.exports = router;
