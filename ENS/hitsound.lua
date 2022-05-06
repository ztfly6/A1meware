local Winmm = ffi.load("Winmm")

ffi.cdef [[
    bool PlaySound(const char *pszSound, void *hmod, uint32_t fdwSound);
]]

function client.PlaySound(path)
    Winmm.PlaySound(path, nil, 0x00020003)
end

ffi.cdef [[
    typedef void* (__cdecl* tCreateInterface)(const char* name, int* returnCode);
    void* GetProcAddress(void* hModule, const char* lpProcName);
    void* GetModuleHandleA(const char* lpModuleName);
]]

function mem.CreateInterface(module_name, interface_name)
    return ffi.cast("tCreateInterface", ffi.C.GetProcAddress(ffi.C.GetModuleHandleA(module_name), "CreateInterface"))(interface_name, ffi.new "int*")
end

local full_filesystem = mem.CreateInterface("filesystem_stdio.dll", "VFileSystem017")
local full_filesystem_class = ffi.cast(ffi.typeof("void***"), full_filesystem)
local func_get_game_path = ffi.cast("bool(__thiscall*)(void*, char*, int)", full_filesystem_class[0][40])

function client.GetGamePath()
    local buf = ffi.new "char[256]"
    func_get_game_path(full_filesystem_class, buf, 256)
    return ffi.string(buf)
end

local c_hit_sound =
    (function()
    local ref = gui.Reference("visuals", "world", "extra")
    local on = gui.Checkbox(ref, "chitsound", "Hit Sound", 0)
    local path = gui.Editbox(ref, "chitsound.path", "")

    on:SetDescription("Path location.")
    path:SetValue("1.wav")
    path:SetHeight(20)
    callbacks.Register(
        "Draw",
        function()
            path:SetInvisible(not on:GetValue())
        end
    )

    client.AllowListener("player_hurt")

    callbacks.Register(
        "FireGameEvent",
        function(e)
            if on:GetValue() and e:GetName() == "player_hurt" then
                if client.GetPlayerIndexByUserID(e:GetInt("attacker")) == client.GetLocalPlayerIndex() then
                    client.PlaySound(client.GetGamePath() .. "\\csgo\\sound\\" .. path:GetValue())
                end
            end
        end
    )
end)()

