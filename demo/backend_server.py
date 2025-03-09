from flask import Flask, request, jsonify
from flask_socketio import SocketIO, emit
import json
import time

app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins="*")

# Sample large JSON file
JSON_FILE = "demo/interpolated_gps_trace.json"

def read_json():
    """Generator function to read and yield objects from a large JSON array."""
    try:
        with open(JSON_FILE, "r") as file:
            data = json.load(file)  # Load full JSON (assuming it's an array)
            for item in data:
                yield item  # Yield one object at a time
    except FileNotFoundError:
        print(f"Error: File {JSON_FILE} not found.")
        yield {"error": f"File {JSON_FILE} not found"}
    except json.JSONDecodeError:
        print(f"Error: {JSON_FILE} contains invalid JSON.")
        yield {"error": f"File {JSON_FILE} contains invalid JSON"}

@app.route('/upload_route_points', methods=['POST'])
def upload_route_points():
    data = request.json
    if not data:
        return jsonify({"error": "No data provided"}), 400
    # Process the data (example: forward to another API)
    return jsonify({"message": "Data received", "received_data": data})

@socketio.on('connect')
def handle_connect():
    """Handle new WebSocket connection."""
    print("Client connected")

@socketio.on('request_stream')
def handle_stream_request():
    """Handles client requests to start streaming data."""
    print("Starting data stream")
    stream_data()

def stream_data():
    """WebSocket function that streams data every 1 second."""
    generator = read_json()
    for item in generator:
        emit('data', item)
        # Using sleep from time module instead of gevent
        socketio.sleep(1)  # SocketIO's built-in sleep

if __name__ == '__main__':
    socketio.run(app, debug=True, host='0.0.0.0', port=5001)