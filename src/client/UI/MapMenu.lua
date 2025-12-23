-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Imports --
local UIBuilder = require(ReplicatedStorage:WaitForChild("Common"):WaitForChild("Utils"):WaitForChild("UIBuilder"))

local MapMenu = {}
MapMenu.__index = MapMenu

 -- Functions --
function MapMenu.new()
	local self = setmetatable({}, MapMenu)
	self.ScreenGui = nil
	self:Build()
	return self
end

function MapMenu:Build()
	self.ScreenGui = UIBuilder.Create("ScreenGui", {
		Name = "MapMenu",
		ResetOnSpawn = false,
		Enabled = false,
		IgnoreGuiInset = true,
		Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	})
	
	local Frame = UIBuilder.Create("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(0,0,0),
		BackgroundTransparency = 0.5,
		Parent = self.ScreenGui
	}, {
		UIBuilder.Create("TextLabel", {
			Text = "MAP SYSTEM (WIP)",
			TextColor3 = Color3.new(1,1,1),
			Size = UDim2.fromScale(1, 0.1),
			Position = UDim2.fromScale(0, 0.5),
			BackgroundTransparency = 1,
			Parent = self.ScreenGui
		})
	})
end

function MapMenu:SetVisible(visible: boolean)
	if self.ScreenGui then self.ScreenGui.Enabled = visible end
end

return MapMenu