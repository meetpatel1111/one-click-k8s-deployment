const express = require('express');
const fs = require('fs');
const path = require('path');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());
app.use(express.static('.')); // serve static files

const DATA_FILE = path.join('/data', 'data.json');

// Ensure data file exists
if (!fs.existsSync(DATA_FILE)) fs.writeFileSync(DATA_FILE, JSON.stringify([]));

// Get transactions
app.get('/api/transactions', (req, res) => {
    const data = JSON.parse(fs.readFileSync(DATA_FILE));
    res.json(data);
});

// Add transaction
app.post('/api/transactions', (req, res) => {
    const transactions = JSON.parse(fs.readFileSync(DATA_FILE));
    transactions.push(req.body);
    fs.writeFileSync(DATA_FILE, JSON.stringify(transactions, null, 2));
    res.json({ success: true });
});

// Delete transaction
app.delete('/api/transactions/:index', (req, res) => {
    const transactions = JSON.parse(fs.readFileSync(DATA_FILE));
    transactions.splice(req.params.index, 1);
    fs.writeFileSync(DATA_FILE, JSON.stringify(transactions, null, 2));
    res.json({ success: true });
});

app.listen(3000, () => console.log('Server running on port 3000'));
