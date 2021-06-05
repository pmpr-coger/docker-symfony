#!/usr/bin/env bash

# Criando referência ao host no arquivo /etc/hosts
cat /etc/hosts > /root/hosts
sed -i '/dockerhost/d' /root/hosts
echo -n $(/sbin/ip route | awk '/default/ { print $3 }')  >> /root/hosts
echo -n " " >> /root/hosts
echo "dockerhost host.docker.internal" >> /root/hosts
cat /root/hosts > /etc/hosts

exec "$@"
