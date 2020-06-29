# MikroTik Configuration Repository

### recursive_failover.rsc

Dual dynamic WAN failover.  Configuration showing recursive route failover using two dynamic connections.  Primary connection uses DHCP, secondary connection uses PPPoE.

### switch_vlan.rsc

VLANs created using the Switch chip.  In this example on the RB3011.

  * Ether2 - VLAN 8 Untagged
  * Ether3 - VLAN 8 Untagged
  * Ether4 - VLAN 8 Untagged
  * Ether5 - VLAN 8 Untagged, VLAN 16 and 32 Tagged