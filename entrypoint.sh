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

# Build authorized_keys from host's public keys on every boot
if ls /run/host-ssh/*.pub &>/dev/null; then
    mkdir -p /home/dev/.ssh
    cat /run/host-ssh/*.pub > /home/dev/.ssh/authorized_keys
    chmod 700 /home/dev/.ssh
    chmod 600 /home/dev/.ssh/authorized_keys
    chown -R dev:dev /home/dev/.ssh
fi

exec /usr/sbin/sshd -D
