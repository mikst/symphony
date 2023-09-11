import zmq
import subprocess

result = subprocess.check_output(['ipconfig', 'getifaddr', 'en0'], universal_newlines=True)
IPAddr = result.strip()

port = 5556
protocol = 'tcp'

xsub_addr = ''.join([protocol, '://', str(IPAddr), ':', str(port)])

context = zmq.Context()
publisherSocket = context.socket(zmq.PUB)
publisherSocket.connect(xsub_addr)
publishName = b"sensors"; #.encode('utf-8')

while True:
    message = input('input the message:')
    publisherSocket.send_multipart([publishName,message.encode('utf-8')])
    print(message)
