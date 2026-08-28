local handle = io.popen("hostname")
local hostname = handle:read("*l")
handle:close()

if hostname == "laptop" then
    hl.monitor({
        output   = "eDP-1",
        mode     = "2560x1600@120",
        position = "0x0",
        scale    = 1,
    })

elseif hostname == "desktop" then
    hl.monitor({
        output   = "DP-1",
        mode     = "2560x1440@165.00",
        position = "0x0",
        scale    = 1,
    })

    hl.monitor({
        output   = "DP-2",
        mode     = "2560x1440@165.00",
        position = "2560x0",
        scale    = 1,
    })
end
