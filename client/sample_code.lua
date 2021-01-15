local websocket = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blue-v3rm/symmetrical-guide/main/client/websocket.lua"))()
local ws = websocket.new("ws://localhost:6789")
ws:init(game:GetService('Players').LocalPlayer.UserId) -- sends your ID as an identifier

ws:register("print","Prints text to the in-game console.",function(...)
    local args = {...}
    print(table.concat(args,"/"))
end)

ws:register("reset","",function()
	game.Players.LocalPlayer.Character:BreakJoints()
end)

ws:register("chat","Chats a message to the game.",function(...)
    local args = {...}
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(table.concat(args,"/"),"All")
end)

game.Players.LocalPlayer.Chatted:Connect(function(msg, rec)
    ws:send("msg/["..game.Players.LocalPlayer.Name.."]: "..msg)
end)

getgenv().ws = ws
