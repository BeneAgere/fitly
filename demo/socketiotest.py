import socketio

# Standard Python Socket.IO client
sio = socketio.Client()

@sio.event
def connect():
    print('Client connected to Flask-SocketIO server!')
    # Test the data stream
    sio.emit('request_stream')

@sio.event
def data(item):
    print('Got data item:', item)

@sio.event
def disconnect():
    print('Disconnected from server')

def main():
    # Connect to your Flask-SocketIO app
    sio.connect('http://localhost:5001')
    sio.wait()

if __name__ == '__main__':
    main()