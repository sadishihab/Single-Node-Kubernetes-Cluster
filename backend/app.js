const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

mongoose.connect('mongodb://mongo:27017/multiapp', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error(err));

app.get('/', (req, res) => {
  res.send('Hello from Backend (Node.js + MongoDB)');
});

// <-- Add this new route
app.get('/api', (req, res) => {
  res.json({ message: 'Hello from /api route' });
});

const PORT = 5000;
app.listen(PORT, () => console.log(`Backend running on port ${PORT}`));
