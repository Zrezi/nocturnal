local constants = require("constants")

local nocturnal_prefix = constants.mod_path .. "/graphics/color_luts/"

for _, entry in pairs(data.raw["utility-constants"]["default"].daytime_color_lookup) do
    if entry[2]:find("^__core__/") then
        local filename = entry[2]:match("([^/]+)$")
        entry[2] = nocturnal_prefix .. filename
    end
end

for _, entry in pairs(data.raw["utility-constants"]["default"].zoom_to_world_daytime_color_lookup) do
    if entry[2]:find("^__core__/") then
        local filename = entry[2]:match("([^/]+)$")
        entry[2] = nocturnal_prefix .. filename
    end
end

if settings.startup["noct-disable-nightvision"].value then
    data.raw["night-vision-equipment"]["night-vision-equipment"].color_lookup = {{0.5,
                                                                                    constants.graphics(
        "color_luts/lut-nightvision.png")}}
end
