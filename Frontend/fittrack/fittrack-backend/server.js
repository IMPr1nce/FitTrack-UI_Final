const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

let workouts = [];

app.get('/', (req, res) => {
  res.send('FitTrack backend is running');
});

app.get('/workouts', (req, res) => {
  res.json(workouts);
});

app.post('/workouts', (req, res) => {
  const { exercise, weight, reps } = req.body;

  if (!exercise || !weight || !reps) {
    return res.status(400).json({ error: 'Missing fields' });
  }

  const newWorkout = {
    id: Date.now(),
    exercise,
    weight,
    reps,
    createdAt: new Date().toISOString(),
  };

  workouts.push(newWorkout);
  res.status(201).json(newWorkout);
});

app.listen(3000, '0.0.0.0', () => {
  console.log('Server running on http://localhost:3000');
});