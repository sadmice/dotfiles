local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local styles = {}
styles.month   = { 
    padding      = 20,
    fg_color     = x.color7,
    border_width = 0,
}
styles.normal  = {}
styles.focus   = { 
    fg_color = x.color1,
    markup   = function(t) return '<b>' .. t .. '</b>' end,
}
styles.header  = { 
    fg_color = x.color5,
    markup   = function(t) return '<span font_desc="Fira Sans Bold 22">' .. t .. '</span>' end,
}
styles.weekday = { 
    fg_color = x.color7,
    padding  = 3,
    markup   = function(t) return '<b>' .. t .. '</b>' end,
}
local function decorate_cell(widget, flag, date)
    if flag=='monthheader' and not styles.monthheader then
        flag = 'header'
    end
    local props = styles[flag] or {}
    if props.markup and widget.get_text and widget.set_markup then
        widget:set_markup(props.markup(widget:get_text()))
    end

    local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
    local weekday = tonumber(os.date('%w', os.time(d)))
    local default_fg = x.color7
    local ret = wibox.widget {
        {
            widget,
            margins = (props.padding or 2) + (props.border_width or 0),
            widget  = wibox.container.margin
        },
        fg                 = props.fg_color or default_fg,
        widget             = wibox.container.background
    }
    return ret
end

calendar_widget = wibox.widget {
    date     = os.date('*t'),
    font     = "Fira Sans medium 13",
    long_weekdays = false,
    spacing  = dpi(3),
    fn_embed = decorate_cell,
    widget   = wibox.widget.calendar.month
}

local current_month = os.date('*t').month
calendar_widget:buttons(gears.table.join(
    -- Left Click - Reset date to current date
    awful.button({ }, 1, function ()
        calendar_widget.date = os.date('*t')
    end),
    -- Scroll - Move to previous or next month
    awful.button({ }, 4, function ()
        new_calendar_month = calendar_widget.date.month - 1
        if new_calendar_month == current_month then
            calendar_widget.date = os.date('*t')
        else
            calendar_widget.date = {month = new_calendar_month, year = calendar_widget.date.year}
        end
    end),
    awful.button({ }, 5, function ()
        new_calendar_month = calendar_widget.date.month + 1
        if new_calendar_month == current_month then
            calendar_widget.date = os.date('*t')
        else
            calendar_widget.date = {month = new_calendar_month, year = calendar_widget.date.year}
        end
    end)
))

return calendar_widget
