
local function require(name, url)
    package = package or {}

    package.loaded = package.loaded or {}

    package.loaded[name] =
        package.loaded[name] or RunScript(name .. ".lua") or
        http.Get(
            url,
            function(body)
                file.Write(name .. ".lua", body)
            end
        )

    return package.loaded[name] or error("unable to load module " .. name .. " ( try to reload )", 2)
end


local function menu_weapon(var)
    local w = var:match("%a+"):lower()
    local w = w:find("heavy") and "hpistol" or w:find("auto") and "asniper" or w:find("submachine") and "smg" or w:find("light") and "lmg" or w
    return w
end

local ui = {}
ui.ref = gui.Reference("visuals", "other", "extra")
ui.multi_box = gui.Multibox(ui.ref, "Indicators")
ui.multi_box:SetDescription("Indicator shown on the left.")

ui.option = {
    gui.Checkbox(ui.multi_box, "indicators.ct", "Custom", 1),
    gui.Checkbox(ui.multi_box, "indicators.lr", "Legit / Rage", 1),
    gui.Checkbox(ui.multi_box, "indicators.af", "Auto fire", 1),
    gui.Checkbox(ui.multi_box, "indicators.fov", "FOV", 1),
    gui.Checkbox(ui.multi_box, "indicators.hc", "Hit Chance", 1),
    gui.Checkbox(ui.multi_box, "indicators.dmg", "Min Damage", 1),
    gui.Checkbox(ui.multi_box, "indicators.aw", "Auto Wall", 1),
    gui.Checkbox(ui.multi_box, "indicators.fl", "Fakelag", 1),
    gui.Checkbox(ui.multi_box, "indicators.fd", "Fake Duck", 1),
    gui.Checkbox(ui.multi_box, "indicators.dt", "Double tap", 1),
    gui.Checkbox(ui.multi_box, "indicators.lc", "Lag Compensation", 1),
    gui.Checkbox(ui.multi_box, "indicators.bomb", "Bomb Info", 1),
    gui.Checkbox(ui.multi_box, "indicators.onshot", "Onshot", 1),
    gui.Checkbox(ui.multi_box, "indicators.fires", "Missed / Hit", 1),
    gui.Checkbox(ui.multi_box, "indicators.backtrack", "BackTrack", 1),
    gui.Checkbox(ui.multi_box, "indicators.ping", "Ping", 1),
    gui.Checkbox(ui.multi_box, "indicators.aa", "AA", 1),
}


ui.edit_box = gui.Editbox(ui.ref, "indicators.custom.text", "Custom indicators")
ui.edit_box:SetDescription("Custom indicator text.")
ui.edit_box:SetValue("LQZ - Aimware")
ui.edit_box:SetHeight(45)
ui.option.clr = {}
for i = 1, #ui.option do
    ui.option.clr[i] = gui.ColorPicker(ui.option[i], "clr", "clr", 255, 255, 255, 255)
end

local origin_records = {}
local globals_CurTime, globals_TickInterval = globals.CurTime, globals.TickInterval
local math_floor = math.floor

local function time_to_ticks(a)
    return math_floor(1 + a / globals_TickInterval())
end

local function on_create_move(cmd)
    local lp = entities.GetLocalPlayer()
    if not (lp and lp:IsAlive()) then
        return
    end
    if ui.option[11]:GetValue() then
        if cmd.sendpacket then
            origin_records[#origin_records + 1] = lp:GetAbsOrigin()
        end
    end
end
local plant_time = globals.RealTime()
local planted = false
local aim_fire = false
local stats = {
    total_shots = 0,
    hits = 0
}

local aimtarget = nil

callbacks.Register( "AimbotTarget", function(target)

    if target:GetIndex() then
        aimtarget = target
    else
        aimtarget = nil
    end
end)
client.AllowListener( "bomb_planted" )
client.AllowListener( "bomb_exploded" )
client.AllowListener("weapon_fire")
client.AllowListener("player_hurt")
client.AllowListener("player_connect_full")

local function on_event(event)
    if not (event) then
        return
    end
    
    local en = event:GetName()

    if en == "bomb_planted" then
        plant_time = globals.RealTime()
        planted = true
    end

    if en == "bomb_exploded" then
        planted = false
    end

    local lp_idx = client.GetLocalPlayerIndex()
    local attacker = client.GetPlayerIndexByUserID(event:GetInt("attacker"))
    local userid = client.GetPlayerIndexByUserID(event:GetInt("userid"))

    if aimtarget then
        stats.total_shots = en == "weapon_fire" and userid == lp_idx and stats.total_shots + 1 or stats.total_shots
        stats.hits = en == "player_hurt" and attacker == lp_idx and userid ~= lp_index and stats.hits + 1 or stats.hits
    end

    if en == "player_connect_full" then
        if lp_idx == userid then
            stats.total_shots = 0
            stats.hits = 0
        end
    end
end

local function RenderCircular(x,y,radius,thickness,degreemin,degreemax,mm)
    local lx,ly = nil,nil
    local fornumber = 360 / mm
    for i = degreemin - fornumber,degreemax,fornumber do
        local x1 = x + math.cos(math.rad(i)) * radius
        local y1 = y + math.sin(math.rad(i)) * radius

        local x2 = x + math.cos(math.rad(i + fornumber)) * radius
        local y2 = y + math.sin(math.rad(i + fornumber)) * radius

        local x3 = x + math.cos(math.rad(i + fornumber / 2)) * (radius + thickness)
        local y3 = y + math.sin(math.rad(i + fornumber / 2)) * (radius + thickness)

       
        draw.Triangle( x1, y1, x2, y2, x3, y3 )

        if lx and ly  then
            draw.Triangle( x3, y3, lx, ly, x1, y1 )
        end
        
        lx,ly = x3,y3
    end
end

local function BombDamage(Bomb, Player)

    local playerOrigin = Player:GetAbsOrigin()
    local bombOrigin = Bomb:GetAbsOrigin()

	local C4Distance = math.sqrt((bombOrigin.x - playerOrigin.x) ^ 2 + 
	(bombOrigin.y - playerOrigin.y) ^ 2 + 
	(bombOrigin.z - playerOrigin.z) ^ 2);

	local Gauss = (C4Distance - 75.68) / 789.2
	local flDamage = 450.7 * math.exp(-Gauss * Gauss);

		if Player:GetProp("m_ArmorValue") > 0 then

			local flArmorRatio = 0.5;
			local flArmorBonus = 0.5;

			if Player:GetProp("m_ArmorValue") > 0 then
			
				local flNew = flDamage * flArmorRatio;
				local flArmor = (flDamage - flNew) * flArmorBonus;
			 
				if flArmor > Player:GetProp("m_ArmorValue") then
				
					flArmor = Player:GetProp("m_ArmorValue") * (1 / flArmorBonus);
					flNew = flDamage - flArmor;
					
				end
			 
			flDamage = flNew;

			end

		end 
		
	return math.max(flDamage, 0);
	
end

local function on_draw()
    local lp = entities.GetLocalPlayer()
    
    if not lp or not lp:IsAlive() then
        return
    end

    local lbot = gui.GetValue("lbot.master")
    local rbot = gui.GetValue("rbot.master")

    if ui.option[17]:GetValue() then

        local r,g,b,a = ui.option.clr[17]:GetValue()
        local rot_ang = gui.GetValue( "rbot.antiaim.base.rotation" )
        local y = draw.indicator(r,g,b,a,"AA" )

        draw.Color( 0,0,0,120 )
        draw.FilledRect( 12, y + 22, 44, y + 25 )
        draw.Color( r,g,b,a )
        if rot_ang > 0 then
            draw.FilledRect( 12, y + 22, 28, y + 25 )
        else
            draw.FilledRect( 28, y + 22, 44 , y + 25 )
        end

    end

    if ui.option[16]:GetValue() then
        
        local delay = entities.GetPlayerResources():GetPropInt("m_iPing",client.GetLocalPlayerIndex())

        local r,g,b,a = ui.option.clr[16]:GetValue()

        if delay > 100 then
            r,g,b = 255,0,0
        elseif delay > 90 then
            r,g,b = 255,255,0
        end

        draw.indicator(r,g,b,a,"PING" )
    end

    if ui.option[15]:GetValue() then
        if gui.GetValue( "misc.fakelatency.enable" ) then
            local r,g,b,a = ui.option.clr[15]:GetValue()

            draw.indicator(r,g,b,a,"BT")
        end
    end

    if ui.option[14]:GetValue() then
        local r, g, b, a = ui.option.clr[14]:GetValue()

        local shotsstring = string.format("%s / %s ( %s",stats.hits,stats.total_shots,
        string.format("%.1f", stats.total_shots ~= 0 and (stats.hits / stats.total_shots * 100) or 0))

        draw.indicator(r,g,b,a,shotsstring .. "% )")
    end

    if ui.option[13]:GetValue() then
        if gui.GetValue( "rbot.antiaim.condition.shiftonshot" ) then
            local r,g,b,a = ui.option.clr[13]:GetValue()

            draw.indicator(r,g,b,a,"HD")
        end
    end

    if ui.option[12]:GetValue() and planted then
        local bomb = entities.FindByClass( "CPlantedC4" )

            local entity = bomb[1]
            if entity then
                local site = entity:GetPropInt("m_nBombSite")

                if site == 0 then
                    site = "A"
                else
                    site = "B"
                end

                local blowtime = 40 - (globals.RealTime() - plant_time)

                local r,g,b,a = ui.option.clr[12]:GetValue()

                local r1,g1,b1 = r,g,b
                local dmg = math.floor(BombDamage(entity,lp))

                local text = "- HP: " .. dmg
                    r1,g1,b1 = 255,0,0
                if dmg >= lp:GetHealth() then
                    r1,g1,b1 = 255,0,0
                    text = "FATAL"
                end

                draw.indicator(r, g, b, a, site .. " - " .. string.format("%.2f",blowtime) .. " s ")
                draw.indicator(r1,g1,b1,a, text )
            end  
    end

    if ui.option[11]:GetValue() and origin_records[1] and origin_records[2] then
        local r, g, b, a = ui.option.clr[11]:GetValue()
        local delta =
            Vector3(origin_records[2].x - origin_records[1].x, origin_records[2].y - origin_records[1].y, origin_records[2].z - origin_records[1].z)
        if delta:Length2D() ^ 2 > 4096 then
            draw.indicator(r, g, b, a, "LC")
        end
        if origin_records[3] then
            table.remove(origin_records, 1)
        end
    end

    if ui.option[10]:GetValue() then
        local weapon = menu_weapon(gui.GetValue("rbot.accuracy.weapon"))
        local dt_pcall = pcall(gui.GetValue, "rbot.accuracy.weapon." .. weapon .. ".doublefire")

        if dt_pcall and gui.GetValue("rbot.accuracy.weapon." .. weapon .. ".doublefire") == 1 then
            local m_flNextSecondaryAttack = lp:GetPropEntity("m_hActiveWeapon"):GetPropFloat("LocalActiveWeaponData", "m_flNextSecondaryAttack")
            local r, g, b, a = ui.option.clr[10]:GetValue()
            if m_flNextSecondaryAttack > globals_CurTime() + 0.03 then
                r, g, b, a = 255, 0, 0, 255
            end
            draw.indicator(r, g, b, a, "DT")
        end
    end

    if ui.option[9]:GetValue() then
        local fakecrouchkey = gui.GetValue("rbot.antiaim.extra.fakecrouchkey")
        if fakecrouchkey ~= 0 and input.IsButtonDown(fakecrouchkey) then
            local r, g, b, a = ui.option.clr[9]:GetValue()
            draw.indicator(r, g, b, a, "DUCK")
        end
    end

    if ui.option[8]:GetValue() then
        local r, g, b, a = ui.option.clr[8]:GetValue()

        local fl = gui.GetValue( "misc.fakelag.factor" )
        local y = draw.indicator(r, g, b, a, "FL ")

        draw.Color( 0,0,0,120 )
        RenderCircular(50,y + 8,6,5,0,360,60)

        draw.Color( r, g, b, a )
        RenderCircular(50,y + 8,6,4,0,fl * 360 / 17,60)
    end

    if ui.option[7]:GetValue() and gui.GetValue("rbot.hitscan.mode." .. menu_weapon(gui.GetValue("rbot.hitscan.mode")) .. ".autowall") then
        local r, g, b, a = ui.option.clr[7]:GetValue()
        draw.indicator(r, g, b, a, "AW")
    end

    if ui.option[6]:GetValue() then
        local r, g, b, a = ui.option.clr[6]:GetValue()
        local weapon = menu_weapon(gui.GetValue("rbot.accuracy.weapon"))
        if weapon == "knife" then
            return
        end
        local text = gui.GetValue("rbot.accuracy.weapon." .. weapon .. ".mindmg")
        draw.indicator(r, g, b, a, "" .. ((text > 100) and ("HP+" .. (text - 100)) or text))
    end

    if ui.option[5]:GetValue() then
        local r, g, b, a = ui.option.clr[5]:GetValue()
        local weapon = menu_weapon(gui.GetValue("rbot.accuracy.weapon"))
        local text = gui.GetValue("rbot.accuracy.weapon." .. weapon .. ".hitchance")
        draw.indicator(r, g, b, a, "" .. text)
    end

    if ui.option[4]:GetValue() then
        local r, g, b, a = ui.option.clr[4]:GetValue()
        local weapon = menu_weapon(gui.GetValue("lbot.weapon.target"))
        local text =
            lbot and ("%.1f"):format(gui.GetValue("lbot.weapon.target." .. weapon .. ".maxfov")) or rbot and gui.GetValue("rbot.aim.target.fov")
        draw.indicator(r, g, b, a, text .. " °")
    end

    if ui.option[3]:GetValue() and ((lbot and gui.GetValue("lbot.aim.autofire")) or (rbot and gui.GetValue("rbot.aim.enable"))) then
        local r, g, b, a = ui.option.clr[3]:GetValue()
        draw.indicator(r, g, b, a, "AF")
    end

    if ui.option[2]:GetValue() then
        local r, g, b, a = ui.option.clr[2]:GetValue()
        local text = lbot and "Legit" or rbot and "Rage"
        draw.indicator(r, g, b, a, text)
    end

    ui.edit_box:SetInvisible(not ui.option[1]:GetValue())
    if ui.option[1]:GetValue() then
        local r, g, b, a = ui.option.clr[1]:GetValue()
        local text = ui.edit_box:GetValue()
        draw.indicator(r, g, b, a, text)
    end
end

callbacks.Register( "FireGameEvent" , on_event )
callbacks.Register("CreateMove", on_create_move)
callbacks.Register("Draw", on_draw)


local ref = ui.ref
local chk = gui.Checkbox( ref, "antiaim_angle_indicator.chk", "AA指示器", true )
local type = gui.Multibox( ref, "类型" )

local circular = gui.Checkbox( type, "antiaim_angle_indicator.circular", "半圆", true )
local triangle = gui.Checkbox( type, "antiaim_angle_indicator.triangle", "三角", false )
local line = gui.Checkbox( type, "antiaim_angle_indicator.arrow", "箭头", false )

local radius = gui.Slider( ref, "antiaim_angle_indicator.radius", "半圆半径", 4, 1, 30 )
local radius_fake = gui.Slider( ref, "antiaim_angle_indicator.radius_fake", "半圆假身半径", 18, 1, 30 )
local thickness = gui.Slider( ref, "antiaim_angle_indicator.thickness", "半圆边缘", 5, 1, 15 )
local fakespread = gui.Slider(ref, "antiaim_angle_indicator.outlinelength", "半圆外围长度", 25, 0, 90)
local bg_color = gui.ColorPicker( ref, "antiaim_angle_indicator.bgcolor", "半圆背景显示颜色", 0,0,0,120 )
local base_color = gui.ColorPicker( ref, "antiaim_angle_indicator.basecolor", "半圆假身显示颜色", 255,255,255,255 )
local rotation_color = gui.ColorPicker( ref, "antiaim_angle_indicator.rotationcolor", "半圆真身显示颜色", 220,220,220,150 )

local triangle_color = gui.ColorPicker( ref, "antiaim_angle_indicator.triangle.color", "三角颜色", 255,255,255,220 )
local triangle_color1 = gui.ColorPicker( ref, "antiaim_angle_indicator.triangle.breathecolor", "三角呼吸颜色", 255,255,255,220 )
local triangle_breathespeed = gui.Slider( ref, "antiaim_angle_indicator.triangle.breathespeed", "三角呼吸速度", 0, 0, 10 )
local triangle_gap = gui.Slider( ref, "antiaim_angle_indicator.triangle.gap", "三角间隔", 30, 0, 200 )
local triangle_size = gui.Slider( ref, "antiaim_angle_indicator.triangle.size", "三角大小", 10, 1, 50 )

local line_size = gui.Slider( ref, "antiaim_angle_indicator.line.size", "箭头大小", 10, 1, 50 )
local line_gap = gui.Slider( ref, "antiaim_angle_indicator.line.gap", "箭头间隔", 10, 1, 100 )
local line_spread_angle = gui.Slider( ref, "antiaim_angle_indicator.lines.angle", "箭头开口角度", 45, 0, 90 )
local line_thickness = gui.Slider( ref, "antiaim_angle_indicator.lines.thickness", "箭头粗细", 2, 1, 18 )

local line_color = gui.ColorPicker( ref, "antiaim_angle_indicator.line.color", "箭头真身颜色", 255,255,255,255 )
local line_color1 = gui.ColorPicker( ref, "antiaim_angle_indicator.line.fakecolor", "箭头假身颜色", 255,255,0,255 )

local yaw = nil
callbacks.Register( "CreateMove", function(c)
    if entities.GetLocalPlayer() and entities.GetLocalPlayer():IsAlive() and chk:GetValue() and gui.GetValue( "rbot.master" ) then
        if c.sendpacket then
            yaw = c.viewangles.yaw
        end
    end
end)

local alpha = 0
local add = 1
local function OnDraw()
    local lplayer = entities.GetLocalPlayer()
    if not lplayer or not lplayer:IsAlive() or not chk:GetValue() or not gui.GetValue( "rbot.master" ) then
        return
    end

    local weapon_inc = lplayer:GetWeaponInaccuracy() * 300

    local AngleBase = nil
    local AngleReal = gui.GetValue("rbot.antiaim.base.rotation")
    
        if yaw ~= nil then
            AngleBase = (yaw - engine.GetViewAngles().yaw) * -1 - 90
        end
        
        local w,h = draw.GetScreenSize()
        local x,y = w / 2,h / 2

        if AngleBase ~= nil then


            radius:SetInvisible(true)
            radius_fake:SetInvisible(true)
            thickness:SetInvisible(true)
            fakespread:SetInvisible(true)
            bg_color:SetInvisible(true)
            base_color:SetInvisible(true)
            rotation_color:SetInvisible(true)
            triangle_gap:SetInvisible(true)
            triangle_color:SetInvisible(true)
            triangle_color1:SetInvisible(true)
            triangle_size:SetInvisible(true)
            line_spread_angle:SetInvisible(true)
            line_size:SetInvisible(true)
            line_gap:SetInvisible(true)
            line_color:SetInvisible(true)
            line_color1:SetInvisible(true)
            triangle_breathespeed:SetInvisible(true)
            line_thickness:SetInvisible(false)

        if circular:GetValue() then

                if AngleReal > 0 then
                    AngleReal = 180
                elseif AngleReal <= 0 then
                    AngleReal = 0
                end

                draw.Color( bg_color:GetValue() )
                RenderCircular(x,y,radius:GetValue(),thickness:GetValue() + 1,0,360,60)
                draw.Color( base_color:GetValue() )
                RenderCircular(x,y,radius_fake:GetValue(),thickness:GetValue(),AngleBase - fakespread:GetValue(),AngleBase + fakespread:GetValue(),60)
                draw.Color( rotation_color:GetValue() )
                RenderCircular(x,y,radius:GetValue(),thickness:GetValue(),AngleReal - 85 ,AngleReal + 85,60)

                radius:SetInvisible(false)
                radius_fake:SetInvisible(false)
                thickness:SetInvisible(false)
                fakespread:SetInvisible(false)
                bg_color:SetInvisible(false)
                base_color:SetInvisible(false)
                rotation_color:SetInvisible(false)
            end

            if triangle:GetValue() then

                alpha = alpha + add

                if alpha >= 255 then
                    alpha = 255
                    add = -triangle_breathespeed:GetValue()
                elseif alpha <= 0 then
                    alpha = 0
                    add = triangle_breathespeed:GetValue()
                end

                local gap = triangle_gap:GetValue()
                local r,g,b,a = triangle_color:GetValue()
                local r1,g1,b1,a1 = triangle_color:GetValue()

                if AngleReal > 0 then
                    r1,g1,b1 = triangle_color1:GetValue()
                    a1 = alpha

                    r,g,b,a = triangle_color:GetValue()
                    

                elseif AngleReal <= 0 then
                    r,g,b = triangle_color1:GetValue()
                    a = alpha

                    r1,g1,b1,a1 = triangle_color:GetValue()
                    
                end

                --left
                draw.Color( r,g,b,a )
                draw.Triangle( x - gap - triangle_size:GetValue(),y,x - gap,y - triangle_size:GetValue(),x - gap,y + triangle_size:GetValue() )

                --right
                draw.Color( r1,g1,b1,a1 )
                draw.Triangle( x + gap + triangle_size:GetValue(),y,x + gap,y - triangle_size:GetValue(),x + gap,y + triangle_size:GetValue() )

                triangle_gap:SetInvisible(false)
                triangle_color:SetInvisible(false)
                triangle_color1:SetInvisible(false)
                triangle_size:SetInvisible(false)
                triangle_breathespeed:SetInvisible(false)
            end

            if line:GetValue() then
                local gap = line_gap:GetValue()

                local r,g,b,a = line_color:GetValue()
                local r1,g1,b1,a1 = line_color:GetValue()

                local angle = line_spread_angle:GetValue()

                local lx1,ly1 = x - gap + math.cos(math.rad(360 - angle)) * line_size:GetValue(),y + math.sin(math.rad(360 - angle)) * line_size:GetValue()
                local lx2,ly2 = x - gap + math.cos(math.rad(angle)) * line_size:GetValue(),y + math.sin(math.rad(angle)) * line_size:GetValue()
                
                local rx1,ry1 = x + gap + math.cos(math.rad(180 + angle)) * line_size:GetValue(),y + math.sin(math.rad(180 + angle)) * line_size:GetValue()
                local rx2,ry2 = x + gap + math.cos(math.rad(180 - angle)) * line_size:GetValue(),y + math.sin(math.rad(180 - angle)) * line_size:GetValue()
                
                if AngleReal > 0 then
                    r1,g1,b1,a1 = line_color1:GetValue()
                    r,g,b,a = line_color:GetValue()

                elseif AngleReal <= 0 then
                    r1,g1,b1,a1 = line_color:GetValue()
                    r,g,b,a = line_color1:GetValue()
                end

                for i = 1,line_thickness:GetValue() do
                    draw.Color( r,g,b,a )
                    draw.Line( x - gap - i - weapon_inc, y, lx1 - weapon_inc,ly1 )
                    draw.Line( x - gap - i - weapon_inc, y, lx2 - weapon_inc,ly2 )

                    draw.Color( r1,g1,b1,a1 )
                    draw.Line( x + gap + i + weapon_inc, y, rx1 + weapon_inc,ry1 )
                    draw.Line( x + gap + i + weapon_inc, y, rx2 + weapon_inc,ry2 )
                end

                line_spread_angle:SetInvisible(false)
                line_gap:SetInvisible(false)
                line_size:SetInvisible(false)
                line_color:SetInvisible(false)
                line_color1:SetInvisible(false)
                line_thickness:SetInvisible(false)
            end

            

        end
end
callbacks.Register( "Draw", OnDraw )




