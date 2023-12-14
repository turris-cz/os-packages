module("luci.controller.easybird", package.seeall)

function index()
    entry({"admin", "status", "easybird"}, template("easybird/overview"), "Bird", 0).dependent=false
    entry({"admin", "services", "easybird"}, cbi("easybird/easybird"), "Bird").dependent=false
    entry({"admin", "status", "easybird", "overview"}, call("status"))
    entry({"admin", "status", "easybird", "ospf"}, call("ospf_status"))
    entry({"admin", "status", "easybird", "babel"}, call("babel_status"))
end

function status()
    local api = io.popen("/usr/sbin/birdcl -s /var/run/easybird.ctl show status", "r")
    local version = "NA"
    local router_id = "NA"
    local last_reconfig = "NA"
    local ln = api:read()
    if not ln or not string.find(ln, " ready.") then
        api:close()
        api = io.popen("/bin/sh -c '/usr/sbin/bird --version 2>&1'", "r")
        ln = api:read()
        if ln then
            local tmp = string.match(ln, "BIRD version ([0-9.]*)")
            version = ln
            if tmp then
                version = tmp
            end
        end
        api:close()
        luci.http.status(200, "OK")
        luci.http.prepare_content("application/json")
        luci.http.write_json({running = false, version = version})
        return
    end
    version = string.match(ln, "BIRD ([0-9.]*) ready.")
    while ln do
        local tmp = string.match(ln, "Router ID is ([0-9.]*)")
        if tmp then
            router_id = tmp
        end
        tmp = string.match(ln, "Last reconfiguration on (.*)")
        if tmp then
            last_reconfig = tmp
        end
        ln = api:read()
    end
    api:close()
    api = io.popen("/usr/sbin/birdcl -s /var/run/easybird.ctl show protocols", "r")
    local lines = api:read("*a")
    api:close()
    local protocols_table = {}
    for ln in string.gmatch(lines,'([^\n]+)') do
        tmp = string.match(ln, "^%w+%s+(%w+)%s+.*up.*")
        if tmp and tmp ~= "Proto" then
            protocols_table[tmp] = 1
        end
    end
    local protocols = {}
    for p, _ in pairs(protocols_table) do
        table.insert(protocols, p)
    end
    luci.http.status(200, "OK")
    luci.http.prepare_content("application/json")
    luci.http.write_json({running = true, version = version, router_id = router_id, last_reconfig = last_reconfig, protocols = protocols})
end

function merge_tables(dest, src)
    for k, v in pairs(src) do
        if type(v) == "table" then
            if not dest[k] then
                dest[k] = v
            else
                merge_tables(dest[k], v)
            end
        else
            if v ~= nil then
                dest[k] = v
            end
        end
    end
end

function ospf_store_element(status, element)
    if not element then
        return
    end
    local t = element["type"]
    local i = element["id"]
    element["type"] = nil
    element["id"] = nil
    if not status[t][i] then
        status[t][i] = element
    else
        merge_tables(status[t][i], element)
    end
end

function ospf_status()
    local status = { routers = {}, networks = {}, neighbors = {}}
    local api = nil
    local lines = ""
    for _, cmd in pairs({"show ospf state ospf4", "show ospf state ospf6", "show ospf topology ospf4", "show ospf topology ospf6"}) do
        api = io.popen("/usr/sbin/birdcl -s /var/run/easybird.ctl " .. cmd, "r")
        lines = lines .. api:read("*a")
        api:close()
        local tmp = ""
        local metric = ""
        local element = nil
        for ln in string.gmatch(lines,'([^\n]+)') do
            tmp = string.match(ln, "^\trouter ([%d.]+)")
            if tmp then
                ospf_store_element(status, element)
                element = { id = tmp, type = "routers" }
            end
            tmp = string.match(ln, "^\tnetwork ([%x./:]+)")
            if tmp then
                ospf_store_element(status, element)
                element = { id = tmp, type = "networks" }
            end
            tmp = string.match(ln, "^\t\tdistance (%d+)")
            if tmp and element then
                element["distance"] = tmp
            end
            tmp = string.match(ln, "^\t\tdr ([%d.]+)")
            if tmp and element then
                element["dr"] = tmp
            end
            for _, net in pairs({ "network", "stubnet", "external" }) do
                _, _, tmp, metric = string.find(ln, "^\t\t" .. net .. " ([%x./:]+) metric (%d+)")
                if tmp and element then
                    if not element["networks"] then
                        element["networks"] = { }
                    end
                    if metric then
                        element["networks"][tmp] = { metric = metric, type = net }
                    else
                        element["networks"][tmp] = { type = net }
                    end
                end
            end
        end
    end
    ospf_store_element(status, element)
    api = io.popen("/usr/sbin/birdcl -s /var/run/easybird.ctl show ospf neighbors", "r")
    lines = api:read("*a")
    api:close()
    for ln in string.gmatch(lines,'([^\n]+)') do
        _, _, rtr, pri, st, iface, ip = string.find(ln, "^([%d.]+)%s+(%d+)%s+([^%s]+)%s+[%d.]+%s+([^%s]+)%s+([%d.]+)$")
        if ip ~= nil then
            if status['neighbors'][rtr] == nil then status['neighbors'][rtr] = {} end
            status['neighbors'][rtr]['ipv4'] = { router = rtr, piority = pri, state = st, interface = iface, ip = ip }
        end
        ip = nil
        _, _, rtr, pri, st, iface, ip = string.find(ln, "^([%d.]+)%s+(%d+)%s+([^%s]+)%s+[%d.]+%s+([^%s]+)%s+([%x:]+)$")
        if ip ~= nil then
            if status['neighbors'][rtr] == nil then status['neighbors'][rtr] = {} end
            status['neighbors'][rtr]['ipv6'] = { router = rtr, piority = pri, state = st, interface = iface, ip = ip }
        end
    end
    luci.http.status(200, "OK")
    luci.http.prepare_content("application/json")
    luci.http.write_json(status)
end

function babel_status()
    local api = io.popen("/usr/sbin/birdcl -s /var/run/easybird.ctl show babel neighbors", "r")
    local status = { }
    status["routers"] = {}
    status["networks"] = {}
    local lines = api:read("*a")
    api:close()
    local ip
    local iface
    local metric
    local hellos
    for ln in string.gmatch(lines,'([^\n]+)') do
        _, _, ip, iface, metric, hellos = string.find(ln, "^([%x:.]+)%s+([^%s]+)%s+(%d+)%s+%d+%s+(%d+)%s+.*")
        if ip then
            table.insert(status["routers"], { ip = ip, interface = iface, metric = metric, hellos = hellos })
        end
    end
    api = io.popen("/usr/sbin/birdcl -s /var/run/easybird.ctl show babel entries", "r")
    lines = api:read("*a")
    api:close()
    for ln in string.gmatch(lines,'([^\n]+)') do
        _, _, ip, iface, metric = string.find(ln, "^([%x:./]+)%s+([%x:.]+)%s+(%d+)%s+.*")
        if ip then
            table.insert(status["networks"], { ip = ip, router = iface, metric = metric })
        end
    end
    luci.http.status(200, "OK")
    luci.http.prepare_content("application/json")
    luci.http.write_json(status)
end
