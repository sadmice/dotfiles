local beautiful = require("beautiful")
local naughty = require("naughty")

local notifications = {}

-- Notification settings
-- Icon size
naughty.config.defaults['border_width'] = beautiful.notification_border_width

-- Timeouts
naughty.config.defaults.timeout = 5
naughty.config.presets.low.timeout = 2
naughty.config.presets.critical.timeout = 12

-- >> Notify DWIM (Do What I Mean):
-- Create or update notification automagically. Requires storing the
-- notification in a variable.
-- Example usage:
--     local my_notif = notifications.notify_dwim({ title = "hello", message = "there" }, my_notif)
--     -- After a while, use this to update or recreate the notification if it is expired / dismissed
--     my_notif = notifications.notify_dwim({ title = "good", message = "bye" }, my_notif)
function notifications.notify_dwim(args, notif)
    local n = notif
    if n and not n._private.is_destroyed and not n.is_expired then
        notif.title = args.title or notif.title
        notif.message = args.message or notif.message
        -- notif.text = args.text or notif.text
        notif.icon = args.icon or notif.icon
        notif.timeout = args.timeout or notif.timeout
    else
        n = naughty.notification(args)
    end
    return n
end

function notifications.init()
    -- Initialize notification daemons
    require("notifications.keyboardlayout")
    -- Load theme
    require("notifications.theme")
end

return notifications
