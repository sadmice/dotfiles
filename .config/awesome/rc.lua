------------------------------
--      User variables      --
------------------------------
user = {
    -- Default applications
    terminal = "kitty -1",
    floating_terminal = "kitty -1",
    browser = "firefox",
    file_manager = "nemo",
    editor = "subl",
    email_client = "kitty -1 --class email -e neomutt",
    music_client = "spotify",

    -- User profile picture
    profile_picture = os.getenv("HOME").."/.config/awesome/profile.png",

    -- Directories
    dirs = {
        downloads = os.getenv("XDG_DOWNLOAD_DIR") or "~/Downloads",
        documents = os.getenv("XDG_DOCUMENTS_DIR") or "~/Documents",
        pictures = os.getenv("XDG_PICTURES_DIR") or "~/Images",
        config = "~/.config",
        -- Make sure the directory exists so that your screenshots
        -- are not lost
        screenshots = os.getenv("XDG_SCREENSHOTS_DIR") or "~/Images/Screenshots",
    },

    -- Sidebar
    sidebar = {
        hide_on_mouse_leave = true,
        show_on_mouse_screen_edge = true,
    },

    -- Lock screen
    -- This password will ONLY be used if you have not installed
    -- https://github.com/RMTT/lua-pam
    -- Leave it empty in order to unlock with just the Enter key.
    -- lock_screen_custom_password = "",
    lock_screen_custom_password = "awesome",
}

------------------------------
--      Initialization      --
------------------------------
-- Theme handling library
local beautiful = require("beautiful")
local xrdb = beautiful.xresources.get_current_theme()
-- Make dpi function global
dpi = beautiful.xresources.apply_dpi
-- Make xresources colors global
x = {
    --           xrdb variable
    background = xrdb.background,
    foreground = xrdb.foreground,
    color0     = xrdb.color0,
    color1     = xrdb.color1,
    color2     = xrdb.color2,
    color3     = xrdb.color3,
    color4     = xrdb.color4,
    color5     = xrdb.color5,
    color6     = xrdb.color6,
    color7     = xrdb.color7,
    color8     = xrdb.color8,
    color9     = xrdb.color9,
    color10    = xrdb.color10,
    color11    = xrdb.color11,
    color12    = xrdb.color12,
    color13    = xrdb.color13,
    color14    = xrdb.color14,
    color15    = xrdb.color15,
}

-- Load AwesomeWM libraries
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Default notification library
local naughty = require("naughty")

-- Load theme
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme/theme.lua")

-- Error handling
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)

-- Keybinds and mousebinds
local keys = require("keys")
-- Load notification daemons and notification theme
local notifications = require("notifications")
notifications.init()
-- Load window decorations
local decorations = require("decorations")
decorations.init()
-- Load helper functions
local helpers = require("helpers")

-- Statusbar(s)
require("elemental.bar")
-- Exit screen
require("elemental.exit_screen")
-- Sidebar
require("elemental.sidebar")
-- Dashboard
require("elemental.dashboard")
-- Lock screen
local lock_screen = require("elemental.lock_screen")
lock_screen.init()
-- Window switcher
require("elemental.window_switcher")

-- Most widgets that display system/external info depend on evil.
-- Make sure to initialize it last in order to allow all widgets to connect to
-- their needed evil signals.
require("evil")

-----------------------
--      Layouts      --
-----------------------
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
}

-------------------------
--      Wallpaper      --
-------------------------
local function set_wallpaper(s)
    if beautiful.wallpaper then
        -- local wallpaper = beautiful.wallpaper
        -- -- If wallpaper is a function, call it with the screen
        -- if type(wallpaper) == "function" then
        --     wallpaper = wallpaper(s)
        -- end

        -- >> Method 1: Built in wallpaper function
        -- gears.wallpaper.fit(wallpaper, s, true)
        -- gears.wallpaper.maximized(wallpaper, s, true)

        -- >> Method 2: Set theme's wallpaper with feh
        --awful.spawn.with_shell("feh --bg-fill " .. wallpaper)

        -- >> Method 3: Set last wallpaper with feh
        awful.spawn.with_shell(os.getenv("HOME") .. "/.fehbg")
    end
end

-- Set wallpaper
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
end)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

--------------------
--      Tags      --
--------------------
awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    local l = awful.layout.suit
    -- Tag layouts
    local layouts = {
        l.max,
        l.tile,
        l.max,
        l.max,
        l.max,
        l.max,
        l.max,
        l.max,
        l.max,
        l.max
    }

    -- Tag names
    local tagnames = beautiful.tagnames or { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }
    -- Create all tags at once (without seperate configuration for each tag)
    awful.tag(tagnames, s, layouts)

    -- Create tags with seperate configuration for each tag
    -- awful.tag.add(tagnames[1], {
    --     layout = layouts[1],
    --     screen = s,
    --     master_width_factor = 0.6,
    --     selected = true,
    -- })
    -- ...
end)

-- Determines how floating clients should be placed
local floating_client_placement = function(c)
    -- If the layout is floating or there are no other visible
    -- clients, center client
    if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating or #mouse.screen.clients == 1 then
        return awful.placement.centered(c,{honor_padding = true, honor_workarea=true})
    end

    -- Else use this placement
    local p = awful.placement.no_overlap + awful.placement.no_offscreen
    return p(c, {honor_padding = true, honor_workarea=true, margins = beautiful.useless_gap * 2})
end

local centered_client_placement = function(c)
    return gears.timer.delayed_call(function ()
        awful.placement.centered(c, {honor_padding = true, honor_workarea=true})
    end)
end

---------------------
--      Rules      --
---------------------
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    {
        -- All clients will match this rule.
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keys.clientkeys,
            buttons = keys.clientbuttons,
            screen = awful.screen.focused,
            size_hints_honor = false,
            honor_workarea = true,
            honor_padding = true,
            maximized = false,
            titlebars_enabled = beautiful.titlebars_enabled,
            maximized_horizontal = false,
            maximized_vertical = false,
            placement = floating_client_placement
        },
    },

    -- Floating clients
    {
        rule_any = {
            instance = {
                "floating_terminal",
                "Devtools",
            },
            class = {
                "Lxappearance",
                "File-roller",
                "Nvidia-settings",
            },
            role = {
                "AlarmWindow",
                "pop-up",
                "GtkFileChooserDialog",
                "conversation",
            },
            type = {
                "dialog",
            }
        },
        properties = { floating = true }
    },

    -- Centered clients
    {
        rule_any = {
            type = {
                "dialog",
            },
            class = {
                "Steam",
                "discord",
                "music",
            },
            instance = {
                "music",
            },
            role = {
                "GtkFileChooserDialog",
                "conversation",
            }
        },
        properties = { placement = centered_client_placement },
    },

    -- Titlebars OFF (explicitly)
    {
        rule_any = {
            class = {
                "discord",
                "TelegramDesktop",
                "Steam",
                "Thunderbird",
            },
        },
        callback = function(c)
            decorations.hide(c)
        end
    },

    -- Titlebars ON (explicitly)
    {
        rule_any = {
            type = {
                "dialog",
            },
            role = {
                "conversation",
            }
        },
        callback = function(c)
            decorations.show(c)
        end
    },

    -- "Needy": Clients that steal focus when they are urgent
    {
        rule_any = {
            class = {
                "TelegramDesktop",
                "firefox",
            },
            type = {
                "dialog",
            },
        },
        callback = function (c)
            c:connect_signal("property::urgent", function ()
                if c.urgent then
                    c:jump_to()
                end
            end)
        end
    },

    -- Fixed terminal geometry for floating terminals
    {
        rule_any = {
            class = {
                "kitty",
            },
        },
        properties = { width = awful.screen.focused().geometry.width * 0.45, height = awful.screen.focused().geometry.height * 0.5 }
    },

    -- File chooser dialog
    {
        rule_any = { role = { "GtkFileChooserDialog" } },
        properties = { floating = true, width = awful.screen.focused().geometry.width * 0.55, height = awful.screen.focused().geometry.height * 0.65 }
    },

    -- File managers
    {
        rule_any = {
            class = {
                "Nemo"
            },
        },
        except_any = {
            type = { "dialog" }
        },
        properties = { floating = true, width = awful.screen.focused().geometry.width * 0.45, height = awful.screen.focused().geometry.height * 0.55}
    },


    -- Steam guard
    {
        rule = { name = "Steam Guard - Computer Authorization Required" },
        properties = { floating = true },
        -- Such a stubborn window, centering it does not work
        -- callback = function (c)
        --     gears.timer.delayed_call(function()
        --         awful.placement.centered(c,{honor_padding = true, honor_workarea=true})
        --     end)
        -- end
    },

    ---------------------------------------------
    -- Start application on specific workspace --
    ---------------------------------------------
    
    -- Editing
    {
        rule_any = {
            class = {
                "^editor$",
            },
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[1] }
    },    

    -- Game clients/launchers
    {
        rule_any = {
            class = {
                "Steam",
            },
            name = {
                "Steam",
            }
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[1] }
    },

    -- Browsing
    {
        rule_any = {
            class = {
                "firefox",
            },
        },
        except_any = {
            role = { "GtkFileChooserDialog" },
            instance = { "Toolkit" },
            type = { "dialog" }
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[2] },
    },

    -- Image editing
    {
        rule_any = {
            class = {
                "Gimp",
                "Inkscape",
            },
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[3] }
    },
    -- Chatting
    {
        rule_any = {
            class = {
                "discord",
                "TelegramDesktop",
            },
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[4] }
    },

    -- Mail
    {
        rule_any = {
            class = {
                "email",
            },
            instance = {
                "email",
            },
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[5] }
    },

    -- System monitoring
    {
        rule_any = {
            class = {
                "Lxtask",
                "htop",
            },
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[9] }
    },

    -- Miscellaneous
    -- All clients that I want out of my way when they are running
    {
        rule_any = {
            class = {
                "torrent",
                "Transmission",
            },
            instance = {
                "torrent",
            }
        },
        except_any = {
            type = { "dialog" }
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[10] }
    },

}

-----------------------
--      Signals      --
-----------------------
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set every new window as a slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then 
        awful.client.setslave(c) 
    end
end)

-- When a client starts up in fullscreen, resize it to cover the fullscreen a short moment later
-- Fixes wrong geometry when titlebars are enabled
client.connect_signal("manage", function(c)
    if c.fullscreen then
        gears.timer.delayed_call(function()
            if c.valid then
                c:geometry(c.screen.geometry)
            end
        end)
    end
end)

if beautiful.border_width > 0 then
    client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
    client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
end

-- Set mouse resize mode (live or after)
awful.mouse.resize.set_mode("live")

-- Restore geometry for floating clients
-- (for example after swapping from tiling mode to floating mode)
tag.connect_signal('property::layout', function(t)
    for k, c in ipairs(t:clients()) do
        if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
            local cgeo = awful.client.property.get(c, 'floating_geometry')
            if cgeo then
                c:geometry(awful.client.property.get(c, 'floating_geometry'))
            end
        end
    end
end)

client.connect_signal('manage', function(c)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, 'floating_geometry', c:geometry())
    end
end)

client.connect_signal('property::geometry', function(c)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, 'floating_geometry', c:geometry())
    end
end)

-- When switching to a tag with urgent clients, raise them.
-- This fixes the issue (visual mismatch) where after switching to
-- a tag which includes an urgent client, the urgent client is
-- unfocused but still covers all other windows (even the currently
-- focused window).
awful.tag.attached_connect_signal(s, "property::selected", function ()
    local urgent_clients = function (c)
        return awful.rules.match(c, { urgent = true })
    end
    for c in awful.client.iterate(urgent_clients) do
        if c.first_tag == mouse.screen.selected_tag then
            client.focus = c
        end
    end
end)

-- Raise focused clients automatically
client.connect_signal("focus", function(c) c:raise() end)

-- Disable ontop when the client is not floating, and restore ontop if needed
-- when the client is floating again
-- I never want a non floating client to be ontop.
client.connect_signal('property::floating', function(c)
    if c.floating then
        if c.restore_ontop then
            c.ontop = c.restore_ontop
        end
    else
        c.restore_ontop = c.ontop
        c.ontop = false
    end
end)

-- Show the dashboard on login
-- Add `touch /tmp/awesomewm-show-dashboard` to your ~/.xprofile in order to make the dashboard appear on login
local dashboard_flag_path = "/tmp/awesomewm-show-dashboard"
-- Check if file exists
awful.spawn.easy_async_with_shell("stat "..dashboard_flag_path.." >/dev/null 2>&1", function (_, __, ___, exitcode)
    if exitcode == 0 then
      -- Show dashboard
      if dashboard_show then dashboard_show() end
      -- Delete the file
      awful.spawn.with_shell("rm "..dashboard_flag_path)
    end
end)

-- Garbage collection
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)