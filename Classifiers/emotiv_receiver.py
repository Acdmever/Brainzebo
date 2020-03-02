from cortex2 import EmotivCortex2Client
from pythonosc import dispatcher
from pythonosc import osc_server
from pythonosc import udp_client
from pythonosc import osc_message_builder
from pythonosc import osc_bundle_builder
from copy import deepcopy
from typing import List, Any
import time
import numpy as np
import asyncio
import keyboard

url = "wss://localhost:6868"

# Remember to start the Emotiv App before you start!
# Start client with authentication
client = EmotivCortex2Client(url,
                             client_id='9nlR2wFvSR08mWKrB4kZlXzGogyY8TiNGamTFfxz',
                             client_secret="GgH7NGOmrifAZeeldMivXMsAfoIQVqusMxIuKmGP3MmkwLqKSqdhXF850wNUB2Cg7NAExCiFIuMnVg9ZJLsQr0q2NJHQlrSkuugc5Ou3jKu8KawgKKGinj92EIHnX0aR",
                             check_response=True,
                             authenticate=True,
                             debug=False)

# Test API connection by using the request access method
client.request_access()

# Explicit call to Authenticate (approve and get Cortex Token)
client.authenticate()

# Connect to headset, connect to the first one found, and start a session for it
client.query_headsets()
client.connect_headset(0)
client.create_activated_session(0)

# Subscribe to the motion and mental command streams
# Spins up a separate subscription thread
client.subscribe(streams=["eeg"])

# Test message handling speed#

#a = client.subscriber_messages_handled
#time.sleep(5)
#b = client.subscriber_messages_handled
#print((b - a) / 5)

# Grab a single instance of data
#print(client.receive_data())
classifier=udp_client.SimpleUDPClient("127.0.0.1", 12345)

d=list([])
key=0



# Continously grab data, while making requests periodically
while True:
        
        
    try:
        # Check the latest data point from the motion stream, from the first session
        d=list(client.data_streams.values())[0]['eeg']
        while True:
            try:
                mess=(d.popleft())['data']
                classifier.send_message("/python",mess[2:-3])
                    
            except:
                break
            
    except:
        pass




