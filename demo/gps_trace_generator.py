import json
import requests
import datetime

# Google Maps API Key (replace with your actual API key)
API_KEY = ''

# Function to get route from Google Maps API
def get_route_google_maps(start, end):
    url = 'https://routes.googleapis.com/directions/v2:computeRoutes'
    headers = {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': API_KEY,
        'X-Goog-FieldMask': 'routes.polyline.encodedPolyline'
    }
    body = {
        "origin": {"location": {"latLng": {"latitude": start["latitude"], "longitude": start["longitude"]}}},
        "destination": {"location": {"latLng": {"latitude": end["latitude"], "longitude": end["longitude"]}}},
        "travelMode": "WALK"
    }
    response = requests.post(url, headers=headers, json=body)
    response.raise_for_status()
    return response.json()

# Decode polyline
import polyline

def decode_polyline(encoded_polyline):
    return polyline.decode(encoded_polyline)

# Read JSONL data
with open('demo_user_story_data.json', 'r') as file:
    json_data = json.load(file)

# Process sessions
realistic_trace = []
for i in range(len(json_data["sessions"]) - 1):
    start_session = json_data["sessions"][i]
    end_session = json_data["sessions"][i + 1]
    start_time = datetime.datetime.fromisoformat(start_session["datetime"].replace("Z", "+00:00"))
    end_time = datetime.datetime.fromisoformat(end_session["datetime"].replace("Z", "+00:00"))
    
    # Fetch realistic route from Google Maps
    route_data = get_route_google_maps(start_session["location"], end_session["location"])
    polyline_points = decode_polyline(route_data['routes'][0]['polyline']['encodedPolyline'])

    # Interpolate timestamps evenly across points
    total_seconds = (end_time - start_time).total_seconds()
    timestamps = [start_time + datetime.timedelta(seconds=i * (total_seconds / len(polyline_points))) for i in range(len(polyline_points))]

    segment_trace = [{"datetime": ts.isoformat(), "latitude": lat, "longitude": lon} for ts, (lat, lon) in zip(timestamps, polyline_points)]
    realistic_trace.extend(segment_trace)

# Output the realistic GPS trace
print(json.dumps(realistic_trace, indent=2))

# Save the realistic GPS trace to a file
with open('interpolated_gps_trace.json', 'w') as outfile:
    json.dump(realistic_trace, outfile, indent=2)