# jan/07/2023 12:55:09 by RouterOS 7.7rc4
# software id = 
#
/interface bridge add name=loopback
/interface lte apn set [ find default=yes ] ip-type=ipv4 use-network-apn=no
/interface wireless security-profiles set [ find default=yes ] supplicant-identity=MikroTik
/port set 0 name=serial0
/routing ospf instance add disabled=yes name=default-v2 originate-default=if-installed redistribute=connected,static
/routing ospf instance add disabled=yes name=default-v3 redistribute=connected,static version=3
/routing ospf area add disabled=no instance=default-v2 name=backbone-v2
/routing ospf area add disabled=no instance=default-v3 name=backbone-v3
/routing bgp template set default disabled=no output.network=bgp-networks .redistribute="" routing-table=main
/ip settings set max-neighbor-entries=8192
/ipv6 settings set max-neighbor-entries=8192
/interface ovpn-server server set auth=sha1,md5
/ip address add address=10.10.2.1/30 interface=ether2 network=10.10.2.0
/ip address add address=10.10.10.11 interface=loopback network=10.10.10.11
/ip dhcp-client add interface=ether1
/ip dhcp-client add disabled=yes interface=ether1
/ip firewall address-list add address=10.10.10.11 list=out-10.10.10.11
/ip firewall address-list add address=200.200.0.0/22 list=out-10.10.10.11
/ip firewall nat add action=masquerade chain=srcnat disabled=yes out-interface=ether1 src-address=10.10.2.0/30
/ip route add blackhole disabled=no dst-address=200.200.0.0/22 gateway="" routing-table=main suppress-hw-offload=no
/ipv6 address add address=2201:db8::1/125 advertise=no interface=ether2
/ipv6 address add address=2001:db8::1/128 advertise=no interface=loopback
/routing bgp connection add as=65530 disabled=no input.filter=bgp_in local.role=ebgp name=bgp1 output.default-originate=always .filter-chain=bgp_out .network=out-10.10.10.11 .redistribute="" remote.address=10.10.2.2/32 .as=65531 routing-table=main templates=default
/routing filter community-list add communities=65530:100 disabled=no list=Aprendidos-Clientes
/routing filter rule add chain=Weight disabled=no rule="if(dst==10.10.10.22/32){set bgp-weight 10;accept}"
/routing filter rule add chain=Communities disabled=no rule="if(protocol bgp){append bgp-communities 65530:100; set bgp-local-pref 200; accept}"
/routing filter rule add chain=bgp_out disabled=no rule="if(dst==10.10.10.11/32){set bgp-path-prepend 5;accept}"
/routing filter rule add chain=bgp_out disabled=no rule="if (dst in 200.200.0.0/22) {set bgp-path-prepend 3;accept}"
/routing filter rule add chain=bgp_out disabled=no rule="if (dst == 0.0.0.0/0) {accept}"
/routing filter rule add chain=bgp_in comment="[ Rejeita Meu Prefixo ]" disabled=no rule="if (dst in 200.200.0.0/22) { reject }"
/routing filter rule add chain=bgp_in comment="[ Rejeita Bogons ]" disabled=no rule="if (chain Bogons) { reject }"
/routing filter rule add chain=bgp_in comment="[ Rejeita Menores que /24 ]" disabled=no rule="if (dst-len>=25) { reject }"
/routing filter rule add chain=bgp_in comment="[ Aceita Default ]" disabled=no rule="if (dst == 0.0.0.0/0) { accept }"
/routing filter rule add chain=bgp_in comment="[ Aceita Tudo ]" disabled=no rule="if (dst in 0.0.0.0/0) { accept }"
/routing filter rule add chain=Bogons disabled=no rule="if (dst-len>=10 && dst-len<=32 && dst in 10.0.0.0/8) { accept }"
/routing filter rule add chain=Bogons rule="if (dst-len>=10 && dst-len<=32 && dst in 100.64.0.0/10) { accept }"
/routing filter rule add chain=Bogons disabled=no rule="if (dst-len>=8 && dst-len<=32 && dst in 127.0.0.0/8) { accept }"
/routing filter rule add chain=Bogons rule="if (dst-len>=16 && dst-len<=32 && dst in 169.254.0.0/16) { accept }"
/routing filter rule add chain=Bogons rule="if (dst-len>=12 && dst-len<=32 && dst in 172.16.0.0/12) { accept }"
/routing filter rule add chain=Bogons rule="if (dst-len>=24 && dst-len<=32 && dst in 192.0.2.0/24) { accept }"
/routing filter rule add chain=Bogons rule="if (dst-len>=16 && dst-len<=32 && dst in 192.168.0.0/16) { accept }"
/routing filter rule add chain=Bogons rule="if (dst-len>=3 && dst-len<=32 && dst in 224.0.0.0/3) { accept }"
/routing ospf interface-template add area=backbone-v2 auth=md5 auth-key=teste123 disabled=no interfaces=ether2 networks=10.10.2.0/30 type=ptp
/routing ospf interface-template add area=backbone-v3 disabled=no interfaces=ether2 networks=2201:db8::/125 type=ptp
/system identity set name=R1
/system package update set channel=testing
/tool romon set enabled=yes id=00:00:00:00:00:01
