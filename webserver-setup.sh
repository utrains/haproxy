#!/bin/bash
#Adapted from https://github.com/justintime/vagrant-haproxy-demo
#Shell script to install Apache Web Server onto Vagrant VM
if [ ! -f /etc/network/if-up.d/custom-networkd-config ]; then
	sudo apt-get update
	/usr/bin/sudo apt-get -y install apache2
	#Make a webpage that shows what server is hosting our connection
	#Must replace old Apache-donated index.html 
	cat > /var/www/html/index.html <<EOD
<html><head><title>${HOSTNAME}</title></head><body><h1>${HOSTNAME}</h1>
<p>Welcome to Utrains.
<br>
You redirected to ${HOSTNAME} to see how the load balancer is sharing the traffic. </p>
</body></html>
EOD
	#Restart Service
	/usr/sbin/service apache2 restart
fi
