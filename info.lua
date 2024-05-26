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
