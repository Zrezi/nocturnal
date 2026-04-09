if settings.startup['noct-enhance-fires'].value then
    local fire_spread_rate = settings.startup['noct-fire-spread-rate'].value or 1.0

    local function modify_fire(name, fire, light)
        if light then
            fire.light = light
        else
            local power = math.abs(fire.damage_per_tick.amount) / 1.7
            if power > 1 then power = 1 end
            if not fire.light then fire.light = {} end

            fire.light.intensity = 0.5 + power * 1.2
            fire.light.size = 15 + power
            fire.light.color = {
                r = math.max(0, math.min(1, 0.75 + power * 0.8)),
                g = math.max(0, math.min(1, 0.3 - power * 0.4)),
                b = math.max(0, math.min(1, 0.1 - power * 0.3))
            }
        end

        fire.light.flicker_interval = fire.light.flicker_interval or 30
        fire.light.flicker_min_modifier = fire.light.flicker_min_modifier or 0.8
        fire.light.flicker_max_modifier = fire.light.flicker_max_modifier or 1.3
        fire.spread_delay = fire.spread_delay and fire.spread_delay / fire_spread_rate or 300
        fire.fire_spread_radius = fire.fire_spread_radius and fire.fire_spread_radius * fire_spread_rate or 0.75
        fire.maximum_spread_count = fire.maximum_spread_count and fire.maximum_spread_count * fire_spread_rate or 100
    end

    for name, fire in pairs(data.raw["fire"]) do
        if (fire.damage_per_tick or {}).type == "fire" then
            modify_fire(name, fire)
        else
            for _, sub in ipairs({"eb-fire"}) do
                if name:find(sub) then
                    local light = {intensity = 1.0, size = 22, color = {r = 1.0, g = 0.5, b = 0.3}}
                    modify_fire(name, fire, light)
                    break
                end
            end
        end
    end
    
    for name, sticker in pairs(data.raw["sticker"]) do
        if not (sticker.damage_per_tick) or not (sticker.spread_fire_entity or sticker.damage_per_tick.type ~= "fire") then
            goto continue
        end
        local light = {intensity = 0.3, size = 10, color = {r = 0.65, g = 0.4, b = 0.3}}
        modify_fire(name, sticker, light)
        if sticker.fire_spread_cooldown then
            sticker.fire_spread_cooldown = sticker.fire_spread_cooldown * (1 / fire_spread_rate)
        end
        ::continue::
    end
end