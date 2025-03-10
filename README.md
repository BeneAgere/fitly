# AI-Driven Personal Running Coach

**Your intelligent companion for personalized running experiences.**

---

## Overview

This project provides an AI-powered personal running coach designed to enhance your running experience through real-time route adjustments, intelligent coaching, and responsive feedback. Using advanced AI, geospatial data, and dynamic interactions, it tailors each running session uniquely to your preferences, goals, and performance.

---

## Features

- **Dynamic Route Generation:**
  - Automatically generates and adjusts running routes based on your live location and real-time conditions.

- **Voice-Activated Coaching:**
  - Hands-free interaction allows seamless communication, guidance, and motivation throughout your run.

- **Real-Time Performance Tracking:**
  - Integrates GPS and fitness data to provide instant feedback on pace, distance, and progress.

- **Contextual Recommendations:**
  - Suggests nearby points of interest, hydration stations, or rest areas dynamically based on your route and preferences.

- **Emergency Assistance:**
  - AI detects signs of distress or fatigue, offering options such as route shortening or transportation via rideshare services.

---

## Technical Components

- **Frontend:**
  - HTML/CSS/JavaScript
  - WebRTC for real-time audio streaming

- **Backend:**
  - Flask (Python)
  - Flask-Sock for WebSocket support

- **AI Services:**
  - OpenAI GPT-4o for real-time conversational interactions

- **Geospatial Services:**
  - Google Maps API (Places, Routes)

---

## Getting Started

### Installation

Clone the repository and install dependencies:

```sh
git clone [your_repository_url]
cd your_repository
pip install -r requirements.txt
```

### Running the App

Start the backend server:

```sh
python backend_server.py
```

Open your web browser and navigate to:

```
http://localhost:5001
```

### Testing WebSocket Functionality

Use Postman or a similar tool to connect to:

```
ws://localhost:5001/
```

Send `start` to initiate data streaming and `end` to stop.

---

## Contributing

Feel free to fork, submit issues, or create pull requests to contribute enhancements, bug fixes, or new features.

