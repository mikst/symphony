import zmq
import socket

hostname = socket.gethostname()
IPAddr = socket.gethostbyname(hostname)
port = 5556
protocol = 'tcp'

xsub_addr = ''.join([protocol], '://', IPAddr, ':', port)

context = zmq.Context()
publisherSocket = context.socket(zmq.PUB)
publisherSocket.connect(xsub_addr)
publishName = b"sensors"; #.encode('utf-8')

while True:
    message = input('input the message:')
    publisherSocket.send_multipart([publishName,message.encode('utf-8')])
    print(message)
