#!/usr/bin/lua
require("init")
require("olsrdata")
olsrdata = olsrdataClass.new()
print([[Content-Type: text/html; charset=UTF-8
Pragma: no-cache
]])
print (olsrdata:html())