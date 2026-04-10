local enhance_buildings = settings.startup["noct-enhance-machines"].value

if enhance_buildings then
    for name, silo in pairs(data.raw["rocket-silo"]) do
        if silo.base_engine_light and silo.base_engine_light.size == 25 then
            silo.base_engine_light.size = 90
            silo.base_engine_light.color = {r = 0.9, g = 0.64, b = 0.52}
        end
    end

    for name, rocket in pairs(data.raw["rocket-silo-rocket"]) do
        if rocket.glow_light and rocket.glow_light.size == 30 then
            rocket.glow_light.size = 35
            rocket.glow_light.color = {r = 0.85, g = 0.55, b = 0.45, a = 0.7}
            rocket.glow_light.shift = {0, 2.0}
        end
    end

    local refinery = data.raw["assembling-machine"]["oil-refinery"]
    if refinery and refinery.graphics_set and refinery.graphics_set.working_visualisations then
        for _, viz in pairs(refinery.graphics_set.working_visualisations) do
            if viz.animation and viz.animation.draw_as_glow then
                viz.light = {
                    intensity = 0.4,
                    size = 20,
                    color = {r = 1.0, g = 0.6, b = 0.15}
                }
                viz.effect = 'uranium-glow'
            end
        end
    end

    local electromag = data.raw["assembling-machine"]["electromagnetic-plant"]
    if electromag and electromag.graphics_set and electromag.graphics_set.working_visualisations then
        local viz = electromag.graphics_set.working_visualisations[#electromag.graphics_set.working_visualisations]
        viz.light.intensity = 0.8
        viz.light.size = 16
        viz.effect = 'uranium-glow'
    end

    local foundry = data.raw["assembling-machine"]["foundry"]
    if foundry and foundry.graphics_set and foundry.graphics_set.working_visualisations then
        for _, viz in pairs(foundry.graphics_set.working_visualisations) do
            if viz.animation and viz.animation.draw_as_glow then
                viz.light = {
                    intensity = 0.3,
                    size = 12,
                    color = {r = 1.0, g = 0.3, b = 0.0}
                }
            end
        end
    end
end