-- {{{ Menu
-- Create a laucher widget and a main menu
mymainmenu = awful.menu({ items = {
   { "manual", terminal .. " -e man awesome" },
   { "open terminal", terminal },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart awm", awesome.restart },
   { "quit", awesome.quit },
   { "restart", "systemctl reboot"},
   { "shutdown", "systemctl poweroff"}
                                  }
                        })
-- }}}

-- {{{{{
-- Fix notification defaults
-- }}}}}
naughty.config.presets.normal.bg = '#0F0F0F'
naughty.config.presets.low.bg = '#0F0F0F'
naughty.config.presets.critical.bg = '#0F0F0F'

---- Volume Widget
volumecfg = {}
volumecfg.cardid  = 0
volumecfg.muted = false
volumecfg.vol = 100
volumecfg.widget = wibox.widget.textbox()
volumecfg.widget:set_align("right")
 --command must start with a space!
volumecfg.mixercommand = function (command, param)
       local fd = io.popen("pactl " .. command .. " " .. volumecfg.cardid .. " -- " .. param)
       fd:close()
       volumecfg.update()
end
volumecfg.update = function ()
       local fd = io.popen("pacmd list-sinks")
       if(fd ~= nil) then volumecfg.widget.text = "??" end
       local status = fd:read("*all")
       fd:close()
       local volume = string.match(status, "(%d?%d?%d)%%")
       volume = "♫" .. string.format("% 3d", volume)
       muted_line = string.match(status, "muted: ...")
       muted_status = string.match(muted_line, "yes")
       if muted_status == nil then
               volumecfg.muted = false
       else   
               volume = volume .. "M"
               volumecfg.muted = true
       end
       volumecfg.widget:set_text(volume)
end
volumecfg.up = function ()
       volumecfg.mixercommand("set-sink-volume", "+5%")
end
volumecfg.down = function ()
       volumecfg.mixercommand("set-sink-volume", "-5%")
end
volumecfg.toggle = function ()
       if volumecfg.muted then
       volumecfg.mixercommand("set-sink-mute","0")
       else
       volumecfg.mixercommand("set-sink-mute","1")
       end
end
volumecfg.widget:buttons(awful.util.table.join(
       awful.button({ }, 4, function () volumecfg.up() end),
       awful.button({ }, 5, function () volumecfg.down() end),
       awful.button({ }, 1, function () volumecfg.toggle() end),
       awful.button({ }, 2, function () awful.util.spawn_with_shell("pavucontrol") end)
))
volumecfg.update()

--refresh volume
voltimer = timer({ timeout = 2 })
voltimer:connect_signal("timeout", function() volumecfg.update() end)
voltimer:start()

----------
-- Clock
----------
-- Initialize widget
datewidget = wibox.widget.textbox()
-- Register widget
vicious.register(datewidget, vicious.widgets.date, " %a %b %d, %R", 19)

----------
-- Battery
----------
battery = require("ross.widget.battery")

batterywidget = wibox.widget.textbox()
batterywidget:set_align("right")

bat_clo = battery.batclosure("BAT1")
batterywidget:set_text(bat_clo())
battimer = timer({ timeout = 30 })
battimer:connect_signal("timeout", function() batterywidget:set_text(bat_clo()) end)
battimer:start()


-- WIFI
wifi =
{
	widget = wibox.widget.textbox(),
	args = "wlan0",
	timeout = 7,
	ssid = "N/A",
	rate = 0,
	link = 0
}
wifi.callback = function(widget, args)
  widget:set_text("la")
  wifi.ssid = args["{ssid}"]
  wifi.rate = args["{rate}"]
  wifi.link = args["{link}"]
  local text = ""

  if wifi.link == 0 then
  	local fdevice = io.popen("ip link | grep 'eth0.*UP'")
  	local device = fdevice:read()
  	fdevice:close()

  	if device ~= "" then
      text = "eth0"
    else
  		text = "d/c"
  	end
  else
    text = wifi.link
  end
  return " ⇅ " .. text .. " "
end

vicious.register(wifi.widget, vicious.widgets.wifi, wifi.callback, wifi.timeout, wifi.args)

-- wifi.tooltip = function()
--   vicious.force({ wifi.widget })
--   return wifi.ssid .. " " .. wifi.rate .. "Mb/s " .. wifi.link .. "%"
-- end
-- awful.tooltip({ objects = { wifi.widget }, timer_function = wifi.tooltip })

-- TEMP
therm = {
	widget = wibox.widget.textbox(),
	margins = { left = 4, right = 4 },
	args = "thermal_zone0",
	format = "# $1°",
	timeout = 67
}

vicious.register(therm.widget, vicious.widgets.thermal, therm.format, therm.timeout, therm.args)
--awful.widget.layout.margins[therm.widget] = therm.margins

-- LOCATION
loc_widget = {}
loc_widget.widget = wibox.widget.textbox()
loc_widget.locate = function() 
  local location_file = io.open("/home/ross/.location")
  local location_text = location_file:read()
  location_file:close()
  return " ⌖ " .. location_text .. " "
end

loc_widget.widget:set_align("right")
loc_widget.widget:set_text(loc_widget.locate())

loc_widget.timer = timer({ timeout = 30 })
loc_widget.timer:connect_signal("timeout", function() loc_widget.widget:set_text(loc_widget.locate()) end)
loc_widget.timer:start()

 -- {{{ Wibox
-- A Widget box, this is the bar across the top of the screen.
mywibox = {}

-- An icon of the current window layout
archlogo = wibox.widget.imagebox()
archlogo:set_image(beautiful.archlinux)
archlogo:buttons(awful.util.table.join(awful.button({ }, 1, function() awful.menu.toggle(mymainmenu) end)))

-- A list of the tags
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
                    
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else
			if not c:isvisible() then
				awful.tag.viewonly(c:tags()[1])
			end
			-- This will also un-minimize the client, if needed
			client.focus = c
			c:raise()
		end end),
	awful.button({ }, 4, function ()
		awful.client.focus.byidx(1)
		if client.focus then client.focus:raise() end end),
	awful.button({ }, 5, function ()
		awful.client.focus.byidx(-1)
		if client.focus then client.focus:raise() end end))

for s = 1, screen.count() do
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    --mytasklist[s] = ross.widget.tasklist(function(c) return ross.widget.tasklist.label.alltags(c, s) end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
	-- Add widgets to the wibox - order matters
	-- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(archlogo)
    left_layout:add(mytaglist[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(loc_widget.widget)
    right_layout:add(wifi.widget)
    right_layout:add(volumecfg.widget)
    right_layout:add(batterywidget)
    right_layout:add(therm.widget)
    right_layout:add(datewidget)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    --layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}
