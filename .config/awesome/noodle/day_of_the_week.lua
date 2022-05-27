local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Create invisible dummy clock that actually updates in order to
-- connect to its redraw_needed signal
local dummy_textclock = wibox.widget.textclock("%M")
dummy_textclock.visible = false

local dotw_initials = {"M", "T", "W", "T", "F", "S", "S"}

local dotw_textboxes = {}

local create_dotw_container = function (text, color)
    local text = wibox.widget.textbox(text)
    text.font = "Fira Sans Bold 9"
    text.align = "center"
    text.valign = "center"
    table.insert(dotw_textboxes, text)

    local container = wibox.widget {
        text,
        forced_height = dpi(25),
        forced_width = dpi(25),
        shape = gears.shape.circle,
        widget = wibox.container.background()
    }

    return container
end

local dotw_containers = {}
for i=1,7 do
    table.insert(dotw_containers, create_dotw_container(dotw_initials[i]))
end

local day_of_the_week = wibox.widget {
    nil,
    {
        dummy_textclock,
        dotw_containers[1],
        dotw_containers[2],
        dotw_containers[3],
        dotw_containers[4],
        dotw_containers[5],
        dotw_containers[6],
        dotw_containers[7],
        spacing = dpi(4),
        layout = wibox.layout.fixed.horizontal
    },
    expand = "none",
    layout = wibox.layout.align.horizontal
}

local update_dotw = function ()
    awful.spawn.easy_async_with_shell("date +%u", function (out)
        local index = tonumber(out)
        for i=1,7 do
            dotw_containers[i].bg = "#00000000"
        end

        dotw_containers[index].bg = x.color5.."99"
    end)
end

-- Initialize
update_dotw()

-- Update every time the dummy clock updates since the "+%u" textclock does not
-- update on its own for some reason
dummy_textclock:connect_signal("widget::redraw_needed", function () 
    update_dotw()
end)

return day_of_the_week
