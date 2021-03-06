-- Standard awesome library
gears = require("gears")
awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
wibox = require("wibox")
menubar = require("menubar")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
-- Widgets Extra Library
vicious = require("vicious")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

function popalert(err)
	naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Alert!",
                         text = err })
end

---------------------------
-- {{{ Variable definitions
---------------------------
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/ross/.config/awesome/ross/theme/theme.lua")
-- {{{ Variable definitions
home = os.getenv("HOME")
exec = awful.util.spawn

-- This is used later as the default terminal and editor to run.
terminal = "lxterminal"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
--    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
--    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
--    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper_cmd then
	io.popen(beautiful.wallpaper_cmd)
end
-- }}}

------------------------
-- {{{ Tags
------------------------
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
--    tags[s] = awful.tag({ 1, 2, 3 }, s, layouts[1])
    tags[s] = awful.tag({ "α", "β", "γ", "δ", "ε", "ζ" }, s, layouts[1])
end
-- }}}

--try a unified tag table
--tags = {
--        names = { 1, 2, 3 },
--        layout = { layouts[1], layouts[1], layouts[1] }
--	}
--tags = sharetags.create_tags(tags.names, tags.layout)


-------------------------
-- Widgits
-------------------------
dofile("/home/ross/.config/awesome/widgets.lua")

--------------------------
-- {{{ Key bindings
--------------------------
dofile("/home/ross/.config/awesome/keybindings.lua")

---------------------
-- {{{ Rules
---------------------
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     --size_hints_honor = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "Kupfer.py" },
      properties = { border_width = 0} },
    { rule = { class = "Vlc" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
    { rule = { instance = "plugin-container" },
        properties = { floating = true } },
    { rule = { name = "File Operation Progress" },
      properties = { },
      callback = awful.client.setslave }
    --{ rule = { class = "Avant-window-navigator" },
		--properties = { hidden = true },
		--callback = function(c) c:connect_signal("unfocus", function(d)
		--d.hidden = true
		--end) end }
}
-- }}}

-----------------------
-- {{{ Signals
-----------------------
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
--    c:connect_signal("mouse::enter", function(c)
--        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--            and awful.client.focus.filter(c) then
--            client.focus = c
--        end
--    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        --awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
