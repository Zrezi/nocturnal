local constants = require("constants")

for _, character in pairs(data.raw.character) do
    if character.light then
        character.light = {}
        local halo = settings.startup["noct-player-halo"].value
        if halo ~= "off" then
            table.insert(character.light, {
                minimum_darkness = 0,
                intensity = halo == "dark" and 0.12 or 0.3,
                size = 10 * (halo == "dark" and 1 or 1.5),
                shift = {0, -1},
                color = constants.light_color_character
            })
        end
        table.insert(character.light, {
            type = "oriented",
            minimum_darkness = 0,
            intensity = 0.15,
            size = 3.3,
            shift = {0, -5},
            color = constants.light_color_character,
            picture = {
                filename = constants.graphics("light/light-spot-glow.png"),
                priority = "extra-high",
                flags = {"light"},
                scale = 1,
                width = 512,
                height = 512
            }
        })
        table.insert(character.light, {
            type = "oriented",
            minimum_darkness = 0,
            intensity = 0.9,
            size = 1.6,
            shift = {0, -11.25},
            color = constants.light_color_character,
            picture = {
                filename = constants.graphics("light/light-spot.png"),
                priority = "extra-high",
                flags = {"light"},
                scale = 1,
                width = 512,
                height = 512
            }
        })
    end
end
