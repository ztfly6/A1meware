ffi.cdef [[
    void* GetProcAddress(void* hModule, const char* lpProcName);
    void* GetModuleHandleA(const char* lpModuleName);
    
    typedef struct {
        uint8_t r;
        uint8_t g;
        uint8_t b;
        uint8_t a;
    } color_struct_t;

    typedef void (*console_color_print)(const color_struct_t&, const char*, ...);

    typedef void* (__thiscall* get_client_entity_t)(void*, int);
]]

local hit_groups = {"头部", "胸部", "腹部", "左臂", "右臂", "左腿", "右腿"}

local ffi_log = ffi.cast("console_color_print", ffi.C.GetProcAddress(ffi.C.GetModuleHandleA("tier0.dll"), "?ConColorMsg@@YAXABVColor@@PBDZZ"))

local _SetTag = ffi.cast('int(__fastcall*)(const char*, const char*)', mem.FindPattern('engine.dll', '53 56 57 8B DA 8B F9 FF 15'))

local SetTag = function(v)
    if v ~= last then
      _SetTag(v, v)
      last = v
    end
  end

function client.log(msg, ...)
    for k, v in pairs({...}) do
        msg = tostring(msg .. v)
    end
    ffi_log(ffi.new("color_struct_t"), msg .. "\n")
end

function client.color_log(r, g, b, msg, ...)
    for k, v in pairs({...}) do
        msg = tostring(msg .. v)
    end
    local clr = ffi.new("color_struct_t")
    clr.r, clr.g, clr.b, clr.a = r, g, b, 255
    ffi_log(clr, msg .. "\n")
end

local c_hud_chat =
    ffi.cast("unsigned long(__thiscall*)(void*, const char*)", mem.FindPattern("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28"))(
    ffi.cast("unsigned long**", ffi.cast("uintptr_t", mem.FindPattern("client.dll", "B9 ?? ?? ?? ?? E8 ?? ?? ?? ?? 8B 5D 08")) + 1)[0],
    "CHudChat"
)

local ffi_print_chat = ffi.cast("void(__cdecl*)(int, int, int, const char*, ...)", ffi.cast("void***", c_hud_chat)[0][27])

function client.PrintChat(msg)
    ffi_print_chat(c_hud_chat, 0, 0, " " .. msg)
end

function startswith(text, prefix)
    return text:find(prefix, 1, true) == 1
end


local function on_player_hurt(Event)
    if(Event:GetName() ~= "player_hurt") then return end

    local local_player = entities.GetLocalPlayer()

    local attacker = entities.GetByUserID(Event:GetInt('attacker'))

    local victim = entities.GetByUserID(Event:GetInt('userid'))

    local damage = Event:GetInt("dmg_health")

    local hitbox = Event:GetInt("hitgroup")

    local hp = Event:GetInt("health")

    if(attacker:GetIndex() == local_player:GetIndex()) then

        client.PrintChat("\x0B» \x0B✔ \x0B" .. local_player:GetName() .. " \01造成\02 " .. damage .. " 伤害 \x01击中 \x10" .. victim:GetName() .. " \01的\02 " .. hit_groups[hitbox])

        client.PrintChat("\x0A» \x0A✔\01 剩余HP \10» \04" .. hp)

    end

    if(victim:GetIndex() == local_player:GetIndex()) then 
        
        client.PrintChat("\x0D» \x0B✘\x0C" .. attacker:GetName() .. " \01造成\02 " .. damage .. " 伤害 \01击中 \x01 \x10" .. local_player:GetName() .. " \01的\02 " .. hit_groups[hitbox])

        client.PrintChat("\x0A» \x0A✘\01 剩余HP \10» \04" .. hp)

    end

end

panorama.RunScript([[
        let muteSomeoneUHate = (ent) => {
        let xuid = GameStateAPI.GetPlayerXuidFromUserID(ent);
            if (GameStateAPI.IsXuidValid(xuid) && !GameStateAPI.IsFakePlayer(xuid) && !GameStateAPI.IsSelectedPlayerMuted(xuid)) {
                let isMuted = GameStateAPI.IsSelectedPlayerMuted(xuid);;
                if(isMuted) return;
                GameStateAPI.ToggleMute(xuid);
            }
        }
]])

panorama.RunScript([[
    let UnmuteSomeoneULike = (ent) => {
    let xuid = GameStateAPI.GetPlayerXuidFromUserID(ent);
        if (GameStateAPI.IsXuidValid(xuid) && !GameStateAPI.IsFakePlayer(xuid) && !GameStateAPI.IsSelectedPlayerMuted(xuid)) {
            let isMuted = GameStateAPI.IsSelectedPlayerMuted(xuid);
            if(isMuted) 
                GameStateAPI.ToggleMute(xuid);
        }
    }
]])

local function mute_someone_you_hate(UserID)

    panorama.RunScript([[muteSomeoneUHate( ]] .. UserID .. [[); 
                        var xuid = GameStateAPI.GetPlayerXuidFromUserID(]] .. UserID .. [[)
                        var name = GameStateAPI.GetPlayerName(xuid);
                        $.Msg("Muted: " + name)]])

end

local function unmute_someone_you_love_like_yukine(UserID)

    panorama.RunScript([[
        $.Msg("Running UnmuteFunc")
        UnmuteSomeoneULike(]] .. UserID .. [[);
    ]])

end

local function unmute_all()

    panorama.RunScript([[
        for(var i = 0; i < 1000; i++){
            $.Msg(i)
            UnmuteSomeoneULike(i)
        }
    ]])

end

local function mute_all()

    panorama.RunScript([[
        for(var i = 0; i < 1000; i++){
            $.Msg(i)
            muteSomeoneUHate(i)
        }
    ]])

end

local clantag_speed = 3

local function print_user_id()

    local players = entities.FindByClass("CCSPlayer");

    for i = 1, #players do

        local player = players[i];

        local info = client.GetPlayerInfo(player:GetIndex())

        client.PrintChat(string.format( "玩家名: %s -> 玩家编号: %s", player:GetName(), info["UserID"]))
        
    end


end

local function round(num, numDecimalPlaces)

	local mult = 10 ^ (numDecimalPlaces or 0)

	return math.floor(num * mult + 0.5) / mult

end

local last_update_time = 0

local iter = 1

local clantag_set = ""

local clantag_type = ""

local clantag_str = ""

local function do_clantag(clantag, style)

    if clantag == nil or clantag == "" then return end

    
    local clantag_len = string.len(clantag) -- ok?

    local cur_time = round(globals.CurTime() * clantag_speed, 0)



    if cur_time == last_update_time then return end

    --bruh what the fuck

    if style == "静止" then

        clantag_set = clantag

    elseif style == "排序" then

        -- reset build iterator

        if cur_time % clantag_len == 0 then

            iter = 1

        end



        -- clear tag

        clantag_set = ""



        for i = 1, iter do

            clantag_set = clantag_set .. clantag:sub(i, i)

            print(clantag_set)

        end



        -- increase iterator

        iter = iter + 1

    elseif style == "滚动" then

        -- reset scroll tag

        if cur_time % clantag_len == 0 then

            clantag_set = clantag .. " "

        end



        -- scroll the tag

        if clantag_set:len() > 0 then

            clantag_set = clantag_set .. clantag_set:sub(1, 1)

            clantag_set = clantag_set:sub(2, clantag_set:len())

        end

    elseif style == "排序-滚动" then

        -- reset iterator

        if cur_time % (clantag_len * 3 + 1) == 0 then 

            iter = 1

        end

    

        -- build tag

        if iter <= clantag_len * 3 + 1 then

            if iter <= clantag_len then

                clantag_set = string.sub(clantag, 1, iter)

            elseif iter >= (clantag_len * 2) then

                clantag_set = string.sub(clantag, iter - clantag_len * 2 + 1, clantag_len)

            end

    

            iter = iter + 1

        end

    end



    SetTag(clantag_set, clantag_set)



    last_update_time = round(globals.CurTime() * clantag_speed, 0)

end

--Digga das gibt mir GehirnTumor

local function on_create_move(cmd)
    --Do the clantag changer in create move for extra safety -dasMax 2020 
    if(clantag_type == "") then clantag_type = "静止" end

    do_clantag(clantag_str, clantag_type)
    
end

local function set_animation(anim_type)

    if(string.find(string.lower(anim_type), "静止") == 1) then

        clantag_type = "静止"

        return true

    elseif(string.find(string.lower(anim_type), "滚动") == 1) then

        clantag_type = "滚动"

        return true

    elseif(string.find(string.lower(anim_type), "排序") == 1) then

        clantag_type = "排序"

        return true

    elseif(string.find(string.lower(anim_type), "排序-滚动") == 1) then

        clantag_type = "排序-滚动"

        return true

    end

end

local function on_cmd(cmd) 

    if(string.find(cmd:Get(), 'say "!') == 1) then 

        if(cmd:Get() == 'say "!帮助"') then

            client.PrintChat("\x0B[A1mware]\08 !组名/!改名 （英文）!动态 静止/滚动/排序/排序-滚动 / !速度 ")

            client.PrintChat("\x0B[A1mware]\08 !屏蔽/!解禁 编号 !屏蔽全部/!解禁全部 !列表")
			
            client.PrintChat("\x0B[A1mware]\08 详细指令及更新请进入社区论坛获取 https://hvh.sh/")

        elseif(cmd:Get() == 'say "!操作"') then

            client.PrintChat("\x0B[可用指令]\08 !屏蔽全部")

            client.PrintChat("\x0B[可用指令]\08 !解禁全部")

            client.PrintChat("\x0B[可用指令]\08 !clantag prints subdirectories")

        elseif(string.find(cmd:Get(), 'say "!组名') == 1) then 

            local commmand = cmd:Get()

            local t = string.gsub(cmd:Get(), 'say "!组名 ', "")

            t = string.gsub(t, '"', "")

            client.PrintChat("\x0B[A1mware]\08 正在设置组名: " .. t)

            clantag_str = t

        elseif(string.find(cmd:Get(), 'say "!解禁全部') == 1) then 

            client.PrintChat("\x0B[A1mware]\08 正在解除屏蔽全部玩家")

            unmute_all()

        elseif(string.find(cmd:Get(), 'say "!屏蔽全部') == 1) then 

            client.PrintChat("\x0B[A1mware]\08 正在屏蔽全部玩家")

            mute_all()

        elseif(string.find(cmd:Get(), 'say "!速度') == 1) then 

            local commmand = cmd:Get()

            local t = string.gsub(cmd:Get(), 'say "!速度 ', "")

            t = string.gsub(t, '"', "")

            client.PrintChat("\x0B[A1mware]\08 正在设置组名速度: " .. t)

            clantag_speed = tonumber(t)

        elseif(string.find(cmd:Get(), 'say "!动态') == 1) then 

            local commmand = cmd:Get()

            local t = string.gsub(cmd:Get(), 'say "!动态 ', "")

            t = string.gsub(t, '"', "")

            local sucess = set_animation(t)

            if(sucess) then client.PrintChat("\x0B[A1mware]\08 正在设置动态组名: " .. t) end

        elseif(string.find(cmd:Get(), 'say "!改名') == 1) then

            local commmand = cmd:Get()

            local t = string.gsub(cmd:Get(), 'say "!改名 ', "")

            t = string.gsub(t, '"', "")

            client.PrintChat("\x0B[A1mware]\08 正在更改名字: " .. t)

            client.SetConVar("name", t, 1)

        elseif(string.find(cmd:Get(), 'say "!屏蔽') == 1) then

            local commmand = cmd:Get()

            local t = string.gsub(cmd:Get(), 'say "!屏蔽 ', "")

            t = string.gsub(t, '"', "")

            client.PrintChat("\x0B[A1mware]\08 正在屏蔽玩家: " .. t)

            mute_someone_you_hate(t)

        elseif(string.find(cmd:Get(), 'say "!解禁') == 1) then

            local commmand = cmd:Get()

            local t = string.gsub(cmd:Get(), 'say "!解禁 ', "")

            t = string.gsub(t, '"', "")

            client.PrintChat("\x0B[A1mware]\08 正在解除屏蔽玩家: " .. t)

            unmute_someone_you_love_like_yukine(t)

        elseif(string.find(cmd:Get(), 'say "!列表') == 1) then

            print_user_id()

        else 

            local commmand = cmd:Get()

            local t = string.gsub(cmd:Get(), 'say "!', "")

            t = string.gsub(t, '"', "")

            client.PrintChat("\x0B[A1mware]\08 正在执行指令: " .. t)

            client.Command(t, 1)

        end

    end

end

client.AllowListener("player_hurt")
callbacks.Register("SendStringCmd", on_cmd)
callbacks.Register("FireGameEvent", on_player_hurt)
callbacks.Register("CreateMove", on_create_move)