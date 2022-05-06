if not in_load_beam_info_t then
    ffi.cdef [[
        typedef struct  {
            float x;
            float y;
            float z;    
        }vec3_t;
        struct beam_info_t {
            int         m_type;
            void* m_start_ent;
            int         m_start_attachment;
            void* m_end_ent;
            int         m_end_attachment;
            vec3_t      m_start;
            vec3_t      m_end;
            int         m_model_index;
            const char  *m_model_name;
            int         m_halo_index;
            const char  *m_halo_name;
            float       m_halo_scale;
            float       m_life;
            float       m_width;
            float       m_end_width;
            float       m_fade_length;
            float       m_amplitude;
            float       m_brightness;
            float       m_speed;
            int         m_start_frame;
            float       m_frame_rate;
            float       m_red;
            float       m_green;
            float       m_blue;
            bool        m_renderable;
            int         m_num_segments;
            int         m_flags;
            vec3_t      m_center;
            float       m_start_radius;
            float       m_end_radius;
        };
        typedef void (__thiscall* draw_beams_t)(void*, void*);
        typedef void*(__thiscall* create_beam_points_t)(void*, struct beam_info_t&);
    ]]
    in_load_beam_info_t = true
end

local render_beams_signature = "B9 ?? ?? ?? ?? A1 ?? ?? ?? ?? FF 10 A1 ?? ?? ?? ?? B9"
local match = mem.FindPattern("client.dll", render_beams_signature) or error("render_beams_signature not found")
local render_beams = ffi.cast("void**", ffi.cast("char*", match) + 1)[0] or error("render_beams is nil")
local render_beams_class = ffi.cast("void***", render_beams)
local render_beams_vtbl = render_beams_class[0]

local draw_beams = ffi.cast("draw_beams_t", render_beams_vtbl[6]) or error("couldn't cast draw_beams_t", 2)
local create_beam_points = ffi.cast("create_beam_points_t", render_beams_vtbl[12]) or error("couldn't cast create_beam_points_t", 2)

local function create_beams(beamtype, startpos, endpos, red, green, blue, alpha, thicc, dalife)
    local beam_info = ffi.new("struct beam_info_t")
    beam_info.m_type = 0x00
    beam_info.m_model_index = -1
    beam_info.m_halo_scale = 0

    beam_info.m_life = dalife
    beam_info.m_fade_length = 1

    beam_info.m_width = thicc -- multiplication is faster than division
    beam_info.m_end_width = thicc -- multiplication is faster than division

    beam_info.m_model_name = beamtype

    beam_info.m_amplitude = 2.3
    beam_info.m_speed = 0.2

    beam_info.m_start_frame = 0
    beam_info.m_frame_rate = 0

    beam_info.m_red = red
    beam_info.m_green = green
    beam_info.m_blue = blue
    beam_info.m_brightness = alpha

    beam_info.m_num_segments = 2
    beam_info.m_renderable = true

    beam_info.m_flags = bit.bor(0x00000100 + 0x00000200 + 0x00008000)

    beam_info.m_start = startpos
    beam_info.m_end = endpos

    local beam = create_beam_points(render_beams_class, beam_info)
    if beam ~= nil then
        draw_beams(render_beams, beam)
    end
end

local bullet_tracers =
    (function()
    local sprites = {
        "sprites/purplelaser1.vmt",
        "sprites/physbeam.vmt",
        "sprites/bubble.vmt"
    }

    local g_bullet_tracers_mode = gui.Reference("visuals", "world", "extra", "bullet tracers mode")
    g_bullet_tracers_mode:SetValue(0)
    g_bullet_tracers_mode:SetInvisible(true)

    local ref = gui.Reference("visuals", "world", "extra")
    local bullet_tracers_on = gui.Checkbox(ref, "bullettracer.on", "Bullet Tracers", 0)
    local bullet_tracers_filter =
        (function()
        local varname = "bullettracer.filter."
        local ref = gui.Multibox(ref, "Bullet Tracers Filter")
        local on = {
            gui.Checkbox(ref, varname .. "alocal", "Local", 0),
            gui.Checkbox(ref, varname .. "friendly", "Friendly", 0),
            gui.Checkbox(ref, varname .. "enemy", "Enemy", 0)
        }

        local temp = {clr = {}, height = {}, thickness = {}, life = {}}
        for i = 1, 3 do
            temp.clr[i] = gui.ColorPicker(on[i], "clr", "clr", 255, 255, 255, 255)
            temp.height[i] = gui.Slider(on[i], "width", "width", 20, 1, 100)
            temp.thickness[i] = gui.Slider(on[i], "thickness", "thickness", 2, 0, 5, 0.1)
            temp.life[i] = gui.Slider(on[i], "life", "life", 1, 1, 10)
            temp.height[i]:SetInvisible(true)
            temp.thickness[i]:SetInvisible(true)
            temp.life[i]:SetInvisible(true)
        end
        return {ref, on, temp}
    end)()

    local bullet_tracers_style = gui.Combobox(ref, "bullettracer.mode", "Bullet Tracers Style", "Skeet", "Beam", "Bubble")

    bullet_tracers_on:SetDescription("Visualiz bullet paths.")

    callbacks.Register(
        "Draw",
        function()
            local vis = not bullet_tracers_on:GetValue()
            bullet_tracers_style:SetInvisible(vis)
            bullet_tracers_filter[1]:SetInvisible(vis)
        end
    )

    local function EyePosition(ent)
        return ent and (ent:GetAbsOrigin() + Vector3(0, 0, ent:GetPropFloat("localdata", "m_vecViewOffset[2]")))
    end

    client.AllowListener("bullet_impact")
    client.AllowListener("player_connect_full")

    callbacks.Register(
        "FireGameEvent",
        function(e)
            local en = e and e:GetName()
            if not (bullet_tracers_on:GetValue() and en and en == "bullet_impact") then
                return
            end
            local lp = entities.GetLocalPlayer()
            local idx = lp:GetIndex()

            local userid = client.GetPlayerIndexByUserID(e:GetInt("userid"))
            local x, y, z = e:GetFloat("x"), e:GetFloat("y"), e:GetFloat("z")
            local sprites = sprites[bullet_tracers_style:GetValue() + 1]
            local ui = bullet_tracers_filter[3]
            if userid == idx then
                if bullet_tracers_filter[2][1]:GetValue() then
                    local pos = EyePosition(lp)
                    local r, g, b, a = ui.clr[1]:GetValue()
                    create_beams(sprites, {x, y, z}, {pos.x, pos.y, pos.z - 1}, r, g, b, a, ui.thickness[1]:GetValue(), ui.life[1]:GetValue())
                end
            else
                local ent = entities.GetByIndex(userid)
                local pos = EyePosition(ent)
                if ent:GetTeamNumber() == lp:GetTeamNumber() then
                    if bullet_tracers_filter[2][2]:GetValue() then
                        local r, g, b, a = ui.clr[2]:GetValue()
                        create_beams(sprites, {x, y, z}, {pos.x, pos.y, pos.z - 1}, r, g, b, a, ui.thickness[2]:GetValue(), ui.life[2]:GetValue())
                    end
                else
                    if bullet_tracers_filter[2][3]:GetValue() then
                        local r, g, b, a = ui.clr[3]:GetValue()
                        create_beams(sprites, {x, y, z}, {pos.x, pos.y, pos.z - 1}, r, g, b, a, ui.thickness[3]:GetValue(), ui.life[3]:GetValue())
                    end
                end
            end
        end
    )

    callbacks.Register(
        "Unload",
        function()
            g_bullet_tracers_mode:SetInvisible(false)
        end
    )
end)()
