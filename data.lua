local constants = require("constants")

data:extend({{
    type = "custom-input",
    name = "noct-flashlight-toggle",
    key_sequence = "SEMICOLON"
}, {
    type = "sound",
    name = "noct-sound-flashlight-on",
    filename = constants.sounds("flashlight-on.ogg"),
    category = "game-effect",
    volume = 0.7
}, {
    type = "sound",
    name = "noct-sound-flashlight-off",
    filename = constants.sounds("flashlight-off.ogg"),
    category = "game-effect",
    volume = 0.7
}})

if settings.startup["noct-enhance-labs"].value then
    data:extend({
        {
            type = "lamp",
            name = "noct-lab-light",
            flags = {"placeable-off-grid", "not-on-map", "not-flammable"},
            hidden = true,
            collision_box = {{0.0, 0.0}, {0.0, 0.0}},
            selection_box = {{0.0, 0.0}, {0.0, 0.0}},
            light = {
                intensity = constants.lab_light_intensity,
                size = constants.lab_light_size,
                color = constants.lab_light_color
            },
            energy_source = {
                type = "void",
                help_text = "No energy source required"
            },
            energy_usage_per_tick = "1W"
        },
        {
            type = "lamp",
            name = "noct-lab-light-dim",
            flags = {"placeable-off-grid", "not-on-map", "not-flammable"},
            hidden = true,
            collision_box = {{0.0, 0.0}, {0.0, 0.0}},
            selection_box = {{0.0, 0.0}, {0.0, 0.0}},
            light = {
                intensity = constants.lab_light_intensity * 0.5,
                size = constants.lab_light_size * 0.9,
                color = constants.lab_light_color
            },
            energy_source = {
                type = "void",
                help_text = "No energy source required"
            },
            energy_usage_per_tick = "1W"
        },
        {
            type = "lamp",
            name = "noct-lab-light-ultra-dim",
            flags = {"placeable-off-grid", "not-on-map", "not-flammable"},
            hidden = true,
            collision_box = {{0.0, 0.0}, {0.0, 0.0}},
            selection_box = {{0.0, 0.0}, {0.0, 0.0}},
            light = {
                intensity = constants.lab_light_intensity * 0.2,
                size = constants.lab_light_size * 0.7,
                color = constants.lab_light_color
            },
            energy_source = {
                type = "void",
                help_text = "No energy source required"
            },
            energy_usage_per_tick = "1W"
        }
    })
end

if settings.startup["noct-enhance-projectiles"].value then
    data:extend({
        {
            type = "explosion",
            name = "explosion-hit-uranium",
            animations = {{
                animation_speed = 1.5,
                draw_as_glow = true,
                filename = "__base__/graphics/entity/explosion-hit/explosion-hit.png",
                frame_count = 13,
                height = 38,
                priority = "extra-high",
                shift = {0, -0.3125},
                tint = constants.explosion_hit_color_uranium,
                usage = "explosion",
                width = 34
            }},
            flags = {"not-on-map"},
            hidden = true,
            smoke = "smoke-fast",
            smoke_count = 1,
            smoke_slow_down_factor = 1,
            subgroup = "explosions"
        }, {
            type = "explosion",
            name = "explosion-hit-piercing",
            animations = {{
                animation_speed = 1.5,
                draw_as_glow = true,
                filename = "__base__/graphics/entity/explosion-hit/explosion-hit.png",
                frame_count = 13,
                height = 38,
                priority = "extra-high",
                shift = {0, -0.3125},
                tint = constants.explosion_hit_color_piercing,
                usage = "explosion",
                width = 34
            }},
            flags = {"not-on-map"},
            hidden = true,
            smoke = "smoke-fast",
            smoke_count = 1,
            smoke_slow_down_factor = 1,
            subgroup = "explosions"
        }
    })
    
    local trails = {
        {name = "bullet-trail-basic", intensity = 0.1},
        {name = "bullet-trail-piercing", intensity = 0.25},
        {name = "bullet-trail-nuclear", intensity = 0.4},
    }

    for _, trail in pairs(trails) do
        data:extend({
            {
            type = "explosion",
            name = trail.name,
            flags = {"not-on-map", "placeable-off-grid"},
            hidden = true,
            random_target_offset = true,
            target_offset_y = -0.3,
            animation_speed = 1,
            rotate = true,
            beam = true,
            animations = {
                {
                filename = "__nocturnal__/graphics/entity/projectile/"..trail.name..".png",
                priority = "extra-high",
                width = 7,
                height = 90,
                frame_count = 5,
                }
            },
            light = {
                intensity = trail.intensity,
                size = 2
            },
            smoke = "smoke-fast",
            smoke_count = 1,
            smoke_slow_down_factor = 1
            }
        })
    end
end