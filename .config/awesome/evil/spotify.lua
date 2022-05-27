-- Provides:
-- evil::spotify
--      artist (string)
--      song (string)
--      status (string) [playing | paused | stopped]
local awful = require("awful")

local function emit_info(playerctl_output)
    local artist = playerctl_output:match('artist_start(.*)title_start')
    local title = playerctl_output:match('title_start(.*)status_start')
    -- Use the lower case of status
    local status = playerctl_output:match('status_start(.*)cover_start'):lower()
    status = string.gsub(status, '^%s*(.-)%s*$', '%1')
    local cover_url = playerctl_output:match('cover_start(.*)')

    if not artist or artist == "" then
      artist = "N/A"
    end
    if not title or title == "" then
      title = "N/A"
    end

    awesome.emit_signal("evil::spotify", artist, title, status, cover_url)
end

local spotify_script = [[
  sh -c '
    playerctl -p spotify metadata --format 'artist_start{{artist}}title_start{{title}}status_start{{status}}cover_start{{mpris:artUrl}}' --follow
  ']]

-- Kill old playerctl process
awful.spawn.easy_async_with_shell("ps -x | grep \"playerctl -p spotify\" | grep -v grep | awk '{print $1}' | xargs kill", function ()
    -- Emit song info with each line printed
    awful.spawn.with_line_callback(spotify_script, {
        stdout = function(line)
            emit_info(line)
        end
    })
end)
