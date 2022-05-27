local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")
local icons = require("icons")
local notifications = require("notifications")

local apps = {}

apps.browser = function ()
    awful.spawn(user.browser, { switchtotag = true })
end

apps.file_manager = function ()
    awful.spawn(user.file_manager, { floating = true })
end

apps.music = function ()
    helpers.scratchpad({instance = "music"}, user.music_client)
end

apps.mail = function ()
    helpers.run_or_raise({instance = 'email'}, false, user.email_client, {switchtotag = true})
end

apps.editor = function ()
    helpers.run_or_raise({instance = 'editor'}, false, user.editor, { switchtotag = true })
end

apps.process_monitor = function ()
    helpers.run_or_raise({instance = 'htop'}, false, user.terminal.." --class htop -e htop", { switchtotag = true })
end

apps.process_monitor_gui = function ()
    helpers.run_or_raise({class = 'Lxtask'}, false, "lxtask")
end

apps.temperature_monitor = function ()
    helpers.run_or_raise({class = 'sensors'}, false, user.terminal.." --class sensors -e watch sensors", { switchtotag = true, tag = mouse.screen.tags[5] })
end

-- Screenshots
local capture_notif = nil
local screenshot_notification_app_name = "screenshot"
function apps.screenshot(action, delay)
    -- Read-only actions
    if action == "browse" then
        awful.spawn.with_shell("cd "..user.dirs.screenshots.." && sxiv $(ls -t)")
        return
    elseif action == "gimp" then
        awful.spawn.with_shell("cd "..user.dirs.screenshots.." && gimp $(ls -t | head -n1)")
        naughty.notification({ message = "Opening last screenshot with GIMP", icon = icon, app_name = screenshot_notification_app_name})
        return
    end

    -- Screenshot capturing actions
    local cmd
    local timestamp = os.date("%Y.%m.%d-%H.%M.%S")
    local filename = user.dirs.screenshots.."/"..timestamp..".screenshot.png"
    local maim_args = "-u -b 3 -m 5"

    local prefix
    if delay then
        prefix = "sleep "..tostring(delay).." && "
    else
        prefix = ""
    end

    -- Configure action buttons for the notification
    local screenshot_open = naughty.action { name = "Open" }
    local screenshot_copy = naughty.action { name = "Copy" }
    local screenshot_edit = naughty.action { name = "Edit" }
    local screenshot_delete = naughty.action { name = "Delete" }
    screenshot_open:connect_signal('invoked', function()
        awful.spawn.with_shell("cd "..user.dirs.screenshots.." && sxiv $(ls -t)")
    end)
    screenshot_copy:connect_signal('invoked', function()
        awful.spawn.with_shell("xclip -selection clipboard -t image/png "..filename.." &>/dev/null")
    end)
    screenshot_edit:connect_signal('invoked', function()
        awful.spawn.with_shell("gimp "..filename.." >/dev/null")
    end)
    screenshot_delete:connect_signal('invoked', function()
        awful.spawn.with_shell("rm "..filename)
    end)

    if action == "full" then
        cmd = prefix.."maim "..maim_args.." "..filename
        awful.spawn.easy_async_with_shell(cmd, function()
            naughty.notification({
                title = "Screenshot",
                message = "Screenshot taken",
                actions = { screenshot_open, screenshot_copy, screenshot_edit, screenshot_delete },
                app_name = screenshot_notification_app_name,
            })
        end)
    elseif action == "selection" then
        cmd = "maim "..maim_args.." -s "..filename
        capture_notif = naughty.notification({ title = "Screenshot", message = "Select area to capture.", icon = icon, timeout = 1, app_name = screenshot_notification_app_name })
        awful.spawn.easy_async_with_shell(cmd, function(_, __, ___, exit_code)
            naughty.destroy(capture_notif)
            if exit_code == 0 then
                naughty.notification({
                    title = "Screenshot",
                    message = "Selection captured",
                    icon = icon,
                    actions = { screenshot_open, screenshot_copy, screenshot_edit, screenshot_delete },
                    app_name = screenshot_notification_app_name,
                })
            end
        end)
    elseif action == "clipboard" then
        capture_notif = naughty.notification({ title = "Screenshot", message = "Select area to copy to clipboard", icon = icon })
        cmd = "maim "..maim_args.." -s /tmp/maim_clipboard && xclip -selection clipboard -t image/png /tmp/maim_clipboard &>/dev/null && rm /tmp/maim_clipboard"
        awful.spawn.easy_async_with_shell(cmd, function(_, __, ___, exit_code)
            if exit_code == 0 then
                capture_notif = notifications.notify_dwim({ title = "Screenshot", message = "Copied selection to clipboard", icon = icon, app_name = screenshot_notification_app_name }, capture_notif)
            else
                naughty.destroy(capture_notif)
            end
        end)
    end

end


return apps
