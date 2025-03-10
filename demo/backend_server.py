from flask import Flask, request, jsonify
from flask_sock import Sock
import gevent
import json

# Initialize Flask and Flask-Sock
app = Flask(__name__)
sock = Sock(app)

# Sample large JSON file
JSON_FILE = "interpolated_gps_trace.json"

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

@sock.route('/')
def stream_data(ws):
    """WebSocket function that streams data when 'start' message is received and stops when 'end' message is received."""
    generator = read_json()
    is_streaming = False  # Track whether the streaming should be active

    while True:
        message = ws.receive()  # Wait for client message
        if message == "start":
            is_streaming = True
            ws.send("Streaming started...")
            for item in generator:
                if not is_streaming:
                    break  # Stop sending if 'end' is received
                ws.send(item)
                gevent.sleep(1)
        elif message == "end":
            is_streaming = False
            ws.send("Streaming stopped.")
            break  # Close the WebSocket connection

if __name__ == '__main__':
    app.run(debug=True)
