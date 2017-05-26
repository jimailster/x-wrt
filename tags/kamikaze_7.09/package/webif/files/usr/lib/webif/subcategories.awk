BEGIN {
	FS=":"
	print "<h3><strong>@TR<<Subcategories>>:</strong></h3>"
	print "<ul>"
}
{
	if ($5 ~ "^" selected "$") print "	<li class=\"selected\"><a href=\"" rootdir "/" $6 "\">@TR<<" $5 ">></a></li>"
	else print "	<li><a href=\"" rootdir "/" $6 "\">@TR<<" $5 ">></a></li>"
}
END {
	print "</ul>"
}

