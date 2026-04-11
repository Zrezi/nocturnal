local constants = require("constants")

local PICTURE_LIGHT_SPOT_GLOW = {
    filename = constants.graphics("light/light-spot-glow.png"),
    priority = "extra-high",
    flags = {"light"},
    scale = 1,
    width = 512,
    height = 512
}

local spidertron = data.raw["spider-vehicle"]["spidertron"]

if spidertron and spidertron.graphics_set and spidertron.graphics_set.light then
    spidertron.graphics_set.light = {}

    local halo = settings.startup["noct-vehicle-halo"].value
    if halo ~= "off" then
        table.insert(spidertron.graphics_set.light, {
            shift = {0, 0},
            intensity = halo == "dark" and constants.intensity_dark or constants.intensity_bright,
            size = halo == "dark" and 22 or 34,
            color = constants.light_color_car
        })
    end

    table.insert(spidertron.graphics_set.light, {
        type = "oriented",
        shift = {0, -5},
        intensity = 0.2,
        size = 6,
        color = constants.light_color_car,
        picture = PICTURE_LIGHT_SPOT_GLOW
    })

    table.insert(spidertron.graphics_set.light, {
        color = {
            b = 0.4,
            g = 0.77,
            r = 1.0
        },
        intensity = 0.95,
        minimum_darkness = 0.3,
        picture = {
            filename = constants.graphics("light/light-flood.png"),
            flags = {
                "light"
            },
            height = 512,
            priority = "extra-high",
            scale = 1,
            width = 512
        },
        shift = {
            x = 0,
            y = -20
        },
        size = 2.8,
        source_orientation_offset = 0,
        type = "oriented"
    })

    table.insert(spidertron.graphics_set.light, {
        color = {
            b = 0.3,
            g = 0.77,
            r = 0.92
        },
        intensity = 0.7,
        minimum_darkness = 0.3,
        picture = {
            filename = constants.graphics("light/light-spot.png"),
            flags = {
                "light" 
            },
            height = 512,
            priority = "extra-high",
            scale = 1,
            width = 512
        },
        shift = {
            x = 0,
            y = -11.5
        },
        size = 1.55,
        source_orientation_offset = -0.05,
        type = "oriented"
    })

    table.insert(spidertron.graphics_set.light, {
        color = {
            b = 0.3,
            g = 0.77,
            r = 0.92
        },
        intensity = 0.7,
        minimum_darkness = 0.3,
        picture = {
            filename = constants.graphics("light/light-spot.png"),
            flags = {
                "light"
            },
            height = 512,
            priority = "extra-high",
            scale = 1,
            width = 512
        },
        shift = {
            x = 0,
            y = -8.5
        },
        size = 1.1,
        source_orientation_offset = 0.04,
        type = "oriented"
    })

    table.insert(spidertron.graphics_set.light, {
        color = {
            b = 0.3,
            g = 0.77,
            r = 0.92
        },
        intensity = 0.9,
        minimum_darkness = 0.3,
        picture = {
            filename = constants.graphics("light/light-spot.png"),
            flags = {
                "light"
            },
            height = 512,
            priority = "extra-high",
            scale = 1,
            width = 512
        },
        shift = {
            x = -1,
            y = -9
        },
        size = 1,
        source_orientation_offset = 0.08,
        type = "oriented"
    })
end