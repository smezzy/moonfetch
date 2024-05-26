local colors = require("colors")

local flags = {
    trans = {
        "\27[38;5;74m",  -- blue
        "\27[38;5;211m", -- pink
        "\27[38;5;15m",  -- white
        "\27[38;5;211m", -- pink
        "\27[38;5;74m",  -- blue
    },
    lgbt = {
        "\27[38;5;160m", -- vermelho
        "\27[38;5;202m", -- orange
        "\27[38;5;220m", -- yellow
        "\27[38;5;28m",  -- green
        "\27[38;5;20m",  -- blue
        "\27[38;5;125m", -- purple
    },
    bissexual = {
        "\27[38;5;161m", -- neon pink
        "\27[38;5;161m", -- neon pink
        "\27[38;5;165m", -- purple
        "\27[38;5;20m",  -- dark blue
        "\27[38;5;20m",  -- dark blue
    },
    gay = {
        "\27[38;5;40m",  -- darker green
        "\27[38;5;35m",  -- dark green
        "\27[38;5;36m",  -- bright green
        "\27[38;5;231m", -- white
        "\27[38;5;80m",  -- bright blue
        "\27[38;5;33m",  -- dark blue
        "\27[38;5;16m",  -- black
    },
    lesbian = {
        "\27[38;5;196m", -- dark red
        "\27[38;5;209m", -- bright red
        "\27[38;5;230m", -- white
        "\27[38;5;168m", -- bright pink
        "\27[38;5;198m", -- dark pink
    },
    pan = {
        "\27[38;5;197m", -- pink
        "\27[38;5;226m", -- yellow
        "\27[38;5;33m",  -- blue
    },
    assexual = {
        "\27[38;5;16m",  -- black
        "\27[38;5;243m", -- gray
        "\27[38;5;15m",  -- white
        "\27[38;5;90m",  -- purple
    },
    agender = {
        "\27[38;5;16m",  -- black
        "\27[38;5;243m", -- gray
        "\27[38;5;15m",  -- white
        "\27[38;5;118m", -- green
        "\27[38;5;15m",  -- white
        "\27[38;5;243m", -- gray
        "\27[38;5;16m",  -- black
    },
    aromantic = {
        "\27[38;5;16m",  -- black
        "\27[38;5;243m", -- gray
        "\27[38;5;15m",  -- white
        "\27[38;5;76m",  -- bright green
        "\27[38;5;34m",  -- dark green
    },
    polyamorous = {
        "\27[38;5;16m",  -- black
        "\27[38;5;124m", -- red
        "\27[38;5;17m",  -- blue
    },
}

return flags
