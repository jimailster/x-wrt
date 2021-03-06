require("uci_iwaddon")
parser = {}
local P = {}
parser = P
-- Import Section:
-- declare everything this package needs from outside
local io = io
local wwwprint = wwwprint
if wwwprint == nil then wwwprint=print end
local oldprint = oldprint
local table = table
local pairs = pairs
local iwuci = iwuci
local tonumber = tonumber
local uci = uci

-- no more external access after this point
setfenv(1, P)

enable    = tonumber(uci.check_set("freeradius","webadmin","enable","1"))
userlevel = tonumber(uci.check_set("freeradius","webadmin","userlevel","1"))
reboot    = false                -- reboot device after all apply process

call_parser = "freeradius_check freeradius_clients freeradius_proxy"

name = "Freeradius"
script = "radiusd"
init_script = "/etc/init.d/radiusd"

function process()
  wwwprint(name.." Parsers...")
  uci.commit("freeradius")
  if tonumber(uci.get("freeradius","webadmin","userlevel")) < 4 then
    wwwprint("Checking freeradius dictionary to chilli")
    local write_file
    if io.exists("/usr/share/freeradius/dictionary.chillispot") then
      local dict = io.totable("/usr/share/freeradius/dictionary",true)
      wwwprint("Updating /usr/share/freeradius/dictionary")
      if dict[1] ~= "$INCLUDE dictionary.chillispot" then
        table.insert(dict,1,"$INCLUDE dictionary.chillispot")
      end
      write_file = io.open("/usr/share/freeradius/dictionary","w")
      write_file:write(table.concat(dict,'\n'))
      write_file:close()
    end
    write_config()
  end

end

function write_config()
  local conf_file = "/etc/freeradius/radiusd.conf"
  local conf_str  = [[######
prefix = /usr
exec_prefix = /usr
sysconfdir = /etc
localstatedir = /var
sbindir = /usr/sbin
logdir = ${localstatedir}/log/radius
raddbdir = /etc/freeradius
radacctdir = ${logdir}/radacct
#  Location of config and logfiles.
confdir = ${raddbdir}
run_dir = ${localstatedir}/run
log_file = ${logdir}/radiusd.log
libdir = /usr/lib/
pidfile = ${run_dir}/radiusd.pid
max_request_time = 30
delete_blocked_requests = no
cleanup_delay = 5
max_requests = 1024
bind_address = *
port = 0
hostname_lookups = no
allow_core_dumps = no
regular_expressions	= yes
extended_expressions	= yes
log_stripped_names = no
log_auth = no
log_auth_badpass = no
log_auth_goodpass = no
usercollide = no
lower_user = no
lower_pass = no
nospace_user = no
nospace_pass = no
security {
	max_attributes = 200
	reject_delay = 0
	status_server = no
}
proxy_requests  = yes
$INCLUDE  ${confdir}/proxy.conf
$INCLUDE  ${confdir}/clients.conf
# SNMP CONFIGURATION
#
#  Snmp configuration is only valid if SNMP support was enabled
#  at compile time.
#
#  To enable SNMP querying of the server, set the value of the
#  'snmp' attribute to 'yes'
#
snmp	= no
#$INCLUDE  ${confdir}/snmp.conf


thread pool {
	start_servers = 5
	max_servers = 32
	min_spare_servers = 3
	max_spare_servers = 10
	max_requests_per_server = 0
}

modules {
#	pap {
#		auto_header = yes
#	}
	chap {
		authtype = CHAP
	}
	pam {
		#
		#  The name to use for PAM authentication.
		#  PAM looks in /etc/pam.d/${pam_auth_name}
		#  for it's configuration.  See 'redhat/radiusd-pam'
		#  for a sample PAM configuration file.
		#
		#  Note that any Pam-Auth attribute set in the 'authorize'
		#  section will over-ride this one.
		#
		pam_auth = radiusd
	}

	# Unix /etc/passwd style authentication
	#
	unix {
		cache = no
		cache_reload = 600
		radwtmp = ${logdir}/radwtmp
	}
	realm suffix {
		format = suffix
		delimiter = "@"
		ignore_default = no
		ignore_null = no
	}

	#  'username%realm'
	#
	realm realmpercent {
		format = suffix
		delimiter = "%"
		ignore_default = no
		ignore_null = no
	}

	#
	#  'domain\user'
	#
	realm ntdomain {
		format = prefix
		delimiter = "\\"
		ignore_default = no
		ignore_null = no
	}	

	checkval {
		# The attribute to look for in the request
		item-name = Calling-Station-Id

		# The attribute to look for in check items. Can be multi valued
		check-name = Calling-Station-Id

		# The data type. Can be
		# string,integer,ipaddr,date,abinary,octets
		data-type = string

		# If set to yes and we dont find the item-name attribute in the
		# request then we send back a reject
		# DEFAULT is no
		#notfound-reject = no
	}
	
	preprocess {
		huntgroups = ${confdir}/huntgroups
		hints = ${confdir}/hints
		with_ascend_hack = no
		ascend_channels_per_line = 23
		with_ntdomain_hack = no
		with_specialix_jetstream_hack = no
		with_cisco_vsa_hack = no
	}

	files {
		usersfile = ${confdir}/users
		acctusersfile = ${confdir}/acct_users
#		preproxy_usersfile = ${confdir}/preproxy_users
		compat = no
	}

	detail {
		detailfile = ${radacctdir}/%{Client-IP-Address}/detail-%Y%m%d
		detailperm = 0600
		#suppress {
			# User-Password
		#}
	}

	acct_unique {
		key = "User-Name, Acct-Session-Id, NAS-IP-Address, Client-IP-Address, NAS-Port"
	}
	radutmp {
		filename = ${logdir}/radutmp
		username = %{User-Name}
		case_sensitive = yes
		check_with_nas = yes		
		perm = 0600
		callerid = "yes"
	}
	radutmp sradutmp {
		filename = ${logdir}/sradutmp
		perm = 0644
		callerid = "no"
	}
	attr_filter {
		attrsfile = ${confdir}/attrs
	}
	always fail {
		rcode = fail
	}
	always reject {
		rcode = reject
	}
	always ok {
		rcode = ok
		simulcount = 0
		mpp = no
	}
	expr {
	}
	digest {
	}
	exec {
		wait = yes
		input_pairs = request
	}
	exec echo {
		wait = yes
		program = "/bin/echo %{User-Name}"
		input_pairs = request
		output_pairs = reply

		#
		#  When to execute the program.  If the packet
		#  type does NOT match what's listed here, then
		#  the module does NOT execute the program.
		#
		#  For a list of allowed packet types, see
		#  the 'dictionary' file, and look for VALUEs
		#  of the Packet-Type attribute.
		#
		#  By default, the module executes on ANY packet.
		#  Un-comment out the following line to tell the
		#  module to execute only if an Access-Accept is
		#  being sent to the NAS.
		#
		#packet_type = Access-Accept
	}

#	ippool main_pool {
#		range-start = 192.168.1.1
#		range-stop = 192.168.3.254
#		netmask = 255.255.255.0
#		cache-size = 800
#		session-db = ${raddbdir}/db.ippool
#		ip-index = ${raddbdir}/db.ipindex
#		override = no
#		maximum-timeout = 0
#	}
}

instantiate {
#	exec
#	expr
#	daily
}

authorize {
#	preprocess
#	auth_log
#	attr_filter
	chap
#	mschap
#	digest
	suffix
#	ntdomain
	files
#	sql
#	etc_smbpasswd
#	ldap
#	daily
#	checkval
#	pap
}


authenticate {
#	Auth-Type PAP {
#		pap
#	}
	Auth-Type CHAP {
		chap
	}
#	digest
#	pam
#	unix
#	Auth-Type LDAP {
#		ldap
#	}
#	eap
}


preacct {
#	preprocess
#	acct_unique
	suffix
#	ntdomain
	files
}
accounting {
#	detail
#	daily
#	unix
	radutmp
#	sradutmp
#	main_pool
#	sql
#	sql_log
#	pgsql-voip
}
session {
	radutmp
#	sql
}
post-auth {
#	main_pool
#	reply_log
#	sql
#	sql_log
#	ldap
#	Post-Auth-Type REJECT {
#		insert-module-name-here
#	}
}
pre-proxy {
#	attr_rewrite
#	files
#	pre_proxy_log
}
post-proxy {
#	post_proxy_log
#	attr_rewrite
#	attr_filter
#	eap
}

]]

  wwwprint ("Writing config file "..conf_file)
  local write_file = io.open(conf_file,"w")
  write_file:write(conf_str)
  write_file:close()
end

return parser
