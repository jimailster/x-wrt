#!/usr/bin/webif-page
<?
. /usr/lib/webif/webif.sh
load_settings mn_p2p

if empty "$FORM_submit"; then
#        FORM_gmode=${wl0_gmode:-$(nvram get wl0_gmode)}
        FORM_ip4broad=$mn_ip4broad
        FORM_ign=$mn_ign
        FORM_will=$mn_will
        FORM_lqmult=$mn_lqmult
	FORM_client1=$mn_client1
	FORM_client2=$mn_client2
	FORM_client3=$mn_client3
	FORM_client4=$mn_client4
	FORM_client5=$mn_client5
else
        SAVED=1
        validate <<EOF
int|FORM_will|Willingness|required min=0 max=8|$FORM_will
mac|FORM_client1|Client 1||$FORM_client1
mac|FORM_client2|Client 2||$FORM_client2
mac|FORM_client3|Client 3||$FORM_client3
mac|FORM_client4|Client 4||$FORM_client4
mac|FORM_client5|Client 5||$FORM_client5
EOF
        equal "$?" 0 && {
  		save_setting mn_p2p wl0_gmode "$FORM_gmode"
                save_setting mn_p2p mn_ip4broad "$FORM_ip4broad"
                save_setting mn_p2p mn_ign "$FORM_ign"
                if [ ".$FORM_will" = ".8" ]; then
                        FORM_will=""
                fi
                save_setting mn_p2p mn_will "$FORM_will"        
                save_setting mn_p2p mn_lqmult "$FORM_lqmult"    
		save_setting mn_p2p mn_client1 "$FORM_client1"
		save_setting mn_p2p mn_client2 "$FORM_client2"
        	save_setting mn_p2p mn_client3 "$FORM_client3"
        	save_setting mn_p2p mn_client4 "$FORM_client4"
        	save_setting mn_p2p mn_client5 "$FORM_client5"
        	/usr/bin/megaset /tmp/.webif/config-mn_p2p
	}
fi 
 
header "Mesh" "Public" "Public network" '' "$SCRIPT_NAME"

echo "<div class=warning>This page is actually at very alpha state, few functinalities are working, explore at your own risk!</div><br><br>"

if [ ".$(uci get mesh.general.enable)" = ".1" ]; then

echo "<P>The \"public network\" is the wireless side of the network.</P><BR>"

display_form <<EOF
start_form|Radio Tuning
field|802.11 mode
select|gmode|$FORM_gmode
option|0|B-only
option|1|Auto (B and G)
option|2|G-only
helpitem|802.11 mode
helptext|802.11b only (up to 11Mbit), 802.11g only (up to 54Mbit), Automatic
end_form
start_form|Mesh Tuning
field|Willingness
select|will|$FORM_will
option|8|Auto
option|0
option|1
option|2
option|3
option|4
option|5
option|6
option|7
helpitem|Willingness
helptext|Helptext olsr_willingness#Changes the willingness to a fixed value (0-7). Leave the input field empty to use a dynamic willingness value based on battery/power status.
field|Peers Quality Multiplier
text|lqmult|$FORM_lqmult
helpitem|Peers Quality Multiplier
helptext|Helptext olsr_lqmult#This setting will lower the LQ value of a specific neighbour station. If two neighbours with approximately the same link quality are present, this setting prevents frequent route changes. Example: '10.1.2.3:0.5' will inhibit a route through this station as long as other neighbours with better LQ value are present. Enter an IP address followed by a colon and a multiplicator value between 0.1 and 1.0. Separate multiple entries with semicolon.
field|Peers Filter
text|ign|$FORM_ign
helpitem|Peers Filter
helptext|Helptext olsr_ign#In case a specific OLSR node is better reached indirect, the OLSR broadcasts from this node can be ignored. Enter the IP address to filter here. Separate multiple IP addresses with semicolon.
field|P2P Broadcast
text|ip4broad|$FORM_ip4broad
helpitem|P2P Broadcast
helptext|Helptext olsr_ip4broad#Change the IP broadcast address for OLSR announcements. It defaults to the device broadcast addresss.
field|Maximum troughput
text|maxtp|$FORM_maxtp
helpitem|Maximum troughput
helptext|Helptext mesh_maxtp#Maximum troughput depends on the amount of nodes in your area, the distance of your peers and meteo phenomenons. If you are experiencing choppy telephone calls or high pings try lowering this value.
end_form

start_form|Wireless clients
helpitem|Wireless clients
helptext|In this form you can define clients allowed to connect wirelessy, without password, to the entire P2P network. Please note that wireless connection is for emergency purposes only and can use a limited set of low speed services only.
helpitem|NOTE
helptext|Insert mac addresses in the form XX:XX:XX:XX:XX:XX . Be sure to use mac address of the proper interface; mac addresses are "interface attributes", this means that the same client can have a mac address for ethernet (cable) connection and one for WiFi (wireless) connection.
field|Client 1
text|client1|$FORM_client1
field|Client 2
text|client2|$FORM_client2
field|Client 3
text|client3|$FORM_client3
field|Client 4
text|client4|$FORM_client4
field|Client 5
text|client5|$FORM_client5
end_form
EOF

else
	echo "<P>In order to use this page you must enable mesh mode; go to Mesh --> Start page first.</P>"
fi

footer ?>
<!-- 
##WEBIF:name:Mesh:300:Public
-->
