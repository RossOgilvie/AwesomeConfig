-- {{{ Menu
-- Create a laucher widget and a main menu
mymainmenu = awful.menu({ items = {
   { "manual", terminal .. " -e man awesome" },
   { "open terminal", terminal },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart awm", awesome.restart },
   { "quit", awesome.quit },
   { "restart", terminal .. " -e reboot"},
   { "shutdown", "systemctl poweroff"}
                                  }
                        })
-- }}}

---- Volume Widget
volumecfg = {}
volumecfg.cardid  = 0
volumecfg.channel = "Master"
local muted = false
volumecfg.widget = widget({ type = "textbox", name = "volumecfg.widget", align = "right" })
-- command must start with a space!
volumecfg.mixercommand = function (command)
       local fd = io.popen("amixer -c " .. volumecfg.cardid .. command)
       if(fd ~= nil) then volumecfg.widget.text = "??" end
       local status = fd:read("*all")
       fd:close()
       local volume = string.match(status, "(%d?%d?%d)%%")
       volume = "♫" .. string.format("% 3d", volume)
       status = string.match(status, "%[(o[^%]]*)%]")
       if string.find(status, "on", 1, true) then
               --volume = volume .. "%"
               muted = false
       else   
               volume = volume .. "M"
               muted = true
       end
       volumecfg.widget.text = volume
end
volumecfg.update = function ()
       volumecfg.mixercommand(" sget " .. volumecfg.channel)
end
volumecfg.up = function ()
       volumecfg.mixercommand(" sset " .. volumecfg.channel .. " 5%+")
end
volumecfg.down = function ()
       volumecfg.mixercommand(" sset " .. volumecfg.channel .. " 5%-")
end
volumecfg.toggle = function ()
       if muted then
       volumecfg.mixercommand(" sset " .. volumecfg.channel .. " unmute")
       volumecfg.mixercommand(" set " .. "Headphone" .. " unmute")
       volumecfg.mixercommand(" set " .. "Speaker" .. " unmute")
       else
       volumecfg.mixercommand(" sset " .. volumecfg.channel .. " mute")
       volumecfg.mixercommand(" set " .. "Headphone" .. " mute")
       volumecfg.mixercommand(" set " .. "Speaker" .. " mute")
       end
end
volumecfg.widget:buttons(awful.util.table.join(
       awful.button({ }, 4, function () volumecfg.up() end),
       awful.button({ }, 5, function () volumecfg.down() end),
       awful.button({ }, 1, function () volumecfg.toggle() end)
))
volumecfg.update()

--refresh volume
mytimer = timer({ timeout = 2 })
mytimer:add_signal("timeout", function() volumecfg.update() end)
mytimer:start()

----------
-- Clock
----------
-- Initialize widget
datewidget = widget({ type = "textbox" })
-- Register widget
vicious.register(datewidget, vicious.widgets.date, " %a %b %d, %R", 19)

----------
-- Battery
----------
battery = require("ross.widget.battery")

batterywidget = widget({type = "textbox", name = "batterywidget", align = "right" })

bat_clo = battery.batclosure("BAT1")
batterywidget.text = bat_clo()
battimer = timer({ timeout = 30 })
battimer:add_signal("timeout", function() batterywidget.text = bat_clo() end)
battimer:start()


-- WIFI
wifi =
{
	widget = widget({ type = "imagebox" }),
	margins = { left = 4, right = 4 },
	resize = false,
	vicious = vicious.widgets.wifi,
	args = "wlan0",
	timeout = 31,
	ssid = "N/A",
	rate = 0,
	link = 0,
	imgs = {
		image(beautiful.wifi_none),
		image(beautiful.wifi_weak),
		image(beautiful.wifi_ok),
		image(beautiful.wifi_good),
		image(beautiful.wifi_excellent),
		image(beautiful.wired)
		}
}
wifi.callback = function(widget, args)
  wifi.ssid = args["{ssid}"]
  wifi.rate = args["{rate}"]
  wifi.link = args["{link}"]

  if wifi.link == 0 then
	local fdevice = io.popen("grep dhcpcd /etc/resolv.conf | awk '{print $6}'")
	local device = fdevice:read()
	fdevice:close()
	if device == "eth0" then
		widget.image = wifi.imgs[6]
	else
		widget.image = wifi.imgs[1]
	end
  elseif wifi.link < 21 then
    widget.image = wifi.imgs[2]
  elseif wifi.link < 51 then
    widget.image = wifi.imgs[3]
  elseif wifi.link < 91 then
    widget.image = wifi.imgs[4]
  else
    widget.image = wifi.imgs[5]
  end
end
wifi.widget:buttons(awful.util.table.join( awful.button({ }, 1, 
	function () awful.util.spawn_with_shell("lxterminal -e wicd-curses") end)
))
wifi.tooltip = function()
  vicious.force({ wifi.widget })
  return wifi.ssid .. " " .. wifi.rate .. "Mb/s " .. wifi.link .. "%"
end

vicious.register(wifi.widget, wifi.vicious,
                     wifi.format == nil and wifi.callback or wifi.format,
                     wifi.timeout, wifi.args)
awful.widget.layout.margins[wifi.widget] = wifi.margins
awful.tooltip({ objects = { wifi.widget }, timer_function = wifi.tooltip })

-- TEMP
therm = {
	widget = widget({ type = "textbox"}),
	margins = { left = 4, right = 4 },
	vicious = vicious.widgets.thermal,
	args = "thermal_zone0",
	format = "# $1°",
	timeout = 67
}

vicious.register(therm.widget, therm.vicious, therm.format == nil and therm.callback or therm.format, therm.timeout, therm.args)
awful.widget.layout.margins[therm.widget] = therm.margins


 -- {{{ Wibox

-- Create a systray
mysystray = widget({ type = "systray" })

-- A Widget box, this is the bar across the top of the screen.
mywibox = {}

-- An icon of the current window layout
archlogo = widget({ type = "imagebox" })
archlogo.image = image(beautiful.archlinux)
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
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)
    --try a unified tag table
--    mytaglist[s] = sharetags.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = ross.widget.tasklist(function(c) return ross.widget.tasklist.label.alltags(c, s) end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
	-- Add widgets to the wibox - order matters
	mywibox[s]:add_signal("mouse::enter", function ()
		for k,c in pairs(client.get()) do
			if awful.rules.match(c, {class = "Avant-window-navigator"}) then
				--c.hidden = false
				--client.focus = c
				c:raise()
				end
			end
		end)
	mywibox[s].widgets = {
		{
			archlogo,
            mytaglist[s],
            layout = awful.widget.layout.horizontal.leftright
		},
		datewidget,
		therm.widget,
        batterywidget,
		volumecfg.widget,
		wifi.widget,
		netwidget,
        s == screen.count() and mysystray or nil,
        --mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
	}
end
-- }}}
