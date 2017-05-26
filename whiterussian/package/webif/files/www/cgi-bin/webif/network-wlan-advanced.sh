#!/usr/bin/webif-page
<?
. /usr/lib/webif/webif.sh
###################################################################
# Advanced wireless configuration
#
# Description:
#	Configure additional wireless settings.
#
# Author(s) [in order of work date]:
#       Original webif authors.
#	Jeremy Collake <jeremy.collake@gmail.com>
#       Travis Kemen <kemen04@gmail.com>
#
# Major revisions:
#
# NVRAM variables referenced:
#
# Configuration files referenced:
#   none
#

load_settings "wireless"

header "Network" "Advanced Wireless" "@TR<<Advanced Wireless Configuration>>" ' onload="modechange()" ' "$SCRIPT_NAME"

#####################################################################
# defaults - ONLY used in the rare case these nvram variables are unset
# todo: maybe change to 84?
DEFAULT_TXPWR=28
DEFAULT_AP_ISOLATE=0

#####################################################################
FORM_wds="${wl0_wds:-$(nvram get wl0_wds)}"
LISTVAL="$FORM_wds"
handle_list "$FORM_wdsremove" "$FORM_wdsadd" "$FORM_wdssubmit" 'mac|FORM_wdsadd|@TR<<WDS MAC address>>|required' && {
	FORM_wds="$LISTVAL"
	save_setting wireless wl0_wds "$FORM_wds"
}
FORM_wdsadd=${FORM_wdsadd:-00:00:00:00:00:00}

#####################################################################
FORM_maclist="${wl0_maclist:-$(nvram get wl0_maclist)}"
LISTVAL="$FORM_maclist"
handle_list "$FORM_maclistremove" "$FORM_maclistadd" "$FORM_maclistsubmit" 'mac|FORM_maclistadd|@TR<<WDS MAC address>>|required' && {
	FORM_maclist="$LISTVAL"
	save_setting wireless wl0_maclist "$FORM_maclist"
}
FORM_maclistadd=${FORM_maclistadd:-00:00:00:00:00:00}

#####################################################################
# initialize txpwr options
txpwr="1"
while [ "$txpwr" -le 251 ]; do
	VALID_TXPWR="${VALID_TXPWR}
	option|$txpwr"
	let "txpwr+=1"
done

#####################################################################
# Initialize forms
if empty "$FORM_submit"; then
	FORM_macmode="${wl0_macmode:-$(nvram get wl0_macmode)}"
	FORM_isolate=${wl0_ap_isolate:-$(nvram get wl0_ap_isolate)}
	FORM_isolate=${FORM_isolate:-$DEFAULT_AP_ISOLATE}
	FORM_txpwr=${wl0_txpwr:-$(nvram get wl0_txpwr)}
	FORM_txpwr=${FORM_txpwr:-$DEFAULT_TXPWR}
	FORM_frameburst=${wl0_frameburst:-$(nvram get wl0_frameburst)}
	FORM_lazywds=${wl0_lazywds:-$(nvram get wl0_lazywds)}
	case "$FORM_lazywds" in
		1|on|enabled) FORM_lazywds=1;;
		*) FORM_lazywds=0;;
	esac
	FORM_wdstimeout=${wl0_wdstimeout:-$(nvram get wl0_wdstimeout)}
	FORM_antdiv=${antdiv:-$(nvram get wl0_antdiv)}
	FORM_antdiv=${FORM_antdiv:-3}
	FORM_txant=${txant:-$(nvram get wl0_txant)}
	FORM_txant=${FORM_txant:-3}
	FORM_wl0_plcphdr=${wl0_plcphdr:-$(nvram get wl0_plcphdr)}
	FORM_wl0_frag=${wl0_frag:-$(nvram get wl0_frag)}
	FORM_wl0_frag=${FORM_wl0_frag:-2346}
	FORM_wl0_rts=${wl0_rts:-$(nvram get wl0_rts)}
	FORM_wl0_rts=${FORM_wl0_rts:-2347}
	FORM_wl0_dtim=${wl0_dtim:-$(nvram get wl0_dtim)}
	FORM_wl0_dtim=${FORM_wl0_dtim:-1}
	FORM_wl0_bcn=${wl0_bcn:-$(nvram get wl0_bcn)}
	FORM_wl0_bcn=${FORM_wl0_bcn:-100}
	FORM_wl0_maxassoc=${wl0_bcn:-$(nvram get wl0_maxassoc)}
	FORM_wl0_maxassoc=${FORM_wl0_maxassoc:-128}
	FORM_wl0_distance=${wl0_distance:-$(nvram get wl0_distance)}
else
#####################################################################
# save forms
	SAVED=1

	validate <<EOF
int|FORM_lazywds|@TR<<Lazy WDS>>|required min=0 max=1|$FORM_lazywds
int|FORM_wdstimeout|@TR<<WDS Watchdog Timeout>>|optional min=0 max=3600|$FORM_wdstimeout
int|FORM_txpwr|@TR<<Transmit Power>>|required min=1 max=251|$FORM_txpwr
int|FORM_wl0_frag|@TR<<Fragmentation Threshold>>|min=0 max=2346|$FORM_wl0_frag
int|FORM_wl0_rts|@TR<<RTS Threshold>>|min=0 max=2347|$FORM_wl0_rts
int|FORM_wl0_dtim|@TR<<DTIM Period>>|min=0|$FORM_wl0_dtim
int|FORM_wl0_bcn|@TR<<Beacon Period>>|min=0|$FORM_wl0_bcn
int|FORM_wl0_maxassoc|@TR<<Max Associated Clients>>|required min=0 max=256|$FORM_wl0_maxassoc
int|FORM_antdiv|@TR<<Receive Antenna Diversity>>|min=0|$FORM_antdiv
int|FORM_txant|@TR<<Transmit Antenna Diversity>>|min=0|$FORM_txant
int|FORM_wl0_distance|@TR<<Wireless Distance>>|min=0|$FORM_wl0_distance
EOF
	equal "$?" 0 && {
		save_setting wireless wl0_lazywds "$FORM_lazywds"
		save_setting wireless wl0_wdstimeout "$FORM_wdstimeout"
		save_setting wireless wl0_macmode "$FORM_macmode"
		save_setting wireless wl0_txpwr "$FORM_txpwr"
		# todo: currently don't save if verify on above failed.. decide on this
		save_setting wireless wl0_ap_isolate "$FORM_isolate"
		save_setting wireless wl0_frameburst "$FORM_frameburst"
		save_setting wireless wl0_antdiv "$FORM_antdiv"
		save_setting wireless wl0_txant "$FORM_txant"
		save_setting wireless wl0_plcphdr "$FORM_wl0_plcphdr"
		save_setting wireless wl0_frag  "$FORM_wl0_frag"
		save_setting wireless wl0_rts   "$FORM_wl0_rts"
		save_setting wireless wl0_dtim  "$FORM_wl0_dtim"
		save_setting wireless wl0_bcn   "$FORM_wl0_bcn"
		save_setting wireless wl0_distance   "$FORM_wl0_distance"
	}
fi

#####################################################################s
cat <<EOF
<script type="text/javascript" src="/webif.js"></script>
<script type="text/javascript">

function modechange() {
	var v = (value("macmode") == "allow") || (value("macmode") == "deny");
	set_visible('mac_list', v);
}
</script>
EOF

#####################################################################s
display_form <<EOF
onchange|modechange
start_form|@TR<<WDS Connections>>
field|@TR<<Lazy WDS>>
select|lazywds|$FORM_lazywds
option|1|@TR<<Enabled>>
option|0|@TR<<Disabled>>
field|@TR<<WDS Watchdog Timeout>>
text|wdstimeout|$FORM_wdstimeout
listedit|wds|$SCRIPT_NAME?|$FORM_wds|$FORM_wdsadd
helpitem|Wireless Distribution System
helptext|HelpText Wireless Distribution System#This feature allows you to use multiple wireless access points to extend the range of your network without having to run wires to the access points.
helpitem|WDS Connections
helptext|HelpText WDS Connections#Enter the MAC addresses of the router(s) on your network that should be wirelessly connected to. The other routers must support Lazy WDS by default (many do), else they will need to be manually reconfigured as well.
helpitem|Lazy WDS
helptext|HelpText Lazy WDS#When set, allow any router to initiate a WDS connection to this router.
end_form

start_form|@TR<<MAC Filter List>>
field|@TR<<Filter Mode>>
select|macmode|$FORM_macmode
option|disabled|@TR<<Disabled>>
option|allow|@TR<<Allow>>
option|deny|@TR<<Deny>>
listedit|maclist|$SCRIPT_NAME?|$FORM_maclist|$FORM_maclistadd
helpitem|MAC Filter List
helptext|HelpText MAC Filter List#Here you can set a list of MAC addresses to allow or deny connection to the wireless network, depending on the 'Filter Mode' setting.
end_form

start_form|@TR<<Settings>>
field|@TR<<Frameburst>>
select|frameburst|$FORM_frameburst
option|0|@TR<<Disabled>>
option|1|@TR<<Enabled>>
field|@TR<<Isolate WLAN clients>>
select|isolate|$FORM_isolate
option|1|@TR<<Enabled>>
option|0|@TR<<Disabled>>
field|@TR<<Transmit Power>> @TR<<(in mw)>>
select|txpwr|$FORM_txpwr
$VALID_TXPWR
field|@TR<<Receive Antenna Diversity>>
select|antdiv|$FORM_antdiv
option|3|@TR<<Automatic>>
option|0|@TR<<Right>>
option|1|@TR<<Left>>
field|@TR<<Transmit Antenna Diversity>>
select|txant|$FORM_txant
option|3|@TR<<Automatic>>
option|0|@TR<<Right>>
option|1|@TR<<Left>>
field|@TR<<Preamble>> @TR<<(Default: Long)>>
select|wl0_plcphdr|$FORM_wl0_plcphdr
option|long|@TR<<Long>>
option|short|@TR<<Short>>
field|@TR<<Fragmentation Threshold>> @TR<<(default 2346)>>
text|wl0_frag|$FORM_wl0_frag
field|@TR<<RTS Threshold>> @TR<<(default 2347)>>
text|wl0_rts|$FORM_wl0_rts
field|@TR<<DTIM Period>> @TR<<(default 1)>>
text|wl0_dtim|$FORM_wl0_dtim
field|@TR<<Beacon Period>> @TR<<(default 100)>>
text|wl0_bcn|$FORM_wl0_bcn
field|@TR<<Max Associated Clients>> @TR<<(default 128)>>
text|wl0_maxassoc|$FORM_wl0_maxassoc
field|@TR<<Wireless Distance>> @TR<<(In Meters)>>
text|wl0_distance|$FORM_wl0_distance
helpitem|Wireless Distance
helptext|Helptext Wireless Distance#You must enter a number that is double the distance of your longest link.
end_form
EOF

footer ?>
<!--
##WEBIF:name:Network:400:Advanced Wireless
-->
