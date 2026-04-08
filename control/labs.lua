local constants = require("constants")

local M = {}

local function _get_storage()
    storage.lab_lights = storage.lab_lights or {}
    storage.lab_light_initial_ticks = storage.lab_light_initial_ticks or {}
    return storage.lab_lights
end

function M.initialize()
    if not settings.startup["noct-enhance-labs"].value then
        local lab_lights = storage.lab_lights or {}
        for pos_key, light_entity in pairs(lab_lights) do
            if light_entity and light_entity.valid then
                light_entity.destroy()
            end
        end
        storage.lab_lights = {}
        storage.lab_light_initial_ticks = {}
        return
    end
    _get_storage()
end

function M.on_tick()
    if not settings.startup["noct-enhance-labs"].value then
        return
    end
    
    local lab_lights = _get_storage()
    
    local force_research_cache = {}
    for _, force in pairs(game.forces) do
        local research = force.current_research
        if research then
            local required = {}
            for _, ingredient in pairs(research.research_unit_ingredients) do
                required[ingredient.name] = true
            end
            force_research_cache[force.name] = required
        end
    end
    
    local active_labs = {}
    
    for _, surface in pairs(game.surfaces) do
        local labs = surface.find_entities_filtered({type = "lab"})
        
        for _, lab in pairs(labs) do
            local pos_key = string.format("%d,%d,%s", lab.position.x, lab.position.y, surface.name)
            local light_entity = lab_lights[pos_key]
            local force_name = lab.force.name
            local has_queued_tech = force_research_cache[force_name] ~= nil
            
            local has_all_science = false
            if has_queued_tech then
                local inventory = lab.get_inventory(defines.inventory.lab_input)
                if inventory then
                    has_all_science = true
                    for required_item, _ in pairs(force_research_cache[force_name]) do
                        if inventory.get_item_count(required_item) == 0 then
                            has_all_science = false
                            break
                        end
                    end
                end
            end
            
            local is_actively_researching = lab.active and has_all_science and has_queued_tech and lab.energy > 0
            
            active_labs[pos_key] = true
            
if is_actively_researching and not light_entity then
                  light_entity = surface.create_entity({
                      name = "noct-lab-light",
                      position = lab.position,
                      force = lab.force
                  })
                  if light_entity then
                      lab_lights[pos_key] = light_entity
                      storage.lab_light_initial_ticks[pos_key] = game.tick
                  end
              elseif not is_actively_researching and light_entity then
                 if light_entity.valid then
                     light_entity.destroy()
                 end
                 lab_lights[pos_key] = nil
                 storage.lab_light_initial_ticks[pos_key] = nil
             end
            
            if light_entity and light_entity.valid and is_actively_researching then
                local initial_tick = storage.lab_light_initial_ticks[pos_key]
                if not initial_tick then
                    initial_tick = game.tick
                    storage.lab_light_initial_ticks[pos_key] = initial_tick
                end
                local lights = {"noct-lab-light", "noct-lab-light-dim", "noct-lab-light-ultra-dim"}
                local random_index = math.random(1, 3)
                local current_type = lights[random_index]
                
                if light_entity.name ~= current_type then
                    local pos = light_entity.position
                    light_entity.destroy()
                    light_entity = surface.create_entity({
                        name = current_type,
                        position = pos,
                        force = lab.force
                    })
                    if light_entity then
                        lab_lights[pos_key] = light_entity
                    end
                end
            end
        end
    end
    
    for pos_key, light_entity in pairs(lab_lights) do
        if not active_labs[pos_key] and light_entity and light_entity.valid then
            light_entity.destroy()
            lab_lights[pos_key] = nil
            storage.lab_light_initial_ticks[pos_key] = nil
        end
    end
end

return M
