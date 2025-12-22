-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Imports --
local UIBuilder = require(ReplicatedStorage:WaitForChild("Common"):WaitForChild("Utils"):WaitForChild("UIBuilder"))

local InventoryMenu = {}
InventoryMenu.__index = InventoryMenu

export type InventoryMenu = {
	IsVisible: boolean,
	ScreenGui: ScreenGui?,
	GridContainer: Frame?,
}

-- Functions --
function InventoryMenu.new()
	local self = setmetatable({}, InventoryMenu)
	self.IsVisible = false
	self.ScreenGui = nil
	self:Build()
	return self
end

function InventoryMenu:Build()
	local Theme = UIBuilder.Theme
	
	self.ScreenGui = UIBuilder.Create("ScreenGui", {
		Name = "InventoryMenu",
		ResetOnSpawn = false,
		Enabled = false,
		IgnoreGuiInset = true,
		Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	})

	local Overlay = UIBuilder.Create("Frame", {
		Name = "Overlay",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.3, 
		Parent = self.ScreenGui
	})

	local Container = UIBuilder.Create("Frame", {
		Name = "Container",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.7, 0.6),
		BackgroundTransparency = 1,
		Parent = Overlay
	}, {
		UIBuilder.Create("UIAspectRatioConstraint", { AspectRatio = 1.8 })
	})

	local LeftPanel = UIBuilder.Create("Frame", {
		Name = "LeftPanel",
		Size = UDim2.fromScale(0.35, 1), 
		BackgroundColor3 = Color3.fromRGB(15, 15, 20),
		BackgroundTransparency = 0.2,
		Parent = Container
	}, {
		UIBuilder.Create("UICorner", { CornerRadius = UDim.new(0.02, 0) }),
		UIBuilder.Create("TextLabel", {
			Text = "EQUIPPED",
			Font = Theme.Font,
			TextColor3 = Color3.fromRGB(150, 150, 150),
			TextSize = 18,
			Size = UDim2.fromScale(1, 0.1),
			BackgroundTransparency = 1
		})
	})

	local RightPanel = UIBuilder.Create("Frame", {
		Name = "RightPanel",
		Size = UDim2.fromScale(0.63, 1),
		Position = UDim2.fromScale(0.37, 0),
		BackgroundColor3 = Color3.new(0,0,0),
		BackgroundTransparency = 0.5,
		Parent = Container
	}, {
		UIBuilder.Create("UICorner", { CornerRadius = UDim.new(0.02, 0) })
	})

	self.GridContainer = UIBuilder.Create("Frame", {
		Name = "Grid",
		Size = UDim2.fromScale(0.9, 0.9),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		Parent = RightPanel
	}, {
		UIBuilder.Create("UIGridLayout", {
			CellSize = UDim2.fromScale(0.32, 0.32), 
			
			CellPadding = UDim2.fromScale(0.015, 0.015), 
			
			FillDirectionMaxCells = 3,
			
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})
	})
end

function InventoryMenu:SetVisible(visible: boolean)
	self.IsVisible = visible
	if self.ScreenGui then
		self.ScreenGui.Enabled = visible
	end
	
	if visible then
		self:RefreshDummySlots()
	end
end

function InventoryMenu:RefreshDummySlots()
	if not self.GridContainer then return end
	
	for _, Child in ipairs(self.GridContainer:GetChildren()) do
		if Child:IsA("GuiObject") then Child:Destroy() end
	end
	
	for i = 1, 9 do
		UIBuilder.Create("ImageButton", {
			Name = "Slot_"..i,
			BackgroundColor3 = Color3.fromRGB(50, 50, 55),
			BackgroundTransparency = 0.6,
			AutoButtonColor = true,
			Parent = self.GridContainer
		}, {
			UIBuilder.Create("UIAspectRatioConstraint", { AspectRatio = 1 }),
			UIBuilder.Create("UICorner", { CornerRadius = UDim.new(0.05, 0) })
		})
	end
end

return InventoryMenu