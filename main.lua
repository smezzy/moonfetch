local colors = require("colors")
local setup = require("info")

local mfetch = {
    default_config = {
        margin = 3,
        sep = " > ",
        color = colors.blue,
        flag = "lgbt",
        art = "arch",
    },
    info = {}
}

function mfetch.addInfo(name, cb)
    mfetch.info[name] = cb
end

function mfetch.getInfo(name)
    return mfetch.info[name]()
end

function mfetch.fetch()
    local logo = require("logos")[mfetch.config.art]
    local flag = require("flags")[mfetch.config.flag]

    local lines = {
        mfetch.getInfo("title"),
        mfetch.getInfo("infosep"),
        mfetch.getInfo("os"),
        mfetch.getInfo("cpu"),
        mfetch.getInfo("kernel"),
        mfetch.getInfo("shell"),
    }

    local widest = 0
    local margin = 3

    local line_count = 0

    for line in logo:gmatch("([^\n]*)\n?") do
        if #line > widest then
            widest = #line
        end
        line_count = line_count + 1
    end

    -- this loop is kind bad.. but ok
    local i = 1
    local div = math.round(line_count / #flag)
    local d = 0
    local j = 1

    for line in logo:gmatch("([^\n]*)\n?") do
        if line ~= "" then
            local padding = (widest - #line) + margin
            -- Process each line (if not empty)
            io.write(flag[d + 1] .. line)

            if (i <= #lines) then
                for i = 1, padding do
                    io.write(" ")
                end
                io.write(lines[i])
            end
            io.write("\n")

            if (j % div) == 0 then
                d = ((d + 1) % #flag)
            end

            i = i + 1
            j = j + 1
        end
    end

    -- print the rest if its missing lol i will do something better later..
    for j = i, #lines do
        local padding = widest + margin
        for i = 1, padding do
            io.write(" ")
        end
        io.write(lines[j])
        io.write("\n")
        j = j + 1
    end
end

mfetch.addInfo('colors', function()
    local r = '\27[49m'
    local result = { '', '' }

    for i = 0, 7 do
        result[1] = result[1] .. '\27[4' .. i .. 'm   '
    end

    result[1] = result[1] .. r

    for i = 0, 7 do
        result[2] = result[2] .. '\27[10' .. i .. 'm   '
    end

    result[2] = result[2] .. r

    return result
end)

mfetch.addInfo("os", function()
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
end)

mfetch.addInfo("cpu", function()
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

    return name .. " (" .. cores .. ") " .. "@ " .. clock .. " MHz"
end)

mfetch.addInfo("shell", function()
    local shell = string.split(os.getenv("SHELL"), '/')
    return shell[#shell]
end)

mfetch.addInfo("kernel", function()
    -- from https://github.com/Rosettea/bunnyfetch/blob/master/cmd/info_linux.go
    -- /proc/version should always exist on linux
    local procver = read_file("/proc/version")

    --  /proc/version has the same format with "Linux version <kern-version>" as the 3rd
    return string.split(procver, " ")[3]
end)

mfetch.addInfo("title", function()
    local user = os.capture("whoami")
    local host = read_file("/etc/hostname")
    return colors.blue .. user .. colors.reset .. "@" .. colors.blue .. host
end)

mfetch.addInfo("infosep", function()
    local title = mfetch.getInfo("title")
    return string.rep('~', #title + 1)
end)



mfetch.fetch()
