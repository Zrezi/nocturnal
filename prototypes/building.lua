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

    for name, lab in pairs(data.raw["lab"]) do
        if lab.graphics_set and lab.graphics_set.working_visualisations then
            table.insert(lab.graphics_set.working_visualisations, {
                type = "light",
                intensity = constants.lab_light_intensity,
                size = constants.lab_light_size,
                color = constants.lab_light_color
            })
        end
    end
end