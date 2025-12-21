-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Modules --
local CameraManagerModule = require(ReplicatedStorage:WaitForChild("Systems"):WaitForChild("CameraManager"))

-- Constants --
local CAMERA_ZONES_FOLDER = Workspace:WaitForChild("CameraZones")
local PLAYER = Players.LocalPlayer

-- Initialize Manager --
local MainCameraManager = CameraManagerModule.new()

local Zone = {}
Zone.__index = Zone

local AllZones = {} 

function Zone.new(ZoneFolder: Folder)
	local self = setmetatable({}, Zone)

	self.Folder = ZoneFolder
	self.Trigger = ZoneFolder:WaitForChild("Trigger") :: BasePart
	self.View = ZoneFolder:WaitForChild("View") :: BasePart

	self:Initialize()

	table.insert(AllZones, self)
	return self
end

function Zone:Initialize()
	self.Trigger.Touched:Connect(function(Hit)
		self:TrySwitchCamera(Hit)
	end)
end

function Zone:TrySwitchCamera(HitOrCharacter: Instance)
	local Character = PLAYER.Character
	if not Character then return end

	if HitOrCharacter:IsDescendantOf(Character) or HitOrCharacter == Character then

		if MainCameraManager.CurrentViewPart == self.View then
			return
		end

		MainCameraManager:SetView(self.View, 0)
	end
end

local function InitAllZones()
	for _, ZoneFolder in ipairs(CAMERA_ZONES_FOLDER:GetChildren()) do
		if ZoneFolder:IsA("Folder") then
			Zone.new(ZoneFolder)
		end
	end
end

local function CheckInitialZone()
	local Character = PLAYER.Character
	if not Character then return end

	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

	local Params = OverlapParams.new()
	Params.FilterType = Enum.RaycastFilterType.Include

	local TriggerParts = {}
	for _, ZoneObj in ipairs(AllZones) do
		table.insert(TriggerParts, ZoneObj.Trigger)
	end
	Params.FilterDescendantsInstances = TriggerParts

	local PartsFound = Workspace:GetPartsInPart(HumanoidRootPart, Params)

	if #PartsFound > 0 then
		local FoundTrigger = PartsFound[1]

		for _, ZoneObj in ipairs(AllZones) do
			if ZoneObj.Trigger == FoundTrigger then
				print("Initial Zone Found: " .. ZoneObj.Folder.Name)
				ZoneObj:TrySwitchCamera(Character)
				break
			end
		end
	else
		warn("Player spawned outside of any CameraZone!")
	end
end

local function Start()
	if not PLAYER.Character then
		PLAYER.CharacterAdded:Wait()
	end

	InitAllZones()

	task.wait(0.1)

	CheckInitialZone()
end

Start()