local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local helpers = require("helpers")
-- Path to save covers
local cover_path = os.getenv("HOME").."/.config/awesome/noodle/spotify/cover.png"
local old_title = ""
-- Declare widgets
local spotify_cover = wibox.widget.imagebox()
local spotify_artist = wibox.widget.textbox()
local spotify_title = wibox.widget.textbox()
local spotify_song = wibox.widget {
    {
        align = "center",
        image = os.getenv("HOME").."/.config/awesome/noodle/spotify/spotify.png",
        clip_shape = helpers.rrect(5),
        widget = spotify_cover,
    },
    helpers.vertical_pad(10),
    {
        align = "center",
        text = "Spotify",
        font = "Fira Sans Bold 13",
        widget = spotify_title,
    },
    {
        align = "center",
        text = "Not playing",
        font = "Fira Sans 10",
        widget = spotify_artist,
    },
    layout = wibox.layout.fixed.vertical
}


local spotify_play = wibox.widget.textbox ("")
spotify_play:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        awful.spawn.with_shell("playerctl -p spotify play-pause")
    end)
))

local spotify_prev = wibox.widget.textbox ("")
spotify_prev:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        awful.spawn.with_shell("playerctl -p spotify previous")
    end)
))

local spotify_next = wibox.widget.textbox ("")
spotify_next:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        awful.spawn.with_shell("playerctl -p spotify next")
    end)
))

helpers.add_hover_cursor(spotify_play, "hand1")
helpers.add_hover_cursor(spotify_prev, "hand1")
helpers.add_hover_cursor(spotify_next, "hand1")

local spotify_buttons = wibox.widget {
    {
        align = "center",
        font = "22",
        widget = spotify_prev,
    },
    {
        align = "center",
        font = "22",
        widget = spotify_play,
    },
    {
        align = "center",
        font = "22",
        widget = spotify_next,
    },
    layout = wibox.layout.align.horizontal
}

-- Main widget that includes all others
local spotify = wibox.widget {
    spotify_song,
    spotify_buttons,
    spacing = 10,
    layout = wibox.layout.fixed.vertical
}

-- Subcribe to spotify updates
awesome.connect_signal("evil::spotify", function(artist, title, status, cover_url)
    if status == "playing" then 
        spotify_play.text = ""
    else
        spotify_play.text = ""
    end

    -- When song changes
    if old_title ~= title then
        old_title = title
        spotify_artist.text = artist
        spotify_title.text = title
        -- Download cover
        local cmd = "wget -O "..cover_path.." "..cover_url
        awful.spawn.with_shell(cmd)
        -- Set cover
        spotify_cover.image = os.getenv("HOME").."/.config/awesome/noodle/spotify/spotify.png"
        gears.timer.start_new(0.5, setCover):start()
    end
end)

function setCover()
    spotify_cover.image = cover_path
    return false
end

return spotify
