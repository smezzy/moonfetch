require("utils")

local info = {}

function info.os()
    local name, version = "", ""

    for line in io.lines("/etc/os-release") do
        local info = string.split(line, "=")

        if info[1] == "NAME" then
            name = string.trim(info[2]):gsub('"', '')
        elseif info[1] == "VERSION" then
            version = string.trim(info[2]):gsub('"', '')
        end
    end

    return name .. " " .. version
end

function info.cpu()
    local name, cores, clock
    -- the lines looks like model name  : AMD RYZEN FX 9600 OCTA CORE

    for line in io.lines("/proc/cpuinfo") do
        if line:match("^%s*$") then
            break
        elseif line:find("model name") then
            name = string.trim(string.split(line, ":")[2])
        elseif line:find("siblings") then
            cores = string.trim(string.split(line, ":")[2])
        elseif line:find("cpu MHz") then
            clock = string.trim(string.split(line, ":")[2])
        end
    end

    return name .. " (" .. cores .. ") " .. "@ " .. clock .. "MHz"
end

function info.shell()
    local shell = string.split(os.getenv("SHELL"), '/')
    return shell[#shell]
end

function info.kernel()
    -- from https://github.com/Rosettea/bunnyfetch/blob/master/cmd/info_linux.go
    -- /proc/version should always exist on linux
    local procver = read_file("/proc/version")

    --  /proc/version has the same format with "Linux version <kern-version>" as the 3rd
    local s = "" .. string.split(procver, " ")[3]
    return s:gsub("%-(.*)", "")
end

function info.uptime()
    local uptime = os.capture('uptime -p')
    return uptime:gsub("\n", ""):gsub("up ", "")
end

function info.memory()
    local total, available = "", ""

    for line in io.lines("/proc/meminfo") do
        if line:find("MemTotal") then
            total = string.trim(string.split(line, ":")[2]:gsub("[a-zA-Z]", ""))
        elseif line:find("MemAvailable") then
            available = string.trim(string.split(line, ":")[2]:gsub("[a-zA-Z]", ""))
            print(available)
        end
    end
    -- local t_str
    --
    local colors = require("colors")
    local status = ((total - available) / total) > 0.5 and "orange" or "blue"
    return string.format("%.2f Gb / %.2f Gb (%s%.0f%%%s)",
        ((total - available) / (1 * 10 ^ 6)),
        (total / (1 * 10 ^ 6)),
        colors[status],
        ((total - available) / total) * 100,
        colors.reset)
end

function info.swap()
    local total, available = "", ""

    for line in io.lines("/proc/meminfo") do
        if line:find("SwapTotal") then
            total = string.trim(string.split(line, ":")[2]:gsub("[a-zA-Z]", ""))
        elseif line:find("SwapFree") then
            available = string.trim(string.split(line, ":")[2]:gsub("[a-zA-Z]", ""))
        end
    end
    -- local t_str
    --
    local colors = require("colors")
    local used = total - available
    local status = (used / total) > 0.5 and "orange" or "blue"
    return string.format("%.2f Gb / %.2f Gb (%s%.0f%%%s)",
        (used / (1 * 10 ^ 6)),
        (total / (1 * 10 ^ 6)),
        colors[status],
        (used / total) * 100,
        colors.reset)
end

function info.user()
    local user = os.capture("whoami")
    return string.trim(user)
end

function info.hostname()
    local host = read_file("/etc/hostname")
    return string.trim(host)
end

function info.title()
    return info.user() .. "@" .. info.hostname()
end

function info.infosep()
    return string.rep("~", #info.title())
end

return info
