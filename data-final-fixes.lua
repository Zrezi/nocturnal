if settings.startup["noct-hide-enemies-from-map"].value then
    for _, unit_name in pairs({"unit", "spider-unit", "spider-leg", "segment", "segmented-unit"}) do
        local units = data.raw[unit_name]
        if not units then return end
        for name, unit in pairs(units) do
            if unit.flags then
                table.insert(unit.flags, "not-on-map")
            end
        end
    end
end

if data.raw["planet"] then
    local constants = require("constants")
    local nocturnal_prefix = constants.mod_path .. "/graphics/color_luts/"
    
    local night_luts = {
        vulcanus = {"vulcanus-2-night.png"},
        gleba = {"gleba-5-after-sunset.png", "gleba-6-before-dawn.png"},
        fulgora = {"fulgora-3-after-sunset.png", "fulgora-4-before-dawn.png"}
    }
    
    for _, planet_name in pairs({"vulcanus", "gleba", "fulgora", "aquilo"}) do
        local planet = data.raw["planet"][planet_name]
        if planet and planet.surface_render_parameters and planet.surface_render_parameters.day_night_cycle_color_lookup then
            for _, entry in pairs(planet.surface_render_parameters.day_night_cycle_color_lookup) do
                local filename = entry[2]:match("([^/]+)$")
                if night_luts[planet_name] then
                    for _, night_filename in ipairs(night_luts[planet_name]) do
                        if filename == night_filename then
                            entry[2] = nocturnal_prefix .. filename
                        end
                    end
                end
            end
        end
    end
end
