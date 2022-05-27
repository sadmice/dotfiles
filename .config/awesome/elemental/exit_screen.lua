local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local helpers = require("helpers")

local icon_font = "bold 45"
local poweroff_text_icon = ""
local reboot_text_icon = ""
local suspend_text_icon = ""
local exit_text_icon = "﫼"
local lock_text_icon = ""

local button_bg = beautiful.exit_screen_button_bg
local button_size = dpi(120)

-- Commands
local poweroff_command = function()
    awful.spawn.with_shell("poweroff")
end
local reboot_command = function()
    awful.spawn.with_shell("reboot")
end
local suspend_command = function()
    lock_screen_show()
    awful.spawn.with_shell("systemctl suspend")
end
local exit_command = function()
    awesome.quit()
end
local lock_command = function()
    lock_screen_show()
end

-- Helper function that generates the clickable buttons
local create_button = function(symbol, hover_color, command)
    local icon = wibox.widget {
        forced_height = button_size,
        forced_width = button_size,
        align = "center",
        valign = "center",
        font = icon_font,
        text = symbol,
        widget = wibox.widget.textbox()
    }

    local button = wibox.widget {
        {
            nil,
            icon,
            expand = "none",
            layout = wibox.layout.align.horizontal
        },
        forced_height = button_size,
        forced_width = button_size,
        border_width = dpi(8),
        border_color = button_bg,
        shape = helpers.rrect(beautiful.exit_screen_button_border_radius),
        bg = button_bg,
        widget = wibox.container.background
    }

    -- Bind left click to run the command
    button:buttons(gears.table.join(
        awful.button({ }, 1, function ()
            command()
        end)
    ))

    -- Change color on hover
    button:connect_signal("mouse::enter", function ()
        icon.markup = helpers.colorize_text(icon.text, hover_color)
        button.border_color = hover_color
    end)
    button:connect_signal("mouse::leave", function ()
        icon.markup = helpers.colorize_text(icon.text, x.foreground)
        button.border_color = button_bg
    end)

    -- Use helper function to change the cursor on hover
    helpers.add_hover_cursor(button, "hand1")

    return button
end

-- Create the buttons
local poweroff = create_button(poweroff_text_icon, x.color1, poweroff_command)
local reboot = create_button(reboot_text_icon, x.color2, reboot_command)
local suspend = create_button(suspend_text_icon, x.color3, suspend_command)
local exit = create_button(exit_text_icon, x.color4, exit_command)
local lock = create_button(lock_text_icon, x.color5, lock_command)

-- Create the exit screen wibox
exit_screen = wibox({visible = false, ontop = true, type = "dock", screen = screen.primary})
awful.placement.maximize(exit_screen)

exit_screen.bg = beautiful.exit_screen_bg
exit_screen.fg = beautiful.exit_screen_fg

-- Add exit screen or mask to each screen
awful.screen.connect_for_each_screen(function(s)
    if s == screen.primary then
        s.exit_screen = exit_screen
    else
        s.exit_screen = helpers.screen_mask(s, beautiful.exit_screen_bg)
    end
end)

local function set_visibility(v)
    for s in screen do
        s.exit_screen.visible = v
    end
end

local exit_screen_grabber
function exit_screen_hide()
    awful.keygrabber.stop(exit_screen_grabber)
    set_visibility(false)
end

local keybinds = {
    ['escape'] = exit_screen_hide,
    ['q'] = exit_screen_hide,
    ['x'] = exit_screen_hide,
    ['s'] = function () suspend_command(); exit_screen_hide() end,
    ['e'] = exit_command,
    ['p'] = poweroff_command,
    ['r'] = reboot_command,
    ['l'] = function ()
        lock_command()
        -- Kinda fixes the "white" (undimmed) flash that appears between
        -- exit screen disappearing and lock screen appearing
        gears.timer.delayed_call(function()
            exit_screen_hide()
        end)
    end
}

function exit_screen_show()
    exit_screen_grabber = awful.keygrabber.run(function(_, key, event)
        -- Ignore case
        key = key:lower()

        if event == "release" then return end

        if keybinds[key] then
            keybinds[key]()
        end
    end)
    set_visibility(true)
end

exit_screen:buttons(gears.table.join(
    -- Left click - Hide exit_screen
    awful.button({ }, 1, function ()
        exit_screen_hide()
    end),
    -- Middle click - Hide exit_screen
    awful.button({ }, 2, function ()
        exit_screen_hide()
    end),
    -- Right click - Hide exit_screen
    awful.button({ }, 3, function ()
        exit_screen_hide()
    end)
))

-- Item placement
exit_screen:setup {
    nil,
    {
        nil,
        {
            poweroff,
            reboot,
            suspend,
            exit,
            lock,
            spacing = dpi(50),
            layout = wibox.layout.fixed.horizontal
        },
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    expand = "none",
    layout = wibox.layout.align.vertical
}
