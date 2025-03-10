import json
import numpy as np
import datetime
from geopy.distance import geodesic

def interpolate_points(start, end, start_time, end_time, speed_mps=2.5):
    """
    Generates interpolated GPS points between the start and end locations.

    Args:
      start (dict): Contains 'latitude' and 'longitude' keys for the starting point.
      end (dict): Contains 'latitude' and 'longitude' keys for the ending point.
      start_time (datetime): Start time as a datetime object.
      end_time (datetime): End time as a datetime object.
      speed_mps (float): Assumed jogging pace in meters per second.

    Returns:
      list of dict: Each dictionary contains an interpolated 'datetime', 'latitude', and 'longitude'.
    """
    start_coords = (start["latitude"], start["longitude"])
    end_coords = (end["latitude"], end["longitude"])
    total_distance = geodesic(start_coords, end_coords).meters  # distance in meters
    
    # Total time in seconds between the two sessions
    total_seconds = (end_time - start_time).total_seconds()
    
    # If there's no time difference, return just the endpoint
    if total_seconds <= 0:
        return [{"datetime": end_time.isoformat(), "latitude": end["latitude"], "longitude": end["longitude"]}]
    
    # Determine number of steps (at least 2 to include start and end) based on distance and pace
    steps = max(2, int(total_distance / speed_mps))
    
    # Create linear interpolation for latitude, longitude, and time
    latitudes = np.linspace(start["latitude"], end["latitude"], steps)
    longitudes = np.linspace(start["longitude"], end["longitude"], steps)
    time_steps = [start_time + datetime.timedelta(seconds=(i * total_seconds / (steps - 1))) for i in range(steps)]
    
    return [{"datetime": t.isoformat(), "latitude": lat, "longitude": lon} 
            for t, lat, lon in zip(time_steps, latitudes, longitudes)]

def generate_full_trace(data, speed_mps=2.5):
    """
    Iterates over the sessions in the provided data and builds a full GPS trace
    with interpolated points between each consecutive session.

    Args:
      data (dict): JSON data containing sessions.
      speed_mps (float): Jogging pace for interpolation.

    Returns:
      list: Combined list of interpolated GPS points.
    """
    sessions = data["sessions"]
    full_trace = []
    
    # Iterate pair-wise over sessions
    for i in range(len(sessions) - 1):
        # Parse the datetime strings (handling the 'Z' as UTC)
        try:
            start_time = datetime.datetime.fromisoformat(sessions[i]["datetime"].replace("Z", "+00:00"))
        except Exception as e:
            print(f"Error parsing datetime for session {i}: {sessions[i]['datetime']} -> {e}")
            continue
        
        try:
            end_time = datetime.datetime.fromisoformat(sessions[i+1]["datetime"].replace("Z", "+00:00"))
        except Exception as e:
            print(f"Error parsing datetime for session {i+1}: {sessions[i+1]['datetime']} -> {e}")
            continue
        
        start_location = sessions[i]["location"]
        end_location = sessions[i+1]["location"]
        segment_trace = interpolate_points(start_location, end_location, start_time, end_time, speed_mps=speed_mps)
        
        # Avoid duplicate endpoints between segments by excluding the last point except for the final segment
        if i < len(sessions) - 2:
            full_trace.extend(segment_trace[:-1])
        else:
            full_trace.extend(segment_trace)
    
    return full_trace

if __name__ == '__main__':
    # Provided JSON data
    data = {
      "profile": {
        "age": 35,
        "gender": "male",
        "fitness_level": "beginner",
        "goal": "run 5K without stopping with a view",
        "preferred_distance": 5.0
      },
      "sessions": [
        {
          "datetime": "2025-03-09T03:29:25:37Z",
          "location": {
            "latitude": 37.80268094322795,
            "longitude": -122.40328083936252,
            "tag": "Hult Business School"
          },
          "distance_traveled": 0.0,
          "heartrate": 120,
          "destination": {
            "latitude": 37.80430419885728,
            "longitude": -122.42771921495286
          },
          "preferred_distance": 5.0
        },
        {
          "datetime": "2025-03-09T03:56:34Z",
          "location": {
            "latitude": 37.80430419885728,
            "longitude": -122.42771921495286,
            "tag": "Patrick's Green in Fort Mason"
          },
          "distance_traveled": 2.57,
          "heartrate": 135,
          "destination": {
            "latitude": 37.80361832716698,
            "longitude": -122.46499429128124,
            "tag": "Chrissy Field"
          },
          "preferred_distance": 5.0,
          "goal": "I'm feeling good. Let's make this a 10km"
        },
        {
          "datetime": "2025-03-09T08:10:00Z",
          "location": {
            "latitude": 37.80503307111832,
            "longitude": -122.4488361765279,
            "tag": "Little Marina Green Picnic Area"
          },
          "distance_traveled": 1.2,
          "heartrate": 130,
          "destination": {
            "latitude": 37.80361832716698,
            "longitude": -122.46499429128124
          },
          "preferred_distance": 5.0,
          "goal": "Oh no. I pushed too hard. I don't think I can do the 10km. Please get me back.",
          "current_location_tag": "Patrick's Green in Fort Mason"
        },
        {
          "datetime": "2025-03-09T08:10:00Z",
          "location": {
            "latitude": 37.805926747186746,
            "longitude": -122.44129548409606,
            "tag": "Marina Green"
          },
          "distance_traveled": 1.2,
          "heartrate": 172,
          "destination": {
            "latitude": 37.80268094322795,
            "longitude": -122.40328083936252,
            "tag": "Hult Business School"
          },
          "preferred_distance": 5.0,
          "goal": "Just get me back safely"
        }
      ]
    }
    
    # Generate and print the full GPS trace
    full_trace = generate_full_trace(data, speed_mps=2.5)
    print(json.dumps(full_trace, indent=2))
