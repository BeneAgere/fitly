from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

# Replace with the actual URL of your mobile endpoint
MOBILE_ENDPOINT_URL = "https://example.com/api/mobile-endpoint"

@app.route('/upload_route_points', methods=['POST'])
def upload_route_points():
    """
    Expects a JSON array of route points in the request body.
    Each item:
      {
        "datetime": "2025-03-09T03:29:25.370000+00:00",
        "latitude": 37.80269,
        "longitude": -122.40321
      }
    For each point, POST to a mobile app endpoint with schema:
      {
        "audio": "base",
        "pace": "aaaa",
        "time": "aaa",
        "route": 1
      }
    """
    # Parse JSON from request body
    data = request.get_json()

    if not isinstance(data, list):
        return jsonify({"error": "Expected a JSON array of route points"}), 400

    # We'll store responses for demonstration
    mobile_responses = []

    for point in data:
        # We are using placeholders for 'audio' and 'pace' here.
        payload = {
            "audio": "base",
            "pace": "aaaa",  # In a real scenario, compute pace from your data
            "time": point["datetime"],  # The 'datetime' from the route point
            "route": 1                  # Or any dynamic route ID
        }

        # Make the POST call to the mobile endpoint
        try:
            response = requests.post(MOBILE_ENDPOINT_URL, json=payload, timeout=5)
            response.raise_for_status()
            mobile_responses.append({"point": point, "status": response.status_code})
        except requests.exceptions.RequestException as e:
            # If there's any network or HTTP error, handle it here
            mobile_responses.append({"point": point, "error": str(e)})

    return jsonify({
        "message": "Processed route points",
        "count": len(data),
        "mobile_responses": mobile_responses
    }), 200

if __name__ == '__main__':
    # Run the Flask development server
    app.run(debug=True, port=5000)
