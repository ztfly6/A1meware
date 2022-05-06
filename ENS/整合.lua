--------By A1mware change
local ffi = ffi
local function a(b, c, d, e)
    local f = gui.Reference("menu")
    return (function()
        local g = {}
        local h, i, j, k, l, m, n, o, p, q, r, s, t, u
        local v = {__index = {Drag = function(self, ...)
                    local w, x = self:GetValue()
                    local y, z = g.drag(w, x, ...)
                    if w ~= y or x ~= z then
                        self:SetValue(y, z)
                    end
                    return y, z
                end, SetValue = function(self, w, x)
                    local p, q = draw.GetScreenSize()
                    self.x:SetValue(w / p * self.res)
                    self.y:SetValue(x / q * self.res)
                end, GetValue = function(self)
                    local p, q = draw.GetScreenSize()
                    return math.floor(self.x:GetValue() / self.res * p), math.floor(self.y:GetValue() / self.res * q)
                end}}
        function g.new(x, A, B, C, D)
            local D = D or 10000
            local p, q = draw.GetScreenSize()
            local A = A ~= "" and A .. "." or A
            local E = gui.Slider(x, A .. "x", "Position x", B / p * D, 0, D)
            local F = gui.Slider(x, A .. "y", "Position y", C / q * D, 0, D)
            E:SetInvisible(true)
            F:SetInvisible(true)
            return setmetatable({x = E, y = F, res = D}, v)
        end
        function g.drag(w, x, G, H, I)
            if globals.FrameCount() ~= h then
                i = f:IsActive()
                l, m = j, k
                j, k = input.GetMousePos()
                o = n
                n = input.IsButtonDown(1) == true
                s = r
                r = {}
                u = t
                t = false
                p, q = draw.GetScreenSize()
            end
            if i and o ~= nil then
                if (not o or u) and n and l > w and m > x and l < w + G and m < x + H then
                    t = true
                    w, x = w + j - l, x + k - m
                    if not I then
                        w = math.max(0, math.min(p - G, w))
                        x = math.max(0, math.min(q - H, x))
                    end
                end
            end
            table.insert(r, {w, x, G, H})
            return w, x, G, H
        end
        return g
    end)().new(b, c, d, e)
end
do
    ffi.cdef [[
    typedef void* (__cdecl* tCreateInterface)(const char* name, int* returnCode);
    void* GetProcAddress(void* hModule, const char* lpProcName);
    void* GetModuleHandleA(const char* lpModuleName);
    ]]
    function mem.CreateInterface(J, K)
        return ffi.cast("tCreateInterface", ffi.C.GetProcAddress(ffi.C.GetModuleHandleA(J), "CreateInterface"))(K, ffi.new("int*"))
    end
end
do
    local L =
        draw.CreateTexture(
        common.RasterizeSVG(
            [[<defs><linearGradient id="b" x1="100%" y1="0%" x2="0%" y2="0%"><stop offset="0%" style="stop-color:rgb(255,255,255); stop-opacity:0" /><stop offset="100%" style="stop-color:rgb(255,255,255); stop-opacity:1" /></linearGradient></defs><rect width="500" height="500" style="fill:url(#b)" /></svg>]]
        )
    )
    local M =
        draw.CreateTexture(
        common.RasterizeSVG(
            [[<defs><linearGradient id="a" x1="0%" y1="100%" x2="0%" y2="0%"><stop offset="0%" style="stop-color:rgb(255,255,255); stop-opacity:0" /><stop offset="100%" style="stop-color:rgb(255,255,255); stop-opacity:1" /></linearGradient></defs><rect width="500" height="500" style="fill:url(#a)" /></svg>]]
        )
    )
    function draw.FilledRectFade(N, O, P, Q, R)
        local S = R and L or M
        draw.SetTexture(S)
        draw.FilledRect(math.floor(N), math.floor(O), math.floor(P), math.floor(Q))
        draw.SetTexture(nil)
    end
end
do
    function math.clamp(T, U, V)
        return T > V and V or T < U and U or T
    end
end
local W = gui.Reference("Misc", "General", "Extra")
local X = gui.Checkbox(W, "so.rainbow", "Rainbow", 1)
X:SetInvisible(true)
local Y = gui.Checkbox(W, "so.watermark", "Watermark", 1)
local Z = gui.ColorPicker(Y, "clr", "Color", 142, 165, 229, 85)
Y:SetDescription("Shows watermark.")
local _ = gui.Checkbox(W, "so.spectators", "Spectators", 1)
local a0 = gui.ColorPicker(_, "clr", "Color", 142, 165, 229, 85)
_:SetDescription("Shows the current spectators.")
local a1 = draw.CreateFont("verdana", 12)
local a2 = {watermark = 0, spectators = 0}
local a3 = {
    watermark = function()
        local a4 = mem.FindPattern("engine.dll", "FF E1")
        local a5 = ffi.cast("uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)", a4)
        local a6 = ffi.cast("uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)", a4)
        local a7 = ffi.cast("uint32_t**", ffi.cast("uint32_t", mem.FindPattern("engine.dll", "FF 15 ?? ?? ?? ?? A3 ?? ?? ?? ?? EB 05")) + 2)[0][0]
        local a8 = ffi.cast("uint32_t**", ffi.cast("uint32_t", mem.FindPattern("engine.dll", "FF 15 ?? ?? ?? ?? 85 C0 74 0B")) + 2)[0][0]
        local a9 = function(aa, ab, ac)
            local ad = ffi.typeof(ac)
            return function(...)
                return ffi.cast(ad, a4)(a6(a7, 0, a5(a8, 0, aa), ab), 0, ...)
            end
        end
        local ae = a9("user32.dll", "EnumDisplaySettingsA", "int(__fastcall*)(unsigned int, unsigned int, unsigned int, unsigned long, void*)")
        local af = ffi.new("struct { char pad_0[120]; unsigned long dmDisplayFrequency; char pad_2[32]; }[1]")
        ae(0, 4294967295, af[0])
        callbacks.Register(
            "Draw",
            function()
                local ag = globals.FrameTime() * 8
                local s, h, c, b = Z:GetValue()
                local ah = entities.GetLocalPlayer()
                local ai = os.date("%X")
                local aj = "aimsense [beta]"
                local ak = ah and ah:GetName() or client.GetConVar("name")
                local al = (" %s | %s | %s"):format(aj, ak, ai)
                if ah then
                    local am = entities.GetPlayerResources():GetPropInt("m_iPing", ah:GetIndex())
                    local an = (" | delay: %dms"):format(am)
                    al = (" %s | %s%s | %s"):format(aj, ak, an, ai)
                end
                draw.SetFont(a1)
                local ao, ap = draw.GetScreenSize()
                local i, x = 18, draw.GetTextSize(al) + 8
                local y, z = ao, 10 + 25 * 0
                y = y - x - 10
                a2.watermark = math.clamp(a2.watermark + (Y:GetValue() and ag or -ag), 0, 1)
                draw.SetScissorRect(y + x - x * a2.watermark, z, x, i * 3)
                if X:GetValue() then
                    draw.Color(s, h, c)
                    draw.FilledRectFade(y + x / 2 + 1, z + 2, y, z, true)
                    draw.FilledRectFade(y + x / 2, z, y + x, z + 2, true)
                    draw.Color(h, c, s)
                    draw.FilledRectFade(y, z, y + x / 2 + 1, z + 2, true)
                    draw.Color(c, s, h)
                    draw.FilledRectFade(y + x, z + 2, y + x / 2, z, true)
                else
                    draw.Color(s, h, c)
                    draw.FilledRect(y, z, y + x, z + 2)
                end
                draw.Color(17, 17, 17, b)
                draw.FilledRect(y, z + 2, y + x, z + i)
                draw.Color(255, 255, 255)
                draw.Text(y + 4, z + 4, al)
                local al = ("4.7ms / %dhz"):format(tonumber(af[0].dmDisplayFrequency))
                local i, x = 18, draw.GetTextSize(al) + 8
                local y, z = ao, 10 + 25 * 1
                y = y - x - 10
                draw.Color(0, 0, 0, 25)
                draw.FilledRectFade(y, z + i, y + x / 2, z + i + 1, true)
                draw.FilledRectFade(y + x, z + i + 1, y + x / 2, z + i, true)
                draw.Color(s, h, c)
                draw.FilledRectFade(y + x / 2, z + i + 1, y, z + i, true)
                draw.FilledRectFade(y + x / 2, z + i, y + x, z + i + 1, true)
                draw.Color(17, 17, 17, b)
                draw.FilledRect(y, z, y + x, z + i)
                draw.Color(255, 255, 255)
                draw.Text(y + 4, z + 4, al)
                draw.SetScissorRect(0, 0, ao, ap)
            end
        )
    end,
    spectators = function()
        local aq = {draw.GetScreenSize()}
        local aq = {aq[1] - aq[1] * client.GetConVar("safezoney"), aq[2] * client.GetConVar("safezoney")}
        local ar = a(_, "", aq[1] / 1.385, aq[2] / 2)
        local as = gui.Reference("menu")
        local at = {}
        callbacks.Register(
            "Draw",
            function()
                draw.SetFont(a1)
                local ah = entities.GetLocalPlayer()
                if not ah then
                    return
                end
                local au = ah:GetIndex()
                local av = false
                local aw = 85
                local ax = as:IsActive()
                local ag = globals.FrameTime() * 8
                local ay = _:GetValue()
                local az = {}
                for l, w in pairs(entities.FindByClass("CCSPlayer")) do
                    local aA = w:GetIndex()
                    if w:GetName() ~= "GOTV" then
                        local aB = w:GetPropEntity("m_hObserverTarget")
                        local aC = aB:GetIndex()
                        at[aA] = at[aA] or 0
                        at[aA] = math.clamp(at[aA] + (aC == au and not entities.GetPlayerResources():GetPropBool("m_bAlive", w:GetIndex()) and ag or -ag), 0, 1)
                        if at[aA] ~= 0 then
                            table.insert(az, w)
                        end
                    end
                end
                local al = "spectators"
                local s, h, c, b = a0:GetValue()
                local aw = 85
                local y, z = ar:GetValue()
                local x, i = 55 + aw, 50
                x = x - 17
                if X:GetValue() then
                    draw.Color(s, h, c, a2.spectators * 255)
                    draw.FilledRectFade(y + x / 2 + 1, z + 2, y, z, true)
                    draw.FilledRectFade(y + x / 2, z, y + x, z + 2, true)
                    draw.Color(h, c, s, a2.spectators * 255)
                    draw.FilledRectFade(y, z, y + x / 2 + 1, z + 2, true)
                    draw.Color(c, s, h, a2.spectators * 255)
                    draw.FilledRectFade(y + x, z + 2, y + x / 2, z, true)
                else
                    draw.Color(s, h, c, a2.spectators * 255)
                    draw.FilledRect(y, z, y + x, z + 2)
                end
                draw.Color(17, 17, 17, a2.spectators * b)
                draw.FilledRect(y, z + 2, y + x, z + 18)
                draw.Color(255, 255, 255, a2.spectators * 255)
                draw.Text(y - draw.GetTextSize(al) / 2 + x / 2, z + 4, al)
                for l, w in pairs(az) do
                    local ak = w:GetName()
                    local aA = w:GetIndex()
                    local aD, aE = draw.GetTextSize(ak)
                    local b = a2.spectators * at[aA] * 255
                    aw = math.max(aw, aD)
                    draw.Color(255, 255, 255, b)
                    draw.Text(y + 15, z + 8 + l * 15, ak)
                    local aF = draw.GetSteamAvatar and draw.GetSteamAvatar(client.GetPlayerInfo(aA).SteamID, 1)
                    if aF then
                        draw.Color(255, 255, 255, b)
                        draw.SetTexture(aF)
                        draw.FilledRect(y + 4, z + 7 + l * 15, y + 7 + aE, z + 11 + l * 15 + aE)
                        draw.SetTexture(nil)
                    else
                        draw.Color(0, 0, 0, b)
                        draw.FilledRect(y + 4, z + 7 + l * 15, y + 7 + aE, z + 11 + l * 15 + aE)
                        draw.Color(34, 34, 34, b)
                        draw.FilledRect(y + 5, z + 8 + l * 15, y + 6 + aE, z + 10 + l * 15 + aE)
                        draw.Color(255, 255, 255, b)
                        draw.Text(y + 6, z + 8 + l * 15, "?")
                    end
                end
                if a2.spectators ~= 0 then
                    ar:Drag(x, 25 + #az * 15)
                end
                a2.spectators = math.clamp(a2.spectators + (ay and (ax or #az > 0) and ag or -ag), 0, 1)
                draw.SetScissorRect(0, 0, draw.GetScreenSize())
            end
        )
    end
}
a3.watermark()
a3.spectators()

----keybinds
--region aw api
--local variables for API. Automatically generated by https://github.com/simpleavaster/gslua/blob/master/authors/sapphyrus/generate_api.lua
--I only made a little change to make him work for aimware
local entities_GetPlayerResources, entities_FindByClass, entities_GetByIndex, entities_GetLocalPlayer, entities_GetByUserID =
    entities.GetPlayerResources,
    entities.FindByClass,
    entities.GetByIndex,
    entities.GetLocalPlayer,
    entities.GetByUserID
local client_GetLocalPlayerIndex,
    client_ChatSay,
    client_WorldToScreen,
    client_Command,
    client_GetPlayerIndexByUserID,
    client_SetConVar,
    client_GetPlayerInfo,
    client_GetConVar =
    client.GetLocalPlayerIndex,
    client.ChatSay,
    client.WorldToScreen,
    client.Command,
    client.GetPlayerIndexByUserID,
    client.SetConVar,
    client.GetPlayerInfo,
    client.GetConVar
local client_GetPlayerNameByIndex, client_GetPlayerNameByUserID, client_ChatTeamSay, client_AllowListener =
    client.GetPlayerNameByIndex,
    client.GetPlayerNameByUserID,
    client.ChatTeamSay,
    client.AllowListener
local globals_FrameTime,
    globals_AbsoluteFrameTime,
    globals_CurTime,
    globals_TickCount,
    globals_MaxClients,
    globals_RealTime,
    globals_FrameCount,
    globals_TickInterval =
    globals.FrameTime,
    globals.AbsoluteFrameTime,
    globals.CurTime,
    globals.TickCount,
    globals.MaxClients,
    globals.RealTime,
    globals.FrameCount,
    globals.TickInterval
local http_Get = http.Get
local math_ceil,
    math_tan,
    math_huge,
    math_log10,
    math_randomseed,
    math_cos,
    math_sinh,
    math_random,
    math_mod,
    math_pi,
    math_max,
    math_atan2,
    math_ldexp,
    math_floor,
    math_sqrt,
    math_deg,
    math_atan =
    math.ceil,
    math.tan,
    math.huge,
    math.log10,
    math.randomseed,
    math.cos,
    math.sinh,
    math.random,
    math.mod,
    math.pi,
    math.max,
    math.atan2,
    math.ldexp,
    math.floor,
    math.sqrt,
    math.deg,
    math.atan
local math_fmod,
    math_acos,
    math_pow,
    math_abs,
    math_min,
    math_log,
    math_frexp,
    math_sin,
    math_tanh,
    math_exp,
    math_modf,
    math_cosh,
    math_asin,
    math_rad =
    math.fmod,
    math.acos,
    math.pow,
    math.abs,
    math.min,
    math.log,
    math.frexp,
    math.sin,
    math.tanh,
    math.exp,
    math.modf,
    math.cosh,
    math.asin,
    math.rad
local table_foreach, table_sort, table_remove, table_foreachi, table_maxn, table_getn, table_concat, table_insert =
    table.foreach,
    table.sort,
    table.remove,
    table.foreachi,
    table.maxn,
    table.getn,
    table.concat,
    table.insert
local string_find,
    string_lower,
    string_format,
    string_rep,
    string_gsub,
    string_len,
    string_gmatch,
    string_dump,
    string_match,
    string_reverse,
    string_byte,
    string_char,
    string_upper,
    string_gfind,
    string_sub =
    string.find,
    string.lower,
    string.format,
    string.rep,
    string.gsub,
    string.len,
    string.gmatch,
    string.dump,
    string.match,
    string.reverse,
    string.byte,
    string.char,
    string.upper,
    string.gfind,
    string.sub
--endregion
local screen_size = {draw.GetScreenSize()}
local menu = gui.Reference("menu")
local dragging = function(reference, name, base_x, base_y)
    return (function()
        local a = {}
        local b, c, d, e, f, g, h, i, j, k, l, m, n, o
        local p = {
            __index = {
                drag = function(self, ...)
                    local q, r = self:get()
                    local s, t = a.drag(q, r, ...)
                    if q ~= s or r ~= t then
                        self:set(s, t)
                    end
                    return s, t
                end,
                set = function(self, q, r)
                    local j, k = draw.GetScreenSize()
                    self.x_reference:SetValue(q / j * self.res)
                    self.y_reference:SetValue(r / k * self.res)
                end,
                get = function(self)
                    local j, k = draw.GetScreenSize()
                    return self.x_reference:GetValue() / self.res * j, self.y_reference:GetValue() / self.res * k
                end
            }
        }
        function a.new(r, u, v, w, x)
            x = x or 10000
            local j, k = draw.GetScreenSize()
            local y = gui.Slider(r, "x", u .. " position x", v / j * x, 0, x)
            local z = gui.Slider(r, "y", u .. " position y", w / k * x, 0, x)
            y:SetInvisible(true)
            z:SetInvisible(true)
            return setmetatable({reference = r, name = u, x_reference = y, y_reference = z, res = x}, p)
        end
        function a.drag(q, r, A, B, C, D, E)
            if globals_FrameCount ~= b then
                c = menu:IsActive()
                f, g = d, e
                d, e = input.GetMousePos()
                i = h
                h = input.IsButtonDown(0x01) == true
                m = l
                l = {}
                o = n
                n = false
                j, k = draw.GetScreenSize()
            end
            if c and i ~= nil then
                if (not i or o) and h and f > q and g > r and f < q + A and g < r + B then
                    n = true
                    q, r = q + d - f, r + e - g
                    if not D then
                        q = math_max(0, math_min(j - A, q))
                        r = math_max(0, math_min(k - B, r))
                    end
                end
            end
            table_insert(l, {q, r, A, B})
            return q, r, A, B
        end
        return a
    end)().new(reference, name, base_x, base_y)
end

local ref = gui.Reference("Misc", "General", "Extra")
local g_keybinds = gui.Checkbox(ref, "keybinds", "Show Keyings", 1)
local g_keybinds_clr = gui.ColorPicker(g_keybinds, "clr", "clr", 131, 109, 221, 255)
local g_keybinds_clr2 = gui.ColorPicker(g_keybinds, "clr2", "clr2", 0, 0, 0, 100)
local g_keybinds_dragging = dragging(g_keybinds, "keybinds", screen_size[1] * 0.25, screen_size[2] * 0.35)

local obj = {}
local alpha = 0

local keybinds = {
    text = "",
    alpha = 0,
    type = 0,
    visible = true
}

local i = 0
function keybinds:New(text, type, visible)
    i = i + 1
    obj[i] = {}
    setmetatable(obj[i], self)
    self.__index = self
    self.text = text or ""
    self.alpha = 0
    self.type = type or 0
    self.visible = visible

    return obj[i]
end

function keybinds:Add(text, type, visible)
    local a = keybinds:New(text, type, visible)
    a:SetText(text)
    a:SetType(type)
    a:SetVisible(visible)
    return a
end

function keybinds:SetText(text)
    self.text = text
end

function keybinds:SetType(type)
    self.type = type
end

function keybinds:SetVisible(vis)
    self.visible = vis
end

local font = draw.CreateFont("Verdana", 12)

local function clamp(val, min, max)
    if (val > max) then
        return max
    elseif (val < min) then
        return min
    else
        return val
    end
end

local function draw_text_shadow(x, y, r, g, b, a, text)
    draw.Color(4, 4, 4, a)
    draw.Text(x + 1, y + 1, text)
    draw.Color(r, g, b, a)
    draw.Text(x, y, text)
end

local renderer = {}

renderer.rectangle = function(x, y, w, h, clr, fill, radius)
    local alpha = 255
    if clr[4] then
        alpha = clr[4]
    end
    draw.Color(clr[1], clr[2], clr[3], alpha)
    if fill then
        draw.FilledRect(x, y, x + w, y + h)
    else
        draw.OutlinedRect(x, y, x + w, y + h)
    end
    if fill == "s" then
        draw.ShadowRect(x, y, x + w, y + h, radius)
    end
end

renderer.gradient = function(x, y, w, h, clr, clr1, vertical)
    local r, g, b, a = clr1[1], clr1[2], clr1[3], clr1[4]
    local r1, g1, b1, a1 = clr[1], clr[2], clr[3], clr[4]

    if a and a1 == nil then
        a, a1 = 255, 255
    end

    if vertical then
        if clr[4] ~= 0 then
            if a1 and a ~= 255 then
                for i = 0, h do
                    renderer.rectangle(x, y + h - i, w, 1, {r1, g1, b1, i / h * a1}, true)
                end
            else
                renderer.rectangle(x, y, w, h, {r1, g1, b1, a1}, true)
            end
        end
        if a2 ~= 0 then
            for i = 0, h do
                renderer.rectangle(x, y + i, w, 1, {r, g, b, i / h * a}, true)
            end
        end
    else
        if clr[4] ~= 0 then
            if a1 and a ~= 255 then
                for i = 0, w do
                    renderer.rectangle(x + w - i, y, 1, h, {r1, g1, b1, i / w * a1}, true)
                end
            else
                renderer.rectangle(x, y, w, h, {r1, g1, b1, a1}, true)
            end
        end
        if a2 ~= 0 then
            for i = 0, w do
                renderer.rectangle(x + i, y, 1, h, {r, g, b, i / w * a}, true)
            end
        end
    end
end

local function draw_keybinds()
    local x, y = g_keybinds_dragging:get()
    local x, y = math_modf(x), math_modf(y)

    local x_a = 0

    local temp = {}

    local fade_factor = ((1.0 / 0.15) * globals_FrameTime()) * 200

    draw.SetFont(font)

    for i = 1, #obj do
        local __ind = obj[i]
        if __ind.visible then
            __ind.alpha = clamp(__ind.alpha + fade_factor, 0, 255)
        else
            __ind.alpha = clamp(__ind.alpha - fade_factor, 0, 255)
        end

        if __ind.alpha ~= 0 then
            table_insert(temp, obj[i])
            if draw.GetTextSize(__ind.text) > 80 then
                x_a = 20
            end
        end
    end

    if (#temp ~= 0 or menu:IsActive()) and g_keybinds:GetValue() then
        alpha = clamp(alpha + fade_factor, 0, 255)
    else
        alpha = clamp(alpha - fade_factor, 0, 255)
    end
    if alpha ~= 0 then
        g_keybinds_dragging:drag(150, 25)
        local r, g, b, a = g_keybinds_clr:GetValue()
        local r2, g2, b2, a2 = g_keybinds_clr2:GetValue()
        draw.Color(4, 4, 4, alpha * a2 / 255)
        draw.FilledRect(x, y + 2, x + 130 + x_a, y + 18)

        renderer.gradient(x, y, (130 + x_a) * 0.5, 2, {r, g, b, alpha * a / 255}, {r, g, b, 0}, nil)
        renderer.gradient(x + (130 + x_a) * 0.5, y, (130 + x_a) * 0.5, 2, {r, g, b, 0}, {r, g, b, alpha * a / 255}, nil)
        renderer.gradient(x, y + 18, (130 + x_a) * 0.5, 2, {r, g, b, alpha * a / 255}, {r, g, b, 0}, nil)
        renderer.gradient(x + (130 + x_a) * 0.5, y + 18, (130 + x_a) * 0.5, 2, {r, g, b, 0}, {r, g, b, alpha * a / 255}, nil)

        draw.Color(r, g, b, alpha * a / 255)
        draw.FilledRect(x, y, x + 2, y + 20)

        draw.FilledRect(x + (130 + x_a), y, x + (130 + x_a) + 2, y + 20)

        draw_text_shadow(x + 44 + (x_a * 0.5), y + 4, 255, 255, 255, alpha, "")
    end

    local y = y + 25

    for i = 1, #obj do
        local __ind = obj[i]

        if __ind.alpha ~= 0 then
            if #temp ~= 0 then
                draw_text_shadow(x + 3, y, 255, 255, 255, __ind.alpha, __ind.text)

                if __ind.type == 1 then
                    draw_text_shadow(x + 82 + x_a, y, 255, 255, 255, __ind.alpha, "")
                elseif __ind.type == 2 then
                    draw_text_shadow(x + 82 + x_a, y, 255, 255, 255, __ind.alpha, "")
                end

                y = y + 15
            end
        end
    end
end

local function add_keybinds(text, type, Visible)
    return keybinds:Add(text, type, Visible)
end

local function menu_weapon(var)
    local wp = string_match(var, [["(.+)"]])
    local wp = string_lower(wp)
    if wp == "heavy pistol" then
        return "hpistol"
    elseif wp == "auto sniper" then
        return "asniper"
    elseif wp == "submachine gun" then
        return "smg"
    elseif wp == "light machine gun" then
        return "lmg"
    else
        return wp
    end
end

--legit
local legitbot_weapon_visibility = gui.Reference("Legitbot", "Weapon", "Visibility")

local legit_silent_aimbot = add_keybinds("Legit silent aimbot", 2, true)
local legit_smoke = add_keybinds("Legit through smoke", 2, true)
local legit_autowall = add_keybinds("Legit auto wall", 2, true)
local legit_aimbot = add_keybinds("Legit aimbot", 1, true)
local legit_triggerbot = add_keybinds("triggerbot", 1, true)

--rage
local ragebot_accuracy_weapon = gui.Reference("Ragebot", "Accuracy", "Weapon")

local aa_inverter = add_keybinds("GOD AA", 2, true)
local shift_on_shot = add_keybinds("Hiding", 2, true)
local double_tap = add_keybinds("Double TAP", 2, true)
local slow_walk = add_keybinds("Slowwalking", 1, true)
local fake_duck = add_keybinds("FUCK DUCK", 1, true)

--misc
local speed_burst = add_keybinds("Speed burst", 1, true)

local get_var = gui.GetValue
local function keybinds()
    --master
    local legit = get_var("lbot.master")
    local rage = get_var("rbot.master")
    local misc = get_var("misc.master")

    legit_aimbot:SetVisible(false)
    legit_triggerbot:SetVisible(false)
    legit_autowall:SetVisible(false)
    legit_smoke:SetVisible(false)
    legit_silent_aimbot:SetVisible(false)
    ----
    double_tap:SetVisible(false)
    slow_walk:SetVisible(false)
    aa_inverter:SetVisible(false)
    fake_duck:SetVisible(false)
    shift_on_shot:SetVisible(false)
    ----
    speed_burst:SetVisible(false)

    if not g_keybinds:GetValue() then
        return
    end

    if legit then
        local aimbot = get_var("lbot.aim.enable")
        if aimbot then
            local key = get_var("lbot.aim.key")
            local af = get_var("lbot.aim.autofire")
            legit_aimbot:SetVisible((key ~= 0 and input.IsButtonDown(key)) or af)
            if af then
                legit_aimbot:SetType(2)
            else
                legit_aimbot:SetType(1)
            end
        end

        local triggerbot = get_var("lbot.trg.enable")
        if triggerbot then
            local key = get_var("lbot.trg.key")
            local af = get_var("lbot.trg.autofire")
            legit_triggerbot:SetVisible((key ~= 0 and input.IsButtonDown(key)) or af)
            if af then
                legit_triggerbot:SetType(2)
            else
                legit_triggerbot:SetType(1)
            end
        end

        local weapon = menu_weapon(legitbot_weapon_visibility:GetValue())
        legit_autowall:SetVisible(get_var("lbot.weapon.vis." .. weapon .. ".autowall"))
        legit_smoke:SetVisible(get_var("lbot.weapon.vis." .. weapon .. ".smoke"))

        legit_silent_aimbot:SetVisible(get_var("lbot.semirage.silentaimbot"))
    end
    if rage then
        local weapon = menu_weapon(ragebot_accuracy_weapon:GetValue())
        local weapon_pcall = pcall(get_var, "rbot.accuracy.weapon." .. weapon .. ".doublefire")
        double_tap:SetVisible(weapon_pcall and get_var("rbot.accuracy.weapon." .. weapon .. ".doublefire") > 0)

        local slow_walk_key = get_var("rbot.accuracy.movement.slowkey")
        slow_walk:SetVisible(slow_walk_key ~= 0 and input.IsButtonDown(slow_walk_key))

        aa_inverter:SetVisible(get_var("rbot.antiaim.base.lby") < 0)

        local fake_duck_key = get_var("rbot.antiaim.extra.fakecrouchkey")
        fake_duck:SetVisible(fake_duck_key ~= 0 and input.IsButtonDown(fake_duck_key))

        shift_on_shot:SetVisible(get_var("rbot.antiaim.condition.shiftonshot"))
    end

    if misc then
        if get_var("misc.speedburst.enable") then
            local speedburst_key = get_var("misc.speedburst.key")
            speed_burst:SetVisible(speedburst_key ~= 0 and input.IsButtonDown(speedburst_key))
        end
    end
end

callbacks.Register(
    "Draw",
    function()
        draw_keybinds()
        keybinds()
    end
)

-----








local fonte = draw.CreateFont("segoe ui", 26, 1000   )--("Tahoma",26, 1000)--("Microsoft Tai Le",30, 600)--("segoe ui", 30, 600) -- skeet fonte
local fonte = draw.CreateFont("Microsoft Tai Le",22, 2000)--("Verdana", 24, 700)
local fonte2 = draw.CreateFont("Marlett", 34, 100)
local fonte3 = draw.CreateFont("Yold Anglican", 24, 20)
local fonte4 = draw.CreateFont("Tahoma", 18, 20)
local fonte5 = draw.CreateFont("ActaSymbolsW95-Arrows", 18, 20)

local renderer = {}
local screenW, screenH = draw.GetScreenSize()
local guiSet = gui.SetValue
local guiGet = gui.GetValue
local baim = 1;
local switch_fbaim = false;
local weapons_table = {"asniper", "hpistol", "lmg", "pistol", "rifle", "scout", "smg", "shotgun", "sniper", "zeus", "shared"};


 ------------------------------------------------ Window 

local visuals_menu = gui.Reference("VISUALS", "OTHER", "Effects")
local visuals_custom_viewmodel_editor = gui.Checkbox( visuals_menu, "lua_custom_viewmodel_editor", "Custom Viewmodel Editor", 0 );
local xO = client.GetConVar("viewmodel_offset_x");  
local yO = client.GetConVar("viewmodel_offset_y");  
local zO = client.GetConVar("viewmodel_offset_z");   
local xS = gui.Slider(visuals_menu, "lua_x", "X", xO, -20, 20);   
local yS = gui.Slider(visuals_menu, "lua_y", "Y", yO, -100, 100);   
local zS = gui.Slider(visuals_menu, "lua_z", "Z", zO, -20, 20);  
local INDICATORS_COLOR = gui.ColorPicker( visuals_menu, 'indicators_color', 'Indicators Color',152, 204, 0, 255)
local r, g, b, a = INDICATORS_COLOR:GetValue()
local function _color(r, g, b, a)
    local r = math.min(255, math.max(0, r))
    local g = math.min(255, math.max(0, g or r))
    local b = math.min(255, math.max(0, b or g or r))
    local a = math.min(255, math.max(0, a or 255))
    return r, g, b, a
end
local gradient_texture_a =
draw.CreateTexture(
    common.RasterizeSVG(
    [[<defs><linearGradient id="a" x1="100%" y1="0%" x2="0%" y2="0%"><stop offset="0%" style="stop-color:rgb(255,255,255); stop-opacity:0" /><stop offset="100%" style="stop-color:rgb(255,255,255); stop-opacity:1" /></linearGradient></defs><rect width="500" height="500" style="fill:url(#a)" /></svg>]]
)
)

local gradient_texture_b =
draw.CreateTexture(
    common.RasterizeSVG(
    [[<defs><linearGradient id="c" x1="0%" y1="100%" x2="0%" y2="0%"><stop offset="0%" style="stop-color:rgb(255,255,255); stop-opacity:0" /><stop offset="100%" style="stop-color:rgb(255,255,255); stop-opacity:1" /></linearGradient></defs><rect width="500" height="500" style="fill:url(#c)" /></svg>]]
)
)

function draw.gradient(xa, ya, xb, yb, ca, cb, ltr)
local r, g, b, a = _color(ca[1], ca[2], ca[3], ca[4])
local r2, g2, b2, a2 = _color(cb[1], cb[2], cb[3], cb[4])

local texture = ltr and gradient_texture_a or gradient_texture_b

local t = (a ~= 255 or a2 ~= 255)
draw.Color(r, g, b, a)
draw.SetTexture(t and texture or nil)
draw.FilledRect(xa, ya, xb, yb)

draw.Color(r2, g2, b2, a2)
local set_texture = not t and draw.SetTexture(texture)
draw.FilledRect(xb, yb, xa, ya)
draw.SetTexture(nil)
end

function math.round(exact, quantum)
    local quant,frac = math.modf(exact/quantum)
    return quantum * (quant + (frac > 0.5 and 1 or 0))
end
local function _round(number, precision)
    local mult = 10 ^ (precision or 0)
    return math.floor(number * mult + 0.5) / mult
end

renderer.text = function(x,y,string, col, font)
   
    draw.Color( col[1], col[2], col[3], col[4] )
    draw.SetFont( font )
    draw.Text( x, y, string )

end
 
renderer.outline_text = function(x,y, string, col, font) 

    draw.SetFont( font )
    draw.Color(0,0,0,255)
    draw.Text(x + 1, y + 1,string) 
    draw.Text(x - 1, y - 1,string) 
    draw.Text(x + 1, y - 1,string) 
    draw.Text(x - 1, y + 1,string) 

    draw.Color(col[1], col[2], col[3], col[4])
    draw.Text(x, y,string) 
    

end
 

renderer.rectangle = function(x, y, w, h, clr, fill, radius)
    local alpha = 255
    if clr[4] then
        alpha = clr[4]
    end
    draw.Color(clr[1], clr[2], clr[3], alpha)
    if fill then
        draw.FilledRect(x, y, x + w, y + h)
    else
        draw.OutlinedRect(x, y, x + w, y + h)
    end
    if fill == "s" then
        draw.ShadowRect(x, y, x + w, y + h, radius)
    end
end

renderer.gradient = function(x, y, w, h, clr, clr1, vertical)
    local r, g, b, a = clr1[1], clr1[2], clr1[3], clr1[4]
    local r1, g1, b1, a1 = clr[1], clr[2], clr[3], clr[4]

    if a and a1 == nil then
        a, a1 = 255, 255
    end

    if vertical then
        if clr[4] ~= 0 then
            if a1 and a ~= 255 then
                for i = 0, w do
                    renderer.rectangle(x, y + w - i, w, 1, {r1, g1, b1, i / w * a1}, true)
                end
            else
                renderer.rectangle(x, y, w, h, {r1, g1, b1, a1}, true)
            end
        end
        if a2 ~= 0 then
            for i = 0, h do
                renderer.rectangle(x, y + i, w, 1, {r, g, b, i / h * a}, true)
            end
        end
    else
        if clr[4] ~= 0 then
            if a1 and a ~= 255 then
                for i = 0, w do
                    renderer.rectangle(x + w - i, y, 1, h, {r1, g1, b1, i / w * a1}, true)
                end
            else
                renderer.rectangle(x, y, w, h, {r1, g1, b1, a1}, true)
            end
        end
        if a2 ~= 0 then
            for i = 0, w do
                renderer.rectangle(x + i, y, 1, h, {r, g, b, i / w * a}, true)
            end
        end
    end
end
 renderer.rect = function(x, y, w, h, col)
    draw.Color(col[1], col[2], col[3], col[4]);
    draw.FilledRect(x, y, x + w, y + h);
end
 
 --DON't TOUCH BELOW OR UR INDICATORS WILL BREAK
  local indicator = {{}}
  function draw.indicator(r,g,b,a, string)
    local new = {}
    local add = indicator[1]
    local x, y = draw.GetScreenSize()

    new.y = y / 1.4105 - #add * 35

    local i = #add + 1
    add[i] = {}

    setmetatable(add[i], new)
    new.__index = new
    new.r, new.g, new.b, new.a = _color(r,g,b,a )
    new.string = string or ""

    return new.y
end

callbacks.Register(
    "Draw",
    function()
        local temp = {}
        local add = indicator[1]
        local _x, y = draw.GetScreenSize()
        local x = 12
        local c = 0

        draw.SetFont(fonte)

        add.y = _round(y / 1.4105 - #temp * 35)

        for i = 1, #add do
            temp[#temp + 1] = add[i]
        end

        for i = 1, #temp do
            local _i = temp[i]

            local w, h = draw.GetTextSize(_i.string)
            local xa = _round(x + w * 0.45)
            local ya = add.y - 6
            local xb = add.y + 25
--                                                               255 = _i.a (useless info xd)
            draw.gradient(x, ya, xa, xb, {c, c, c, c}, {c, c, c, 255 * 0.3}, true)
            draw.gradient(xa, ya, x + w * 0.9, xb, {c, c, c, 255 * 0.3}, {c, c, c, c}, true)

            draw.Color (_i.r, _i.g, _i.b, 255)
            draw.TextShadow(x + 1, add.y + 1.5, _i.string)

            add.y = add.y - 35
        end

        indicator[1] = {}
    end
)

local defaultratio = client.GetConVar("r_aspectratio")

callbacks.Register( "Draw", function()
    for i, Player in pairs(entities.FindByClass("CCSPlayer")) do
        Player:SetProp("m_bSpotted", 1)
    end
end)

local function UnlockInventory()
    panorama.RunScript([[ LoadoutAPI.IsLoadoutAllowed = () => { return true; }; ]]);
end

callbacks.Register( "Draw", UnlockInventory)
 
local function Visuals_Viewmodel() 

   if visuals_custom_viewmodel_editor:GetValue() then  
	client.SetConVar("viewmodel_offset_x", xS:GetValue(), true); 
	client.SetConVar("viewmodel_offset_y", yS:GetValue(), true); 
	client.SetConVar("viewmodel_offset_z", zS:GetValue(), true); 
else
	client.SetConVar("viewmodel_offset_x", x0, true); 
	client.SetConVar("viewmodel_offset_y", y0, true); 
	client.SetConVar("viewmodel_offset_z", z0, true); 

   end
   end
local function Visuals_Disable_Post_Processing()
       if visuals_disable_post_processing:GetValue() then  
           client.SetConVar( "mat_postprocess_enable", 0, true );
   else
       client.SetConVar( "mat_postprocess_enable", 1, true );
       end
   end
 local function unload_viewmodel()
	client.SetConVar("viewmodel_offset_x", x0, true); 
	client.SetConVar("viewmodel_offset_y", y0, true); 
	client.SetConVar("viewmodel_offset_z", z0, true); 
end

callbacks.Register("Draw", "Custom Viewmodel Editor", Visuals_Viewmodel)
callbacks.Register("Unload", unload_viewmodel)

local aspect_ratio_table = {};   
local aspect_ratio_check = gui.Checkbox(visuals_menu, "aspect_ratio_check", "Aspect Ratio Changer", false); 
local aspect_ratio_reference = gui.Slider(visuals_menu, "aspect_ratio_reference", "Force aspect ratio", 100, 1, 199)
local function gcd(m, n)    while m ~= 0 do   m, n = math.fmod(n, m), m; 
end
return n
end

local function set_aspect_ratio(aspect_ratio_multiplier)
local screen_width, screen_height = draw.GetScreenSize();   local aspectratio_value = (screen_width*aspect_ratio_multiplier)/screen_height; 
    if aspect_ratio_multiplier == 1 or not aspect_ratio_check:GetValue() then  aspectratio_value = 0;   end
        client.SetConVar( "r_aspectratio", tonumber(aspectratio_value), true);   end
local function on_aspect_ratio_changed()
local screen_width, screen_height = draw.GetScreenSize();
for i=1, 200 do   local i2=i*0.01;    i2 = 2 - i2;   local divisor = gcd(screen_width*i2, screen_height);    if screen_width*i2/divisor < 100 or i2 == 1 then   aspect_ratio_table[i] = screen_width*i2/divisor .. ":" .. screen_height/divisor;  end  end
local aspectonload = aspect_ratio_reference:GetValue()
local aspect_ratio = aspectonload*0.01;
aspect_ratio = 2 - aspect_ratio;
set_aspect_ratio(aspect_ratio);
end

local function unload_aspect_ratio()
	client.SetConVar( "r_aspectratio", defaultratio, true);
end
callbacks.Register('Draw', "Aspect Ratio" ,on_aspect_ratio_changed)
callbacks.Register("Unload", unload_aspect_ratio)

callbacks.Register("FireGameEvent", "Crosshair", function(event)
    if event:GetName()=="round_start" then
    	if entities.GetLocalPlayer()~=nil then
    		client.SetConVar("weapon_recoil_view_punch_extra", 0, true)
    		client.SetConVar("weapon_debug_spread_show",3,true)
    		client.SetConVar("view_punch_decay", 0, true)
    		client.SetConVar("viewmodel_recoil", 0, true)
    	end
    end
end)

client.AllowListener("round_start")

local guiSet = gui.SetValue
local guiGet = gui.GetValue
local togglekey = input.IsButtonDown
local ref = gui.Reference("RAGEBOT");
local tab = gui.Tab(ref,"Extra","Jackyaw")
local dmgsettings = gui.Groupbox(tab,"Jackyaw",16,16,280,300)
local togglekey = gui.Keybox(dmgsettings, "ChangeDmgKey", "Mindamage Key", 0)
local setDmg = gui.Combobox(dmgsettings, "mindmgmode", "Min Damage Mode", "Off", "Toggle", "Hold")
local awpdmg = gui.Groupbox(tab,"Awp Damage Settings",16,190,280,300)
local awpori = gui.Slider(awpdmg, "awpori", "Awp Original Min Damage", 1, 0, 130)
local awpDamage = gui.Slider(awpdmg, "awpDamage", "Awp Override Min Damage", 1, 0, 130)
local scoutdmg = gui.Groupbox(tab,"Scout Damage Settings",310,16,280,300)
local scoutori = gui.Slider(scoutdmg, "scoutori", "Scout Original Min Damage", 1, 0, 130)
local scoutDamage = gui.Slider(scoutdmg, "scoutDamage", "Scout Override Min Damage", 1, 0, 130)
local autodmg = gui.Groupbox(tab,"Auto Damage Settings",310,190,280,300)
local autoori = gui.Slider(autodmg, "autoori", "Auto Original Min Damage", 1, 0, 130)
local autoDamage = gui.Slider(autodmg, "autoDamage", "Auto Override Min Damage", 1, 0, 130)
local r8dmg = gui.Groupbox(tab,"R8 Damage Settings",16,350,280,300)
local r8ori = gui.Slider(r8dmg, "r8ori", "R8 Original Min Damage", 1, 0, 130)
local r8Damage = gui.Slider(r8dmg, "R8Damage", "R8 Override Min Damage", 1, 0, 130)


local Toggle =-1
local pressed = false

function changeMinDamage()
if (setDmg:GetValue()==1) then
        if input.IsButtonReleased(togglekey:GetValue()) then
            pressed=true;
Toggle = Toggle *-1

        elseif (pressed and input.IsButtonPressed(togglekey:GetValue())) then
            pressed=false;

            if Toggle == 1 then
            guiSet("rbot.accuracy.weapon.sniper.mindmg", awpDamage:GetValue())
            guiSet("rbot.accuracy.weapon.scout.mindmg", scoutDamage:GetValue())
            guiSet("rbot.accuracy.weapon.asniper.mindmg", autoDamage:GetValue())
            guiSet("rbot.accuracy.weapon.hpistol.mindmg", r8Damage:GetValue())
            else
        guiSet("rbot.accuracy.weapon.asniper.mindmg", autoori:GetValue())
        guiSet("rbot.accuracy.weapon.sniper.mindmg", awpori:GetValue())
        guiSet("rbot.accuracy.weapon.scout.mindmg", scoutori:GetValue())
        guiSet("rbot.accuracy.weapon.hpistol.mindmg", r8ori:GetValue())
            end
        end
    elseif (setDmg:GetValue()==2) then
        if input.IsButtonDown(togglekey:GetValue()) then
            guiSet("rbot.accuracy.weapon.sniper.mindmg", awpDamage:GetValue())
            guiSet("rbot.accuracy.weapon.scout.mindmg", scoutDamage:GetValue())
            guiSet("rbot.accuracy.weapon.asniper.mindmg", autoDamage:GetValue())
            guiSet("rbot.accuracy.weapon.hpistol.mindmg", r8Damage:GetValue())
        else
        guiSet("rbot.accuracy.weapon.asniper.mindmg", autoori:GetValue())
        guiSet("rbot.accuracy.weapon.sniper.mindmg", awpori:GetValue())
        guiSet("rbot.accuracy.weapon.scout.mindmg", scoutori:GetValue())
        guiSet("rbot.accuracy.weapon.hpistol.mindmg", r8ori:GetValue())
        end
    elseif (setDmg:GetValue()==0) then
        Toggle = -1
        guiSet("rbot.accuracy.weapon.asniper.mindmg", autoori:GetValue())
        guiSet("rbot.accuracy.weapon.sniper.mindmg", awpori:GetValue())
        guiSet("rbot.accuracy.weapon.scout.mindmg", scoutori:GetValue())
        guiSet("rbot.accuracy.weapon.hpistol.mindmg", r8ori:GetValue())
    end
end

-- get weapon in hand 
local function weapon()
	if not entities.GetLocalPlayer() then return end
	entity = entities.GetLocalPlayer()
	weaponID = entity:GetWeaponID()
	if weaponID==2 or weaponID==3 or weaponID==4 or weaponID==30 or weaponID==32 or weaponID==36 or weaponID==61 or weaponID==63 then
		return "pistol"
	elseif weaponID==9 then
		return "sniper"
	elseif weaponID==40 then
		return "scout"
	elseif weaponID==1 or weaponID==64 then
		return "hpistol"
	elseif weaponID==17 or weaponID== 19 or weaponID== 23 or weaponID== 24 or weaponID== 26 or weaponID== 33 or weaponID== 34 then
		return "smg"
	elseif weaponID==7 or weaponID==8 or weaponID== 10 or weaponID== 13 or weaponID== 16 or weaponID== 39 or weaponID== 61 then
		return "rifle"
	elseif weaponID== 25 or weaponID== 27 or weaponID== 29 or weaponID== 35 then
		return "shotgun"
	elseif weaponID == 38 or weaponID==11 then
		return "asniper"
	elseif weaponID == 28 or weaponID== 14 then
		return "lmg"
	else
		return nil
	end
end

local fonte = draw.CreateFont( "tahoma negrito", 40 )

function Drawtext()
	if gui.GetValue("rbot.master")==false then return end
	if entities.GetLocalPlayer()==nil then return end
	if entities.GetLocalPlayer():IsAlive()==false then return end
	localp = entities.GetLocalPlayer()

	local r, g, b, a = INDICATORS_COLOR:GetValue()
	if not weapon()==nil then
		local dt_pcall = pcall(gui.GetValue, "rbot.accuracy.weapon." .. weapon() .. ".doublefire")
	end
	draw.SetFont(fonte)
    local w, h = draw.GetScreenSize()
    w = 14
    h = (h/2)-14
    
   --
   	if gui.GetValue("rbot.antiaim.extra.fakecrouchkey")~=0 then
	    if input.IsButtonDown(gui.GetValue("rbot.antiaim.extra.fakecrouchkey")) then
	        draw.indicator(255,255,255, 255, "DUCK")
	    end
	end
    if gui.GetValue("rbot.accuracy.movement.autopeekkey") ~= 0 then
        if input.IsButtonDown(gui.GetValue("rbot.accuracy.movement.autopeekkey")) then
        	draw.indicator(255,255,255, 255, "PEEK")
        end
    end
    if weapon()~=nil then
        if gui.GetValue("rbot.accuracy.weapon." .. weapon() .. ".doublefire") > 0 then   
            draw.indicator(255,255,255,255, "DT")
        end
    end
    local body_yaw = math.max(-60, math.min(60, math.round((entities.GetLocalPlayer():GetPropFloat( "m_flPoseParameter", "11") or 0)*120-60+0.5, 1)))
    if weapon()=="sniper" then
    	text = "DMG: " .. gui.GetValue("rbot.accuracy.weapon.sniper.mindmg")
    	draw.indicator(r,g,b,a,text)
    elseif weapon()=="scout" then
    	text = "DMG: " .. gui.GetValue("rbot.accuracy.weapon.scout.mindmg")
        draw.indicator(r,g,b,a,text)
    elseif weapon()=="hpistol" then
    	text = "DMG: " .. gui.GetValue("rbot.accuracy.weapon.hpistol.mindmg")
    	draw.indicator(r,g,b,a,text)
    elseif weapon()=="asniper" then
    	text = "DMG: " .. gui.GetValue("rbot.accuracy.weapon.asniper.mindmg")
    	draw.indicator(r,g,b,a,text)
    end
    draw.indicator(r, g, b, a, 'FAKE:' .. ' ' ..  math.abs(body_yaw) .. '°')
    draw.indicator(r, g, b, a, 'FOV:' .. ' ' ..gui.GetValue( "rbot.aim.target.fov" ) .. '°')
end

callbacks.Register("Draw", "Drawtext", Drawtext);
callbacks.Register("Draw", "changeMinDamage", changeMinDamage);

local cb = gui.Checkbox( gui.Reference( "Visuals", "Other", "Effects" ), "esp.chams.ghost.pulsating", "Pulsating Chams", 1)
local picker = gui.ColorPicker( gui.Reference( "Visuals", "Other", "Effects" ), "esp.chams.ghost.pulsating.clr", "Color Chams", 0, 0, 0, 0 )

callbacks.Register("Draw", function()
    if not cb:GetValue() then return end
    local r,g,b,o = picker:GetValue()
    local o = math.floor(math.sin((globals.RealTime()) * 6) * 68 + 112) - 40
    gui.SetValue("esp.chams.ghost.visible.clr", r, g, b, o)
end)