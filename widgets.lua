
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
       volume = string.format("% 3d", volume)
       status = string.match(status, "%[(o[^%]]*)%]")
       if string.find(status, "on", 1, true) then
               volume = volume .. "%"
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
--~ batwidget = awful.widget.progressbar()
--~ batwidget:set_width(8)
--~ batwidget:set_height(10)
--~ batwidget:set_vertical(true)
--~ batwidget:set_background_color("#494B4F")
--~ batwidget:set_border_color(nil)
--~ batwidget:set_color("#AECF96")
--~ batwidget:set_gradient_colors({ "#AECF96", "#88A175", "#FF5656" })
--~ vicious.register(batwidget, vicious.widgets.bat, "$2", 127, "BAT1")

--~ bat = delightful.widgets.battery:load()


-- {{{ Wibox

-- Create a systray
mysystray = widget({ type = "systray" })

-- A Widget box, this is the bar across the top of the screen.
mywibox = {}

-- An icon of the current window layout
mylayoutbox = {}

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
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(awful.button({ }, 1, function() awful.menu.toggle(mymainmenu) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)
    --try a unified tag table
--    mytaglist[s] = sharetags.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = ross.widget.tasklist(function(c) return ross.widget.tasklist.label.alltags(c, s) end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
	        mylayoutbox[s],
            mytaglist[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        datewidget,
        --~ bat,
		volumecfg.widget,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}
