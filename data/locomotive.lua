local constants = require("constants")

for _, loco in pairs(data.raw["locomotive"]) do
    if loco then
        if loco.front_light then
            loco.front_light = {}

            local halo = settings.startup["noct-vehicle-halo"].value
            if halo ~= "off" then
                table.insert(loco.front_light, {
                    intensity = halo == "dark" and constants.intensity_dark or constants.intensity_bright,
                    size = halo == "dark" and 20 or 24,
                    color = constants.light_color_locomotive
                })
            end

            table.insert(loco.front_light, {
                type = "oriented",
                shift = {0, -12},
                minimum_darkness = 0.3,
                intensity = 0.15,
                size = 3,
                color = constants.light_color_locomotive,
                picture = {
                    filename = constants.graphics("light/light-flood-glow.png"),
                    priority = "extra-high",
                    flags = {"light"},
                    scale = 2,
                    width = 512,
                    height = 512
                }
            })

            table.insert(loco.front_light, {
                type = "oriented",
                shift = {-0.6, -24},
                minimum_darkness = 0.3,
                intensity = 0.9,
                size = 3,
                color = constants.light_color_locomotive,
                picture = {
                    filename = constants.graphics("light/light-flood.png"),
                    priority = "extra-high",
                    flags = {"light"},
                    scale = 1,
                    width = 512,
                    height = 512
                },
                source_orientation_offset = 0.99
            })

            table.insert(loco.front_light, {
                type = "oriented",
                shift = {0.6, -24},
                minimum_darkness = 0.3,
                intensity = 0.9,
                size = 3,
                color = constants.light_color_locomotive,
                picture = {
                    filename = constants.graphics("light/light-flood.png"),
                    priority = "extra-high",
                    flags = {"light"},
                    scale = 1,
                    width = 512,
                    height = 512
                },
                source_orientation_offset = 0.01
            })
        end

        if loco.stand_by_light then
            if loco.stand_by_light.intensity then
                loco.stand_by_light = {loco.stand_by_light}
            end
            local halo = settings.startup["noct-vehicle-halo"].value
            if halo ~= "off" then
                table.insert(loco.stand_by_light, {
                    intensity = halo == "dark" and constants.intensity_dark or constants.intensity_bright,
                    size = halo == "dark" and 20 or 24,
                    color = constants.light_color_locomotive
                })
            end
        end

        if loco.back_light then
            if loco.back_light.intensity then
                loco.back_light = {loco.back_light}
            end
            local halo = settings.startup["noct-vehicle-halo"].value
            if halo ~= "off" then
                table.insert(loco.back_light, {
                    intensity = halo == "dark" and constants.intensity_dark or constants.intensity_bright,
                    size = halo == "dark" and 20 or 24,
                    color = constants.light_color_locomotive
                })
            end
        end
    end
end
