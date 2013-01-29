-------------------------------
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

-- Alternative icon sets and widget icons:
--  * http://awesome.naquadah.org/wiki/Nice_Icons

-- {{{ Main
theme = {}
theme.wallpaper_cmd = "/home/ross/.scripts/screens wallpaper"
theme.rootdir = "/home/ross/.config/awesome/ross/theme/"
-- }}}

-- {{{ Styles
theme.font      = "sans 8"

-- {{{ Colors
theme.fg_normal = "#DDDDDD"
theme.fg_secondary = "#666666"
theme.fg_focus  = "#F0DFAF"
theme.fg_urgent = "#CC9393"
-- Altered for transparency
theme.bg_normal = "#3F3F3F00"
theme.bg_focus  = "#3F3F3F00"
--theme.bg_focus  = "#1E2320"
theme.bg_urgent = "#3F3F3F"
-- }}}

-- {{{ Borders
theme.border_width  = "2"
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#6F6F6F"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#3F3F3F"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = "15"
theme.menu_width  = "100"
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = theme.rootdir .. "taglist/squarefz.png"
theme.taglist_squares_unsel = theme.rootdir .. "taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = theme.rootdir .. "awesome-icon.png"
theme.menu_submenu_icon      = "/usr/share/awesome/themes/default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = theme.rootdir .. "layouts/tile.png"
theme.layout_tileleft   = theme.rootdir .. "layouts/tileleft.png"
theme.layout_tilebottom = theme.rootdir .. "layouts/tilebottom.png"
theme.layout_tiletop    = theme.rootdir .. "layouts/tiletop.png"
theme.layout_fairv      = theme.rootdir .. "layouts/fairv.png"
theme.layout_fairh      = theme.rootdir .. "layouts/fairh.png"
theme.layout_spiral     = theme.rootdir .. "layouts/spiral.png"
theme.layout_dwindle    = theme.rootdir .. "layouts/dwindle.png"
theme.layout_max        = theme.rootdir .. "layouts/max.png"
theme.layout_fullscreen = theme.rootdir .. "layouts/fullscreen.png"
theme.layout_magnifier  = theme.rootdir .. "layouts/magnifier.png"
theme.layout_floating   = theme.rootdir .. "layouts/floating.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = theme.rootdir .. "titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.rootdir .. "titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = theme.rootdir .. "titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.rootdir .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = theme.rootdir .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.rootdir .. "titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = theme.rootdir .. "titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.rootdir .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = theme.rootdir .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.rootdir .. "titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = theme.rootdir .. "titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.rootdir .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = theme.rootdir .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.rootdir .. "titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = theme.rootdir .. "titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.rootdir .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.rootdir .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.rootdir .. "titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

-- {{{ Tasklist
theme.tasklist_floating_icon_active = theme.rootdir .. "tasklist/ontop_focus_active.png"
theme.tasklist_floating_icon_inactive = theme.rootdir .. "tasklist/ontop_focus_inactive.png"
theme.tasklist_maximised_icon_active = theme.rootdir .. "tasklist/floating_focus_active.png"
theme.tasklist_maximised_icon_inactive = theme.rootdir .. "tasklist/floating_focus_inactive.png"
--}}}

-- WIFI
theme.wifi_excellent = theme.rootdir .. "icons/network-wireless-signal-excellent-symbolic.png"
theme.wifi_good = theme.rootdir .. "icons/network-wireless-signal-good-symbolic.png"
theme.wifi_ok = theme.rootdir .. "icons/network-wireless-signal-ok-symbolic.png"
theme.wifi_weak = theme.rootdir .. "icons/network-wireless-signal-weak-symbolic.png"
theme.wifi_none = theme.rootdir .. "icons/network-wireless-signal-none-symbolic.png"
theme.wired = theme.rootdir .. "icons/network-wired.png"

-- Arch
theme.archlinux = theme.rootdir .. "icons/archlinux.png"


return theme
