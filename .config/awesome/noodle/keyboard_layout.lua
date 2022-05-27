local wibox = require("wibox")

local helpers = require("helpers")

kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
kbdcfg.layout = { { "us", "" }, { "ru", "" } }
kbdcfg.current = 1  -- us is our default layout
kbdcfg.widget = wibox.widget {
        id = "text_role",
        font = "Fira Sans Medium 10",
        markup = helpers.colorize_text(" " .. kbdcfg.layout[kbdcfg.current][1] .. " ", x.color8),
        widget = wibox.widget.textbox()
    }
kbdcfg.switch = function ()
  kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
  local t = kbdcfg.layout[kbdcfg.current]
  kbdcfg.widget.markup = helpers.colorize_text(" " .. kbdcfg.layout[kbdcfg.current][1] .. " ", x.color8)
  os.execute( kbdcfg.cmd .. " " .. t[1] .. " " .. t[2] )
end

return kbdcfg.widget