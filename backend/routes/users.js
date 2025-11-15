const express = require('express');
const { body, validationResult } = require('express-validator');
const authMiddleware = require('../middleware/auth');
const db = require('../db');

const router = express.Router();

// All routes require authentication
router.use(authMiddleware);

// Get user settings
router.get('/settings', (req, res) => {
    const settings = db.userSettings.find(s => s.userId === req.userId);

    if (!settings) {
        return res.json({
            userId: req.userId,
            displayName: null,
            accentColorValue: null,
            avatarIconCodePoint: null,
            avatarColorValue: null
        });
    }

    res.json(settings);
});

// Update user settings
router.put('/settings',
    [
        body('displayName').optional().trim(),
        body('accentColorValue').optional().isInt(),
        body('avatarIconCodePoint').optional().isInt(),
        body('avatarColorValue').optional().isInt()
    ],
    (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        let settings = db.userSettings.find(s => s.userId === req.userId);

        if (!settings) {
            settings = { userId: req.userId };
            db.userSettings.push(settings);
        }

        // Update fields
        if (req.body.displayName !== undefined) settings.displayName = req.body.displayName;
        if (req.body.accentColorValue !== undefined) settings.accentColorValue = req.body.accentColorValue;
        if (req.body.avatarIconCodePoint !== undefined) settings.avatarIconCodePoint = req.body.avatarIconCodePoint;
        if (req.body.avatarColorValue !== undefined) settings.avatarColorValue = req.body.avatarColorValue;

        res.json(settings);
    }
);

// Get premium status
router.get('/premium', (req, res) => {
    const premium = db.premiumStatus.find(p => p.userId === req.userId);

    if (!premium) {
        return res.json({
            userId: req.userId,
            isPremium: false,
            premiumPlan: null,
            premiumExpiry: null
        });
    }

    res.json(premium);
});

// Update premium status (admin only - in production, this would be protected)
router.put('/premium',
    [
        body('isPremium').optional().isBoolean(),
        body('premiumPlan').optional().isString(),
        body('premiumExpiry').optional().isISO8601()
    ],
    (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        let premium = db.premiumStatus.find(p => p.userId === req.userId);

        if (!premium) {
            premium = { userId: req.userId };
            db.premiumStatus.push(premium);
        }

        // Update fields
        if (req.body.isPremium !== undefined) premium.isPremium = req.body.isPremium;
        if (req.body.premiumPlan !== undefined) premium.premiumPlan = req.body.premiumPlan;
        if (req.body.premiumExpiry !== undefined) premium.premiumExpiry = req.body.premiumExpiry;

        res.json(premium);
    }
);

module.exports = router;
