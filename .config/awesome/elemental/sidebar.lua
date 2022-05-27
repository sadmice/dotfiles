local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local apps = require("apps")

local helpers = require("helpers")

-- Helper function that changes the appearance of progress bars and their icons
local function format_progress_bar(bar)
    -- Since we will rotate the bars 90 degrees, width and height are reversed
    bar.forced_width = dpi(70)
    bar.forced_height = dpi(30)
    bar.shape = gears.shape.rounded_bar
    bar.bar_shape = gears.shape.rectangle
    local w = wibox.widget{
        bar,
        direction = 'east',
        layout = wibox.container.rotate,
    }
    return w
end


local spotify = require("noodle.spotify.spotify")

local temperature_bar = require("noodle.temperature_bar")
local temperature = format_progress_bar(temperature_bar)
temperature:buttons(
    gears.table.join(
        awful.button({ }, 1, apps.temperature_monitor)
))

local cpu_bar = require("noodle.cpu_bar")
local cpu = format_progress_bar(cpu_bar)

cpu:buttons(
    gears.table.join(
        awful.button({ }, 1, apps.process_monitor),
        awful.button({ }, 3, apps.process_monitor_gui)
))

local ram_bar = require("noodle.ram_bar")
local ram = format_progress_bar(ram_bar)

ram:buttons(
    gears.table.join(
        awful.button({ }, 1, apps.process_monitor),
        awful.button({ }, 3, apps.process_monitor_gui)
))

local hours = wibox.widget.textclock("%H")
local minutes = wibox.widget.textclock("%M")

local make_little_dot = function (color)
    return wibox.widget{
        bg = color,
        forced_width = dpi(10),
        forced_height = dpi(10),
        shape = helpers.rrect(dpi(2)),
        widget = wibox.container.background
    }
end

local time = {
    {
        font = "Fira Sans Ultra-Bold 44",
        align = "right",
        valign = "top",
        widget = hours
    },
    {
        nil,
        {
            make_little_dot(x.color1),
            make_little_dot(x.color4),
            make_little_dot(x.color5),
            spacing = dpi(8),
            widget = wibox.layout.fixed.vertical
        },
        expand = "none",
        widget = wibox.layout.align.vertical
    },
    {
        font = "Fira Sans Ultra-Bold 44",
        align = "left",
        valign = "top",
        widget = minutes
    },
    spacing = dpi(15),
    layout = wibox.layout.fixed.horizontal
}

-- Day of the week
local dotw = require("noodle.day_of_the_week")
local day_of_the_week = wibox.widget {
    nil,
    dotw,
    expand = "none",
    layout = wibox.layout.align.horizontal
}

local volume_bar = require("noodle.volume_bar")
local volume = format_progress_bar(volume_bar)

volume:buttons(gears.table.join(
    -- Left click - Mute / Unmute
    awful.button({ }, 1, function ()
        helpers.volume_control(0)
    end),
    -- Scroll - Increase / Decrease volume
    awful.button({ }, 4, function () 
        helpers.volume_control(2)
    end),
    awful.button({ }, 5, function () 
        helpers.volume_control(-2)
    end)
))

-- Create tooltip widget
-- It should change depending on what the user is hovering over
local adaptive_tooltip = wibox.widget {
    visible = false,
    top_only = true,
    layout = wibox.layout.stack
}

-- Create tooltip for widget w
local tooltip_counter = 0
local create_tooltip = function(w)
    local tooltip = wibox.widget {
        font = "Fira Sans medium 8",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    tooltip_counter = tooltip_counter + 1
    local index = tooltip_counter

    adaptive_tooltip:insert(index, tooltip)

    w:connect_signal("mouse::enter", function()
        -- Raise tooltip to the top of the stack
        adaptive_tooltip:set(1, tooltip)
        adaptive_tooltip.visible = true
    end)
    w:connect_signal("mouse::leave", function ()
        adaptive_tooltip.visible = false
    end)

    return tooltip
end

local cpu_tooltip = create_tooltip(cpu_bar)
awesome.connect_signal("evil::cpu", function(value)
    cpu_tooltip.markup = "You are using <span foreground='" .. beautiful.cpu_bar_active_color .."'><b>" .. tostring(value) .. "%</b></span> of CPU"
end)

local ram_tooltip = create_tooltip(ram_bar)
awesome.connect_signal("evil::ram", function(value, _)
    ram_tooltip.markup = "You are using <span foreground='" .. beautiful.ram_bar_active_color .."'><b>" .. string.format("%.1f", value / 1000) .. "G</b></span> of memory"
end)

local volume_tooltip = create_tooltip(volume_bar)
awesome.connect_signal("evil::volume", function(value, muted)
    volume_tooltip.markup = "The volume is at <span foreground='" .. beautiful.volume_bar_active_color .."'><b>" .. tostring(value) .. "%</b></span>"
    if muted then
        volume_tooltip.markup = volume_tooltip.markup.." and <span foreground='" .. beautiful.volume_bar_active_color .."'><b>muted</b></span>"
    end
end)

local temperature_tooltip = create_tooltip(temperature_bar)
awesome.connect_signal("evil::temperature", function(value)
    temperature_tooltip.markup = "Your CPU temperature is at <span foreground='" .. beautiful.temperature_bar_active_color .."'><b>" .. tostring(value) .. "°C</b></span>"
end)

-- Add clickable mouse effects on some widgets
helpers.add_hover_cursor(cpu, "hand1")
helpers.add_hover_cursor(ram, "hand1")
helpers.add_hover_cursor(temperature, "hand1")
helpers.add_hover_cursor(volume, "hand1")


-- Create the sidebar
sidebar = wibox({visible = false, ontop = true, type = "dock", screen = screen.primary})
sidebar.bg = "#00000000" -- For anti aliasing
sidebar.fg = beautiful.sidebar_fg
sidebar.opacity = beautiful.sidebar_opacity
sidebar.height = screen.primary.geometry.height / 1.5
sidebar.width = beautiful.sidebar_width
sidebar.y = beautiful.sidebar_y0
local radius = beautiful.sidebar_border_radius
if beautiful.sidebar_position == "right" then
    awful.placement.right(sidebar)
else
    awful.placement.left(sidebar)
end

sidebar:buttons(gears.table.join(
    -- Middle click - Hide sidebar
    awful.button({ }, 2, function ()
        sidebar_hide()
    end)
))

sidebar_show = function()
    sidebar.visible = true
end

sidebar_hide = function()
    sidebar.visible = false
end

-- Hide sidebar when mouse leaves
if user.sidebar.hide_on_mouse_leave then
    sidebar:connect_signal("mouse::leave", function ()
        sidebar_hide()
    end)
end
-- Activate sidebar by moving the mouse at the edge of the screen
if user.sidebar.show_on_mouse_screen_edge then
    local sidebar_activator = wibox({y = sidebar.y, width = 1, visible = true, ontop = false, opacity = 0, below = true, screen = screen.primary})
    sidebar_activator.height = sidebar.height
    sidebar_activator:connect_signal("mouse::enter", function ()
        sidebar_show()
    end)

    if beautiful.sidebar_position == "right" then
        awful.placement.right(sidebar_activator)
    else
        awful.placement.left(sidebar_activator)
    end

    sidebar_activator:buttons(
        gears.table.join(
            awful.button({ }, 4, function ()
                awful.tag.viewprev()
            end),
            awful.button({ }, 5, function ()
                awful.tag.viewnext()
            end)
    ))
end


-- Item placement
sidebar:setup {
    {
        {
            {
                helpers.vertical_pad(dpi(30)),
                {
                    nil,
                    {
                        time,
                        spacing = dpi(12),
                        layout = wibox.layout.fixed.horizontal
                    },
                    expand = "none",
                    layout = wibox.layout.align.horizontal
                },
                helpers.vertical_pad(dpi(20)),
                day_of_the_week,
                helpers.vertical_pad(dpi(30)),
                layout = wibox.layout.fixed.vertical
            },
            layout = wibox.layout.fixed.vertical
        },
        {
            {
                helpers.vertical_pad(dpi(30)),
                {
                    {
                        spotify,
                        layout = wibox.layout.fixed.vertical
                    },
                    bottom = dpi(180),
                    left = dpi(30),
                    right = dpi(30),
                    widget = wibox.container.margin
                },
                {
                    nil,
                    {
                        volume,
                        cpu,
                        temperature,
                        ram,
                        spacing = dpi(5),
                        layout = wibox.layout.fixed.horizontal
                    },
                    expand = "none",
                    layout = wibox.layout.align.horizontal
                },
                helpers.vertical_pad(dpi(10)),
                adaptive_tooltip,  
                layout = wibox.layout.fixed.vertical
            },
            shape = helpers.prrect(beautiful.sidebar_border_radius, true, false, false, true),
            bg = x.color0.."66",
            widget = wibox.container.background
        },
        layout = wibox.layout.align.vertical,
    },
    shape = helpers.prrect(beautiful.sidebar_border_radius, true, false, false, true),
    bg = beautiful.sidebar_bg,
    widget = wibox.container.background
}
