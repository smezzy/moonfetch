-- local cpu = os.capture("cat /proc/cpuinfo | grep 'model name' | uniq | awk -F: '{print $2}' | sed 's/^[ \t]*//'")
-- local user = os.capture("whoami") .. "@" .. os.capture("cat /etc/hostname")
local info = require("info")
local colors = require("colors")
local flags = require("flags")
local logos = require("logos")

mfetch = {
    config = {
        default = {
            sep = " > ",
            logo = "flag",
            flag = "lgbt",
        }
    }
}

function mfetch.generateConfig(cfg)
    local str = "return { "
    for k, v in pairs(cfg) do
        str = str .. k .. " = " .. '"' .. v .. '"' .. ", "
    end
    str = str .. " }"

    local handle = io.open("config.lua", "w")
    handle:write(str)
    handle:close()
end

function mfetch.getConfig(name)
    return mfetch.config.user[name]
end

function mfetch.loadConfig()
    local user_cfg = require("config")

    mfetch.config.user = {}

    for k, v in pairs(mfetch.config.default) do
        mfetch.config.user[k] = v
    end


    for k, v in pairs(user_cfg) do
        mfetch.config.user[k] = v
    end
end

function mfetch.setup()
    local cfg = {}

    io.write("What are your colours?\n")
    io.write(
        "[Trans], [Lgbt], [Bissexual], [Gay], [Lesbian], [Assexual], [Pan], [Aromantic], [Agender], [Polyamorous]\n > ")
    io.flush()
    local input = io.read():lower()
    while (flags[input] == nil) do
        io.write("Sorry, we dont have that flag yet! Please try again.\n")
        io.flush()
        input = io.read()
    end
    cfg.flag = input

    mfetch.generateConfig(cfg)
    io.write("\n\n")
end

function mfetch.fetch()
    if arg[1] == "--configure" or arg[1] == "-c" or not pcall(require, "config") then
        mfetch.setup()
    end

    mfetch.loadConfig()

    local logo = logos[mfetch.getConfig("logo")]
    local flag = flags[mfetch.getConfig("flag")]

    local infos = {}
    for k, _ in pairs(info) do
        infos[k] = function(name, color)
            color = color or colors.blue
            if name then
                return colors.bold ..
                    color .. name .. colors.reset .. mfetch.getConfig("sep") .. info[k]() .. colors.reset
            else
                return colors.bold .. color .. info[k]() .. colors.reset
            end
        end
    end

    local lines = {
        infos.title(nil, mfetch.getConfig("titleColor")),
        infos.infosep(nil, colors.reset),
        infos.os("OS"),
        infos.cpu("Processor"),
        infos.kernel("Kernel"),
        infos.shell("Shell"),
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

    io.write(colors.reset)
    io.flush()
end

mfetch.fetch()
