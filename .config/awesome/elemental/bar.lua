local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local apps = require("apps")

local keys = require("keys")
local helpers = require("helpers")

-- Helper function that creates a button widget
local create_button = function (symbol, color, bg_color, hover_color)
    local widget = wibox.widget {
        font = "15",
        align = "center",
        id = "text_role",
        valign = "center",
        markup = helpers.colorize_text(symbol, color),
        widget = wibox.widget.textbox()
    }

    local section = wibox.widget {
        widget,
        forced_width = dpi(70),
        bg = bg_color,
        widget = wibox.container.background
    }

    -- Hover animation
    section:connect_signal("mouse::enter", function ()
        section.bg = hover_color
    end)
    section:connect_signal("mouse::leave", function ()
        section.bg = bg_color
    end)

    helpers.add_hover_cursor(section, "hand1")

    return section
end

local exit = create_button("﫼", x.color5, x.background, x.color8.."30")
exit:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        exit_screen_show()
    end)
))

local dashboard = create_button("", x.color5, x.background, x.color8.."30")
dashboard:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        dashboard_show()
    end)
))

local keyboard_layout = require("noodle.keyboard_layout")

awful.screen.connect_for_each_screen(function(s)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = keys.taglist_buttons,
    }

    -- Create a tasklist for every screen
    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = keys.tasklist_buttons,
        style    = {
            font = beautiful.tasklist_font,
        },
        layout   = {
            layout  = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    id     = 'text_role',
                    align  = "center",
                    widget = wibox.widget.textbox,
                },
                forced_width = dpi(220),
                left = dpi(15),
                right = dpi(15),
                -- Add margins to top and bottom in order to force the
                -- text to be on a single line, if needed. Might need
                -- to adjust them according to font size.
                top  = dpi(4),
                bottom = dpi(4),
                widget = wibox.container.margin
            },
            id = "bg_role",
            widget = wibox.container.background,
        },
    }

    -- Create the wibox
    s.mywibox = awful.wibar({screen = s, visible = true, ontop = true, type = "dock", position = beautiful.wibar_position})
    s.mywibox.height = beautiful.wibar_height
    s.mywibox.bg = beautiful.wibar_bg

    -- Bar placement
    awful.placement.maximize_horizontally(s.mywibox)

    -- Wibar items
    -- Add or remove widgets here
    s.mywibox:setup {
        {
            dashboard,
            s.mytaglist,
            layout = wibox.layout.fixed.horizontal
        },
            s.mytasklist,
        {
            keyboard_layout,
            exit,
            layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal
    }

end)

-- We have set the wibar(s) to be ontop, but we do not want it to be above fullscreen clients
local function no_wibar_ontop(c)
    local s = awful.screen.focused()
    if c.fullscreen then
        s.mywibox.ontop = false
    else
        s.mywibox.ontop = true
    end
end

client.connect_signal("focus", no_wibar_ontop)
client.connect_signal("unfocus", no_wibar_ontop)
client.connect_signal("property::fullscreen", no_wibar_ontop)

-- Every bar theme should provide these fuctions
function wibars_toggle()
    local s = awful.screen.focused()
    s.mywibox.visible = not s.mywibox.visible
end