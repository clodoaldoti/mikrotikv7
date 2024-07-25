# mikrotikv7
Scripts Mikrotik Version 7

Exemplos de Filter Rule BGP
---------------------------

# Permit Default route static 
if (dst==0.0.0.0/0 && protocol static) { accept }

# Match prefixo 172.16.0.0/16 somente /24 estatico
if (dst in 172.16.0.0/16 && dst-len==24 && protocol static) { accept }

# Match prefixo 172.16.0.0/16 somente /24 aplicando med 20 e prepend 2
add chain=BGP_OUT rule="if (dst-len==24 && dst in 172.16.0.0/16) { set bgp-med 20; set bgp-path-prepend 2; accept }"
	
add chain=BGP_OUT rule="if (dst-len>13 && dst-len<31 && dst in 172.16.0.0/16) { accept }"

# Aplica community no filtro de entrada
add chain=bgp_in rule="set bgp-large-communities 200001:200001:10 "

/routing/filter/large-community-set
add set=myLargeComSet communities=200001:200001:10
 
 
/routing/filter/rule
add chain=bgp_in rule="append bgp-large-communities myLargeComSet "

	
# Examplo de Weight
if(dst==10.10.10.22/32){set bgp-weight 10;accept}

# AS-Prepend Example
if(dst==10.10.10.11/32){set bgp-path-prepend 5;accept}

# Aceita protocol bgp aplicando community e localpref 200
if(protocol bgp){append bgp-communities 65530:100; set bgp-local-pref 200; accept}

# Sintax politicas basicas de entrada e saida
#out
anunciar /22 /23 /24
drop

#in
drop meu prefixo
drop bogons
drop menor que /24
accept default route 
accept restante 

# Networks
/ip/firewall/address-list/
add list=bgp-networks address=192.168.0.0/24
 
/ip/route
add dst-address=192.168.0.0/24 blackhole
 
/routing/bgp/connection
set peer_name output.network=bgp-networks

# BOGONS Filter
/routing/filter/rule
add chain=Bogons rule="if (dst-len>=10 && dst-len<=32 && dst in 10.0.0.0/8) { accept }"
add chain=Bogons rule="if (dst-len>=10 && dst-len<=32 && dst in 100.64.0.0/10) { accept }"
add chain=Bogons rule="if (dst-len>=8 && dst-len<=32 && dst in 127.0.0.0/8) { accept }"
add chain=Bogons rule="if (dst-len>=16 && dst-len<=32 && dst in 169.254.0.0/16) { accept }"
add chain=Bogons rule="if (dst-len>=12 && dst-len<=32 && dst in 172.16.0.0/12) { accept }"
add chain=Bogons rule="if (dst-len>=24 && dst-len<=32 && dst in 192.0.2.0/24) { accept }"
add chain=Bogons rule="if (dst-len>=16 && dst-len<=32 && dst in 192.168.0.0/16) { accept }"
add chain=Bogons rule="if (dst-len>=3 && dst-len<=32 && dst in 224.0.0.0/3) { accept }"


# Export dos Filtros Prontos
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
/routing filter rule add chain=Bogons rule="if (dst-len>=10 && dst-len<=32 && dst in 10.0.0.0/8) { accept }"
/routing filter rule add chain=Bogons rule="if (dst-len>=10 && dst-len<=32 && dst in 100.64.0.0/10) { accept }"
/routing filter rule add chain=Bogons rule="if (dst-len>=8 && dst-len<=32 && dst in 127.0.0.0/8) { accept }"
/routing filter rule add chain=Bogons rule="if (dst-len>=16 && dst-len<=32 && dst in 169.254.0.0/16) { accept }"
/routing filter rule add chain=Bogons rule="if (dst-len>=12 && dst-len<=32 && dst in 172.16.0.0/12) { accept }"
/routing filter rule add chain=Bogons rule="if (dst-len>=24 && dst-len<=32 && dst in 192.0.2.0/24) { accept }"
/routing filter rule add chain=Bogons rule="if (dst-len>=16 && dst-len<=32 && dst in 192.168.0.0/16) { accept }"
/routing filter rule add chain=Bogons rule="if (dst-len>=3 && dst-len<=32 && dst in 224.0.0.0/3) { accept }"
