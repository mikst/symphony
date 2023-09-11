import zmq
import subprocess

result = subprocess.check_output(['ipconfig', 'getifaddr', 'en0'], universal_newlines=True)
IPAddr = result.strip()

protocol = 'tcp'

port_p = 5555
port_s = 5556

xpub_addr = ''.join([protocol, '://', str(IPAddr), ':', str(port_p)])
xsub_addr = ''.join([protocol, '://', str(IPAddr), ':', str(port_s)])
context = zmq.Context()

#create XPUB
xpub_socket = context.socket(zmq.XPUB)
xpub_socket.bind(xpub_addr)
#create XSUB
xsub_socket = context.socket(zmq.XSUB)
xsub_socket.bind(xsub_addr)


#create poller
poller = zmq.Poller()
poller.register(xpub_socket, zmq.POLLIN)
poller.register(xsub_socket, zmq.POLLIN)


while True:
    # get event
    event = dict(poller.poll(1000))
    if xpub_socket in event:
        message = xpub_socket.recv_multipart()
        #print("[BROKER] xpub_socket recv message: %r" % message)
        xsub_socket.send_multipart(message)
    if xsub_socket in event:
        message = xsub_socket.recv_multipart()
        #print("[BROKER] xsub_socket recv message: %r" % message)
        xpub_socket.send_multipart(message)
