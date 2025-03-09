tools = [{
    "type": "function",
    "function": {
        "name": "get_running_route",
        "description": "Get Route from start to end destinations",
        "parameters": {
            "type": "object",
            "properties": {
                "start_lat": {
                    "type": "string",
                    "description": "Starting latitude"
                },
                "start_long": {
                    "type": "string",
                    "description": "Start Longitude"
                },
                "end_lat": {
                    "type": "string",
                    "description": "End Latitude"
                },
                "end_long": {
                    "type": "string",
                    "description": "End Longitude"
                }
            },
            "required": [
                "location"
            ],
            "additionalProperties": False
        },
        "strict": True
    }
}]


import requests

def get_walking_route(api_key, start_lat,start_long, end_lat,end_long):
    url = "https://routes.googleapis.com/directions/v2:computeRoutes"
    headers = {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": api_key,
        "X-Goog-FieldMask": "routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline"
    }
    data = {
        "origin": {
            "location": {
                "latLng": {
                    "latitude": start_lat,
                    "longitude": start_long
                }
            }
        },
        "destination": {
            "location": {
                "latLng": {
                    "latitude": end_lat,
                    "longitude": end_long
                }
            }
        },
        "travelMode": "WALK",
        "routingPreference": "TRAFFIC_AWARE",
        "computeAlternativeRoutes": False,
        "routeModifiers": {
            "avoidTolls": False,
            "avoidHighways": False,
            "avoidFerries": False
        },
        "languageCode": "en-US",
        "units": "IMPERIAL"
    }
    
    response = requests.post(url, headers=headers, json=data)
    return response.json()
