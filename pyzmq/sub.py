import zmq
import socket

hostname = socket.gethostname()
IPAddr = socket.gethostbyname(hostname)
port = 5555
protocol = 'tcp'

xpub_addr = ''.join([protocol], '://', IPAddr, ':', port)
context = zmq.Context()
subscriberSocket = context.socket(zmq.SUB)
subscriberSocket.connect(xpub_addr)
subscriberSocket.setsockopt(zmq.SUBSCRIBE, b"sensors")
while True:
    if subscriberSocket.poll(timeout=1000):
        message = subscriberSocket.recv_multipart()
        print(message)
