local constants = require("constants")

local enhance_buildings = settings.startup["noct-enhance-buildings"].value

if enhance_buildings then
    for name, silo in pairs(data.raw["rocket-silo"]) do
        if silo.base_engine_light and silo.base_engine_light.size == 25 then
            silo.base_engine_light.size = constants.rocket_silo_light_size
            silo.base_engine_light.color = constants.rocket_silo_light_color
        end
    end

    for name, rocket in pairs(data.raw["rocket-silo-rocket"]) do
        if rocket.glow_light and rocket.glow_light.size == 30 then
            rocket.glow_light.size = constants.rocket_glow_light_size
            rocket.glow_light.color = constants.rocket_glow_light_color
            rocket.glow_light.shift = {0, 2.0}
        end
    end

    local refinery = data.raw["assembling-machine"]["oil-refinery"]
    if refinery and refinery.graphics_set and refinery.graphics_set.working_visualisations then
        for _, viz in pairs(refinery.graphics_set.working_visualisations) do
            if viz.animation and viz.animation.draw_as_glow then
                viz.light = {
                    intensity = constants.oil_refinery_light_intensity,
                    size = constants.oil_refinery_light_size,
                    color = constants.oil_refinery_light_color
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
                    intensity = constants.oil_refinery_light_intensity,
                    size = constants.oil_refinery_light_size,
                    color = constants.oil_refinery_light_color
                }
                viz.effect = 'uranium-glow'
            end
        end
    end
end