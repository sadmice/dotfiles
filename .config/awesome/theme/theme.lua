local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme_name = "amarena"
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local layout_icon_path = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/layout/"
local titlebar_icon_path = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/titlebar/"
local taglist_icon_path = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/taglist/"
local tip = titlebar_icon_path --alias to save time/space
local xrdb = xresources.get_current_theme()
-- local theme = dofile(themes_path.."default/theme.lua")
local theme = {}

-- Set theme wallpaper.
-- It won't change anything if you are using feh to set the wallpaper like I do.
theme.wallpaper = os.getenv("HOME") .. "/.config/awesome/theme/wallpaper.jpg"

-- Set the theme font. This is the font that will be used by default in menus, bars, titlebars etc.
theme.font          = "Fira Sans 9"

-- This is how to get other .Xresources values (beyond colors 0-15, or custom variables)
-- local cool_color = awesome.xrdb_get_value("", "color16")

theme.bg_dark       = x.background
theme.bg_normal     = x.color8
theme.bg_focus      = x.color8
theme.bg_urgent     = x.color8
theme.bg_minimize   = x.color8

theme.fg_normal     = x.foreground
theme.fg_focus      = x.color5
theme.fg_urgent     = x.color1
theme.fg_minimize   = x.color7

--------------------
--      Gaps      --
--------------------
theme.useless_gap   = dpi(5)
-- This could be used to manually determine how far away from the
-- screen edge the bars / notifications should be.
theme.screen_margin = dpi(5)

-- ### Borders ###
theme.border_width  = dpi(0)
-- theme.border_color = x.color0
-- theme.border_normal = x.color0
-- theme.border_focus  = x.color6.."20"
-- Rounded corners
theme.border_radius = dpi(6)

-------------------------
--      Titlebars      --
-------------------------
-- (Titlebar items can be customized in titlebars.lua)
theme.titlebars_enabled = true
theme.titlebar_size = dpi(30)
theme.titlebar_bg = x.background
theme.titlebar_title_enabled = false
-- theme.titlebar_font = "sans bold 9"
-- theme.titlebar_title_align = "center"
-- theme.titlebar_position = "top"
-- theme.titlebar_fg_focus = x.foreground
-- theme.titlebar_fg_normal = x.color7

-----------------------------
--      Notifications      --
-----------------------------
-- Note: Some of these options are ignored by my custom
-- notification widget_template
-- 
-- Position: bottom_left, bottom_right, bottom_middle,
--         top_left, top_right, top_middle
theme.notification_position = "top_right"
theme.notification_border_width = dpi(0)
theme.notification_border_radius = theme.border_radius
-- theme.notification_border_color = x.color10
theme.notification_icon_size = dpi(200)
theme.notification_margin = dpi(16)
theme.notification_opacity = 1
theme.notification_font = "Fira Sans 11"
theme.notification_padding = theme.screen_margin * 2
theme.notification_spacing = theme.screen_margin * 4

-------------------------
--      Edge snap      --
-------------------------
theme.snap_shape = gears.shape.rectangle
theme.snap_bg = x.foreground
theme.snap_border_width = dpi(3)

-------------------------
--      Tag names      --
-------------------------
theme.tagnames = {
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "0",
}

-------------------------
--      Separator      --
-------------------------
theme.separator_text = "|"
theme.separator_fg = x.color8

------------------------
--      Wibar(s)      --
------------------------
theme.wibar_position = "top"
theme.wibar_height = dpi(35)
theme.wibar_fg = x.foreground
theme.wibar_bg = x.background
-- theme.wibar_opacity = 0.9
theme.wibar_border_width = dpi(0)
-- theme.wibar_border_color = x.color0
theme.wibar_border_radius = dpi(0)
theme.wibar_width = dpi(380)

theme.prefix_fg = x.color8

------------------------
--      Tasklist      --
------------------------
theme.tasklist_font = "Fira Sans Medium 7"
theme.tasklist_plain_task_name = true
theme.tasklist_fg_focus = x.foreground
theme.tasklist_fg_normal = x.foreground.."80"
theme.tasklist_fg_minimize = x.color7.."80"
theme.tasklist_fg_urgent = x.color1
theme.tasklist_spacing = dpi(0)
theme.tasklist_align = "center"

-----------------------
--      Sidebar      --
-----------------------
-- (Sidebar items can be customized in sidebar.lua)
theme.sidebar_bg = x.background
theme.sidebar_fg = x.foreground
theme.sidebar_opacity = 1
theme.sidebar_position = "right"
theme.sidebar_width = dpi(300)
theme.sidebar_y = 0
theme.sidebar_border_radius = theme.border_radius

-- Volume bar
theme.volume_bar_active_color = x.color5
theme.volume_bar_active_background_color = x.color0
theme.volume_bar_muted_color = x.color8
theme.volume_bar_muted_background_color = x.color0

-- Temperature bar
theme.temperature_bar_active_color = x.color1
theme.temperature_bar_background_color = x.color0

-- CPU bar
theme.cpu_bar_active_color = x.color4
theme.cpu_bar_background_color = x.color0

-- RAM bar
theme.ram_bar_active_color = x.color2
theme.ram_bar_background_color = x.color0


-------------------------
--      Dashboard      --
-------------------------
theme.dashboard_bg = x.color0.."40"
theme.dashboard_fg = x.color7
theme.dashboard_box_border_radius = theme.border_radius

---------------------------
--      Exit screen      --
---------------------------
theme.exit_screen_bg = x.color0.."40"
theme.exit_screen_fg = x.foreground
theme.exit_screen_button_border_radius = theme.border_radius
theme.exit_screen_button_bg = x.background

---------------------------
--      Lock screen      --
---------------------------
theme.lock_screen_bg = x.color0.."40"
theme.lock_screen_fg = x.foreground

-----------------------
--      Taglist      --
-----------------------

-- Text Taglist (default)
theme.taglist_font = "Fira Sans Bold 8"
theme.taglist_bg_focus = x.background
theme.taglist_fg_focus = x.color5
theme.taglist_bg_occupied = x.background
theme.taglist_fg_occupied = x.color8
theme.taglist_bg_empty = x.background
theme.taglist_fg_empty = x.background
theme.taglist_bg_urgent = x.background
theme.taglist_fg_urgent = x.color1
theme.taglist_spacing = dpi(0)

-- Variables set for theming the menu:
theme.menu_height = dpi(35)
theme.menu_width  = dpi(180)
theme.menu_bg_normal = x.color0
theme.menu_fg_normal= x.color7
theme.menu_bg_focus = x.color8 .. "55"
theme.menu_fg_focus= x.color7
theme.menu_border_width = dpi(0)
theme.menu_border_color = x.color0

--------------------------------
--      Titlebar buttons      --
--------------------------------
theme.titlebar_close_button_normal = tip .. "close_normal.svg"
theme.titlebar_close_button_focus  = tip .. "close_focus.svg"
theme.titlebar_minimize_button_normal = tip .. "minimize_normal.svg"
theme.titlebar_minimize_button_focus  = tip .. "minimize_focus.svg"
theme.titlebar_ontop_button_normal_inactive = tip .. "ontop_normal_inactive.svg"
theme.titlebar_ontop_button_focus_inactive  = tip .. "ontop_focus_inactive.svg"
theme.titlebar_ontop_button_normal_active = tip .. "ontop_normal_active.svg"
theme.titlebar_ontop_button_focus_active  = tip .. "ontop_focus_active.svg"
theme.titlebar_sticky_button_normal_inactive = tip .. "sticky_normal_inactive.svg"
theme.titlebar_sticky_button_focus_inactive  = tip .. "sticky_focus_inactive.svg"
theme.titlebar_sticky_button_normal_active = tip .. "sticky_normal_active.svg"
theme.titlebar_sticky_button_focus_active  = tip .. "sticky_focus_active.svg"
theme.titlebar_floating_button_normal_inactive = tip .. "floating_normal_inactive.svg"
theme.titlebar_floating_button_focus_inactive  = tip .. "floating_focus_inactive.svg"
theme.titlebar_floating_button_normal_active = tip .. "floating_normal_active.svg"
theme.titlebar_floating_button_focus_active  = tip .. "floating_focus_active.svg"
theme.titlebar_maximized_button_normal_inactive = tip .. "maximized_normal_inactive.svg"
theme.titlebar_maximized_button_focus_inactive  = tip .. "maximized_focus_inactive.svg"
theme.titlebar_maximized_button_normal_active = tip .. "maximized_normal_active.svg"
theme.titlebar_maximized_button_focus_active  = tip .. "maximized_focus_active.svg"
-- (hover)
theme.titlebar_close_button_normal_hover = tip .. "close_normal_hover.svg"
theme.titlebar_close_button_focus_hover  = tip .. "close_focus_hover.svg"
theme.titlebar_minimize_button_normal_hover = tip .. "minimize_normal_hover.svg"
theme.titlebar_minimize_button_focus_hover  = tip .. "minimize_focus_hover.svg"
theme.titlebar_ontop_button_normal_inactive_hover = tip .. "ontop_normal_inactive_hover.svg"
theme.titlebar_ontop_button_focus_inactive_hover  = tip .. "ontop_focus_inactive_hover.svg"
theme.titlebar_ontop_button_normal_active_hover = tip .. "ontop_normal_active_hover.svg"
theme.titlebar_ontop_button_focus_active_hover  = tip .. "ontop_focus_active_hover.svg"
theme.titlebar_sticky_button_normal_inactive_hover = tip .. "sticky_normal_inactive_hover.svg"
theme.titlebar_sticky_button_focus_inactive_hover  = tip .. "sticky_focus_inactive_hover.svg"
theme.titlebar_sticky_button_normal_active_hover = tip .. "sticky_normal_active_hover.svg"
theme.titlebar_sticky_button_focus_active_hover  = tip .. "sticky_focus_active_hover.svg"
theme.titlebar_floating_button_normal_inactive_hover = tip .. "floating_normal_inactive_hover.svg"
theme.titlebar_floating_button_focus_inactive_hover  = tip .. "floating_focus_inactive_hover.svg"
theme.titlebar_floating_button_normal_active_hover = tip .. "floating_normal_active_hover.svg"
theme.titlebar_floating_button_focus_active_hover  = tip .. "floating_focus_active_hover.svg"
theme.titlebar_maximized_button_normal_inactive_hover = tip .. "maximized_normal_inactive_hover.svg"
theme.titlebar_maximized_button_focus_inactive_hover  = tip .. "maximized_focus_inactive_hover.svg"
theme.titlebar_maximized_button_normal_active_hover = tip .. "maximized_normal_active_hover.svg"
theme.titlebar_maximized_button_focus_active_hover  = tip .. "maximized_focus_active_hover.svg"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua

return theme
