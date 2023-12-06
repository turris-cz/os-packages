local uci = require "luci.model.uci"
local datatypes  = require("luci.cbi.datatypes")

local _uci = uci.cursor()

function iface_select(ifaces)
    ifaces[1].widget = "select"
    _uci:foreach("network", "interface",
        function(s)
            if s['device'] and s['device'] ~= "lo" and string.sub(s['device'],1,1) ~= "@" then
                ifaces[1]:value(s['.name'], s['.name'])
            end
        end)
end

local m = Map("easybird", "Bird", translate("Easy configuration of Bird Internet Routing Daemon"))

local s = m:section(NamedSection, "global")
s.title = translate("Global")
s.anonymous = true
local id = s:option(Value, "id", translate("Router ID"))
id.default = string.format('%d.%d.%d.%d', math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255))
function id:validate(id)
    if datatypes.ip4addr(id) or datatypes.uinteger(id) then
        return id
    end
    return nil
end
local ospf = s:option(Flag, "ospf", translate("Enable OSPF"))
ospf.default = 0
local babel = s:option(Flag, "babel", translate("Enable Babel"))
babel.default = 0

s = m:section(NamedSection, "ospf", "OSPF")
s.title = "OSPF"
s.anonymous = true
local dummy = s:option(DummyValue, "dummy", translate("Not enabled."))
dummy:depends("easybird.global.ospf", 0)
local hello = s:option(Value, "hello", translate("Hello interval"))
hello.optional = true
hello:depends("easybird.global.ospf", 1)
local ifaces = s:option(StaticList, "interface", translate("Interfaces to run OSPF on"))
ifaces:depends("easybird.global.ospf", 1)
iface_select({ ifaces })
ifaces = s:option(StaticList, "propagate", translate("Passive interfaces"))
ifaces:depends("easybird.global.ospf", 1)
iface_select({ ifaces })

s = m:section(NamedSection, "babel", "Babel")
s.title = "Babel"
s.anonymous = true
dummy = s:option(DummyValue, "dummy", translate("Not enabled."))
dummy:depends("easybird.global.babel", 0)
local rxcost = s:option(Value, "rxcost", translate("Receive cost"))
rxcost:depends("easybird.global.babel", 1)
rxcost.optional = true
ifaces = s:option(StaticList, "interface", translate("Interfaces to run Babel on"))
ifaces:depends("easybird.global.babel", 1)
iface_select({ ifaces })
ifaces = s:option(StaticList, "propagate", translate("Passive interfaces"))
ifaces:depends("easybird.global.babel", 1)
iface_select({ ifaces })

m.on_after_commit = function()
    luci.sys.call("/etc/init.d/easybird reload");
end

return m
