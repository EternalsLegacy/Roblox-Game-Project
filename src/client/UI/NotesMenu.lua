-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Imports --
local UIBuilder = require(ReplicatedStorage:WaitForChild("Common"):WaitForChild("Utils"):WaitForChild("UIBuilder"))

local NotesMenu = {}
NotesMenu.__index = NotesMenu

 -- Functions --
function NotesMenu.new()
	local self = setmetatable({}, NotesMenu)
	self.ScreenGui = nil
	self:Build()
	return self
end

function NotesMenu:Build()
	self.ScreenGui = UIBuilder.Create("ScreenGui", {
		Name = "NotesMenu",
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
			Text = "Notes SYSTEM (WIP)",
			TextColor3 = Color3.new(1,1,1),
			Size = UDim2.fromScale(1, 0.1),
			Position = UDim2.fromScale(0, 0.5),
			BackgroundTransparency = 1,
			Parent = self.ScreenGui
		})
	})
end

function NotesMenu:SetVisible(visible: boolean)
	if self.ScreenGui then self.ScreenGui.Enabled = visible end
end

return NotesMenu