/interface bridge
add auto-mac=no name=bridge
/interface ethernet
set [ find default-name=ether6 ] disabled=yes
set [ find default-name=ether7 ] disabled=yes
set [ find default-name=ether8 ] disabled=yes
set [ find default-name=ether9 ] disabled=yes
set [ find default-name=ether10 ] disabled=yes
set [ find default-name=sfp1 ] disabled=yes
/interface vlan
add interface=bridge name=VLAN-Guest vlan-id=16
add interface=bridge name=VLAN-Home vlan-id=8
add interface=bridge name=VLAN-IoT vlan-id=32
/interface ethernet switch port
set 1 default-vlan-id=8 vlan-header=add-if-missing vlan-mode=secure
set 2 default-vlan-id=8 vlan-header=add-if-missing vlan-mode=secure
set 3 default-vlan-id=8 vlan-header=add-if-missing vlan-mode=secure
set 4 default-vlan-id=8 vlan-header=add-if-missing vlan-mode=secure
set 10 vlan-mode=secure
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=Pool-Home ranges=10.1.8.100-10.1.8.199
add name=Pool-Guest ranges=10.1.16.100-10.1.16.199
add name=Pool-IoT ranges=10.1.32.100-10.1.32.199
/ip dhcp-server
add address-pool=Pool-Home disabled=no interface=VLAN-Home lease-time=4d name=DHCP-Home
add address-pool=Pool-Guest disabled=no interface=VLAN-Guest lease-time=1d name=DHCP-Guest
add address-pool=Pool-IoT disabled=no interface=VLAN-IoT lease-time=2d name=DHCP-IoT
/interface bridge port
add bridge=bridge interface=ether2
add bridge=bridge interface=ether3
add bridge=bridge interface=ether4
add bridge=bridge interface=ether5
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface ethernet switch vlan
add independent-learning=no ports=ether2,ether3,ether4,ether5,switch1-cpu switch=switch1 vlan-id=8
add independent-learning=no ports=ether5,switch1-cpu switch=switch1 vlan-id=16
add independent-learning=no ports=ether5,switch1-cpu switch=switch1 vlan-id=32
/interface list member
add interface=bridge list=LAN
add interface=ether1 list=WAN
add interface=VLAN-Guest list=LAN
add interface=VLAN-Home list=LAN
add interface=VLAN-IoT list=LAN
/ip address
add address=10.1.8.1/24 interface=VLAN-Home network=10.1.8.0
add address=10.1.16.1/24 interface=VLAN-Guest network=10.1.16.0
add address=10.1.32.1/24 interface=VLAN-IoT network=10.1.32.0
/ip dhcp-client
add disabled=no interface=ether1
/ip dhcp-server config
set store-leases-disk=12h
/ip dhcp-server lease
add address=10.1.8.8 mac-address=E8:FC:AF:E4:EF:3E server=DHCP-Home
add address=10.1.8.2 mac-address=00:E1:6D:B6:06:EC server=DHCP-Home
add address=10.1.8.3 mac-address=B4:FB:E4:70:63:D9 server=DHCP-Home
add address=10.1.8.5 mac-address=40:23:43:DB:29:C9 server=DHCP-Home
/ip dhcp-server network
add address=10.1.8.0/24 gateway=10.1.8.1
add address=10.1.16.0/24 gateway=10.1.16.1
add address=10.1.32.0/24 gateway=10.1.32.1
/ip dns
set allow-remote-requests=yes servers=1.1.1.1,9.9.9.9
/ip dns static
add address=10.1.8.1 name=router.home
/ip firewall address-list
add address=10.1.1.0/24 list=adminaccess
/ip firewall filter
add action=accept chain=input comment="defconf: accept established,related,untracked" connection-state=established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=invalid
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=accept chain=input comment="defconf: accept to local loopback (for CAPsMAN)" dst-address=127.0.0.1
add action=accept chain=input comment="Admin Access" in-interface=VLAN-Home
add action=accept chain=input comment="Allow LAN DNS queries-TCP" dst-port=53 in-interface-list=LAN protocol=tcp
add action=accept chain=input comment="Allow LAN DNS queries-UDP" dst-port=53 in-interface-list=LAN protocol=udp
add action=drop chain=input comment="Drop all else"
add action=accept chain=forward comment="defconf: accept in ipsec policy" ipsec-policy=in,ipsec
add action=accept chain=forward comment="defconf: accept out ipsec policy" ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" connection-state=established,related
add action=accept chain=forward comment="defconf: accept established,related, untracked" connection-state=established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" connection-state=invalid
add action=accept chain=forward comment="Allow Home-Guest-IoT access to internet" in-interface-list=LAN out-interface-list=WAN
add action=accept chain=forward comment="Admin Access to Guest VLAN" disabled=yes in-interface=VLAN-Home out-interface=VLAN-Guest src-address-list=adminaccess
add action=accept chain=forward comment="Admin Access to IOT VLAN" disabled=yes in-interface=VLAN-Home out-interface=VLAN-IoT src-address-list=adminaccess
add action=accept chain=forward comment="Allow Port Forwarding - DSTNAT" connection-nat-state=dstnat connection-state=new in-interface-list=WAN
add action=drop chain=forward comment="Drop all else"
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" ipsec-policy=out,none out-interface-list=WAN
/ip service
set telnet disabled=yes
set ftp disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/ip ssh
set strong-crypto=yes
/lcd
set backlight-timeout=1m default-screen=interfaces read-only-mode=yes
/system clock
set time-zone-name=America/Toronto
/system identity
set name=MikroTik
/tool graphing
set store-every=24hours
/tool graphing interface
add interface=ether1
add interface=VLAN-Guest
add interface=VLAN-Home
add interface=VLAN-IoT
/tool graphing queue
add simple-queue=QoS
add simple-queue=QoS-Guest
/tool graphing resource
add
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN