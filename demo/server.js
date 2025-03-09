// server.js
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());

app.get('/session', (req, res) => {
  res.json({ apiKey: "" });
});

app.listen(4000, () => {
  console.log("Server running on port 4000");
});