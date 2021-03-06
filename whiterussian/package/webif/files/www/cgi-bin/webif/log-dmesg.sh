#!/usr/bin/webif-page
<?
. /usr/lib/webif/webif.sh
[ -f /etc/syslog.default ] && . /etc/syslog.default

header_inject_head=$(cat <<EOF
<style type="text/css">
<!--
#dmesgarea pre {
	margin: 0.2em auto 1em auto;
	padding: 3px;
	width: 98%;
	margin: auto;
	height: 300px;
	overflow: scroll;
	border: 1px solid;
} \
// -->
</style>

EOF
)

filter_temp="/tmp/.webif.log-dmesg.tmp"
if [ -n "$FORM_clearfilter" ]; then
	rm -f "$filter_temp" 2>/dev/null
	unset FORM_filtext FORM_filtmode
fi
if [ -n "$FORM_newfilter" ]; then
	echo "# this file is automatically generated by webi^2 page" > "$filter_temp" 2>/dev/null
	echo "# for temporary processing; you are free to delete it" >> "$filter_temp" 2>/dev/null
	echo "filtext=$FORM_filtext" >> "$filter_temp" 2>/dev/null
	echo "filtmode=$FORM_filtmode" >> "$filter_temp" 2>/dev/null
else
	if [ -e "$filter_temp" ]; then
		FORM_filtext=$(sed '/^filtext=/!d; s/^filtext=//' "$filter_temp" 2>/dev/null)
		FORM_filtmode=$(sed '/^filtmode=/!d; s/^filtmode=//' "$filter_temp" 2>/dev/null)
	fi
fi
if [ "$FORM_filtmode" != "include" -a "$FORM_filtmode" != "exclude" ]; then
	FORM_filtmode="include"
fi
[ -n "$FORM_filtext" ] && filtered_title=" (@TR<<log_filter_filtered#filtered>>)"


header "Log" "Kernel" "@TR<<log_dmesg_Kernel_Ring_Buffer#Kernel Ring Buffer>>"

show_messages() {
awk -v "filtmode=$FORM_filtmode" -v "filtext=$FORM_filtext" -v "showtype=$1" '
BEGIN {
	msgcntr = 0
}
function print_sanitize(msg) {
	gsub(/&/, "\\&amp;", msg)
	gsub(/</, "\\&lt;", msg)
	gsub(/>/, "\\&gt;", msg)
	print msg
}
{
	if (filtmode == "include") {
		if ($0 ~ filtext) {
			print_sanitize($0)
			msgcntr++
		}
	} else {
		if ($0 !~ filtext) {
			print_sanitize($0)
			msgcntr++
		}
	}
}
END {
	if (msgcntr == 0) {
		if (showtype)
			print "@TR<<log_dmesg_no_archived_messages#There are no archived kernel messages.>>"
		else
			print "@TR<<log_dmesg_no_current_messages#There are no kernel messages.>>"
	}
}'
}

cat <<EOF
<div id="dmesgarea">
<div class="settings">
<h3><strong>@TR<<log_dmesg_Current_messages#Current messages>>$filtered_title</strong></h3>
<pre>
EOF
buffersize=$(nvram get klog_buffersize)
buffersize="${buffersize:-$DEFAULT_klog_buffersize}"
let "buffersize *= 1024"
[ $buffersize -gt 1024 ] || buffersize=""
dmesg ${buffersize:+-s$buffersize} 2>/dev/null | show_messages
echo " </pre>"

dmesgbackup_enabled=$(nvram get klog_enabled)
dmesgbackup_enabled="${dmesgbackup_enabled:-$DEFAULT_klog_enabled}"
if [ 1 -eq "$dmesgbackup_enabled" ]; then
	dmesgbackup_file=$(nvram get klog_file)
	dmesgbackup_file="${dmesgbackup_file:-$DEFAULT_klog_file}"
	dmesgbackup_gzip=$(nvram get klog_gzip)
	dmesgbackup_gzip="${dmesgbackup_gzip:-$DEFAULT_klog_gzip}"
	[ 1 -eq "$dmesgbackup_gzip" ] && dmesgbackup_file="$dmesgbackup_file.gz"
	if [ -f "$dmesgbackup_file" ]; then
		echo "<div class=\"clearfix\">&nbsp;</div></div>"
		cat <<EOF
<div class="settings">
<h3><strong>@TR<<log_dmesg_Boot_time_messages#Boot time messages>>$filtered_title</strong></h3>
<pre>
EOF
		if [ 1 -eq "$dmesgbackup_gzip" ]; then
			cat "$dmesgbackup_file" 2>/dev/null | gzip -d - | show_messages 1
		else
			cat "$dmesgbackup_file" 2>/dev/null | show_messages 1
		fi
		echo " </pre>"
	fi
fi
echo "<div class=\"clearfix\">&nbsp;</div></div>"
echo "</div>"

FORM_filtext=$(echo "$FORM_filtext" | sed 's/&/\&amp;/; s/"/\&#34;/; s/'\''/\&#39;/; s/\$/\&#36;/; s/</\&lt;/; s/>/\&gt;/; s/\\/\&#92;/; s/|/\&#124;/;')

display_form <<EOF
formtag_begin|filterform|$SCRIPT_NAME
start_form|@TR<<log_filter_Text_Filter#Text Filter>>
field|@TR<<log_filter_Text_to_Filter#Text to Filter>>
text|filtext|$FORM_filtext
field|@TR<<log_filter_Filter_Mode#Filter Mode>>
select|filtmode|$FORM_filtmode
option|include|@TR<<log_filter_Include#Include>>
option|exclude|@TR<<log_filter_Exclude#Exclude>>
string|</td></tr><tr><td>
submit|clearfilter|@TR<<log_filter_Remove_Filter#Remove Filter>>
string|</td><td>
submit|newfilter|@TR<<log_filter_Filter_Messages#Filter Messages>>
helpitem|log_filter_Text_to_Filter#Text to Filter
helptext|log_filter_Text_to_Filter_helptext#Insert a string that covers what you would like to see or exclude. In fact you can use the reqular expression constants like: <code>00:[[:digit:]]{2}:[[:digit:]]{2}</code> or <code>.debug&#124;.err</code>.
helpitem|log_filter_Filter_Mode#Filter Mode
helptext|log_filter_Filter_Mode_helptext#You will see only messages containing the text in the Include mode while you will not see them in the Exclude mode.
end_form
formtag_end
EOF

footer ?>
<!--
##WEBIF:name:Log:003:Kernel
-->
