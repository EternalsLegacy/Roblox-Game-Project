-- Services --
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Variables --
local RequestKeySelectionEvent = ReplicatedStorage.Network.RequestKeySelection

local Door = {}
Door.__index = Door

type DoorInstance = typeof(setmetatable({}, Door))

-- Functions --
function Door.new(Model: Model)
	local self = setmetatable({}, Door)
	
	self.Model = Model
	self.DoorPart = Model:WaitForChild("DoorRoot") :: BasePart
	self.Hinge = self.DoorPart:FindFirstChildWhichIsA("HingeConstraint", true)
	self.Prompt = self.DoorPart:FindFirstChildWhichIsA("ProximityPrompt", true)

	self.IsLocked = Model:GetAttribute("IsLocked") or false
	self.KeyName = Model:GetAttribute("KeyName") or ""
	
	self:Initialize()
	
	return self
end

function Door:Initialize()
	if not self.Hinge then
		warn("Door missing HingeConstraint: " .. self.Model.Name)
		return
	end
	
	self.Hinge.ActuatorType = Enum.ActuatorType.Servo
	self.Hinge.ServoMaxTorque = 100000
	self.Hinge.TargetAngle = 0
	
	if self.Prompt then
		self.Prompt.Triggered:Connect(function(Player)
			self:OnInteract(Player)
		end)
		
		self:UpdatePromptVisuals()
	end
end

function Door:UpdatePromptVisuals()
	if not self.Prompt then return end
	
	if self.IsLocked then
		if self.KeyName ~= "" then
			self.Prompt.ActionText = "Unlock"
			self.Prompt.ObjectText = "Locked Door"
		else
			self.Prompt.ActionText = "Open"
			self.Prompt.ObjectText = "Door"
		end
	else
		self.Prompt.Enabled = false
	end
end

function Door:OnInteract(Player: Player)
    if self.KeyName ~= "" then
        RequestKeySelectionEvent:FireClient(Player, self.Model, self.KeyName)
    else
        self:Unlock()
    end
end

function Door:Unlock()
	self.IsLocked = false
	self.Model:SetAttribute("IsLocked", false)
	
	if self.Hinge then
		self.Hinge.ActuatorType = Enum.ActuatorType.None
	end
	
	local Sound = Instance.new("Sound")
	Sound.SoundId = "rbxassetid://339599660"
	Sound.Parent = self.DoorPart
	Sound:Play()
	game.Debris:AddItem(Sound, 2)
	
	self:UpdatePromptVisuals()
end

function Door.Start()
	for _, instance in ipairs(CollectionService:GetTagged("Door")) do
		if instance:IsA("Model") then
			Door.new(instance)
		end
	end
	
	CollectionService:GetInstanceAddedSignal("Door"):Connect(function(instance)
		if instance:IsA("Model") then
			Door.new(instance)
		end
	end)
end

return Door