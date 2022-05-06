--Aimware V5 Locational Hit Indicator Lua By Rudi

local ref = gui.Reference("Visuals", "World", "Extra");
local hitmarkerCheckbox = gui.Checkbox(ref, "lua_hitmarker", "命中提示", true);
local headshotCheckbox = gui.Checkbox(ref, "lua_headshot", "爆头提示", true);

local hitmarkerColor = gui.ColorPicker(hitmarkerCheckbox, "lua_hitmarker_color", "", 255, 255, 255, 255);
local headshotColor = gui.ColorPicker(headshotCheckbox, "lua_headshot_color", "", 0, 255, 0, 255);

hitPositions = {};
hitTimes = {};
hitTypes = {};
bulletImpactPositions = {};
deltaTimes = {};

local hitCount = 0;
local newHitCount = 0;
local bulletImpactCount = 0;
local hitFlag = false;

--Change if you want
local markerSize = 5;
local fadeTime = 1;
local headshotSpeed = 5;

local function AddHit(hitPos, type)
    table.insert(hitPositions, hitPos);
    table.insert(hitTimes, globals.CurTime());
    table.insert(hitTypes, type);
    hitCount = hitCount + 1;
end

local function RemoveHit(index)
    table.remove(hitPositions, index);
    table.remove(hitTimes, index);
    table.remove(hitTypes, index);
    table.remove(deltaTimes, index);
    newHitCount = newHitCount - 1;
end

local function GetClosestImpact(point)
    local bestImpactIndex;
    local bestDist = 11111111111;
    for i = 0, bulletImpactCount, 1 do
        if (bulletImpactPositions[i] ~= nil) then
            local delta = bulletImpactPositions[i] - point;
            local dist = delta:Length();
            if (dist < bestDist) then
                bestDist = dist;
                bestImpactIndex = i;
            end
        end
    end

    return bulletImpactPositions[bestImpactIndex];
end

local function hFireGameEvent(GameEvent)
    if (GameEvent:GetName() == "bullet_impact") then
        local attacker = entities.GetByUserID(GameEvent:GetInt("userid"));
        if (attacker ~= nil and attacker:GetName() == entities.GetLocalPlayer():GetName()) then
            hitFlag = true;
            local hitPos = Vector3(GameEvent:GetFloat("x"), GameEvent:GetFloat("y"), GameEvent:GetFloat("z"));
            table.insert(bulletImpactPositions, hitPos);
            bulletImpactCount = bulletImpactCount + 1;
        end

    elseif (GameEvent:GetName() == "player_hurt") then
        local victim = entities.GetByUserID(GameEvent:GetInt("userid"));
        local attacker = entities.GetByUserID(GameEvent:GetInt("attacker"));
        if (attacker ~= nil and victim ~= nil and attacker:GetName() == entities.GetLocalPlayer():GetName() and victim:GetTeamNumber() ~= entities.GetLocalPlayer():GetTeamNumber()) then
            local hitGroup = GameEvent:GetInt("hitgroup");
            if (hitFlag) then
                hitFlag = false;
                local impact = GetClosestImpact(victim:GetHitboxPosition(hitGroup));
                if (hitGroup == 1 and headshotCheckbox:GetValue()) then
                    impact.z = impact.z + 5
                    AddHit(impact, 1);
                elseif (hitmarkerCheckbox:GetValue()) then
                    AddHit(impact, 0);
                end
                bulletImpactPositions = {};
                bulletImpactCount = 0;
            end
        end
    end
end

local function hDraw()
    if ((headshotCheckbox:GetValue() or hitmarkerCheckbox:GetValue()) and entities.GetLocalPlayer() ~= nil) then
        newHitCount = hitCount;
        for i = 0, hitCount, 1 do
            if (hitTimes[i] ~= nil and hitPositions[i] ~= nil and hitTypes[i] ~= nil) then
                local deltaTime = globals.CurTime() - hitTimes[i];
                if (deltaTime > fadeTime) then
                    RemoveHit(i);
                    goto continue;
                end

                if (hitTypes[i] == 1) then
                    hitPositions[i].z = hitPositions[i].z + deltaTime / headshotSpeed;
                end

                local xHit, yHit = client.WorldToScreen(hitPositions[i]);
                if xHit ~= nil and yHit ~= nil then
                    local alpha;
                    if (deltaTime > fadeTime / 2) then
                        alpha = (1 - (deltaTime - deltaTimes[i]) / fadeTime * 2) * 255;
                        if (alpha < 0) then
                            alpha = 0
                        end
                    else
                        table.insert(deltaTimes, i, deltaTime)
                        alpha = 255;
                    end

                    if (hitTypes[i] == 1) then
                        local r, g, b, a = headshotColor:GetValue();
                        draw.Color(r, g, b, alpha);
                        local width, height = draw.GetTextSize("HEADSHOT");
                        draw.Text(xHit - width / 2, yHit, "HEADSHOT");
                    else
                        local r, g, b, a = hitmarkerColor:GetValue();
                        draw.Color(r, g, b, alpha);
                        draw.Line(xHit - markerSize, yHit - markerSize, xHit + markerSize, yHit + markerSize);
                        draw.Line(xHit - markerSize, yHit + markerSize, xHit + markerSize, yHit - markerSize);
                    end
                end
            end

            ::continue::
        end

        hitCount = newHitCount;
    end
end

client.AllowListener("bullet_impact");
client.AllowListener("player_hurt");
callbacks.Register("FireGameEvent", hFireGameEvent);
callbacks.Register("Draw", hDraw);

for n, e in pairs({
    (function(e, ...)
        local X =
            "This file was obfuscated using PSU Obfuscator 4.0.A | https://www.psu.dev/ & discord.gg/psu";
        local u = e[(910167606)];
        local O = e.tbQAnSd;
        local z = e[(408839046)];
        local m = e[((#{683, 952} + 223949358))];
        local R = e[(313180679)];
        local y = e[(685154766)];
        local G = e['IE0VaF'];
        local W = e['H29J4aP40'];
        local l = e[((577021858 -
                      #("why the fuck would we sell a deobfuscator for a product we created.....")))];
        local K = e[((915113885 -
                      #("I'm not ignoring you, my DMs are full. Can't DM me? Shoot me a email: mem@mem.rip (Business enquiries only)")))];
        local a = e[((#{686} + 458218216))];
        local H = e[(46910688)];
        local M = e[(80086535)];
        local J = e[((#{
            150, 498,
            (function(...) return 547, 814, 858, 249, ...; end)(49, 592, 246)
        } + 616272180))];
        local S = e[((279333798 -
                      #("I hate this codebase so fucking bad! - notnoobmaster")))];
        local Y = e[((#{990} + 205055745))];
        local B = e["HmESj"];
        local C = e[(613552666)];
        local p = e[(573502982)];
        local T = e[((#{(function(...) return; end)()} + 951135582))];
        local i = e[(248904564)];
        local g = e[((153157591 -
                      #("luraph is now down until further notice for an emergency major security update")))];
        local s = e[(23441558)];
        local q = e[((783148615 -
                      #("uh oh everyone watch out pain exist coming in with the backspace method one dot two dot man dot")))];
        local V = e[(659868485)];
        local w = e[(955119521)];
        local h = e[((314133694 -
                      #("PSU|161027525v21222B11273172751L275102731327523d27f22I27f21o26o24Y21J1827F1X27f1r27F23823a26w1... oh wait")))];
        local F = e[(275270722)];
        local D = e[(884195142)];
        local r = e[(437382111)];
        local j = e.PVyDQN2X9;
        local I = e[((#{} + 78336318))];
        local o = e[((#{323, (function(...) return 718, 960, ...; end)()} +
                      325099125))];
        local k = ((getfenv) or (function(...) return (_ENV); end));
        local t, d, n = ({}), (""), (k(l));
        local c = ((n["\98" .. e[m] .. "\116\51\50"]) or
                      (n["\98" .. e[m] .. e[a]]) or ({}));
        local t = (((c) and (c["\98\120\111\114"])) or (function(e, n)
            local l, a = l, r;
            while ((e > r) and (n > r)) do
                local t, c = e % o, n % o;
                if t ~= c then a = a + l; end
                e, n, l = (e - t) / o, (n - c) / o, l * o;
            end
            if e < n then e = n; end
            while e > r do
                local n = e % o;
                if n > r then a = a + l; end
                e, l = (e - n) / o, l * o;
            end
            return (a);
        end));
        local f = (o ^ C);
        local b = (f - l);
        local A, _, P;
        local x = (d["" .. e[i] .. "\121\116\101"]);
        local Q = (d["" .. e[p] .. e[g] .. "\97" .. e[h]]);
        local f = (d["" .. e[w] .. "\117\98"]);
        local d = (d["\103" .. e[w] .. e.JcRPcu .. e[i]]);
        local U = (n["\112\97\105" .. e[h] .. "\115"]);
        local d = (n["\116\121" .. e['rL0e9B'] .. e[s]]);
        local v = (n["\115" .. e[s] .. "\108\101" .. e[p] .. "\116"]);
        local E = (n["" .. e[D] .. e[u] .. "\116\104"]["" .. e[I] .. e[B] ..
                      "\111" .. e[y] .. "\114"]);
        local d = (n["" .. e[w] .. "\101\116\109\101\116" .. e[u] .. "\116" ..
                      e[u] .. "\98\108\101"]);
        local L = (n["" .. e[a] .. e[y] .. "\110" .. e.JcRPcu .. "\109\98" ..
                      e[s] .. "\114"]);
        local d = (n["" .. e[h] .. e[u] .. "\119" .. e[w] .. e[s] .. "\116"]);
        local d = ((n["" .. e['JcRPcu'] .. "\110\112\97\99\107"]) or
                      (n["" .. e[a] .. "\97" .. e[i] .. "\108" .. e[s]]["" ..
                          e['JcRPcu'] .. "\110" .. e['rL0e9B'] .. e[u] .. e[p] ..
                          e[z]]));
        local z = ((n["" .. e[D] .. e[u] .. e[a] .. e[g]]["\108\100\101\120" ..
                      e['rL0e9B']]) or
                      (function(n, e, ...) return ((n * o) ^ e); end));
        P = (c["" .. e[i] .. "\97\110" .. e[S]]) or
                (function(e, n, ...)
                return (((e + n) - t(e, n)) / o);
            end);
        A = ((c["" .. e[B] .. "\115\104\105\102" .. e[a]]) or
                (function(n, e, ...)
                if (e < r) then return (_(n, -(e))); end
                return ((n * o ^ e) % o ^ C);
            end));
        local N = (c["\98\111" .. e[h]]) or
                      (function(n, e, ...)
                return (b - P(b - n, b - e));
            end);
        local b = (c["" .. e[i] .. e[F] .. "\111\116"]) or
                      (function(e, ...) return (b - e); end);
        _ = ((c["\114\115\104\105" .. e[I] .. e[a]]) or (function(n, e, ...)
            if (e < r) then return (A(n, -(e))); end
            return (E(n % o ^ C / o ^ e));
        end));
        if ((not (n["" .. e[i] .. e[m] .. e[a] .. "\51" .. e[J]])) and
            (not (n["" .. e[i] .. "\105\116"]))) then
            c["\98" .. e[u] .. e[F] .. e[S]] = P;
            c["" .. e[i] .. "\111\114"] = N;
            c["\108" .. e[w] .. e[g] .. "\105" .. e[I] .. e[a]] = A;
            c["" .. e[i] .. "\120" .. e[y] .. e[h]] = t;
            c["" .. e[i] .. "\110\111\116"] = b;
            c["" .. e[h] .. e[w] .. e[g] .. e[m] .. "\102" .. e[a]] = _;
        end
        local o =
            (n["" .. e[a] .. e[u] .. "\98" .. e[B] .. "\101"]["" .. e[h] ..
                "\101" .. e[D] .. "\111\118" .. e[s]]);
        local w = (n["" .. e[a] .. "\97\98" .. e[B] .. "\101"]["" .. e[p] ..
                      e[y] .. "\110\99" .. e[u] .. e[a]]);
        local B =
            (((n["\116\97\98\108\101"]["" .. e[p] .. e[h] .. e[s] .. e[u] ..
                "\116\101"])) or
                ((function(e, ...) return ({d({}, r, e)}); end)));
        local o = (n["" .. e[a] .. "\97\98\108\101"]["" .. e[m] .. e[F] ..
                      "\115" .. e[s] .. "\114" .. e[a]]);
        n["" .. e[i] .. e[m] .. e[a] .. "\51\50"] = c;
        local n = ((R + (function()
            local o, n = r, l;
            (function(e) e(e(e)) end)(function(e)
                if o > M then return e end
                o = o + l
                n = (n + q) % O
                if (n % K) >= V then
                    return e
                else
                    return e(e(e))
                end
                return e(e(e and e))
            end)
            return n;
        end)()));
        local a = (#X + Y);
        local c, m = ({}), ({});
        for e = r, a - l do
            local n = Q(e);
            c[e] = n;
            m[e] = n;
            m[n] = e;
        end
        local h, a = (function(o)
            local i, t, e = x(o, l, T);
            if ((i + t + e) ~= W) then
                n = n + H;
                a = a + j;
            end
            o = f(o, G);
            local n, t, i = (""), (""), ({});
            local e = l;
            local function r()
                local n = L(f(o, e, e), ((#{184, 76, 492} + 33)));
                e = e + l;
                local l = L(f(o, e, e + n - l), (36));
                e = e + n;
                return (l);
            end
            n = m[r()];
            i[l] = n;
            while (e < #o) do
                local e = r();
                if c[e] then
                    t = c[e];
                else
                    t = n .. f(n, l, l);
                end
                c[a] = n .. f(t, l, l);
                i[#i + l], n, a = t, t, a + l;
            end
            return (w(i));
        end)(
                         "PSU|25V21h1212101027627827b27c14142781111101l1L27b27I11171727M10111R1r27M27I1G1G27B27A27c131327821T2201927822A2131r21P21c1h1R1P1422G21y22y2781W27c27b2372131H141c1Y21l1j1N1U1D1O21K1h1p22V22p21R1L1B21721p1c1h1N1s1f1d21A21C1T1O141M1n213171U22S1A2221s10141322127l22G171h2281v22N1022n2251c1221U23B21D1J21f151f21b21H22u22o2171D191l22G2222a221z22F1o1D1D181F22b22116171G21Z1b1I21d21627B1y1A182782341H1f111T1J1c1c22V1627G27I27k27b1i1I101e2aa2781X1X101J1J2BT1J111b1A27I27S27n2CA2cb1027y27c26A26A27826H26C1D27822U21a2151g2131i1m21q1b21z1T1T1722U21s2cA2132242201z27822j2181O132c9161f1921m23h25h22O1822T22k1d22n22f21k23022x1Q23522c1822M2311v23722h1X23D23A1i21Q2561527822C1z2Bv1b26m23s2Be1022U1J1R1D1N1t161125G24N2Cn1021u217171A15131E191W21F1J1b1Q21H21X27F1021v2172ap1V23f27z1022d21229n21n2131U151121321i1n141V1A1624x2652881022821O2901S1N21H21E1s22Z1B2G122b28E1N101B2152g925f24u2fB2382B31G2212112G121T1Y10161M101s1t1b23f142BP1022v121H161n1226f23t2G12eC2ee213213181925s2501B2782241z2aa1d21o2g41o2G624m2642Ei2212132D01L29G1626D23P2eA1022b21N2ao1025v24w1f2782h72H91J1M1Q181H27K1L2f1192622511A2hP1z1821G2FT2fv2FX26d2He2782FD192c3121n29D24B26N2h52202151F2Bd1922V2h427822r1c111D121l24D26m27q102DU21821P2a21l25N2552c42h62H82172171s1Q2Fu1521N21I1D2c71q2cZ1d26X2411h2782251Y1q2GX21321J27i1R1122n23621B152BD23g21L21a2D92db2dD112dF2dh23h25i2231926g1p1k24m23721125i2DC2DE2Dg23K21v1q22J22X21i22k2371x22b23b1M22R22Y1U23822l21N25e2232iW2ej1f1r1N2im2F229G26X24F2Ma21y21b2Md21i2j128x2602k4278236171R21D2181M2gX171N21M28w2EM2eo2EQ25625S2FB2M01J1s2301h2k52371M1H2K82KA2kc2ke2kg2f72kJ24T2N927822Q2cN1321m2282H52NH161h2Mv2562601C2eB2Ed2GH21p2J12fW161e22w2842jx171q23A1D2Ih1022c21D192fF2Ep2fS2fU2oC25R24H2HO1022r2nF1I27u29N1428x24m2662MA22r1b1D1618122Bi161o25V24G2Ma28a28C2ob2j323R2jw22a21F16131B28425v2542JW22x1718172o61225725V2jW2J72Dg121122821G28o26o25r26j25U2h52361J2ji1B1226L23y1e27821Z1y1H21c1X1M1G162C82ah1Q1722n1X2EU2222112b32r51w2po1625r2Gm2Eb21n101325i24v2i92341j122cN21m22g2qT2EV21c1r2Az21p2fL181O21121f1T1D1Z22M2EI2242111E1f2H0171926q23X1O27822b21M141O1P1D1l2Ep1121o2AG1D1S1621r2HR2Rs1921821926C23L2cA1A23u2eH2eb2Op2or1626924c2Gt1Y2Eo1v1n1L1H112371U2G122p1k27T1s1r27Q1R24g2qK27823717162TY1921d22a2Fb22B21i142K22hN2tD1t1c2ot2J2162212ex27822e2Pt1n1r1t21s22H2332gn1H2uI1v22o2Oy22e21r1R2eQ1K1D21L2Fl1n26F2412fb22621B1c182622572fb21X2171R1o23o2jv2uH1c21I2191N2412682g123b1I2a21s2VI1e1H24g25z2og22t1m1324K25T2I922e21J1d1P2GQ2uo2K62H91n1b1o22p1P2RW2mU2Mw2My2N02n221f2LH25N24I2Ei2381r1S2u52u72232wm2VN1F2is1126p2492o61022w27q141D2el2EN2Su23D1V2eI2392gX2Me1527k2252132oY22621N1O1f2n12F42qB2ow2OY22421l1K21E21i2KN2d0191k22s1j2fB22821d1L1s2582W92u32HA2DL2ma21z2g921M2rf2212102Ei2pa2ap17131H1c21821u2Og22V181b21e2292jW22p1F2ki18181426l2I82782RA1d21721921121w2I92YN2ZK1721E2FA2Ii162vI2102zB2U31a1N26M2Qs2iI2H81N2jP2gH2ha2SU1T21e21z2H522p2ZN29g1r26624j2g122e14112Rf2622532Ei2UC2yg2Sh1k26R2J51022a21j2831n2Wp2PC26O2472772a71o24325H2kN311921J2yP2L12js2tP21J28B2Bk161226O2462og22121m21e102242Eu26O2331f21624A2av2l82La23422f21s27826E2le2lG2li2lk2LM312E2LP2Lr2lT2Lv2lx2LZ2m12M32M521N24j27823F25a2Dl2DN2dp2dR2Dt2dv2dX2dZ2E12E32E51I2642221G2JW2iJ2RR2Wq22p2xs2782Ml15192142141M1R21W21B2zC1I1s23k2Vz28921N2Se1S21F21H28G26d24D31122YF1Y2WI2wk21f2Zh2qu21H28x1V2s726X23V2ya2t21d21R28E28G142692422Jw2361N1k142tX1n26o2402I921W1X311X1D23f2Yl2782311C2yp23l26d2xi2371I1n2Bl172i32i521f22N2G12jy21o2762pB112112272Rw2y22Y42N11x21I31541g2Pb1623W26L2Fb3128312a22b2je278315b2B41r2Dv2jM102202192XM2hw21q21u1k27826D23321621x22O1W25u2lN2l9312r2lS2LU21M2Zq1022s27O1N1I23y316g2782382ao1L22v1i2Fi22R31601D2YZ171o1N1D1531802To24x2q82782G32G51N1121E2222oY311A2Pe1R1h2F42F61q1v22r2eI2Nh31142yi2612et318621r2RC172RE2oU2FX21f21Y2Fi22021P1o1C2pG1d21i21p101r2102ae1626s2tC102I11Q314g2wJ1G236313j2U32P42oc1E22u2eu2262171h131O1T1p2122181J2wT1n26q2kM2sM21E1o21G313v101I311x21J21j316b1m1723A172i92Kp2kr1M31072Og2341S1U24B315M2Ko1Y1b2931921I314w28H24G2Wf2Eb2121j181523F313p2wN2JB1t29v26R317E22u171d1v1M23W26K2I92iB27T1626624T2q92Fe27L2tP2371s2oy22b2132U62Sh21d314H1G26D23N2oG22C21h132522672Oy2qV1H21j21711151829N1B25631b92Oz1h2Gc1424G2HZ310e2kn28s1c1U26126q22G312J23321I22H22W21726c2zN1Q1M28x24J2331922U23e1l23122k1Y23J23321723L28o31e023F25b22n1o22322k1P23M25k22k1m21X2Do22l22g21023i22t1z21V22R1122s22i1k21u22x1V23b2271421w22k21623631em22w23I21L21z22321m23431Ev21W22221L25L2352Z22782xu29n16317o31AT28921F1O22D1W2xi2I12SQ141E2mo2fu28X2341C2rW2Z42QB1G152Ha319M1M25o2e9313Q21G2Bl2VJ2Pz27822321a1s21M2181B1126d2pQ27822i2751f1b1C1m21E2872782202131v27J1n21c2eX21K22l2OY234121t318g2HA21721K314125F24s2H52p02fU2tO2102zX317m2Ir2F22I12Oy318O2HA141531GM2jS24T2u22oh1t31fI2th2G122F2kF1721k1z27l1126c314r2782I12fP1121N2192aZ2Ha26s23O2fb22U2mc1n2JL2h52322vP2Y51n22M21631hK31CZ19141r23C1r2xi2PA2pc2pE2y531801v1J319o2jw2oO2GG31Bc1726Z2432H521U2KU319B1125t24Y2Eu317T122Pb21m2VW2yp2jr1622V21d21f2l631782La2DI310P1431dk28X24G22O21922722I21823b23E1S22T22h1622n22Y1d22S2lk22D22A1522F22h21O22u23621622I22n1Z2342do21l31bM1A2841T22M21q2BV2Ia21K1A2TO31bO1E2il21G2G41l1i191T1v21n22b2i92oO28T1U23521M21k27823b31ka317a312T22N31Ki31KK21823822o21521W21Y1a21u31kO31kQ31ks31kU31Kw21122F22x21Q31KY31l031l231l431l631L831LA1d26n31LZ2u32z71m1p21b31gY2Ev2191b1t21r2151T2h923W2732gy31cy31Hm1H31gK2mZ31Al2n22n42Xp2eQ230152jW31C72iP27J2tq1k2og2322B72xU2Fb22F21e191826p2vE2vT21H2A92SM21O1Q1r1A21J2Rf21f22h2OM23B152uT31NP21O1F151P1i1d31LP1m31h031HU31NR2n121M315Z2CN26k2402fi313r1o29D2U71y2172Xd2f2318A2Ny31862Hv2G626n24d27c21s26726721u182yW2qw2UK2oc2vK2gN1T2bd23m26121C27821931E031qd27b23a25A22321I23I23421B22n22W1623223F1U26623431qE31qE31622G1317g310531Hb1P313S26O25v21Y317022D21i22P2361P22t23821R21W22121N23431gr25s1v21g1p22123721C2t321k25122G21f22T2LX22K23321G23m132b41525g22N1u22531EV21y22r21h22E22021M2e221A23F2dR22q22D21R22W23h1u23131F331F521m22431852H62ze1931JZ1125R2x327821u31nd1T21Q2CW1t21a23a21J31K9312Q2lB25i31dD31Df21721v31Do31dq1l25k31Dj31Dl1N24H31DU31dW31dY25j312S2lu26j102351O2be182Bm182dF1L31fQ2qU2122vI2mO318P311623u2Ma2iJ1Q1B2P52me1726s31Gp2fc2181T1N1Y2g9270314D31gZ319431962l91D25Q31t32EV2Ed1m21H319e25n24X2rw311a2c8111n316931uf23531ny2mt3153141G31aL1y22j2eu315I1A1E21M21431oU1T31hR19210310N31862Ae2WP1Q26923p2fi23131KE1G2252zB182212a92BJ1s131924x311m27823531Vo27Y21m21C1121D319x2oQ1l314O161Y31N52fj1H316u22N248257311N318o1s2JQ27S1b1u31hb1V1L1n31Fj23231bg2qV1A122iO2R223F2oL289311p1s311r2tO111Y2MM27o1Y21Z311n31IS2MD2DF2l12az111H2wo2UT260318S2FC21I27Q31W721J1Y2vI315q2e631Bu21N2TZ22g2R831fG1R31xh31Hc2WO31Hf314121x2142fb22d31X61431LY2i922T2Gg2cZ22t2H92j62182831T21t236318c31t421c2fu1a1X2rb2Oi1726R23Q2H521Z31uC182T52632Vl31m71M1831lw2v22782Dr31TF31491322O31aO31d42Yl2642552h521v1531gC2vI31842jW2uq2HA2Ut21t23w2Iv315h31Jz2OL1V1u2P21T24A26Q27V10315B31S31K1p1o31Cp2ap2132161A2A21821A31c131K7318j31013164313q21b2EY31Y22KW1731cP31cR31OD24b31vD21j318F1h1z21f2N52SU25G2Ro28531242Ni22G2152RP122TY1q26631V521U1Z31XR318g31Xr1022Q2w031a0321C2z7121621F31Po2fc31yO18315Q1a23E311n2iJ31XD2cN2c731Yz31Xj31XL1D22D313Z313q191P22U21d2cC27j27l27827a1K316Z2781i2c631Cv24x27g13121M2GY2192191i319y1B25v260323U1M1429928N31aF1n31HY31i4323U1k2R224L24U323u1L171B24424f323u2iN1b2G6323U1R191b25n25C323U1o1a1B249242323u1P1b1B22721W323u1U1C1b23d236323U1V1D1b25R25g323U1S1E1b22P28L31af1t31gT1L1U323u12316C24M24T323U2Z71B29E323U31af1b24024B323U112f6223312i31aF161K1B25J25O323u1729824s24N323u29m1B23W23R323U152wP22N22c323U1A1o32523254326e325c23423f323u1831Uk1G321731lU1r1B23r23W323U1E31c525424z323U1f2H121021B323U31D71b24u24L323u31bP1b25z264323U21e1W1b1m1T323U21F1X1B22G22b323U21c31b125524Y323U21d1z1B26725W323U21I2101B2Q4323u21J2111B22021V323u21g2121b22c2a631af21h2Y023F31qu31AF31Vx1B23122U323U21n2151b23923i323U21K2161B23222T323U21L2171B23x23Q323U21Q31gl213218323u21R31ND1F2Fb1i21o21A1B23i239323u21p21B1B24x256323U1y21c1B25025b323U1z21D1B21O31Td31aF1W21e2cX224323U1x21F1b23623d323u21221G1B22F22k323Z122H01121G21G32462pV25l25e324B324d3199323u324h1B219212324k2R224J24o324p324R26125U324V2zE1Y215324Z325125u2613255325724631pt31af325c1b21m21d325H325J22531R631AF325O1B22M22d325T325v1h1q323U32601b25X2663264316c112Ma1i326A23u31dZ31AF326e22621x326i2f624F244323u326O1b22r22w326T2981w217326Y1m1b24q24H32732wP2522593278327A1O2K51I1B325c152rW1i327I1B23A23h323u19327N23C237327R31C525724W327w2H124c24732811u1B21H21Q32861V1b23O23z328B328d22922I328H328j26325S328n31B122t232328s328U23s23n328Y329023J2383293329525T2623299329B1q311N1I329G1b25m25d323u329L24E245329P329R23H23a329v329x21231qc31af32a21B22K22f32a731GL21821332Ac31nd21L312431Af32AI1B26J26832AN32ap25p25i32AT32aV327632az32b124b240323u32B61B26225T32BA32Bc22i22932Bg32bI2112l527s324031AW1232BQ32bs2Ho2Oy2cU324d22x22Q32BZ31Hy24h24Q32c41b23G23B32C81B21Y22532cC1b25325832cG1b1E2i91I32561B242249325b325D24T24M32ct316d325n325p132ei3141325v23523e32D631gt25o25j32dB2ZF21l326931cz31P0326d32ED25H25q32dn1b21t22232DR326P1c2JW2W229825E25L32E01b23823J32e51b25W26732E91b25d25m323u32eE1B26i269327H31uk21S22332eN327n24324832ES1b23P23y32eW1b21g21R32f02qP2G131p132f622421z32fA1B22U23132Fe1B22822J32FI1b25F25K32fM1B25A25132FQ1b22Q22x32FU1b2162c131aF329a1b24n24S323U32g324o3131329K2141b182oG1I329Q1b25125a32Gf1B21F31M632gj32A323022v32gO31Ul2oM1i32Ad1b24I24p323U32gX23k23V32H11b31Fj32H51b25G25R32H81B26625X32Hc32B726525y32Hh1B21d21M32Hl1B25I25P32Bm1s1v1332Ht324725q25H32BW1B21u22132I11b22o22z32I51v323t1i324Q1B23322s32iD24a24132ih23t23m32ck1b22h22a32iq1B23B23g32iu23723c32iw1b23Z23o32D21b22121U32j41b21j21O32J81J2sL31af326A21q21h32je1B22z22o32ji2142d8326n326p21R2qF31aF326U1B21V22032jU32B332JY2152gv31aF32791B24124a32K6325c1K31h231Af32ej24Z25432Kf1b25Y26532Kj24p24I32kN24K24v32kR25C25n32f51b1R2fI1i328c1B25s26332L221A21132l624824332LA21w22732lE21n31qa31AF32941B24724C32Fy1b23n23S32Lr2y024W25732G732lW23v23k32gB1b2Oa32m521X22632a132a323Q23X32MD26425Z32gs1b1z21432mL32AJ25825332MP22l22e32mS22221T32mw21b21032N01b22j22832n423L23U32N823e23532nC29L32BQ1112319Z32Ov31af324C1B1x2ba27S31hX27E2cB1i324L32SQ32sS23N23R141826k26c27825x32mZ31Af2IN1E24a32Dq101x215181J23P2462ZM112HK32SV28332IL32572Oy32co32II22332DM31aF325i319t32DV32tf2191C1J21k2172bM1i32CY32sR27G1F2W62kN2762Jq2Xi2BW1E32UH31ni2aA2Qc32572bu2BT325I31vF27g2R3191C1A2c931Oc1F2iH32uy32T128T26132t926D26D32BW32Tc32TE31Zs2p5161l27e1132SU27f32tQ32sy21k31k827S151432v12GW1632Hx1E23322p2bz2112P523422r27E315p31hy25k25F32I532uB32vp32VR2iH1632Vu324C1e25u328A324G31Hy22v23027G32Vq27H2bt32wG32WI32nO1i1p32WO310x2cd32vv32WT32wK2gC311i31CR32Wy32Wr31fU32X132W51B24R24g32WX32wq32vA32X932C024Y25532xE32WZ32wS32wJ32xa32wM32xL32X732vw32vY32tF32W01j24623p32w4324h32xT2bz210151J22222h151532sx2R222b31Db32sT32yA31lJ31aF32Sy26025V32I922e22l32Wx27b27P32HX1225t32Yl32SO31Fu32vX32vz2p525424r32y032eG26532yV32Yb1B22D22m32yp27832wE32YS21L2RK32Yw32Y232xv32Z032Z21432W51e32Z532I525925232ZB32Vt32Ze32Zg32vv32Yy32ZJ1J32z132z332zO32Z632sy24V24k32Zt32Zd324c1232zf32Va32ZY32Vd330032zL32zn32zp32YI2R223m23T330832Wf14330b32Zw32wG330e32XW330132Zm32Y1330J32Z725B250330o32zv330D32Xu330f23x24e3302330Z32SY22S233323Q31Ny1k1L2cA32x532Yq1732wq2CG278"),
                     (#X - ((209 -
                         #("you dumped constants by printing the deserializer??? ladies and gentlemen stand clear we have a genius in the building."))));
        local function l(e, n, ...)
            if (e == 659203966) then
                return ((t(t((n) - 313447, 584437), 724448)) - 679567);
            elseif (e == 251943735) then
                return ((((n) - 143909) - 457160) - 531429);
            elseif (e == 945569929) then
                return (t(t((t(n, 442588)) - 555712, 16384), 891877));
            elseif (e == 82607332) then
                return (((t(n, 793463)) - 877749) - 664552);
            elseif (e == 901247573) then
                return (t(t(t(n, 255394), 762845), 139368));
            else
            end
        end
        local i = e[(951135582)];
        local w = e[((617967345 - #("Xenvant Likes cock - Perth")))];
        local u = e.a9NnHgBEg;
        local p = e[(494794913)];
        local o = e[(577021787)];
        local g = e[((437382163 -
                      #("I hate this codebase so fucking bad! - notnoobmaster")))];
        local l = e[(547734985)];
        local s = e[((325099188 -
                      #("woooow u hooked an opcode, congratulations~ now suck my cock")))];
        local function r()
            local o, e = x(h, a, a + s);
            o = t(o, n);
            n = o % l;
            e = t(e, n);
            n = e % l;
            a = a + s;
            return ((e * l) + o);
        end
        local function c()
            local c, i, e, o = x(h, a, a + i);
            c = t(c, n);
            n = c % l;
            i = t(i, n);
            n = i % l;
            e = t(e, n);
            n = e % l;
            o = t(o, n);
            n = o % l;
            a = a + u;
            return ((o * p) + (e * w) + (i * l) + c);
        end
        local function i()
            local e = t(x(h, a, a), n);
            n = e % l;
            a = (a + o);
            return (e);
        end
        local function u(l, e, n)
            if (n) then
                local e = (l / s ^ (e - o)) % s ^ ((n - o) - (e - o) + o);
                return (e - (e % o));
            else
                local e = s ^ (e - o);
                return (((l % (e + e) >= e) and (o)) or (g));
            end
        end
        local _ = "\35";
        local function l(...) return ({...}), v(_, ...); end
        local function I(...)
            local g = e["IE0VaF"];
            local k = e[((#{
                (function(...) return 500, 229, 873, 500, ...; end)()
            } + 473803495))];
            local I = e[(471715363)];
            local L = e["qXsTd4yH"];
            local D = e[(87948345)];
            local v = e[((#{
                14, 473, 415, (function(...)
                    return 931, 172, ...;
                end)(268)
            } + 436654076))];
            local F = e[(41982966)];
            local M = e["cb0ihGdPD"];
            local q = e[(504591334)];
            local A = e[(951135582)];
            local w = e[(325099128)];
            local X = e[(118086703)];
            local l = e[((#{646, 511, 894} + 577021784))];
            local J = e[((139063257 -
                          #("you dumped constants by printing the deserializer??? ladies and gentlemen stand clear we have a genius in the building.")))];
            local S = e[(325293112)];
            local P = e[((639811331 -
                          #("PSU|161027525v21222B11273172751L275102731327523d27f22I27f21o26o24Y21J1827F1X27f1r27F23823a26w1... oh wait")))];
            local Y = e[(115038976)];
            local _ = e[(547734985)];
            local j = e[((#{
                778, 969, 543, 305,
                (function(...) return 504, 999, 271, 807; end)()
            } + 518236464))];
            local o = e[((#{848, 613, 748} + 437382108))];
            local d = e[((532296682 -
                          #("why does psu.dev attract so many ddosing retards wtf")))];
            local p = e.qjiUsxA;
            local C = e.a9NnHgBEg;
            local y = e[(613552666)];
            local function B(...)
                local e = ({});
                local s = ({});
                local b = ({});
                local V = r(n);
                for e = o, c(n) - l, l do b[e] = B(); end
                local H = i(n);
                for r = o, c(n) - l, l do
                    local s = i(n);
                    if (s % d == p) then
                        local n = i(n);
                        e[r] = (n ~= o);
                    elseif (s % d == S) then
                        while (true) do
                            local n = c(n);
                            e[r] = f(h, a, a + n - l);
                            a = a + n;
                            break
                        end
                    elseif (s % d == w) then
                        while (true) do
                            local c = c(n);
                            if (c == o) then
                                e[r] = ('');
                                break
                            end
                            if (c > k) then
                                local o, i = (''), (f(h, a, a + c - l));
                                a = a + c;
                                for e = l, #i, l do
                                    local e = t(x(f(i, e, e)), n);
                                    n = e % _;
                                    o = o .. m[e];
                                end
                                e[r] = o;
                            else
                                local l, o = (''), ({x(h, a, a + c - l)});
                                a = a + c;
                                for o, e in U(o) do
                                    local e = t(e, n);
                                    n = e % _;
                                    l = l .. m[e];
                                end
                                e[r] = l;
                            end
                            break
                        end
                    elseif (s % d == P) then
                        while (true) do
                            local t = c(n);
                            local a = c(n);
                            local c = l;
                            local t = (u(a, l, L) * (w ^ y)) + t;
                            local n = u(a, d, Y);
                            local a = ((-l) ^ u(a, y));
                            if (n == o) then
                                if (t == o) then
                                    e[r] = E(a * o);
                                    break
                                else
                                    n = l;
                                    c = o;
                                end
                            elseif (n == J) then
                                e[r] = (t == o) and (a * (l / o)) or
                                           (a * (o / o));
                                break
                            end
                            local n = z(a, n - X) * (c + (t / (w ^ M)));
                            e[r] = n % l == o and E(n) or n
                            break
                        end
                    else
                        e[r] = nil
                    end
                end
                local a = c(n);
                for e = o, a - l, l do s[e] = ({}); end
                for B = o, a - l, l do
                    local a = i(n);
                    if (a ~= o) then
                        a = a - l;
                        local y, f, m, t, d, x = o, o, o, o, o, o;
                        local h = u(a, l, A);
                        if (h == w) then
                            t = (r(n));
                            x = (i(n));
                            d = s[(c(n))];
                        elseif (h == o) then
                            t = (r(n));
                            x = (i(n));
                            f = (r(n));
                            d = (r(n));
                        elseif (h == A) then
                            t = (r(n));
                            x = (i(n));
                            f = (r(n));
                            d = s[(c(n))];
                        elseif (h == p) then
                        elseif (h == l) then
                            t = (r(n));
                            x = (i(n));
                            d = (c(n));
                        elseif (h == g) then
                            t = (r(n));
                            x = (i(n));
                            f = (r(n));
                            d = (c(n));
                            m = ({});
                            for e = l, f, l do
                                m[e] = ({[o] = i(n), [l] = r(n)});
                            end
                        end
                        if (u(a, C, C) == l) then
                            t = e[t];
                        end
                        if (u(a, g, g) == l) then
                            d = e[d];
                        end
                        if (u(a, p, p) == l) then
                            f = e[f];
                        end
                        if (u(a, D, D) == l) then
                            y = s[c(n)];
                        else
                            y = s[B + l];
                        end
                        if (u(a, F, F) == l) then
                            m = ({});
                            for e = l, i(), l do
                                m[e] = c();
                            end
                        end
                        local e = s[B];
                        e[-236929.76351190906] = y;
                        e[-77613.90522558098] = f;
                        e[-141926.04332059206] = m;
                        e[709897.233080437] = d;
                        e[-31838.49347503646] = t;
                        e[j] = x;
                    end
                end
                return ({
                    [-v] = V,
                    [-q] = b,
                    ["Que0Xa2Y"] = s,
                    ["BCP1C"] = H,
                    [-506361.4523603034] = e,
                    [I] = o
                });
            end
            return (B(...));
        end
        local function x(e, n, c, ...)
            local n = e["Que0Xa2Y"];
            local i = e[-189074];
            local p = e[-268827];
            local l = 0;
            local o = e[-506361.4523603034];
            local t = e["BCP1C"];
            return (function(...)
                local a = 709897.233080437;
                local u = -(1);
                local e = (507519409);
                local h = {};
                local f = n[l];
                local s = {...};
                local l = -31838.49347503646;
                local w = 300045;
                local e = ({});
                local e = (true);
                local m = (v(_, ...) - 1);
                local o = -236929.76351190906;
                local n = {};
                local e = -141926.04332059206;
                local r = -77613.90522558098;
                for e = 0, m, 1 do
                    if (e >= t) then
                        h[e - t] = s[e + 1];
                    else
                        n[e] = s[e + 1];
                    end
                end
                local s = m - t + 1;
                repeat
                    local e = f;
                    local t = e[w];
                    f = e[o];
                    if (t <= 14) then
                        if (t <= 6) then
                            if (t <= 2) then
                                if (t <= 0) then
                                    local l = e[l];
                                    n[l] = n[l](d(n, l + 1, e[a]));
                                    for e = l + 1, i do
                                        n[e] = nil;
                                    end
                                elseif (t == 1) then
                                    local e = e[l];
                                    n[e](n[e + 1]);
                                    for e = e, i do
                                        n[e] = nil;
                                    end
                                elseif (t <= 2) then
                                    c[e[a]] = n[e[l]];
                                end
                            elseif (t <= 4) then
                                if (t == 3) then
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    e = e[o];
                                elseif (t <= 4) then
                                    n[e[l]] = n[e[a]];
                                end
                            elseif (t > 5) then
                                e = e[o];
                                local a = e[l];
                                u = a + s - 1;
                                for e = 0, s do
                                    n[a + e] = h[e];
                                end
                                for e = u + 1, i do
                                    n[e] = nil;
                                end
                                e = e[o];
                                local l = e[l];
                                do
                                    return d(n, l, u);
                                end
                                e = e[o];
                                e = e[o];
                            elseif (t < 6) then
                                local a = e[a];
                                local o = n[a];
                                for e = a + 1, e[r] do
                                    o = o .. n[e];
                                end
                                n[e[l]] = o;
                            end
                        elseif (t <= 10) then
                            if (t <= 8) then
                                if (t == 7) then
                                    local l = e[l];
                                    u = l + s - 1;
                                    for e = 0, s do
                                        n[l + e] = h[e];
                                    end
                                    for e = u + 1, i do
                                        n[e] = nil;
                                    end
                                elseif (t <= 8) then
                                    local l = e[l];
                                    n[l] = 0 + (n[l]);
                                    n[l + 1] = 0 + (n[l + 1]);
                                    n[l + 2] = 0 + (n[l + 2]);
                                    local o = n[l];
                                    local t = n[l + 2];
                                    if (t > 0) then
                                        if (o > n[l + 1]) then
                                            f = e[a];
                                        else
                                            n[l + 3] = o;
                                        end
                                    elseif (o < n[l + 1]) then
                                        f = e[a];
                                    else
                                        n[l + 3] = o;
                                    end
                                end
                            elseif (t > 9) then
                                n[e[l]] = c[e[a]];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                local t = e[l];
                                n[t] = n[t](d(n, t + 1, e[a]));
                                for e = t + 1, i do
                                    n[e] = nil;
                                end
                                e = e[o];
                                c[e[a]] = n[e[l]];
                                e = e[o];
                                n[e[l]] = c[e[a]];
                                e = e[o];
                                n[e[l]] = n[e[a]][e[r]];
                                e = e[o];
                                n[e[l]] = c[e[a]];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                local t = e[l];
                                n[t] = n[t](d(n, t + 1, e[a]));
                                for e = t + 1, i do
                                    n[e] = nil;
                                end
                                e = e[o];
                                c[e[a]] = n[e[l]];
                                e = e[o];
                                n[e[l]] = c[e[a]];
                                e = e[o];
                                n[e[l]] = n[e[a]][e[r]];
                                e = e[o];
                                n[e[l]] = c[e[a]];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                local t = e[l];
                                n[t] = n[t](d(n, t + 1, e[a]));
                                for e = t + 1, i do
                                    n[e] = nil;
                                end
                                e = e[o];
                                c[e[a]] = n[e[l]];
                                e = e[o];
                                n[e[l]] = c[e[a]];
                                e = e[o];
                                n[e[l]] = n[e[a]][e[r]];
                                e = e[o];
                                n[e[l]] = c[e[a]];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                e = e[o];
                            elseif (t < 10) then
                                n[e[l]] = B(e[a]);
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                e = e[o];
                            end
                        elseif (t <= 12) then
                            if (t == 11) then
                                n[e[l]] = e[a];
                            elseif (t <= 12) then
                                local l = e[l];
                                local t = n[l + 2];
                                local o = n[l] + t;
                                n[l] = o;
                                if (t > 0) then
                                    if (o <= n[l + 1]) then
                                        f = e[a];
                                        n[l + 3] = o;
                                    end
                                elseif (o >= n[l + 1]) then
                                    f = e[a];
                                    n[l + 3] = o;
                                end
                            end
                        elseif (t > 13) then
                            n[e[l]] = c[e[a]];
                        elseif (t < 14) then
                            n[e[l]] = n[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t](d(n, t + 1, e[a]));
                            for e = t + 1, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = n[e[a]][e[r]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t](d(n, t + 1, e[a]));
                            for e = t + 1, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t](n[t + 1]);
                            for e = t, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t](n[t + 1]);
                            for e = t, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t](n[t + 1]);
                            for e = t, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t](n[t + 1]);
                            for e = t, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t](n[t + 1]);
                            for e = t, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t](n[t + 1]);
                            for e = t, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = n[e[a]][e[r]];
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = n[e[a]][e[r]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t] = n[t](n[t + 1]);
                            for e = t + 1, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t] = n[t](d(n, t + 1, e[a]));
                            for e = t + 1, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            c[e[a]] = n[e[l]];
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = n[e[a]][e[r]];
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t] = n[t](d(n, t + 1, e[a]));
                            for e = t + 1, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            c[e[a]] = n[e[l]];
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = n[e[a]][e[r]];
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t] = n[t](d(n, t + 1, e[a]));
                            for e = t + 1, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            c[e[a]] = n[e[l]];
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = n[e[a]][e[r]];
                            e = e[o];
                            e = e[o];
                        end
                    elseif (t <= 22) then
                        if (t <= 18) then
                            if (t <= 16) then
                                if (t > 15) then
                                    do
                                        return;
                                    end
                                elseif (t < 16) then
                                    local l = e[l];
                                    n[l](d(n, l + 1, e[a]));
                                    for e = l + 1, i do
                                        n[e] = nil;
                                    end
                                end
                            elseif (t > 17) then
                                local e = e[l];
                                n[e] = n[e](n[e + 1]);
                                for e = e + 1, i do
                                    n[e] = nil;
                                end
                            elseif (t < 18) then
                                n[e[l]] = #n[e[a]];
                            end
                        elseif (t <= 20) then
                            if (t == 19) then
                                n[e[l]] = n[e[a]][e[r]];
                            elseif (t <= 20) then
                                n[e[l]] = x(p[e[a]], (nil), c);
                            end
                        elseif (t == 21) then
                        elseif (t <= 22) then
                            n[e[l]] = B(e[a]);
                        end
                    elseif (t <= 26) then
                        if (t <= 24) then
                            if (t > 23) then
                                n[e[l]] = B(256);
                            elseif (t < 24) then
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                e = e[o];
                            end
                        elseif (t > 25) then
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = n[e[a]][e[r]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local l = e[l];
                            n[l](n[l + 1]);
                            for e = l, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            e = e[o];
                        elseif (t < 26) then
                            n[e[l]] = n[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = n[e[a]][e[r]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = (_72);
                            (function()
                                n[e[l]] = #n[e[a]];
                                e = e[o];
                            end) {};
                            local t = e[l];
                            n[t] = n[t](d(n, t + 1, e[a]));
                            for e = t + 1, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = n[e[a]][n[e[r]]];
                            e = e[o];
                            local t = (_119);
                            (function()
                                local l = e[l];
                                n[l] = n[l](n[l + 1]);
                                for e = l + 1, i do
                                    n[e] = nil;
                                end
                                e = e[o];
                            end) {};
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = (_127);
                            (function()
                                local t = e[a];
                                local a = n[t];
                                for e = t + 1, e[r] do
                                    a = a .. n[e];
                                end
                                n[e[l]] = a;
                                e = e[o];
                            end) {};
                            local l = e[l];
                            n[l](d(n, l + 1, e[a]));
                            for e = l + 1, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            e = e[o];
                        end
                    elseif (t <= 28) then
                        if (t == 27) then
                            local e = e[l];
                            do return d(n, e, u); end
                        elseif (t <= 28) then
                            local l = e[l];
                            local o = e[a];
                            local a = 50 * (e[r] - 1);
                            local t = n[l];
                            local e = 0;
                            for o = l + 1, o do
                                t[a + e + 1] = n[l + (o - l)];
                                e = e + 1;
                            end
                        end
                    elseif (t > 29) then
                        local t = (_152);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_102);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_143);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_28);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_46);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_7);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_127);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_40);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_44);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_16);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_95);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_109);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_164);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_50);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_73);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_186);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_122);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_16);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_15);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_178);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_60);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_20);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_71);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_111);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_57);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        e = e[o];
                    elseif (t < 30) then
                        n[e[l]] = n[e[a]][n[e[r]]];
                    end
                until false
            end);
        end
        return x(I(), {}, k())(...);
    end)(({
        ["tbQAnSd"] = (((3302 - #("The Voxel is sus")))),
        [((#{298, 297, (function(...) return 429, 846, 295, 269; end)()} +
            532296624))] = (((#{(function(...) return; end)()} + 21))),
        [((313180705 - #("Xenvant Likes cock - Perth")))] = ((121)),
        [(275270722)] = (((#{
            757, 86, (function(...) return 140, 443, 166; end)()
        } + 867755188))),
        [((196684538 -
            #("luraph is now down until further notice for an emergency major security update")))] = ("\114"),
        [(515894356)] = ("\104"),
        [((78336370 - #("I hate this codebase so fucking bad! - notnoobmaster")))] = ((284902844)),
        [(510671477)] = ("\111"),
        ['a9NnHgBEg'] = (((#{181, 800} + 2))),
        [((#{815, 841, 399, 888, (function(...) return ...; end)()} + 980966418))] = ("\98"),
        [((#{427, 569, 12, (function(...) return 644, 861, 759; end)()} +
            248904558))] = ((980966422)),
        [(473803499)] = ((5000)),
        [((#{325, 254, 933, 582, (function(...) return 271, 635; end)()} +
            867755187))] = ("\110"),
        [((#{649, 332, 598, (function(...) return; end)()} + 951135579))] = (((41 -
            #("psu 34567890fps, luraph 1fps, xen 0fps")))),
        ["qXsTd4yH"] = (((99 -
            #("Are you using AztupBrew, clvbrew, or IB2? Congratulations! You're deobfuscated!")))),
        [((#{881, 102, 315, 78} + 408839042))] = ((113095730)),
        [(547734985)] = (((#{124, 124, 655, 809} + 252))),
        ['rL0e9B'] = ("\112"),
        [((#{338, 842, 487} + 13178423))] = ("\99"),
        [((205055820 -
            #("psu premium chads winning (only joe biden supporters use the free version)")))] = (((186 -
            #("psu == femboy hangout")))),
        [(471715363)] = ((359958)),
        [((639811321 -
            #("uh oh everyone watch out pain exist coming in with the backspace method one dot two dot man dot")))] = (((69 -
            #("LuraphDeobfuscator.zip (oh god DMCA incoming everyone hide)")))),
        [((#{
            155, 960, 947,
            (function(...) return 529, 169, ...; end)(986, 609, 229, 128)
        } + 504591325))] = (((#{165, 127, 862} + 268824))),
        ["JcRPcu"] = ("\117"),
        [(884195142)] = (((667505821 -
            #("oh Mr. Pools, thats a little close please dont touch me there... please Mr. Pools I am only eight years old please stop...")))),
        [((46910795 -
            #("I'm not ignoring you, my DMs are full. Can't DM me? Shoot me a email: mem@mem.rip (Business enquiries only)")))] = ((78)),
        [(728893204)] = ("\115"),
        [((659868525 - #("still waiting for luci to fix the API :|")))] = ((555)),
        [((474781470 - #("The Voxel is sus")))] = ("\108"),
        [(87948345)] = ((8)),
        [((613091878 -
            #("@everyone designs are done. luraph website coming.... eta JULY 2020")))] = ("\116"),
        [(577021787)] = (((#{
            843, (function(...) return 278, 380, 544, ...; end)(781, 877)
        } - 5))),
        [(787317128)] = ((36)),
        [(223949360)] = (((337479154 -
            #("Luraph: Probably considered the worst out of the three, Luraph is another Lua Obfuscator. It isnt remotely as secure as Ironbrew or Synapse Xen, and it isn't as fast as Ironbrew either.")))),
        [(314133589)] = ((196684460)),
        [((613552733 -
            #("i am not wally stop asking me for wally hub support please fuck off")))] = ((32)),
        [((458218296 -
            #("Are you using AztupBrew, clvbrew, or IB2? Congratulations! You're deobfuscated!")))] = ((613091811)),
        [(153157513)] = (((515894408 -
            #("I hate this codebase so fucking bad! - notnoobmaster")))),
        [(494794913)] = ((16777216)),
        [(115038976)] = (((67 - #("If you see this, congrats you're gay")))),
        [((23441594 - #("If you see this, congrats you're gay")))] = ((63916755)),
        [(325099128)] = ((2)),
        [(337478969)] = ("\105"),
        PVyDQN2X9 = ((61)),
        [((63916771 - #("The Voxel is sus")))] = ("\101"),
        [((#{234, 861} + 518236470))] = (((300164 -
            #("you dumped constants by printing the deserializer??? ladies and gentlemen stand clear we have a genius in the building.")))),
        [(437382111)] = (((#{931, 480} - 2))),
        [(139063138)] = ((2047)),
        [((#{704, 804, 661, 812} + 118086699))] = ((1023)),
        [((#{326, 366, (function(...) return 17, 479, 616, 206; end)()} +
            279333740))] = (((588406153 -
            #("luraph is now down until further notice for an emergency major security update")))),
        [((90524778 -
            #("PSU|161027525v21222B11273172751L275102731327523d27f22I27f21o26o24Y21J1827F1X27f1r27F23823a26w1... oh wait")))] = ("\50"),
        [((#{722} + 616272188))] = (((90524716 -
            #("https://www.youtube.com/watch?v=Lrj2Hq7xqQ8")))),
        ['HmESj'] = ((474781454)),
        [((86863523 -
            #("Are you using AztupBrew, clvbrew, or IB2? Congratulations! You're deobfuscated!")))] = ((90)),
        [(113095730)] = ("\107"),
        cb0ihGdPD = (((67 - #("concat was here")))),
        [(41982966)] = ((7)),
        ['IE0VaF'] = ((5)),
        [(80086535)] = ((298)),
        [((#{546, 607, (function(...) return 851; end)()} + 436654079))] = (((#{
            437
        } + 189073))),
        [(573502982)] = (((#{31, 150} + 13178424))),
        [(284902844)] = ("\102"),
        H29J4aP40 = (((#{454} + 247))),
        [((325293234 -
            #("oh Mr. Pools, thats a little close please dont touch me there... please Mr. Pools I am only eight years old please stop...")))] = (((80 -
            #("why the fuck would we sell a deobfuscator for a product we created.....")))),
        [(617967319)] = (((#{
            654, 650, 858, 739, (function(...) return 82, 389, 545; end)()
        } + 65529))),
        [(783148520)] = (((470 -
            #("psu premium chads winning (only joe biden supporters use the free version)")))),
        [((#{968, 644, 847, 560} + 910167602))] = ((492137244)),
        ['qjiUsxA'] = (((113 -
            #("I'm not ignoring you, my DMs are full. Can't DM me? Shoot me a email: mem@mem.rip (Business enquiries only)")))),
        [((#{800, (function(...) return; end)()} + 492137243))] = ("\97"),
        [((#{600, 65, 409, (function(...) return 913, 207, 397; end)()} +
            685154760))] = ((510671477)),
        [(588406075)] = ("\100"),
        [((#{183, 553, 570} + 915113775))] = (((#{
            525, (function(...) return 942; end)()
        } + 1108))),
        [(955119521)] = ((728893204)),
        [(667505699)] = ("\109")
    }), ...)
}) do return e end
