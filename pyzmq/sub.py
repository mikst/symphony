import zmq
import subprocess

result = subprocess.check_output(['ipconfig', 'getifaddr', 'en0'], universal_newlines=True)
IPAddr = result.strip()

port = 5555
protocol = 'tcp'

xpub_addr = ''.join([protocol, '://', str(IPAddr), ':', str(port)])
context = zmq.Context()
subscriberSocket = context.socket(zmq.SUB)
subscriberSocket.connect(xpub_addr)
subscriberSocket.setsockopt(zmq.SUBSCRIBE, b"sensors")
while True:
    if subscriberSocket.poll(timeout=1000):
        message = subscriberSocket.recv_multipart()
        print(message)
