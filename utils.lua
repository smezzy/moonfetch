function os.capture(cmd, raw)
    local handle = io.popen(cmd, 'r')
    local output = assert(handle:read('*a'))

    handle:close()

    if raw then
        return output
    end

    output = string.gsub(
        string.gsub(
            string.gsub(output, '^%s+', ''),
            '%s+$',
            ''
        ),
        '[\n\r]+',
        ' '
    )

    return output
end

-- trim 6 from http://lua-users.org/wiki/StringTrim
function string.trim(s)
    return s:match '^()%s*$' and '' or s:match '^%s*(.*%S)'
end

function string.split(s, sep)
    local t = {}
    for str in string.gmatch(s, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function math.round(num)
    return num + (2 ^ 52 + 2 ^ 51) - (2 ^ 52 + 2 ^ 51)
end

function read_file(file)
    local handle = assert(io.open(file, 'r'))
    local data = handle:read("*all")
    handle:close()
    return data
end
