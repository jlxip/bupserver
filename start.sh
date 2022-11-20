#!/bin/sh -e

SENTINEL="/etc/ssh/.allset"
if [ ! -f "$SENTINEL" ]; then
	echo "This is your first time, resetting SSH server keys"
	rm /etc/ssh/ssh_host_*
	dpkg-reconfigure openssh-server

	echo "--- Generating your SSH key ---"
	mkdir -p /etc/ssh/yourssh
	ssh-keygen -t ed25519 -f /etc/ssh/yourssh/key -q -N ""

	touch "$SENTINEL"
fi

# It might change in some updates
cp /.sshd_config /etc/ssh/sshd_config

if [ ! -d /home/user/.ssh ]; then
	echo "--- Copying SSH key ---"
	mkdir /home/user/.ssh
	cat /etc/ssh/yourssh/key.pub > /home/user/.ssh/authorized_keys
	chown -R user:user /home/user/.ssh
fi

touch /home/user/.hushlogin

service ssh start

chown user:user /home/user/.bup

if [ ! -f "/home/user/.bup/HEAD" ]; then
	echo "--- Running bup init ---"
	sudo -u user bup init
fi

if [ -z "$NO_WEB" ]; then
	echo "--- Running bup web ---"
	sudo -u user bup web :8080
else
	touch /tmp/nothing
	tail -f /tmp/nothing
	# I didn't know what to do to stop execution and this
	#   doesn't consume CPU
fi
