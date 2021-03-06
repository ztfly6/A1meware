--使用了An QQ 2926669800 的代码 --Lua交流群  1093993910
--李清照和左词测试--
--此lua为柒制作 Aimware 图片水印 --QID AIMWAREQI
local qi_avatars_ui_Checkbox = gui.Checkbox( gui.Reference( "Visuals" , "Local" , "Camera" ), "qi_avatars_ui", "图片水印", 0 )
X , Y = draw.GetScreenSize();
local sX_avatars_ui = gui.Slider( gui.Reference( "Visuals" , "Local"  ), "qi_avatars_ui_x", "X", 400 , 0 , X );
local sY_avatars_ui = gui.Slider( gui.Reference( "Visuals" , "Local"  ), "qi_avatars_ui_y", "Y", 260 , 0 , Y );

sX_avatars_ui:SetInvisible( true );
sY_avatars_ui:SetInvisible( true );
local is_inside = function(a, b, x, y, w, h) return a >= x and a <= w and b >= y and b <= h end
local tX, tY, offsetX, offsetY, _drag
local drag_menu = function(x, y, w, h)
    if not gui.Reference("MENU"):IsActive() then
        return tX, tY
    end

    local mouse_down = input.IsButtonDown(1)

    if mouse_down then
        local X, Y = input.GetMousePos()

        if not _drag then
            local w, h = x + w, y + h
            if is_inside(X, Y, x, y, w, h) then
                offsetX, offsetY = X - x, Y - y
                _drag = true
            end
        else
            tX, tY = X - offsetX, Y - offsetY
            sX_avatars_ui:SetValue(tX) sY_avatars_ui:SetValue(tY)
        end
    else
        _drag = false
    end

    return tX, tY
end
--jian bian
function gradientH(x1, y1, x2, y2,col1, left)
    local w = x2 - x1
    local h = y2 - y1
 
    for i = 0, w do
        local a = (i / w) * col1[4]
        local r, g, b = col1[1], col1[2], col1[3];
        draw.Color(r,g,b, a)
        if left then
            draw.FilledRect(x1 + i, y1, x1 + i + 1, y1 + h)
        else
            draw.FilledRect(x1 + w - i, y1, x1 + w - i + 1, y1 + h)
        end
    end
end
--steam

local avatarsdata = file.Open("图片/1.jpg", "r")
avatars = avatarsdata:Read()
avatarsdata:Close()
local RGBA, width, height = common.DecodeJPEG(avatars);
local texture = draw.CreateTexture(RGBA, width, height);

local font = draw.CreateFont('Verdana', 13.5, 11.5);
local font2 = draw.CreateFont('Verdana', 12, 11.5);
function drawavatars()
    if not tX then
        tX, tY = sX_avatars_ui:GetValue(),sY_avatars_ui:GetValue()
    end
    local lp = entities.GetLocalPlayer();
    local x, y = drag_menu(tX, tY, 100, 100)
    local x, y = x + 50 , y + 50
    if qi_avatars_ui_Checkbox:GetValue() then
    if lp ~= nil  then
    --信息栏
    --hp
    local localPlayer = entities.GetLocalPlayer()
    local hp = localPlayer:GetHealth()
    local r , g , b , a = 34, 34, 34, 255
    gradientH( x-130 , y , x , y-20 ,{ r , g , b , a*0.6 }, true);
    gradientH( x-125 , y , x , y-20 ,{ r , g , b , a*0.8 }, true);
    gradientH( x-120 , y , x , y-20 ,{ r , g , b , a }, true);
    gradientH( x-115 , y , x , y-20 ,{ r , g , b , a }, true);
    gradientH( x-112 , y , x , y-20 ,{ r , g , b , a }, true);
    gradientH( x-110 , y , x , y-20 ,{ r , g , b , a }, true);
    gradientH( x-108 , y , x , y-20 ,{ r , g , b , a }, true);
    gradientH( x-106 , y , x , y-20 ,{ r , g , b , a }, true);
    draw.SetFont( font2 )
    if hp > 35 then
    draw.Color( 134, 200, 134, 255 )
    else
    draw.Color( 255, 0, 0, 255 )    
    end
    draw.TextShadow( x-92, y-15, hp.."hp" )        
    --货币
    local Money = localPlayer:GetProp("m_iAccount")
    local r , g , b , a = 40, 40, 40, 255
    gradientH( x , y , x+170 , y+20 ,{ r , g , b , a*0.6  }, false);
    gradientH( x , y , x+165 , y+20 ,{ r , g , b , a*0.8  }, false);
    gradientH( x , y , x+165 , y+20 ,{ r , g , b , a  }, false);
    gradientH( x , y , x+160 , y+20 ,{ r , g , b , a  }, false);
    gradientH( x , y , x+155 , y+20 ,{ r , g , b , a  }, false);
    gradientH( x , y , x+152 , y+20 ,{ r , g , b , a  }, false);
    gradientH( x , y , x+150 , y+20 ,{ r , g , b , a  }, false);
    gradientH( x , y , x+148 , y+20 ,{ r , g , b , a  }, false);
    gradientH( x , y , x+146 , y+20 ,{ r , g , b , a  }, false);
    draw.Color( 254, 215, 0, 255 )
    draw.TextShadow( x+65, y+5, "Money ● " )
    draw.Color( 255, 255, 255, 255 )
    draw.TextShadow( x+110, y+5, "$"..Money )

    --绘制底色1
    if hp > 35 then
     r , g , b , a = 134, 200, 134, 255
    else
     r , g , b , a = 255, 0, 0, 255   
    end
    draw.Color( r , g , b, a )
    draw.FilledCircle( x, y, 56.3 )
    draw.Color( r , g , b, a*0.8 )
    draw.FilledCircle( x, y, 56.4 )
    draw.FilledCircle( x, y, 56.5 )
    draw.Color( r , g , b, a*0.6 )
    draw.FilledCircle( x, y, 56.6 )
    draw.FilledCircle( x, y, 56.7 )
    draw.FilledCircle( x, y, 56.8 )
    draw.Color( r , g , b, a*0.4 )
    draw.FilledCircle( x, y, 56.9 )
    draw.FilledCircle( x, y, 57 )
    draw.FilledCircle( x, y, 57.1 )
    draw.FilledCircle( x, y, 57.2 )
    draw.Color( r , g , b, a*0.2 )
    draw.FilledCircle( x, y, 57.3 )
    draw.FilledCircle( x, y, 57.4 )
    draw.FilledCircle( x, y, 57.5 )
    draw.FilledCircle( x, y, 57.6 )
    --绘制底色2
    local r , g , b , a = 36, 36, 36, 255
    draw.Color( r , g , b, a )
    draw.FilledCircle( x, y, 55 )
    draw.Color( r , g , b, a*0.8 )
    draw.FilledCircle( x, y, 55.1 )
    draw.FilledCircle( x, y, 55.2 )
    draw.Color( r , g , b, a*0.6 )
    draw.FilledCircle( x, y, 55.3 )
    draw.FilledCircle( x, y, 55.4 )
    draw.FilledCircle( x, y, 55.5 )
    draw.Color( r , g , b, a*0.4 )
    draw.FilledCircle( x, y, 55.6 )
    draw.FilledCircle( x, y, 55.7 )
    draw.FilledCircle( x, y, 55.8 )
    draw.FilledCircle( x, y, 55.9 )
    draw.Color( r , g , b, a*0.2 )
    draw.FilledCircle( x, y, 56 )
    draw.FilledCircle( x, y, 56.1 )
    draw.FilledCircle( x, y, 56.2)
    --头像
    local r , g , b , a = 255, 255, 255, 255
    draw.Color(r , g , b , a)
    draw.SetTexture(texture)
    draw.FilledRect(x-39, y-39, width-145+x, height-145+y)

    --号码牌
    local r , g , b , a = 80,163, 248, 50
    local teamnumber = lp:GetTeamNumber()
    draw.Color(r , g , b , a)
    draw.FilledCircle( x, y+37, 14)
    draw.Color(r , g , b , a*0.8)
    draw.FilledCircle( x, y+37, 14.1)
    draw.Color(r , g , b , a*0.6)
    draw.FilledCircle( x, y+37, 14.2)
    draw.FilledCircle( x, y+37, 14.3)
    draw.Color(r , g , b , a*0.4)
    draw.FilledCircle( x, y+37, 14.4)
    draw.FilledCircle( x, y+37, 14.5)
    draw.FilledCircle( x, y+37, 14.6)
    draw.Color(r , g , b , a*0.2)
    draw.FilledCircle( x, y+37, 14.7)
    draw.FilledCircle( x, y+37, 14.8)
    draw.FilledCircle( x, y+37, 14.9)
    draw.FilledCircle( x, y+37, 15)
    draw.Color(255 , 255 , 255 , 255)
    local x1 , y1 = draw.GetTextSize(teamnumber)
    draw.SetFont( font )
    draw.TextShadow( x-x1+2, y+27, teamnumber )

    --绘制底色3
    local r , g , b , a = 34,34, 34, 255
    draw.Color( r , g , b, a )
    draw.OutlinedCircle( x, y, 55 )
    draw.OutlinedCircle( x, y, 54.5 )
    draw.OutlinedCircle( x, y, 54 )
    draw.OutlinedCircle( x, y, 53.5 )
    draw.OutlinedCircle( x, y, 53 )
    draw.OutlinedCircle( x, y, 52.5 )
    draw.OutlinedCircle( x, y, 52 )
    draw.OutlinedCircle( x, y, 51.5 )
    draw.OutlinedCircle( x, y, 51 )
    draw.OutlinedCircle( x, y, 50.5 )
    draw.OutlinedCircle( x, y, 50 )
    draw.OutlinedCircle( x, y, 49.5 )
    draw.OutlinedCircle( x, y, 49 )
    draw.OutlinedCircle( x, y, 48.5 )
    draw.OutlinedCircle( x, y, 48 )
    draw.OutlinedCircle( x, y, 47.5 )
    draw.OutlinedCircle( x, y, 47 )
    draw.OutlinedCircle( x, y, 46.5 )
    draw.OutlinedCircle( x, y, 46 )
    draw.OutlinedCircle( x, y, 45.5 )
    draw.OutlinedCircle( x, y, 45 )
    draw.OutlinedCircle( x, y, 44.5 )
    draw.OutlinedCircle( x, y, 44 )
    draw.OutlinedCircle( x, y, 43.5 )
    draw.OutlinedCircle( x, y, 43 )
    draw.OutlinedCircle( x, y, 42.5 )
    draw.OutlinedCircle( x, y, 42 )
    draw.OutlinedCircle( x, y, 41.5 )
    draw.OutlinedCircle( x, y, 41 )
    draw.OutlinedCircle( x, y, 40.5 )
    draw.OutlinedCircle( x, y, 40 )
    draw.Color( r , g , b, a*0.8 )
    draw.OutlinedCircle( x, y, 39.9 )
    draw.Color( r , g , b, a*0.6 )
    draw.OutlinedCircle( x, y, 39.8 )
    draw.OutlinedCircle( x, y, 39.7 )
    draw.Color( r , g , b, a*0.4 )
    draw.OutlinedCircle( x, y, 39.6 )
    draw.OutlinedCircle( x, y, 39.5 )
    draw.OutlinedCircle( x, y, 39.4 )
    draw.Color( r , g , b, a*0.2 )
    draw.OutlinedCircle( x, y, 39.3 )
    draw.OutlinedCircle( x, y, 39.2 )
    draw.OutlinedCircle( x, y, 39.1 )
    draw.OutlinedCircle( x, y, 39 )
    end
    end
end
local kills  = {}
local deaths = {}
 
local function KillDeathCount(event)
    if qi_avatars_ui_Checkbox:GetValue() then
	local local_player = client.GetLocalPlayerIndex( );
	local INDEX_Attacker = client.GetPlayerIndexByUserID( event:GetInt( 'attacker' ) );
	local INDEX_Victim = client.GetPlayerIndexByUserID( event:GetInt( 'userid' ) );
 
	if (event:GetName( ) == "client_disconnect") or (event:GetName( ) == "begin_new_match") then
		kills = {}
		deaths = {}
	end
 
	if event:GetName( ) == "player_death" then
		if INDEX_Attacker == local_player then
			kills[#kills + 1] = {};
		end
 
		if (INDEX_Victim == local_player) then
			deaths[#deaths + 1] = {};
		end
    end
end
end
function drawavatars2()
    if not tX then
        tX, tY = sX_avatars_ui:GetValue(),sY_avatars_ui:GetValue()
    end
    local lp = entities.GetLocalPlayer();
    if qi_avatars_ui_Checkbox:GetValue() then
    if lp ~= nil then
    if (engine.GetServerIP() == "loopback") then
        server = "localhost"
    elseif string.find(engine.GetServerIP(), "A") then
        server = "valve"
    else
        server = "unknown"
    end
    local x, y = drag_menu(tX, tY, 100, 100)
    local x, y = x + 50 , y + 50
    local r , g , b , a = 34, 34, 34, 255
    gradientH( x+42 , y-10 , x+230 , y-35 ,{ r , g , b , a*0.8 }, false);
    gradientH( x+42 , y-10 , x+225 , y-35 ,{ r , g , b , a*0.6 }, false);
    gradientH( x+42 , y-10 , x+220 , y-35 ,{ r , g , b , a }, false);
    gradientH( x+42 , y-10 , x+218 , y-35 ,{ r , g , b , a }, false);
    gradientH( x+42 , y-10 , x+216 , y-35 ,{ r , g , b , a }, false);
    gradientH( x+42 , y-10 , x+214 , y-35 ,{ r , g , b , a }, false);
    gradientH( x+42 , y-10 , x+212 , y-35 ,{ r , g , b , a }, false);
    draw.Color(255 , 255 , 255 , 255)
    draw.SetFont( font2 )
    draw.TextShadow( x+65, y-27, server.." ●  kills "..#kills.." deaths "..#deaths )
    end  
end
end


callbacks.Register( "Draw","drawavatars",drawavatars );
callbacks.Register( "Draw","drawavatars2",drawavatars2 );
callbacks.Register( "FireGameEvent", "KillDeathCount", KillDeathCount);
local drawetxtShadow_x = gui.Slider( gui.Reference( "Visuals" , "Local"  ), "drawetxtShadow_x", "X", 400 , 0 , 038 );local drawetxtShadow_y = gui.Slider( gui.Reference( "Visuals" , "Local"  ), "drawetxtShadow_y", "Y", 100 , 0 , 100 );drawetxtShadow_x:SetInvisible( true );drawetxtShadow_y:SetInvisible( true );
