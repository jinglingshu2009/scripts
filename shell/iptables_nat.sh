#!/bin/bash

wifi=eth0
lan=eth1
echo "1" > /proc/sys/net/ipv4/ip_forward
iptables --table nat --append POSTROUTING --out-interface $wifi -j MASQUERADE
iptables --append FORWARD --in-interface $lan -j ACCEPT

