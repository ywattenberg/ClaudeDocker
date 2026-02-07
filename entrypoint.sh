#!/bin/bash
# Generate SSH host keys on first boot if they don't exist (persisted via volume)
if [ ! -f /etc/ssh/host_keys/ssh_host_ed25519_key ]; then
    ssh-keygen -t ed25519 -f /etc/ssh/host_keys/ssh_host_ed25519_key -N ""
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/host_keys/ssh_host_rsa_key -N ""
fi

# Seed home directory from skeleton on first boot
if [ ! -f /home/dev/.zshrc ]; then
    cp -a /etc/skel.dev/. /home/dev/
    chown -R dev:dev /home/dev
fi

exec /usr/sbin/sshd -D
