-- Services --
local ServerScriptService = game:GetService("ServerScriptService")
local DoorComponent = require(ServerScriptService.Components.Door)

print("Game Loader Initializing...")

-- Start Components
DoorComponent.Start()