-- Document key bindings

local awful     = require("awful")
local table     = table
local ipairs    = ipairs
local pairs     = pairs
local math      = math
local string    = string
local type      = type
local modkey    = "Mod4"
local defaultweight = 100
local beautiful = require("beautiful")
local naughty   = require("naughty")
local capi      = {
   root = root,
   client = client
}

module("keydoc")

local doc = { }
local currentgroup = "Misc"
local currentweight = defaultweight
local orig = awful.key.new

-- Replacement for awful.key.new
local function new(mod, key, press, release, docstring)
   -- Usually, there is no use of release, let's just use it for doc
   -- if it's a string.
   if press and release and not docstring and type(release) == "string" then
      docstring = release
      release = nil
   end
   local k = orig(mod, key, press, release)
   -- Remember documentation for this key (we take the first one)
   if k and #k > 0 and docstring then
      doc[k[1]] = { help = docstring,
		    group = currentgroup,
		    weight = currentweight }
   end

   return k
end
awful.key.new = new		-- monkey patch

-- Turn a key to a string
local function key2str(key)
   local sym = key.key or key.keysym
   local translate = {
      ["#14"] = "#",
      [" "] = "Space",
   }
   sym = translate[sym] or sym
   if not key.modifiers or #key.modifiers == 0 then return sym end
   local result = ""
   local translate = {
--      [modkey] = "⊞",
      [modkey] = "#",
      Shift    = "⇧",
--      Control  = "Ctrl",
--      Shift    = "+",
      Control  = "^",
   }
   for _, mod in pairs(key.modifiers) do
      mod = translate[mod] or mod
      result = result .. mod .. " + "
   end
   return result .. sym
end

-- Unicode "aware" length function (well, UTF8 aware)
-- See: http://lua-users.org/wiki/LuaUnicode
local function unilen(str)
   local _, count = string.gsub(str, "[^\128-\193]", "")
   return count
end

-- Start a new group
function group(name,weight)
   if(name and weight) then
     currentgroup = name
     currentweight = weight
   else
     currentgroup = name
     currentweight = defaultweight
   end
   return {}
end

local function markup(keys)
   local markedupkeys = {}

   -- Compute longest key combination
   local longest = 0
   for _, key in ipairs(keys) do
      if doc[key] then
	 longest = math.max(longest, unilen(key2str(key)))
      end
   end

   local curgroup = nil
   local curweight = nil
   for _, key in ipairs(keys) do
      if doc[key] then
	 local help, group, weight = doc[key].help, doc[key].group, doc[key].weight
	 local skey = key2str(key)
         markedupkeys[group] = markedupkeys[group] or {}
	 markedupkeys[group].text = (markedupkeys[group].text or "") ..
--	    '<span font="DejaVu Sans Mono 10" color="' .. beautiful.fg_widget_clock .. '"> ' ..
            '<span font="DejaVu Sans Mono 10" color="green"> ' ..
	    string.format("%" .. (longest - unilen(skey)) .. "s  ", "") .. skey ..
--	    '</span>  <span color="' .. beautiful.fg_widget_value .. '">' ..
	    '</span>  <span color="white">' ..
	    help .. '</span>\n'
         markedupkeys[group].weight = weight
      end
   end

   return markedupkeys
end

-- Display help in a naughty notification
local nid = nil
function display()
   local markedupkeys = awful.util.table.join(
      markup(capi.root.keys()),
      capi.client.focus and markup(capi.client.focus:keys()) or {})

-- get the text of each group formatted and put it in a table with the weight of that group
   local grptexts = {}
   for group, res in pairs(markedupkeys) do
      local grptext = ""
      if #grptext > 0 then grptext = grptext .. "\n" end
      grptext = grptext ..
--	 '<span weight="bold" color="' .. beautiful.fg_widget_value_important .. '">' ..
         '<span weight="bold" color="red">' ..
	 group .. "</span>\n" .. res.text
      table.insert(grptexts,{res.weight, grptext})
   end

--sort by weights
table.sort(grptexts, function(a,b) return a[1] < b[1] end)

--concat all the groups together now that they're sorted
   local result = ""
for _, grptext in pairs(grptexts) do
      if #result > 0 then result = result .. "\n" end
      result = result .. grptext[2]
   end

   nid = naughty.notify({ text = result,
			  replaces_id = nid,
			  hover_timeout = 0.1,
			  timeout = 30 }).id
end
