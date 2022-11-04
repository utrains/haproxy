#!/bin/bash
#Adapted from https://github.com/justintime/vagrant-haproxy-demo

#if it doesn't exist on our VM...
if [ ! -f /etc/haproxy/haproxy.cfg ]; then
	#Install haproxy
	/usr/bin/sudo apt-get -y install haproxy
	#Configure haproxy
	#This enables haproxy to start upon init
	cat > /etc/default/haproxy <<EOD
# Set ENABLED to 1 if you want the init script to start haproxy.
ENABLED=1
# Add extra flags here.
#EXTRAOPTS="-de -m 16"
EOD
	#This configures the loadbalancer in the .cfg file
	cat > /etc/haproxy/haproxy.cfg <<EOD
global
    daemon
    maxconn 256

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend http-in
    bind *:80
    default_backend webservers

backend webservers
    balance roundrobin
    # Poor-man's sticky
    # balance source
    # JSP SessionID Sticky
    # appsession JSESSIONID len 52 timeout 3h
    option httpchk
    option forwardfor
    option http-server-close
    server webserver1 192.168.56.16:80 maxconn 32 check
    server webserver2 192.168.56.17:80 maxconn 32 check

listen admin
    bind *:8080
    stats enable
EOD
	#Copy file for record keeping
	cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.orig
	/usr/sbin/service haproxy restart
fi