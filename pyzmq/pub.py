import zmq
xsub_addr = 'tcp://192.168.0.100:5556'
context = zmq.Context()
publisherSocket = context.socket(zmq.PUB)
publisherSocket.connect(xsub_addr)
publishName = b"control"; #.encode('utf-8')

while True:
    message = input('input the message:')
    publisherSocket.send_multipart([publishName,message.encode('utf-8')])
    print(message)
