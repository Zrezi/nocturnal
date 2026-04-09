local DIRECTION_LOOKUP = {defines.direction.north, defines.direction.northeast, defines.direction.east,
                          defines.direction.southeast, defines.direction.south, defines.direction.southwest,
                          defines.direction.west, defines.direction.northwest}
local SURFACES = {"nauvis"}

local labs = require("control/labs")

local function _initialize()
    for _, name in ipairs(SURFACES) do
        local s = game.surfaces[name]
        if s then
            s.daytime = 0.5
            s.freeze_daytime = true
        end
    end
    storage.flashlight_state = storage.flashlight_state or {}
    labs.initialize()
end
script.on_init(_initialize)
script.on_event(defines.events.on_cutscene_cancelled, _initialize)

local function _on_configuration_changed()
    _initialize()
    labs.initialize()
end
script.on_configuration_changed(_on_configuration_changed)

script.on_event(defines.events.on_player_created, _initialize)

if settings.startup["noct-enhance-labs"].value then
    script.on_nth_tick(5, labs.on_tick)
end

if settings.startup["noct-turn-toward-target"].value then
    script.on_event(defines.events.on_selected_entity_changed, function(event)
        local current_player = game.players[event.player_index]
        if current_player.render_mode ~= defines.render_mode.game then
            return
        end

        local selected_entity = current_player.selected
        local player_character = current_player.character
        local current_surface = current_player.surface

        if selected_entity and player_character and player_character.valid and current_surface.darkness >= 0.3 and
            not current_player.vehicle and not current_player.walking_state.walking then

            local radians_to_entity = math.atan2(current_player.position.x - selected_entity.position.x,
                selected_entity.position.y - current_player.position.y)

            local slot = math.floor((radians_to_entity / math.pi + 1) * 4 + 0.5) % 8
            local idx = slot + 1

            player_character.direction = DIRECTION_LOOKUP[idx]
        end
    end)
end

script.on_event("noct-flashlight-toggle", function(event)
    local player = game.players[event.player_index]
    local character = player.character

    if player.render_mode ~= defines.render_mode.game then
        if character and character.is_flashlight_enabled() then
            character.disable_flashlight()
        end
        return
    end

    if not character then
        return
    end

    local flashlightEnabled = character.is_flashlight_enabled()

    if flashlightEnabled then
        character.disable_flashlight()
        player.play_sound({
            path = "noct-sound-flashlight-on"
        })
    else
        character.enable_flashlight()
        player.play_sound({
            path = "noct-sound-flashlight-off"
        })
    end
end)

script.on_event(defines.events.on_tick, function()
    storage.flashlight_state = storage.flashlight_state or {}
    for _, player in pairs(game.players) do
        local state = storage.flashlight_state[player.index] or {}
        local current_mode = player.render_mode
        local previous_mode = state.previous_mode or current_mode

        if previous_mode == defines.render_mode.game and current_mode ~= defines.render_mode.game then
            state.was_on_before_map = player.character and player.character.valid and
                                          player.character.is_flashlight_enabled() or false
            state.in_map = true
            if player.character and player.character.is_flashlight_enabled() then
                player.character.disable_flashlight()
            end
        end

        if current_mode ~= defines.render_mode.game then
            if player.character and player.character.is_flashlight_enabled() then
                player.character.disable_flashlight()
            end
        end

        if previous_mode ~= defines.render_mode.game and current_mode == defines.render_mode.game then
            if state.in_map then
                if player.character then
                    if state.was_on_before_map then
                        player.character.enable_flashlight()
                    else
                        if player.character.is_flashlight_enabled() then
                            player.character.disable_flashlight()
                        end
                    end
                end
                state.in_map = false
                state.was_on_before_map = nil
            end
        end

        state.previous_mode = current_mode
        storage.flashlight_state[player.index] = state
    end
end)
