-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Variables --
local NetworkFolder = ReplicatedStorage:WaitForChild("Network")
local RequestKeySelectionEvent = NetworkFolder:WaitForChild("RequestKeySelection")

-- Imports --
local InventoryMenuClass = require(Players.LocalPlayer.PlayerScripts:WaitForChild("UI"):WaitForChild("InventoryMenu"))

local UIController = {}

-- Constants --
local KEY_INVENTORY = Enum.KeyCode.Tab 

-- State --
local InventoryInstance = nil
local IsMenuOpen = false

 -- Events --
local EventsFolder = ReplicatedStorage:FindFirstChild("Network")
if not EventsFolder then
	EventsFolder = Instance.new("Folder")
	EventsFolder.Name = "ClientEvents"
	EventsFolder.Parent = ReplicatedStorage
end

local MenuStateEvent = EventsFolder:FindFirstChild("MenuStateChanged")
if not MenuStateEvent then
	MenuStateEvent = Instance.new("BindableEvent")
	MenuStateEvent.Name = "MenuStateChanged"
	MenuStateEvent.Parent = EventsFolder
end

-- Functions --
function UIController:Start()
	print("UIController started.")
	
	InventoryInstance = InventoryMenuClass.new()
	
	UserInputService.InputBegan:Connect(function(Input, GameProcessed)
		if Input.KeyCode == KEY_INVENTORY then
			self:ToggleInventory()
			return
		end
		
		if GameProcessed then return end
	end)
	
	RequestKeySelectionEvent.OnClientEvent:Connect(function(DoorModel, RequiredKeyName)
		
		if not IsMenuOpen then
			self:ToggleInventory()
		end
	end)
end

function UIController:ToggleInventory()
	if not InventoryInstance then return end
	
	IsMenuOpen = not IsMenuOpen
	
	InventoryInstance:SetVisible(IsMenuOpen)
	
	if IsMenuOpen then
		UserInputService.MouseIconEnabled = true
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	else
		UserInputService.MouseIconEnabled = true 
		
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
	
	MenuStateEvent:Fire(IsMenuOpen)
end

UIController:Start()

return UIController