local io = io
local math = math
local naughty = naughty
local beautiful = beautiful
local tonumber = tonumber
local tostring = tostring
local print = print
local pairs = pairs

module("ross.widget.battery")

local limits = {{25, 5},
          {12, 3},
          { 7, 1},
            {0}}

function get_bat_state (adapter)
    local fcur = io.open("/sys/class/power_supply/"..adapter.."/charge_now")
    local fcap = io.open("/sys/class/power_supply/"..adapter.."/charge_full")
    local fsta = io.open("/sys/class/power_supply/"..adapter.."/status")
    local cur = fcur:read()
    local cap = fcap:read()
    local sta = fsta:read()
    fcur:close()
    fcap:close()
    fsta:close()
    local battery = math.floor(cur * 100 / cap)
    if sta:match("Charging") then
        dir = 1
    elseif sta:match("Discharging") then
        dir = -1
    elseif sta:match("Full") then
        dir = 2
     else
		dir = 0
        battery = -1
    end
    return battery, dir
end

function getnextlim (num)
    for ind, pair in pairs(limits) do
        lim = pair[1]; step = pair[2]; nextlim = limits[ind+1][1] or 0
        if num > nextlim then
            repeat
                lim = lim - step
            until num > lim
            if lim < nextlim then
                lim = nextlim
            end
            return lim
        end
    end
end


function batclosure (adapter)
    local nextlim = limits[1][1]
    return function ()
        local prefix = "⚡"
        local postfix = ""
        local battery, dir = get_bat_state(adapter)
        if dir == -1 then
			-- DISCHARGING
            --prefix = prefix .. "↓"
            --prefix = "Bat:"

            --show notifaction when crossing a threshold
            if battery <= nextlim then
                naughty.notify({title = "⚡ Beware! ⚡",
                            text = "Battery charge is low ( ⚡ "..battery.."%)!",
                            timeout = 7,
                            position = "top_right",
                            fg = beautiful.fg_focus,
                            bg = "#3F3F3F"
                            })
                nextlim = getnextlim(battery)

			-- low bettery signal
			if battery < 15 then
				postfix = "!"
			end
            end
        elseif dir == 1 then
			-- CHARGING
            --prefix = prefix .. "↑"
            nextlim = limits[1][1]
        elseif dir == 2 then
			-- CHARGED
            postfix = "⚡"
        elseif dir == 0 then
			-- UNKNOWN STATE
			battery = "??"
        end

        
        return " "..prefix..battery..postfix.." "
    end
end
