local constants = require("constants")

local function should_skip(name)
    for _, pattern in ipairs(constants.explosion_skip) do
        if name:find(pattern, 1, true) then return true end
    end
    return false
end

local function contains_any(name, list)
    for _, item in ipairs(list) do
        if name:find(item, 1, true) then return true end
    end
    return false
end

local function get_explosion_scale(explosion)
    local anims = explosion.animations
    if not anims then return 1 end

    if anims.width then
        return (anims.width * (anims.scale or 1)) / 32
    end

    local total, count = 0, 0
    for _, anim in ipairs(anims) do
        if anim.width then
            total = total + (anim.width * (anim.scale or 1))
            count = count + 1
        end
    end
    return count > 0 and (total / count / 32) or 1
end

local function set_explosion_light(explosion, size, color, intensity)
    explosion.light = {
        intensity = intensity or constants.explosion_light_intensity,
        size = math.ceil(size),
        color = color or constants.explosion_light_color_default
    }

    explosion.light_intensity_peak_end_progress = 0.2
    explosion.light_size_peak_start_progress = 0.125
    explosion.light_size_peak_end_progress = 0.3
    explosion.scale_out_duration = 0.1
    explosion.scale_end = 0.1
    explosion.scale_animation_speed = true
end

local function slow_explosion_animation(explosion, rate)
    local anims = explosion.animations
    if not anims then return end

    if anims.animation_speed then
        anims.animation_speed = anims.animation_speed / rate
    else
        for _, anim in ipairs(anims) do
            if anim.animation_speed then
                anim.animation_speed = anim.animation_speed / rate
            end
        end
    end
end

local function add_flicker(explosion)
    explosion.light.flicker_interval = explosion.light.flicker_interval or 10
    explosion.light.flicker_min_modifier = explosion.light.flicker_min_modifier or 0.8
    explosion.light.flicker_max_modifier = explosion.light.flicker_max_modifier or 1.5
end

local function enhance_nuke()
    local atomic_rocket = data.raw["projectile"]["atomic-rocket"]
    if not atomic_rocket then return end

    local atomic_rocket_effects = atomic_rocket.action.action_delivery.target_effects
    if not atomic_rocket_effects then return end

    for _, effect in ipairs(atomic_rocket_effects) do
        if effect.type == "camera-effect" then
            effect.duration = 60 * constants.nuke_effect_duration_mult
            effect.ease_in_duration = 5 * constants.nuke_effect_ease_in_mult
            effect.ease_out_duration = 60 * constants.nuke_effect_ease_out_mult
            effect.delay = 4
            effect.full_strength_max_distance = 200 * constants.nuke_effect_full_strength_dist_mult
            effect.max_distance = 800 * constants.nuke_effect_max_dist_mult
        end
    end
end

local function enhance_explosion(name, explosion, light_scale)
    if explosion.subgroup ~= "explosions" then return end
    if explosion.light or explosion.scale then return end
    if should_skip(name) then return end

    local scale = get_explosion_scale(explosion)
    if not scale then return end

    local base_size = 5.5 + scale * constants.explosion_light_size_mult_normal
    local final_size = base_size * light_scale

    if name:find("railgun", 1, true) then
        set_explosion_light(explosion, final_size * 1.6)
        slow_explosion_animation(explosion, 1.5)
    elseif name:find("fissure", 1, true) then
        set_explosion_light(explosion, final_size * 1.8,
            constants.explosion_light_color_fissure)
        add_flicker(explosion)
        slow_explosion_animation(explosion, constants.explosion_slow_rate_fissure)
    elseif name:find("uranium", 1, true) then
        set_explosion_light(explosion, final_size,
            constants.explosion_light_color_uranium, 0.7)
    elseif name:find("hit-uranium", 1, true) then
        set_explosion_light(explosion, final_size,
            constants.explosion_hit_color_uranium, 0.7)
    elseif name:find("hit-piercing", 1, true) then
        set_explosion_light(explosion, final_size,
            constants.explosion_hit_color_piercing, 0.7)
    elseif name:find("gunshot", 1, true) then
        set_explosion_light(explosion, final_size * 1.6)
        slow_explosion_animation(explosion, constants.explosion_slow_rate_gunshot)
    else
        set_explosion_light(explosion, final_size)
        slow_explosion_animation(explosion, constants.explosion_slow_rate_normal)
    end
end

local function enhance_building_explosion(name, explosion, light_scale)
    if explosion.light then return end
    if not contains_any(name, constants.explosion_buildings) then return end
    if contains_any(name, constants.explosion_buildings_skip) then return end

    local scale = get_explosion_scale(explosion)
    if not scale then return end

    local death_size = (7 + scale * constants.explosion_light_size_mult_death) * light_scale
    set_explosion_light(explosion, death_size)
    slow_explosion_animation(explosion, constants.explosion_slow_rate_normal)
end

if settings.startup["noct-enhance-explosions"].value then
    enhance_nuke()

    local light_scale = settings.startup["noct-explosion-light-scale"].value

    for name, explosion in pairs(data.raw.explosion) do
        enhance_explosion(name, explosion, light_scale)
    end

    for name, explosion in pairs(data.raw.explosion) do
        enhance_building_explosion(name, explosion, light_scale)
    end
end
