local constants = require("constants")

local pattern = "__core__"
local replace = constants.mod_path

for _, entry in pairs(data.raw["utility-constants"]["default"].daytime_color_lookup) do
    entry[2] = entry[2]:gsub(pattern, replace)
end

for _, entry in pairs(data.raw["utility-constants"]["default"].zoom_to_world_daytime_color_lookup) do
    entry[2] = entry[2]:gsub(pattern, replace)
end

if settings.startup["noct-disable-nightvision"].value then
    data.raw["night-vision-equipment"]["night-vision-equipment"].color_lookup = {{0.5,
                                                                                  constants.graphics(
        "color_luts/lut-nightvision.png")}}
end
