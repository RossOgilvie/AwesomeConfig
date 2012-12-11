local keydoc = require("keydoc")
--What's the last tag or screen?
local maxtag = 6

globalkeys = awful.util.table.join(
--FOCUS
keydoc.group("Focus",1),
-- Focus Position
awful.key({ modkey }, "Left", function ()
	awful.client.focus.byidx(-1)
	if client.focus then client.focus:raise() end end, "Focus Previous Window"),
awful.key({ modkey }, "Right", function ()
	awful.client.focus.byidx( 1)
	if client.focus then client.focus:raise() end end, "Focus Next Window"),

-- Focus Tags
awful.key({ modkey,    }, "Prior", awful.tag.viewprev, "Focus Previous Tag"),
awful.key({ modkey,    }, "Next", awful.tag.viewnext, "Focus Next Tag"),    

-- Focus Screens
awful.key({ modkey,  }, "Home", function () awful.screen.focus_relative(-1) end, "Focus Previous Screen"),
awful.key({ modkey,  }, "End", function () awful.screen.focus_relative(1) end, "Focus Next Screen"),


keydoc.group("Layout Control",4),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end,
	"Increase master width"),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end,
	"Decrease master width"),
    awful.key({ modkey,           }, "grave", function () awful.layout.inc(layouts,  1) end,
	"Next Layout"),
    awful.key({ modkey, "Shift"   }, "grave", function () awful.layout.inc(layouts, -1) end,
	"Previous Layout"),

keydoc.group("Awesome"),
    awful.key({ modkey, "Control" }, "r", awesome.restart, "Restart Awesome"),
    awful.key({ modkey, "Control"   }, "q", awesome.quit, "Quit Awesome"),
    awful.key({modkey}, "F1", keydoc.display, "Display Help")
)

-------------------
-- Client based bindings
-------------------
clientkeys = awful.util.table.join(
keydoc.group("Move",2),
-- MOVE WINDOWS
-- Move Position
awful.key({ modkey, "Control"   }, "Left", function () awful.client.swap.byidx( -1)    end,
	"Swap with the previous window"),
awful.key({ modkey, "Control"   }, "Right", function () awful.client.swap.byidx(  1)    end,
	"Swap with the next window"),

-- Move Tags
-- By default this didn't change tags, but to make it consistent I've made it that way
awful.key({ modkey, "Control" }, "Prior", function (c)
	local curidx = awful.tag.getidx(c:tags()[1])
        if awful.tag.getidx(c:tags()[1]) == 1 then
		awful.client.movetotag(screen[c.screen]:tags()[maxtag],c)
        else
		awful.client.movetotag(screen[c.screen]:tags()[curidx - 1],c)
        end
        awful.tag.viewprev(screen[c.screen])
    end,
	"Move to the previous tag"),
awful.key({ modkey, "Control" }, "Next", function (c)
        local curidx = awful.tag.getidx(c:tags()[1])
        if curidx == maxtag then
		awful.client.movetotag(screen[c.screen]:tags()[1],c)
        else
		awful.client.movetotag(screen[c.screen]:tags()[curidx + 1],c)
        end
        awful.tag.viewnext(screen[c.screen])
    end,
	"Move to the next tag"),
 
-- Move Screens
awful.key({ modkey, "Control" }, "Home", function (c)
	local sidx = c.screen
        if sidx == 1 then
		awful.client.movetoscreen(c, screen.count())
        else
		awful.client.movetoscreen(c, sidx - 1)
        end
    end,
	"Move to the previous screen"),
awful.key({ modkey, "Control" }, "End", function (c)
	local sidx = c.screen
        if sidx == screen.count() then
		awful.client.movetoscreen(c, 1)
        else
		awful.client.movetoscreen(c, sidx + 1)
        end
    end,
	"Move to the next screen"),

-- Return -- Swap with master window
awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end,
	"Swap with master window"),

keydoc.group("Window States",3),
-- Up -- Maximise
awful.key({ modkey,           }, "Up", function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end,
	"Maximise"),
-- ^Up -- Float
awful.key({ modkey, "Control" }, "Up", awful.client.floating.toggle,
	"Float"),

-- Down -- Minimise
awful.key({ modkey,           }, "Down", function (c) c.minimized = true end,
	"Minimise"),
-- ^Down -- Restore
awful.key({ modkey, "Control" }, "Down", function (c) awful.client.restore() end,
	"Restore last minimised window"),

-- Q -- Quit app
awful.key({ modkey,           }, "q", function (c) c:kill() end,
	"Quit program"),
-- +r -- Redraw window
awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw() end,
	"Redraw Window")
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end)
        --awful.key({ modkey, "Control" }, "#" .. i + 9,
                  --function ()
                      --local screen = mouse.screen
                      --if tags[screen][i] then
                          --awful.tag.viewtoggle(tags[screen][i])
                      --end
                  --end),
        --awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  --function ()
                      --if client.focus and tags[client.focus.screen][i] then
                          --awful.client.movetotag(tags[client.focus.screen][i])
                      --end
                  --end),
        --awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  --function ()
                      --if client.focus and tags[client.focus.screen][i] then
                          --awful.client.toggletag(tags[client.focus.screen][i])
                      --end
                  --end)
)end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))



-- Set keys
root.keys(globalkeys)
-- }}}
