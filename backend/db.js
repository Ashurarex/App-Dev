// In-memory database (for development)
// In production, replace with a real database like MongoDB, PostgreSQL, etc.

const db = {
    users: [],
    habits: [],
    userSettings: [],
    premiumStatus: []
};

module.exports = db;
