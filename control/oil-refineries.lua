local constants = require("constants")

local M = {}
local LIGHT_NAME = "noct-oil-refinery-light"

local PLUME_OFFSETS = {
    [defines.direction.north] = {x = 1, y = -1.5},
    [defines.direction.east] = {x = -1.65, y = -1.9},
    [defines.direction.south] = {x = -1.8, y = -2.35},
    [defines.direction.west] = {x = 1.35, y = -1.1}
}

local function is_actively_crafting(refinery, prev_progress)
    if not refinery.is_crafting() then
        return false
    end
    
    local curr_progress = refinery.crafting_progress or 0
    
    if prev_progress == nil then
        return true
    elseif curr_progress > prev_progress then
        return true
    elseif curr_progress < prev_progress and curr_progress > 0 then
        return true
    end
    
    return false
end

function M.initialize()
    if not settings.startup["noct-enhance-buildings"].value then
        storage.oil_refinery_lights = {}
        storage.oil_refinery_progress = {}
        return
    end
    
    storage.oil_refinery_lights = storage.oil_refinery_lights or {}
    storage.oil_refinery_progress = storage.oil_refinery_progress or {}
    
    for key, data in pairs(storage.oil_refinery_lights) do
        if type(data) == "table" then
            if not data.entity or not data.entity.valid then
                storage.oil_refinery_lights[key] = nil
                storage.oil_refinery_progress[key] = nil
            end
        elseif type(data) == "userdata" and not data.valid then
            storage.oil_refinery_lights[key] = nil
            storage.oil_refinery_progress[key] = nil
        end
    end
end

function M.on_tick()
   if not settings.startup["noct-enhance-buildings"].value then
        return
    end
    
    storage.oil_refinery_lights = storage.oil_refinery_lights or {}
    storage.oil_refinery_progress = storage.oil_refinery_progress or {}
    
    local active_refineries = {}
    
    for _, surface in pairs(game.surfaces) do
        local refineries = surface.find_entities_filtered({name = "oil-refinery"})
        
        for _, refinery in pairs(refineries) do
            local pos_key = string.format("%d,%d,%s", refinery.position.x, refinery.position.y, surface.name)
            local light_data = storage.oil_refinery_lights[pos_key]
            local prev_progress = storage.oil_refinery_progress[pos_key]
            local curr_direction = refinery.direction
            
            local actively_crafting = is_actively_crafting(refinery, prev_progress)
            
            storage.oil_refinery_progress[pos_key] = refinery.crafting_progress or 0
            active_refineries[pos_key] = true
            
            if actively_crafting then
                if not light_data then
                    local offset = PLUME_OFFSETS[curr_direction]
                    local light = surface.create_entity({
                        name = LIGHT_NAME,
                        position = {
                            x = refinery.position.x + offset.x,
                            y = refinery.position.y + offset.y
                        },
                        force = refinery.force
                    })
                    if light then
                        storage.oil_refinery_lights[pos_key] = {entity = light}
                    end
                elseif type(light_data) == "userdata" then
                    storage.oil_refinery_lights[pos_key] = {entity = light_data}
                end
            else
                if light_data then
                    local entity = type(light_data) == "table" and light_data.entity or light_data
                    if entity and entity.valid then
                        entity.destroy()
                    end
                    storage.oil_refinery_lights[pos_key] = nil
                end
            end
        end
    end
    
    for pos_key, light_data in pairs(storage.oil_refinery_lights) do
        if not active_refineries[pos_key] then
            local entity = type(light_data) == "table" and light_data.entity or light_data
            if entity and entity.valid then
                entity.destroy()
            end
            storage.oil_refinery_lights[pos_key] = nil
            storage.oil_refinery_progress[pos_key] = nil
        end
    end
end

function M.on_player_rotated_entity(event)
    if not settings.startup["noct-enhance-buildings"].value then
        return
    end
    
    local entity = event.entity
    if not entity.valid or entity.name ~= "oil-refinery" then
        return
    end
    
    local pos_key = string.format("%d,%d,%s", entity.position.x, entity.position.y, entity.surface.name)
    local light_data = storage.oil_refinery_lights[pos_key]
    
    if light_data then
        local light = type(light_data) == "table" and light_data.entity or light_data
        if light and light.valid then
            light.destroy()
        end
        storage.oil_refinery_lights[pos_key] = nil
    end
    
    local prev_progress = storage.oil_refinery_progress[pos_key]
    
    if not is_actively_crafting(entity, prev_progress) then
        return
    end
    
    local offset = PLUME_OFFSETS[entity.direction]
    local light = entity.surface.create_entity({
        name = LIGHT_NAME,
        position = {
            x = entity.position.x + offset.x,
            y = entity.position.y + offset.y
        },
        force = entity.force
    })
    
    if light then
        storage.oil_refinery_lights[pos_key] = {entity = light}
    end
end

return M
