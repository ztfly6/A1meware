local roundtext ={"我正在使用A1mware的大神ENS参数 不要迷恋A1mware参数哥 扫码+2329554378"}

local function roundsay(e)
if e:GetName() == "round_start" then
client.ChatSay( tostring( roundtext[1] ) );
end
end
callbacks.Register( "FireGameEvent", roundsay );
client.AllowListener( 'round_start' );