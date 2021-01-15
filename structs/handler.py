all_triggers = []
channel = None

async def on_message_received(identifier, user, message):
    args = message.split("/")
    if args[0] == "trigger" and len(args) == 3:
        print("Registering trigger \""+args[1]+"\" for "+identifier)
        user[1][args[1]] = args[2]
        all_triggers.append([args[1],args[2],user[0]])
    elif args[0] == "msg" and channel != None:
        await channel.send(args[1])

async def on_unregister(identifier, *user):
    if user:
        for trigger in all_triggers:
            if trigger[2] == user[0]:
                all_triggers.remove(trigger)
