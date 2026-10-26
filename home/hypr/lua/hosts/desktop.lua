-- Desktop: two 1440p monitors side by side

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
