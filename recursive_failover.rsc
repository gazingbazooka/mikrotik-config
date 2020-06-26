/interface bridge
add auto-mac=no name=bridge
/interface pppoe-client
add disabled=no interface=ether1 name=pppoe-out1
/interface list
add name=WAN
add name=LAN
/ip pool
add name=dhcp ranges=192.168.88.10-192.168.88.100
/ip dhcp-server
add address-pool=dhcp disabled=no interface=bridge lease-time=1h name=DHCP-Home
/interface bridge port
add bridge=bridge interface=ether2
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface list member
add interface=bridge list=LAN
add interface=ether1 list=WAN
add interface=pppoe-out1 list=WAN
add interface=ether3 list=WAN
/ip address
add address=192.168.88.1/24 interface=ether2 network=192.168.88.0
/ip dhcp-client
add add-default-route=no disabled=no interface=ether3 script="log info \"\$[/system identity get name] DHCP Client Starting\";\
\n:if (\$bound=1) do={ \
\n log info \"\$[/system identity get name] DHCP Client Bound IP \$\"lease-address\" GW \$\"gateway-address\"\";\
\n /ip route set [find comment=\"Rogers\"] gateway=(\$\"gateway-address\");\
\n} else={\
\n log error \"\$[/system identity get name] DHCP Client Not Bound\";\
\n}" use-peer-dns=no
/ip dhcp-server config
set store-leases-disk=12h
/ip dhcp-server network
add address=192.168.88.0/24 gateway=192.168.88.1
/ip dns
set allow-remote-requests=yes servers=9.9.9.9,1.1.1.1
/ip dns static
add address=192.168.88.1 name=router.home
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" ipsec-policy=out,none out-interface-list=WAN
/ip route
add check-gateway=ping distance=1 gateway=9.9.9.9
add distance=2 gateway=pppoe-out1
add comment=Rogers distance=1 dst-address=9.9.9.9/32 gateway=1.2.3.4 scope=10
/system ntp client
set enabled=yes server-dns-names=time.google.com