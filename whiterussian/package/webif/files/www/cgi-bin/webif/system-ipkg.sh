#!/usr/bin/webif-page
<?
. /usr/lib/webif/webif.sh
###################################################################
# Packages configuration page
#
# Description:
#	Allows installation and removal of packages.
#
# Author(s) [in order of work date]:
#   OpenWrt developers (??)
#   todo: person who added descriptions..
#   Dmytro
#   eJunky
#   emag
#   Jeremy Collake <jeremy.collake@gmail.com>
#
# Major revisions:
#
# NVRAM variables referenced:
#   none
#
# Configuration files referenced:
#   none
#
# Utilities/applets referenced:
#   ipkg
#
#

# default X-Wrt repository
xwrtrepourl="http://download2.berlios.de/pub/xwrt/packages"
xwrtreponame="X-Wrt"

header "System" "Packages" "@TR<<system_ipkg_Packages#Packages>>" '' "$SCRIPT_NAME"

cat <<EOF
<script type="text/javascript">
function confirmT(action,pkg) {
if ( pkg == "uclibc" || pkg == "base-files" || pkg == "bridge" || pkg == "busybox" || pkg == "dnsmasq" || pkg == "dropbear" || pkg == "haserl" || pkg == "hotplug" || pkg == "iptables" || pkg == "kernel" || pkg == "mtd" || pkg == "wireless-tools" || pkg == "wlc") {
alert ("             <<< WARNING >>> \n\nPackage \"" + pkg + "\" should not be removed!\n\n>>> Removing may brick your router. <<<\n\nSystem requires \"" + pkg + "\" package to run.\n\n") ;
}
if (window.confirm("Please Confirm!\n\nDo you want to " + action + " \"" + pkg + "\" package?")){
window.location="system-ipkg.sh?action=" + action + "&amp;pkg=" + pkg
} }
</script>
EOF

##################################################################
#
# Install from URL and Add Repository code - self-contained block.
#

repo_update_needed=0

! empty "$FORM_install_url" && {
	# just set up to pass-through to normal handler
	FORM_action="install"
	FORM_pkg="$FORM_pkgurl"
}

! empty "$FORM_install_repo" && {
validate << EOF
string|FORM_reponame|@TR<<system_ipkg_reponame#Repo. Name>>|min=4 max=40 required nospaces|$FORM_reponame
string|FORM_repourl|@TR<<system_ipkg_repourl#Repo. URL>>|min=4 max=4096 required|$FORM_repourl
EOF
	if equal "$?" "0"; then
		repo_update_needed=1
		# since firstboot doesn't make a copy of ipkg.conf, we must do it
		# todo: need a mutex or lock here
		local tmpfile=$(mktemp "/tmp/.webif-ipkg-XXXXXX")
		cp -p "/etc/ipkg.conf" "$tmpfile" 2>/dev/null
		# a bit tricky but we want the X-Wrt repository always to be there
		# and the last and the preferred one (i mean it!)
		local oldlist=$(grep "^src[[:space:]]$xwrtreponame[[:space:]]$xwrtrepourl" /etc/ipkg.conf | cut -d' ' -f2)
		! empty "$oldlist" && ! equal "$oldlist" "$xwrtreponame" ] && {
			rm -f "/usr/lib/ipkg/lists/$oldlist" 2>/dev/null
		}
		(echo "src $FORM_reponame $FORM_repourl"
		grep "^src[[:space:]]" "/etc/ipkg.conf") | grep -vi "^src[[:space:]].*[[:space:]]$xwrtrepourl" > "$tmpfile"
		echo "src $xwrtreponame $xwrtrepourl" >> "$tmpfile"
		grep -v "^src[[:space:]]" "/etc/ipkg.conf" >> "$tmpfile"
		rm -f "/etc/ipkg.conf"
		mv -f "$tmpfile" "/etc/ipkg.conf"
	else
		echo "<h3 class=\"warning\">$ERROR</h3>"
	fi
}

! empty "$FORM_remove_repo_name" && ! empty "$FORM_remove_repo_url" && {
	repo_update_needed=1
	repo_src_line="src $FORM_remove_repo_name $FORM_remove_repo_url"
	remove_lines_from_file "/etc/ipkg.conf" "$repo_src_line"
	# do not enable the user to remove our repository and force it to be
	# the last and the preferred one (i mean it!)
	local tmpfile=$(mktemp "/tmp/.webif-ipkg-XXXXXX")
	cp -p "/etc/ipkg.conf" "$tmpfile" 2>/dev/null
	local oldlist=$(grep "^src[[:space:]]$xwrtreponame[[:space:]]$xwrtrepourl" /etc/ipkg.conf | cut -d' ' -f2)
	! empty "$oldlist" && ! equal "$oldlist" "$xwrtreponame" ] && {
		rm -f "/usr/lib/ipkg/lists/$oldlist" 2>/dev/null
	}
	grep "^src[[:space:]]" "/etc/ipkg.conf" | grep -vi "^src[[:space:]].*[[:space:]]$xwrtrepourl" > "$tmpfile"
	echo "src $xwrtreponame $xwrtrepourl" >> "$tmpfile"
	grep -v "^src[[:space:]]" "/etc/ipkg.conf" >> "$tmpfile"
	rm -f "/etc/ipkg.conf"
	mv -f "$tmpfile" "/etc/ipkg.conf"
	# manually remove package lists since ipkg update won't..
	# todo: odd issue where 'rm -f /usr/lib/ipkg/lists/* does not work - openwrt should investigate
	rm -f "/usr/lib/ipkg/lists/$FORM_remove_repo_name" >&- 2>&-
	echo "<br />Repository source was removed: $FORM_remove_repo_name<br />"
}

equal "$repo_update_needed" "1" && {
	echo "<br />Repository sources updated.<br />"
}

! empty "$FORM_update_package_lists" && repo_update_needed=1


equal "$repo_update_needed" "1" && {
	echo "<pre>Performing update of package lists ...<br />"
	echo "@TR<<system_ipkg_pleasewait#Please wait>> ...<br />"
	mkdir "/usr/lib/ipkg/lists" >&- 2>&-
	ipkg update
	echo "</pre><br />"
}

if [ "$FORM_action" = "install" ]; then
	echo "<pre>@TR<<system_ipkg_pleasewait#Please wait>> ...<br />"
	install_package `echo "$FORM_pkg" | sed -e 's, ,+,g'`
	echo "</pre><br />"
elif [ "$FORM_action" = "remove" ]; then
	echo "<pre>@TR<<system_ipkg_pleasewait#Please wait>> ...<br />"
	ipkg remove `echo "$FORM_pkg" | sed -e 's, ,+,g'`
	echo "</pre><br />"
fi

repo_list=$(awk '/^[[:space:]]*src[[:space:]]/ { print "<tr class=\"repositories\"><td><a href=\"./system-ipkg.sh?remove_repo_name=" $2 "&amp;remove_repo_url=" $3 "\">@TR<<system_ipkg_removerepo#remove>></a>&nbsp;&nbsp;" $2 "</td><td colspan=\"2\">" $3 "</td></tr>"}' /etc/ipkg.conf)

display_form <<EOF
start_form|@TR<<system_ipkg_addrepo#Add Repository>>
field|@TR<<system_ipkg_reponame#Repo. Name>>
text|reponame|$FORM_reponame|
field|@TR<<system_ipkg_repourl#Repo. URL>>
text|repourl|$FORM_repourl|
field|&nbsp;
submit|install_repo|@TR<<system_ipkg_addrepo#Add Repository>>|
EOF
?>
</td></tr><tr><td colspan="2" class="repositories"><h4>@TR<<system_ipkg_currentrepos#Current Repositories>>:</h4></td></tr>
<?
echo "${repo_list}"
display_form <<EOF
helpitem|Add Repository
helptext|HelpText Add Repository#A repository is a server that contains a list of packages that can be installed on your OpenWrt device. Adding a new one allows you to list packages here that are not shown by default.
helpitem|Backports Tip
helptext|HelpText Backports Tip#For a much larger assortment of packages, see if there is a backports repository available for your firmware.
end_form
start_form|@TR<<system_ipkg_installfromurl#Install Package From URL>>
field|@TR<<system_ipkg_packageurl#URL of Package>>
text|pkgurl|$FORM_pkgurl
field|&nbsp;
submit|install_url|@TR<<system_ipkg_installfromurl#Install Package From URL>>|
helpitem|Install Package
helptext|HelpText Install Package#Normally one installs a package by clicking on the install link in the list of packages below. However, you can install a package not listed in the known repositories here.
end_form
EOF

# Block ends
##################################################################

display_form <<EOF
start_form|@TR<<system_ipkg_packagesavailable#Packages Available>>
field|&nbsp;
submit|update_package_lists|@TR<<system_ipkg_updatelists#Update package lists>>|
end_form
EOF
?>

<div class="settings">
<h3>@TR<<system_ipkg_installedpackages#Installed Packages>></h3>
<div class="packages">
<table>
<tr>
	<th width="150">@TR<<system_ipkg_th_action#Action>></th>
	<th width="200">@TR<<system_ipkg_th_package#Package>></th>
	<th width="150">@TR<<system_ipkg_th_version#Version>></th>
	<th>@TR<<system_ipkg_th_desc#Description>></th>
</tr>
<?
ipkg list_installed | awk -F ' ' '
$2 !~ /terminated/ {
	link=$1
	gsub(/\+/,"%2B",link)
	gsub(/^ */,"",link)
	gsub(/ *$/,"",link)
	version=$3
	desc=$5
	for (i=6; i <= NF; i++)
			desc = desc " " $i
	gsub(/&/, "\\&amp;", desc)
	gsub(/</, "\\&lt;", desc)
	gsub(/>/, "\\&gt;", desc)
	print "<tr><td><a href=\"javascript:confirmT('\''remove'\'','\''" link "'\'')\">@TR<<system_ipkg_Uninstall#Uninstall>></a></td><td>" $1 "</td><td>" version "</td><td>" desc "</td></tr>"
}'
display_form <<EOF
end_form
EOF
?>
<div class="settings">
<h3>@TR<<system_ipkg_availablepackages#Available packages>></h3>
<div class="packages">
<table>
<tr>
	<th width="150">@TR<<system_ipkg_th_action#Action>></th>
	<th width="250">@TR<<system_ipkg_th_package#Package>></th>
	<th width="150">@TR<<system_ipkg_th_version#Version>></th>
	<th>@TR<<system_ipkg_th_desc#Description>></th>
</tr>
<?
repo_list=$(awk '/^[[:space:]]*src[[:space:]]/ { printf " /usr/lib/ipkg/lists/" $2 }' /etc/ipkg.conf)
status_list=$(awk '/^[[:space:]]*dest[[:space:]]/ { if ($3 == "/") printf " /usr/lib/ipkg/status"; else printf " "$3"/usr/lib/ipkg/status" }' /etc/ipkg.conf)
[ -z "$status_list" ] && status_list="/usr/lib/ipkg/status"
egrep 'Package:|Description:|Version:' $status_list $repo_list 2>&- | sed -e 's, ,,' -e 's,^[^:]*/usr/lib/ipkg/lists/,,' | awk -F: '
$1 ~ /status/ {
	installed[$3]++;
}
($1 !~ /terminated/) && ($1 !~ /\/status/) && (!installed[$3]) && ($2 !~ /Description/) && ($2 !~ /Version/) {
	if (current != $1) print "<tr><th colspan=\"4\">" $1 "</th></tr>"
	link=$3
	gsub(/\+/,"%2B",link)
	gsub(/^ */,"",link)
	gsub(/ *$/,"",link)
	getline verline
	split(verline,ver,":")
	getline descline
	split(descline,desc,":")
	gsub(/&/, "\\&amp;", desc[3])
	gsub(/</, "\\&lt;", desc[3])
	gsub(/>/, "\\&gt;", desc[3])
	print "<tr><td><a href=\"javascript:confirmT('\''install'\'','\''" link "'\'')\">@TR<<system_ipkg_Install#Install>></a></td><td>" $3 "</td><td>" ver[3] "</td><td>" desc[3] "</td></tr>"
	current=$1
}
'
display_form <<EOF
end_form
EOF

footer ?>
<!--
##WEBIF:name:System:300:Packages
-->
