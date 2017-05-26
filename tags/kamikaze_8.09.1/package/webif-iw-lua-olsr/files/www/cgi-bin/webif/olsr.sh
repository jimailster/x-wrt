#!/usr/bin/lua
--[[
##WEBIF:name:HotSpot:120:OLSR
]]--
--dofile("/usr/share/internet-wifi/set_path.lua")
require("set_path")
require("init")
require("webpkg")
require("olsrdata")
local olsrdata = olsrdataClass.new()
pkg.check("ip olsrd olsrd-mod-dyn-gw olsrd-mod-nameservice olsrd-mod-txtinfo")

require("olsr")
--olsr = uciClass.new("olsr")
forms = {}
__WIP=4
olsrd.set_menu()
local option = string.trim(__FORM.option)
page.title = "OLSR"
local str_content = ""
if option == "" then option = "service" end
if option == "service" then
  forms[1] = olsrd.core_form()
elseif option == "general" then
  forms[1] = olsrd.general_form()
elseif option == "Ipc" then
  forms = olsrd.ipc_form()
elseif option == "Hna4" then
  forms[1] = olsrd.hna_form()
elseif option == "Hna6" then
  forms[1] = olsrd.hna_form()
elseif option == "interfaces" then
  forms[1] = olsrd.interfaces_form()
elseif option == "plugin" then
  if __FORM["plname"] == nil then
    forms[1] = olsrd.plugin_list_form()
--    forms[2] = olsrd.add_plugin_form()
  else
    forms = olsrd.plugins_form()
  end
elseif option == "Links" 
    or option == "Neighbors"
    or option == "Topology"
    or option == "HNA"
    or option == "MID"
    or option == "Routes"
  then
  page.__DOCTYPE = ""
  page.form = ""
  forms[1] = olsrdata:htmlData(nil,option)    
elseif option == "viz" then
  __WIP = 0
  page.__DOCTYPE = ""
  page.form = ""
--  forms[1] = olsrd.viz_form()
  str_content = olsrd.viz_form()
else
  form.title = __FORM.option.." ".. form.title
end
print(page:header())
print(str_content)
--forms[#forms]:Add_help_link("http://www.olsr.org","About OLSR" )
if #forms > 0 then
  for i=1, #forms do
    forms[i]:print()
  end
end
--[[
for i,v in pairs(__FORM) do
  print(i,v,"<br/>")
end
]]--
print(page:footer())
