local constants = require("constants")

local PICTURE_LIGHT_SPOT = {
    filename = constants.graphics("light/light-spot.png"),
    priority = "extra-high",
    flags = {"light"},
    scale = 1,
    width = 512,
    height = 512
}

local PICTURE_LIGHT_SPOT_GLOW = {
    filename = constants.graphics("light/light-spot-glow.png"),
    priority = "extra-high",
    flags = {"light"},
    scale = 1,
    width = 512,
    height = 512
}

local function _update_car_lights(car)
    car.light = {}
    local halo = settings.startup["noct-vehicle-halo"].value
    if halo ~= "off" then
        table.insert(car.light, {
            shift = {0, -2},
            intensity = halo == "dark" and constants.intensity_dark or constants.intensity_bright,
            size = halo == "dark" and 13 or 19,
            color = constants.light_color_car
        })
    end
    table.insert(car.light, {
        type = "oriented",
        shift = {0, -4},
        intensity = 0.15,
        size = 3.2,
        color = constants.light_color_car,
        picture = PICTURE_LIGHT_SPOT_GLOW
    })
    table.insert(car.light, {
        type = "oriented",
        shift = {-0.35, -11.5},
        intensity = 0.9,
        size = 1.5,
        color = constants.light_color_car,
        picture = PICTURE_LIGHT_SPOT,
        source_orientation_offset = 0.99
    })
    table.insert(car.light, {
        type = "oriented",
        shift = {0.35, -11.5},
        intensity = 0.9,
        size = 1.5,
        color = constants.light_color_car,
        picture = PICTURE_LIGHT_SPOT,
        source_orientation_offset = 0.01
    })
end

local function _update_tank_lights(tank)
    tank.light = {}
    local halo = settings.startup["noct-vehicle-halo"].value
    if halo ~= "off" then
        table.insert(tank.light, {
            shift = {0, -2},
            intensity = halo == "dark" and constants.intensity_dark or constants.intensity_bright,
            size = halo == "dark" and 20 or 34,
            color = constants.light_color_tank
        })
    end
    table.insert(tank.light, {
        type = "oriented",
        shift = {0, -6},
        intensity = 0.15,
        size = 4.5,
        color = constants.light_color_tank,
        picture = PICTURE_LIGHT_SPOT_GLOW
    })
    table.insert(tank.light, {
        type = "oriented",
        shift = {-0.1, -15},
        intensity = 0.9,
        size = 2,
        color = constants.light_color_tank,
        picture = PICTURE_LIGHT_SPOT,
        source_orientation_offset = 0.985
    })
    table.insert(tank.light, {
        type = "oriented",
        shift = {0.1, -15},
        intensity = 0.9,
        size = 2,
        color = constants.light_color_tank,
        picture = PICTURE_LIGHT_SPOT,
        source_orientation_offset = 0.015
    })
end

for name, vehicle in pairs(data.raw.car) do
    if name == "car" then
        _update_car_lights(vehicle)
    elseif name == "tank" then
        _update_tank_lights(vehicle)
    end
end
