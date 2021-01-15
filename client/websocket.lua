local websocket = {}
websocket.__index = websocket

function websocket.new(url)
    local self = {}
    setmetatable(self, websocket)
    self.obj = syn.websocket.connect(url)
    self.triggers = {}
    self.events = {}

    return self
end

function websocket.init(self, identifier)
    self.obj:Send(identifier)
    self.obj.OnMessage:Connect(function(msg)
        local numargs = select(2, string.gsub(msg,"/",""))+1
        local args = {}
        for i = 1, numargs do
            table.insert(args, msg:sub(0, msg:find("/") and msg:find("/")-1 or #msg))
            msg = msg:sub(#(args[#args])+2)
        end
        if args[1] == "trigger" and self.triggers[args[2]] then
            self.triggers[args[2]](select(3,unpack(args)))
        end
    end)
end

function websocket.register(self, trigger, desc, func)
    if not self.triggers[trigger] then
        self.triggers[trigger] = func
        self.obj:Send("trigger/"..trigger.."/"..desc)
        print("Created trigger "..trigger.." with "..tostring(func))
    else
        warn("Trigger \""..trigger.."\" is already registered with "..tostring(func)..". Please choose a different trigger.")
    end
end

function websocket.send(self, str)
    self.obj:Send(str)
end

return websocket
