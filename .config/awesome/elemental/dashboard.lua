local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")
local apps = require("apps")
local icons = require("icons")

local keygrabber = require("awful.keygrabber")

-- Appearance
local box_radius = beautiful.dashboard_box_border_radius
local box_gap = dpi(6)

-- Get screen geometry
local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

-- Create the widget
dashboard = wibox({visible = false, ontop = true, type = "dock", screen = screen.primary})
awful.placement.maximize(dashboard)

dashboard.bg = beautiful.dashboard_bg
dashboard.fg = beautiful.dashboard_fg

-- Add dashboard or mask to each screen
awful.screen.connect_for_each_screen(function(s)
    if s == screen.primary then
        s.dashboard = dashboard
    else
        s.dashboard = helpers.screen_mask(s, beautiful.dashboard_bg)
    end
end)

local function set_visibility(v)
    for s in screen do
        s.dashboard.visible = v
    end
end

dashboard:buttons(gears.table.join(
    -- Middle click - Hide dashboard
    awful.button({ }, 2, function ()
        dashboard_hide()
    end)
))

-- Helper function that puts a widget inside a box with a specified background color
-- Invisible margins are added so that the boxes created with this function are evenly separated
-- The widget_to_be_boxed is vertically and horizontally centered inside the box
local function create_boxed_widget(widget_to_be_boxed, width, height, bg_color)
    local box_container = wibox.container.background()
    box_container.bg = bg_color
    box_container.forced_height = height
    box_container.forced_width = width
    box_container.shape = helpers.rrect(box_radius)

    local boxed_widget = wibox.widget {
        -- Add margins
        {
            -- Add background color
            {
                -- Center widget_to_be_boxed horizontally
                nil,
                {
                    -- Center widget_to_be_boxed vertically
                    nil,
                    -- The actual widget goes here
                    widget_to_be_boxed,
                    layout = wibox.layout.align.vertical,
                    expand = "none"
                },
                layout = wibox.layout.align.horizontal,
                expand = "none"
            },
            widget = box_container,
        },
        margins = box_gap,
        widget = wibox.container.margin
    }

    return boxed_widget
end



-- User widget
local user_picture_container = wibox.container.background()
-- user_picture_container.shape = gears.shape.circle
user_picture_container.shape = helpers.prrect(dpi(40), true, true, false, true)
user_picture_container.forced_height = dpi(140)
user_picture_container.forced_width = dpi(140)
local user_picture = wibox.widget {
    wibox.widget.imagebox(user.profile_picture),
    widget = user_picture_container
}
local username = os.getenv("USER")
-- local user_text = wibox.widget.textbox(username)
-- Capitalize username
-- local user_text = wibox.widget.textbox(username:upper())
-- Capitalize first letter
local user_text = wibox.widget.textbox(username:sub(1,1):upper()..username:sub(2))
user_text.font = "Fira Sans Bold 18"
user_text.align = "center"
user_text.valign = "center"

local user_widget = wibox.widget {
    user_picture,
    helpers.vertical_pad(dpi(30)),
    user_text,
    layout = wibox.layout.fixed.vertical
}
local user_box = create_boxed_widget(user_widget, dpi(300), dpi(330), x.background)

-- Calendar
local calendar = require("noodle.calendar")
-- Update calendar whenever dashboard is shown
dashboard:connect_signal("property::visible", function ()
    if dashboard.visible then
        calendar.date = os.date('*t')
    end
end)

local calendar_box = create_boxed_widget(calendar, dpi(300), dpi(400), x.background)

-- Time widget
local hours = wibox.widget.textclock("%H  ")
hours.font = "Fira Sans Bold 30"
hours.align = "center"
hours.valign = "center"
local minutes = wibox.widget.textclock("<span foreground='" .. x.color5 .."'>  %M</span>")
minutes.font = "Fira Sans 30"
minutes.align = "center"
minutes.valign = "center"

-- Time
local time = wibox.widget {
    hours,
    minutes,
    layout = wibox.layout.fixed.vertical
}
local time_box = create_boxed_widget(time, dpi(150), dpi(150), x.background)

-- Date
local day_of_the_week = wibox.widget.textclock("%A")
day_of_the_week.font = "Fira Sans Italic 20"
day_of_the_week.align = "center"
day_of_the_week.valign = "center"
day_of_the_week.align = "center"
day_of_the_week.valign = "center"

local day_of_the_month = wibox.widget.textclock("<span foreground='" .. x.color5 .."'>%d</span>")
day_of_the_month.font = "Fira Sans Bold 30"
day_of_the_month.align = "center"
day_of_the_month.valign = "center"

local date = wibox.widget {
    day_of_the_week,
    day_of_the_month,
    layout = wibox.layout.align.vertical
}
local date_box = create_boxed_widget(date, dpi(150), dpi(150), x.background)

-- File system bookmarks
local function create_bookmark(name, path, original_color, hover_color)
    local bookmark = wibox.widget.textbox()
    bookmark.font = "Fira Sans Bold 16"
    bookmark.markup = helpers.colorize_text(name, original_color)
    bookmark.align = "center"
    bookmark.valign = "center"

    -- Buttons
    bookmark:buttons(gears.table.join(
        awful.button({ }, 1, function ()
            awful.spawn.with_shell(user.file_manager.." "..path)
            dashboard_hide()
        end),
        awful.button({ }, 3, function ()
            awful.spawn.with_shell(user.terminal.." -e 'ranger' "..path)
            dashboard_hide()
        end)
    ))

    -- Hover effect
    bookmark:connect_signal("mouse::enter", function ()
        bookmark.markup = helpers.colorize_text(name, hover_color)
    end)
    bookmark:connect_signal("mouse::leave", function ()
        bookmark.markup = helpers.colorize_text(name, original_color)
    end)

    helpers.add_hover_cursor(bookmark, "hand1")

    return bookmark
end

local bookmarks = wibox.widget {
    create_bookmark("home", os.getenv("HOME"), x.color5, x.color5..90),
    create_bookmark("documents", user.dirs.documents, x.color2, x.color2..90),
    create_bookmark("downloads", user.dirs.downloads, x.color1, x.color1..90),
    create_bookmark("images", user.dirs.pictures, x.color3, x.color3..90),
    create_bookmark("config", user.dirs.config, x.color6, x.color6..90),
    spacing = dpi(10),
    layout = wibox.layout.fixed.vertical
}

local bookmarks_box = create_boxed_widget(bookmarks, dpi(200), dpi(300), x.background)

-- URLs
local function create_url(name, path, original_color, hover_color)
    local url = wibox.widget.textbox()
    url.font = "Fira Sans Bold 16"
    url.markup = helpers.colorize_text(name, original_color)
    url.align = "center"
    url.valign = "center"

    -- Buttons
    url:buttons(
        gears.table.join(
            awful.button({ }, 1, function ()
                awful.spawn(user.browser.." "..path)
                dashboard_hide()
            end),
            awful.button({ }, 3, function ()
                awful.spawn(user.browser.." -new-window "..path)
                dashboard_hide()
            end)
    ))

    -- Hover effect
    url:connect_signal("mouse::enter", function ()
        url.markup = helpers.colorize_text(name, hover_color)
    end)
    url:connect_signal("mouse::leave", function ()
        url.markup = helpers.colorize_text(name, original_color)
    end)

    helpers.add_hover_cursor(url, "hand1")

    return url
end

local urls = wibox.widget {
    create_url("twitch", "https://www.twitch.tv/directory", x.color5, x.color5..90),
    create_url("youtube", "https://www.youtube.com/", x.color1, x.color1..90),
    create_url("github", "https://github.com/sadmice", x.color4, x.color4..90),
    spacing = dpi(10),
    layout = wibox.layout.fixed.vertical
}

local urls_box = create_boxed_widget(urls, dpi(200), dpi(180), x.background)

local icon_size = dpi(40)

-- Uptime
local uptime_text = wibox.widget.textbox()
awful.widget.watch("uptime -p", 60, function(_, stdout)
    -- Remove trailing whitespaces
    local out = stdout:gsub('^%s*(.-)%s*$', '%1')
    uptime_text.text = out
end)
local uptime = wibox.widget {
    {
        align = "center",
        valign = "center",
        font = "30",
        markup = helpers.colorize_text("", x.color3),
        widget = wibox.widget.textbox()
    },
    {
        align = "center",
        valign = "center",
        font = "Fira Sans medium 11",
        widget = uptime_text
    },
    spacing = dpi(10),
    layout = wibox.layout.fixed.horizontal
}

local uptime_box = create_boxed_widget(uptime, dpi(300), dpi(80), x.background)

uptime_box:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        exit_screen_show()
        gears.timer.delayed_call(function()
            dashboard_hide()
        end)
    end)
))
helpers.add_hover_cursor(uptime_box, "hand1")

-- Item placement
dashboard:setup {
    -- Center boxes vertically
    nil,
    {
        -- Center boxes horizontally
        nil,
        {
            -- Column container
            {
                -- Column 1
                user_box,
                {
                    time_box,
                    date_box,
                    layout = wibox.layout.fixed.horizontal
                },
                layout = wibox.layout.fixed.vertical
            },
            {
                -- Column 2
                bookmarks_box,
                urls_box,
                layout = wibox.layout.fixed.vertical
            },
            {
                -- Column 3
                calendar_box,
                uptime_box,
                layout = wibox.layout.fixed.vertical
            },
            layout = wibox.layout.fixed.horizontal
        },
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal

    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical
}

local dashboard_grabber
function dashboard_hide()
    awful.keygrabber.stop(dashboard_grabber)
    set_visibility(false)
end


local original_cursor = "left_ptr"
function dashboard_show()
    -- Fix cursor sometimes turning into "hand1" right after showing the dashboard
    -- Sigh... This fix does not always work
    local w = mouse.current_wibox
    if w then
        w.cursor = original_cursor
    end
    
    dashboard_grabber = awful.keygrabber.run(function(_, key, event)
        if event == "release" then return end
        -- Press Escape or q or F1 to hide it
        if key == 'Escape' or key == 'q' or key == 'F1' then
            dashboard_hide()
        end
    end)
    set_visibility(true)
end
