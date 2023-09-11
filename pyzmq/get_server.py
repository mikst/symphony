#! /usr/bin/python

# IMPORTANT! This file is compatible python 2.7.13 as that is what's available on the Bela board by default

import socket

subnet = "192.168.1"  # Replace with your local network subnet
start_host = 1
end_host = 254
target_port = 5556

def is_port_open(host, port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(1)

    try:
        s.connect((host, port))
        return True
    except (socket.timeout, socket.error):
        return False
    finally:
        s.close()

for host in range(start_host, end_host + 1):
    ip = "{}.{}".format(subnet, host)

    if is_port_open(ip, target_port):
        print("Port {} is open on {}".format(target_port, ip))
