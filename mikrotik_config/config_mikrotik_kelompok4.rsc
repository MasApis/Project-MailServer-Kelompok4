# dec/01/2025 03:34:14 by RouterOS 6.47.10
# software id = 02Q5-YLFF
#
# model = RB952Ui-5ac2nD
# serial number = D3D50F2177E3
/interface bridge
add name=kelompok4
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
add authentication-types=wpa-psk,wpa2-psk mode=dynamic-keys name=\
    password-hp-abdul supplicant-identity=""
add authentication-types=wpa-psk,wpa2-psk mode=dynamic-keys name=\
    password-kelompok4 supplicant-identity=""
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n disabled=no frequency=2437 \
    security-profile=password-hp-abdul ssid="Infinix HOT 60 Pro"
set [ find default-name=wlan2 ] disabled=no mode=ap-bridge security-profile=\
    password-kelompok4 ssid=Kelompok4-Mail
/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot
/ip pool
add name=dhcp_pool0 ranges=192.168.4.2-192.168.4.254
add name=dhcp_pool1 ranges=192.168.4.2-192.168.4.254
add name=dhcp_pool2 ranges=192.168.4.2-192.168.4.254
add name=dhcp_pool3 ranges=192.168.4.2-192.168.4.254
/ip dhcp-server
add address-pool=dhcp_pool3 disabled=no interface=kelompok4 name=dhcp1
/tool user-manager customer
set admin access=\
    own-routers,own-users,own-profiles,own-limits,config-payment-gw
/interface bridge port
add bridge=kelompok4 interface=wlan2
add bridge=kelompok4 interface=ether2
/ip address
add address=192.168.4.1/24 interface=kelompok4 network=192.168.4.0
/ip dhcp-client
add disabled=no interface=wlan1
/ip dhcp-server network
add address=192.168.4.0/24 dns-server=192.168.4.1 gateway=192.168.4.1
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=192.168.4.2 name=mail.kelompok4.net
add address=192.168.4.2 name=kelompok4.net
add address=192.168.4.2 name=www.kelompok4.net
/ip firewall nat
add action=masquerade chain=srcnat out-interface=wlan1
/system clock
set time-zone-name=Asia/Jakarta
/tool user-manager database
set db-path=flash/user-manager
