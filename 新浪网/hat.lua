local lua_ref = gui.Reference("Visuals", "World","Extra")

local lua_chinese_hat = gui.Checkbox(lua_ref, "chinese_hat", "Enable Hat", true)
local lua_chinese_hat_color = gui.ColorPicker(lua_chinese_hat, "chinese_hat_color", "", 255, 255, 255, 200)
local lua_chinese_hat_color_round = gui.ColorPicker(lua_chinese_hat, "chinese_hat_color_round", "", 255, 255, 255, 125)
local lua_chinese_hat_size = gui.Slider(lua_ref, "chinese_hat_size", "Hat Size", 8, 1, 20)
local lua_chinese_hat_position_z = gui.Slider(lua_ref, "chinese_hat_position_z", "Position Z", 1, 0, 20)
local lua_chinese_hat_height = gui.Slider(lua_ref, "chinese_hat_height", "Hat Height", 6, 0, 20)
local lua_chinese_hat_rgb = gui.Checkbox(lua_ref, "chinese_hat_rgb ", "Rainbow Hat", false)
local lua_chinese_hat_rgb_speed = gui.Slider(lua_ref, "chinese_hat_rgb_speed", "RGB Speed", 0.035, 0.02, 0.5, 0.005)
local lua_chinese_hat_rgb_alpha = gui.Slider(lua_ref, "chinese_hat_rgb_alpha", "Rainbow Alpha Round", 60, 0, 255, 1)
local lua_chinese_hat_rgb_alpha_2 = gui.Slider(lua_ref, "chinese_hat_rgb_alpha_2", "Rainbow Alpha Circle", 255, 0, 255, 1)

local function RaibowColor(Step, Speed)
    local r = math.floor(math.sin(Step * Speed) * 127 + 128)
    local g = math.floor(math.sin(Step * Speed + 2) * 127 + 128)
    local b = math.floor(math.sin(Step * Speed + 4) * 127 + 128)
    local a = lua_chinese_hat_rgb_alpha:GetValue()
    return r, g, b, a;
end

local function RaibowColor_2(Step, Speed)
    local r = math.floor(math.sin(Step * Speed) * 127 + 128)
    local g = math.floor(math.sin(Step * Speed + 2) * 127 + 128)
    local b = math.floor(math.sin(Step * Speed + 4) * 127 + 128)
    local a = lua_chinese_hat_rgb_alpha_2:GetValue()
    return r, g, b, a;
end

draw.ChineseHat = function(color, color_2, size, extra_z, height)
local local_entity = entities:GetLocalPlayer()

if not local_entity or not local_entity:IsAlive() then 
        return
    end

local hat_center = local_entity:GetHitboxPosition(0)

local hat_up_position = {  client.WorldToScreen(Vector3(hat_center.x, hat_center.y, hat_center.z + extra_z + height))}

for i = 1, 360, 1 do

local old_position_x = nil
local old_position_y = nil

local current_position_x = nil
local current_position_y = nil

current_position_x, current_position_y = client.WorldToScreen(Vector3(hat_center.x + math.sin(math.rad(i)) * size, hat_center.y + math.cos(math.rad(i)) * size, hat_center.z + extra_z))

old_position_x, old_position_y = client.WorldToScreen(Vector3(hat_center.x + math.sin(math.rad(i - 1)) * size, hat_center.y + math.cos(math.rad(i - 1)) * size, hat_center.z + extra_z))

if lua_chinese_hat_rgb:GetValue() then
draw.Color(RaibowColor_2(i, lua_chinese_hat_rgb_speed:GetValue()))
else
draw.Color(color[1], color[2], color[3], color[4])
end

draw.Line(current_position_x, current_position_y, old_position_x, old_position_y)

if lua_chinese_hat_rgb:GetValue() then
draw.Color(RaibowColor(i, lua_chinese_hat_rgb_speed:GetValue()))
else
draw.Color(color_2[1], color_2[2], color_2[3], color_2[4])
end

draw.Line(current_position_x, current_position_y, hat_up_position[1], hat_up_position[2])
end
end

local function ui()
if not lua_chinese_hat_rgb:GetValue() then
lua_chinese_hat_rgb_speed:SetInvisible(true)
lua_chinese_hat_rgb_alpha:SetInvisible(true)
lua_chinese_hat_rgb_alpha_2:SetInvisible(true)
else
lua_chinese_hat_rgb_speed:SetInvisible(false)
lua_chinese_hat_rgb_alpha:SetInvisible(false)
lua_chinese_hat_rgb_alpha_2:SetInvisible(false)
end
end
callbacks.Register('Draw', ui) 

function draw_hat( ... )
local local_entity = entities:GetLocalPlayer()

if not local_entity or not local_entity:IsAlive() then 
        return
    end

if lua_chinese_hat:GetValue() then
if gui.GetValue("esp.local.thirdperson") then
draw.ChineseHat({lua_chinese_hat_color:GetValue()}, {lua_chinese_hat_color_round:GetValue()}, lua_chinese_hat_size:GetValue(), lua_chinese_hat_position_z:GetValue(), lua_chinese_hat_height:GetValue())
end
end
end
callbacks.Register('Draw', draw_hat)
