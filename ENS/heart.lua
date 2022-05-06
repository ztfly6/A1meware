local lua_ref = gui.Reference("Visuals", "World","Extra")
local lua_enable_heart_marker = gui.Checkbox(lua_ref, "damage_indicator_checkbox", "Enable Heart Indicators", true)
local lua_heart_marker_size = gui.Slider(lua_ref, "heart_marker_size", "Heart Size", 20, 1 , 100)
local lua_heart_marker_speed = gui.Slider(lua_ref, "heart_marker_speed", "Animation Speed", 3, 1 , 15)
local lua_heart_marker_time = gui.Slider(lua_ref, "heart_marker_time", "Time of Visibility", 250, 50, 800, 10)

local particles = {{}}
local shot_particle = {}

--hearts taked from purple cheat 
local red_heart =
{
    {{r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 0, g = 0, b = 0, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 255, g = 132, b = 135, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 136, g = 0, b = 21, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 0, g = 0, b = 0, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 136, g = 0, b = 21, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 136, g = 0, b = 21, a = 255}, {r = 0, g = 0, b = 0, a = 255}, },
    {{r = 0, g = 0, b = 0, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 136, g = 0, b = 21, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 0, g = 0, b = 0, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 136, g = 0, b = 21, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
}

local green_heart =
{
    {{r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 0, g = 0, b = 0, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 99, g = 228, b = 124, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 16, g = 92, b = 31, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 0, g = 0, b = 0, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 16, g = 92, b = 31, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 16, g = 92, b = 31, a = 255}, {r = 0, g = 0, b = 0, a = 255}, },
    {{r = 0, g = 0, b = 0, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 16, g = 92, b = 31, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 0, g = 0, b = 0, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 16, g = 92, b = 31, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
}

local yellow_heart =
{
    {{r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 0, g = 0, b = 0, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 249, g = 253, b = 96, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 149, g = 153, b = 2, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 0, g = 0, b = 0, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 149, g = 153, b = 2, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 149, g = 153, b = 2, a = 255}, {r = 0, g = 0, b = 0, a = 255}, },
    {{r = 0, g = 0, b = 0, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 149, g = 153, b = 2, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 0, g = 0, b = 0, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 149, g = 153, b = 2, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
}

local orange_heart =
{
    {{r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 249, g = 253, b = 96, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 193, g = 78, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 193, g = 78, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 193, g = 78, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, },
    {{r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 193, g = 78, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 193, g = 78, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
    {{r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
}

draw.Heart = function(heart_type, position_x, position_y, size, alpha)
    for i = 1, #heart_type, 1 do
        for j = 1, #heart_type[i], 1 do
            -- don't draw white background color
            if heart_type[j][i].r + heart_type[j][i].g + heart_type[j][i].b == 255 * 3 then
                draw.Color(heart_type[j][i].r, heart_type[j][i].g, heart_type[j][i].b, 0)
                draw.FilledRect(position_x + (j-1) * size, position_y + (i-1) * size, position_x + (j-1) * size + size, position_y + (i-1) * size + size)
            else
                draw.Color(heart_type[j][i].r, heart_type[j][i].g, heart_type[j][i].b, alpha)
                draw.FilledRect(position_x + (j-1) * size, position_y + (i-1) * size, position_x + (j-1) * size + size, position_y + (i-1) * size + size)
            end        
        end
    end
end


function Enemy_Hurted(GameEvent)
    if not entities:GetLocalPlayer() or not entities:GetLocalPlayer():IsAlive() then 
        return
    end
    if not lua_enable_heart_marker:GetValue() then
        lua_heart_marker_speed:SetInvisible(true)
        lua_heart_marker_time:SetInvisible(true)
        lua_heart_marker_size:SetInvisible(true)
    else
        lua_heart_marker_speed:SetInvisible(false)
        lua_heart_marker_time:SetInvisible(false)
        lua_heart_marker_size:SetInvisible(false)
    end

    local math_random_1 = math.random(1,10)
    local math_random_2 = math.random(1,10)
    local math_random_3 = math.random(1,10)
    if GameEvent then
        if GameEvent:GetName() == "player_hurt" then
            local user_id = GameEvent:GetInt("userid")
            local user = entities.GetByUserID(user_id)
            local user_index = entities.GetByUserID(user_id):GetIndex()
            local attacker_id = GameEvent:GetInt("attacker")
            local attacker = entities.GetByUserID(attacker_id)
            local attacker_index = entities.GetByUserID(attacker_id):GetIndex()
            local localplayer_index = entities:GetLocalPlayer():GetIndex()
            if attacker_index == localplayer_index and user_index ~=localplayer_index then

                local HitGround = GameEvent:GetInt("hitgroup")
                pos = user:GetHitboxPosition( HitGroup )
                if pos == nil then
                    pos = entities.GetAbsOrigin(user)
                    pos.z  = pos.z + 30
                end
                pos.x = pos.x - 10 + (math_random_1 * 5)
                pos.y  = pos.y - 10 + (math_random_2 * 5)
                pos.z  = pos.z  - 15 + (math_random_3 * 4)

                shot_particle = {}

                table.insert(shot_particle, pos.x)
                table.insert(shot_particle, pos.y)
                table.insert(shot_particle, pos.z)

                time = globals.TickCount() + lua_heart_marker_time:GetValue()
                table.insert(shot_particle, time)

                health = GameEvent:GetInt("health")
                table.insert(shot_particle, health)

                damage = GameEvent:GetInt("dmg_health")
                table.insert(shot_particle, damage)

                pos_hitmarker = user:GetHitboxPosition(  GameEvent:GetInt("hitgroup") )
                if pos_hitmarker == nil then
                    pos_hitmarker = entities.GetAbsOrigin(user)
                    pos_hitmarker.z  = pos_hitmarker.z + 30 
                end
                table.insert(shot_particle, pos_hitmarker.x)
                table.insert(shot_particle, pos_hitmarker.y)
                table.insert(shot_particle, pos_hitmarker.z)

                table.insert(particles, shot_particle)
            end
        end
    end
end
client.AllowListener("player_hurt");
callbacks.Register("FireGameEvent", Enemy_Hurted);
callbacks.Register("Draw", Enemy_Hurted);


function animation()
    if not entities:GetLocalPlayer() or not entities:GetLocalPlayer():IsAlive() then 
        return
    end
    for i = 1, #particles, 1 do
        if particles[i][1] ~= nil then
            local delta_time = particles[i][4] - globals.TickCount()
            if delta_time > 0 then
                particles[i][3] = particles[i][3] + (lua_heart_marker_speed:GetValue() / 10)
            end
        end
    end
end
callbacks.Register('CreateMove', animation) 


function render_hearts()
    if not entities:GetLocalPlayer() or not entities:GetLocalPlayer():IsAlive() then
        particles = {}
        timer = 0
    end
    for i = 1, #particles, 1 do
        if particles[i][1] ~= nil and particles[i][2] ~= nil and particles[i][3] ~= nil then
            position_x, position_y = client.WorldToScreen(Vector3(particles[i][1], particles[i][2], particles[i][3]))
            local timer = particles[i][4]  - globals.TickCount()
            health_remaining = particles[i][5]
            damage_health = particles[i][6]

            if timer > 255 then
                timer = 255
            end
            if timer > 0 then
                if  lua_enable_heart_marker:GetValue() and  position_x ~= nil and position_y~= nil then
                    if damage_health <= 25 then
                        draw.Heart(green_heart, position_x, position_y,  lua_heart_marker_size:GetValue()/10, timer)
                    elseif damage_health <= 50 then
                        draw.Heart(yellow_heart, position_x + 7, position_y + 7,  lua_heart_marker_size:GetValue()/10, timer)
                    elseif damage_health <= 75 then
                        draw.Heart(orange_heart, position_x + 7, position_y + 7, lua_heart_marker_size:GetValue()/10, timer)
                    else
                        draw.Heart(red_heart, position_x + 7, position_y  + 7,  lua_heart_marker_size:GetValue()/10, timer)
                    end
                end
            end
        end
    end
end
callbacks.Register('Draw', render_hearts)

