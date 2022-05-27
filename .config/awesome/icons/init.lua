local icons = {}
icons.text = {}


-- Set up text symbols and accent colors to be used in tasklists or docks
-- instead of awful.widget.clienticon
-- Based on the client's `class` property
icons.text.by_class = {
    ['kitty'] = { symbol = "", color = x.color5 },
    ['feh'] = { symbol = "", color = x.color1 },
    ['TelegramDesktop'] = { symbol = "", color = x.color4 },
    ['firefox'] = { symbol = "", color = x.color3 },
    ['Steam'] = { symbol = "", color = x.color4 },
    ['Spotify'] = { symbol = "", color = x.color2 },
    ['Sublime_text'] = { symbol = "", color = x.color3 },
    ['email'] = { symbol = "", color = x.color6 },
    ['Bitwarden'] = { symbol = "", color = x.color4 },
    ['htop'] = { symbol = "", color = x.color1 },
    ['Wine'] = { symbol = "", color = x.color1 },
    ['Discord'] = { symbol = "", color = x.color5 },
    ['libreoffice-writer'] = { symbol = "", color = x.color4 },
    ['libreoffice-calc'] = { symbol = "", color = x.color2 },
    ['libreoffice-impress'] = { symbol = "", color = x.color1 },
    ['Nemo'] = { symbol = "", color = x.color4 },
    ['Gimp'] = { symbol = "", color = x.color8 },

    -- Default
    ['_'] = { symbol = "", color = x.color7.."99" }
}

return icons
