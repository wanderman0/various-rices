-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("/usr/libexec/xdg-desktop-portal-hyprland &")
    hl.exec_cmd("sleep 2 && /usr/libexec/xdg-desktop-portal &")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("flameshot")
    hl.exec_cmd("kdeconnect-indicator")
    hl.exec_cmd("waybar & hyprpaper")
    hl.exec_cmd("hypridle")
end)