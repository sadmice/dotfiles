local awful = require("awful")
local naughty = require("naughty")
local helpers = require("helpers")
local notifications = require("notifications")

local notif
-- We will not actually display this, but only subscribe to its
-- updates in order to send a notification whenerver needed.
local dummy_keyboardlayout_widget = awful.widget.keyboardlayout()
dummy_keyboardlayout_widget:connect_signal("widget::redraw_needed", function ()
    notif = notifications.notify_dwim({ title = "Keyboard layout", message = dummy_keyboardlayout_widget.widget.text:upper(), timeout = 1, app_name = "keyboard" }, notif)
end) 