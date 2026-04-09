data:extend{{
    type = "color-setting",
    name = "noct-default-lamp-color",
    setting_type = "startup",
    default_value = {
        r = 1.0,
        g = 0.75,
        b = 0.5
    },
    order="a"
}, {
    type = "bool-setting",
    name = "noct-hide-enemies-from-map",
    setting_type = "startup",
    default_value = true,
    order="b"
}, {
    type = "bool-setting",
    name = "noct-disable-nightvision",
    setting_type = "startup",
    default_value = true,
    order="d"
}, {
    type = "bool-setting",
    name = "noct-turn-toward-target",
    setting_type = "startup",
    default_value = true,
    order="e"
}, {
    type = "string-setting",
    name = "noct-player-halo",
    setting_type = "startup",
    default_value = "dark",
    allowed_values = {"off", "dark", "bright"},
    order="f"
}, {
    type = "string-setting",
    name = "noct-vehicle-halo",
    setting_type = "startup",
    default_value = "dark",
    allowed_values = {"off", "dark", "bright"},
    order="g"
}, {
    type = "bool-setting",
    name = "noct-enhance-buildings",
    setting_type = "startup",
    default_value = true,
    order="h"
}, {
    type = "bool-setting",
    name = "noct-enhance-explosions",
    setting_type = "startup",
    default_value = true,
    order="i"
}, {
    type = "double-setting",
    name = "noct-explosion-light-scale",
    setting_type = "startup",
    default_value = 1.0,
    minimum_value = 0.5,
    maximum_value = 3.0,
    order="j"
}, {
    type = "bool-setting",
    name = "noct-enhance-projectiles",
    setting_type = "startup",
    default_value = true,
    order="k"
}, {
    type = "bool-setting",
    name = "noct-enhance-labs",
    setting_type = "startup",
    default_value = true,
    order="l"
}}
