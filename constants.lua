local MOD_PATH = "__nocturnal__"

return {
    mod_name = "nocturnal",
    mod_path = MOD_PATH,

    graphics = function(path)
        return MOD_PATH .. "/graphics/" .. path
    end,

    sounds = function(path)
        return MOD_PATH .. "/sounds/" .. path
    end,
    
    intensity_dark = 0.1,
    intensity_bright = 0.4,

    light_color_character = {r = 1.0, g = 0.75, b = 0.5},
    light_color_car = {r = 1.0, g = 0.75, b = 0.5},
    light_color_tank = {r = 1.0, g = 0.83, b = 0.66},
    light_color_locomotive = {r = 1.0, g = 1.0, b = 0.9},

    explosion_light_intensity = 0.8,
    explosion_light_size_mult_normal = 4,
    explosion_light_size_mult_death = 7,
    explosion_light_color_default = {r = 1.0, g = 0.85, b = 0.7},
    explosion_light_color_uranium = {r = 0.42, g = 0.9, b = 0.32},
    explosion_light_color_fissure = {r = 1.0, g = 0.45, b = 0.35},
    explosion_hit_color_uranium = {r = 0.22, g = 1.0, b = 0.22},
    explosion_hit_color_piercing = {r = 1.0, g = 0.15, b = 0.15},

    explosion_slow_rate_normal = 1.1,
    explosion_slow_rate_gunshot = 2.0,
    explosion_slow_rate_fissure = 1.2,

    -- explosion_skip = {"blood", "nuke", "hit"},
    explosion_skip = {},
    explosion_buildings = {
        "furnace", "inserter", "electric-pole", "car", "robot", "engine",
        "mining-drill", "assembling-machine", "lab", "turret", "radar",
        "train", "locomotive", "cargo", "solar", "accumulator", "substation",
        "wagon", "tank", "reactor", "spidertron", "refinery", "chemical-plant",
        "centrifuge", "beacon", "silo", "land-mine", "boiler", "roboport",
        "steam-turbine", "heat-exchanger", "pumpjack", "space-platform-foundation",
        "foundry", "agricultural-tower", "biochamber", "electromagnetic-plant",
        "cryogenic-plant", "fusion-generator", "captive-spawner", "asteroid",
        "boompuff", "heating-tower"
    },
    explosion_buildings_skip = {"storage"},

    nuke_effect_duration_mult = 2.2,
    nuke_effect_ease_in_mult = 3,
    nuke_effect_ease_out_mult = 1.5,
    nuke_effect_full_strength_dist_mult = 1.4,
    nuke_effect_max_dist_mult = 1.5,

    lab_light_intensity = 2.4,
    lab_light_size = 10,
    lab_light_color = {r = 0, g = 0.1, b = 1.0},
}
