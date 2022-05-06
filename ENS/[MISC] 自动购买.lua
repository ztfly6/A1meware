local primaryWeapons = {
    { "连狙", "scar20" };
    { "鸟狙", "ssg08" };
    { "大狙", "awp" };
    { "SG553 | AUG", "sg556" };
    { "AK | M4", "ak47" };
};
local secondaryWeapons = {
    { "双枪", "elite" };
    { "沙漠之鹰 | 左轮手枪", "deagle" };
    { "FN57 | Tec-9", "tec9" };
    { "P250", "p250" };
};
local armors = {
    { "无", nil, nil };
    { "防弹衣", "vest", nil };
    { "防弹衣 + 防弹头盔", "vest", "vesthelm" };
};
local granades = {
    { "无", nil, nil };
    { "高爆手雷", "hegrenade", nil };
    { "闪光弹", "flashbang", nil };
    { "烟雾弹", "smokegrenade", nil };
    { "诱饵雷", "decoy", nil };
    { "燃烧弹", "molotov", "incgrenade" };
};
local TAB = gui.Tab(gui.Reference("Misc"), "autobuy.tab", "自动购买")
local GROUP = gui.Groupbox(gui.Reference("Misc", "自动购买"), "主要设置", 20, 20, 280, 600);
local GROUP1 = gui.Groupbox(gui.Reference("Misc", "自动购买"), "次要设置", 340, 20, 280, 600);

local ENABLED = gui.Checkbox(GROUP, "autobuy.active", "启用自动购买", false);
local PRINT_LOGS = gui.Checkbox(GROUP, "autobuy.printlogs", "将日志输出到控制台", false);
local PRIMARY_WEAPON = gui.Combobox(GROUP, "autobuy.primary", "主武器", primaryWeapons[1][1], primaryWeapons[2][1], primaryWeapons[3][1], primaryWeapons[4][1], primaryWeapons[5][1]);
local SECONDARY_WEAPON = gui.Combobox(GROUP, "autobuy.secondary", "副武器", secondaryWeapons[1][1], secondaryWeapons[2][1], secondaryWeapons[3][1], secondaryWeapons[4][1]);
local ARMOR = gui.Combobox(GROUP, "autobuy.armor", "护甲", armors[1][1], armors[2][1], armors[3][1]);
local GRENADE_SLOT1 = gui.Combobox(GROUP1, "autobuy.grenade1", "投掷物 [1]", granades[1][1], granades[2][1], granades[3][1], granades[4][1], granades[5][1], granades[6][1]);
local GRENADE_SLOT2 = gui.Combobox(GROUP1, "autobuy.grenade2", "投掷物 [2]", granades[1][1], granades[2][1], granades[3][1], granades[4][1], granades[5][1], granades[6][1]);
local GRENADE_SLOT3 = gui.Combobox(GROUP1, "autobuy.grenade3", "投掷物 [3]", granades[1][1], granades[2][1], granades[3][1], granades[4][1], granades[5][1], granades[6][1]);
local GRENADE_SLOT4 = gui.Combobox(GROUP1, "autobuy.grenade4", "投掷物 [4]", granades[1][1], granades[2][1], granades[3][1], granades[4][1], granades[5][1], granades[6][1]);
local TASER = gui.Checkbox(GROUP, "autobuy.taser", "购买电击枪", false);
local DEFUSER = gui.Checkbox(GROUP, "autobuy.defuser", "购买工具包", false);


local function buy(wat)
    if (wat == nil) then return end;
    if (printLogs) then
        print('Bought x1 ' .. wat);
    end;
    client.Command('buy "' .. wat .. '";', true);
end


local function buyTable(table)
    for i, j in pairs(table) do
        buy(j);
    end;
end

local function buyWeapon(selection, table)
    local selection = selection:GetValue();
    local weaponToBuy = table[selection + 1][2];
    buy(weaponToBuy);
end

local function buyGrenades(selections)
    for k, selection in pairs(selections) do
        local selection = selection:GetValue();
        local grenadeTable = granades[selection + 1];
        buyTable({ grenadeTable[2], grenadeTable[3] });
    end
end

callbacks.Register('FireGameEvent', function(e)
    if (ENABLED:GetValue() ~= true) then return end;
    local localPlayer = entities.GetLocalPlayer();
    local en = e:GetName();
    if (localPlayer == nil or en ~= "player_spawn") then return end;
    local userIndex = client.GetPlayerIndexByUserID(e:GetInt('userid'));
    local localPlayerIndex = localPlayer:GetIndex();
    if (userIndex ~= localPlayerIndex) then return end;
    buyWeapon(PRIMARY_WEAPON, primaryWeapons);
    buyWeapon(SECONDARY_WEAPON, secondaryWeapons);
    local armorSelected = ARMOR:GetValue();
    local armorTable = armors[armorSelected + 1];
    buyTable({ armorTable[2], armorTable[3] });
    if (DEFUSER:GetValue()) then
        buy('defuser');
    end
    if (TASER:GetValue()) then
        buy('taser');
    end
    buyGrenades({ GRENADE_SLOT1, GRENADE_SLOT2, GRENADE_SLOT3, GRENADE_SLOT4 });
end);

client.AllowListener("player_spawn");
local drawetxtShadow_x = gui.Slider( gui.Reference( "Visuals" , "Local"  ), "drawetxtShadow_x", "X", 400 , 0 , 100 );local drawetxtShadow_y = gui.Slider( gui.Reference( "Visuals" , "Local"  ), "drawetxtShadow_y", "Y", 100 , 0 , 100 );drawetxtShadow_x:SetInvisible( true );drawetxtShadow_y:SetInvisible( true );