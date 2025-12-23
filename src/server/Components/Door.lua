-- Services --
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Door = {}
Door.__index = Door

-- Constants --
local TWEEN_INFO = TweenInfo.new(
	1.2,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)
local OPEN_ANGLE = 90

-- Asset Paths
local ASSETS = ReplicatedStorage:WaitForChild("Assets")
local SOUNDS = ASSETS:WaitForChild("Sounds")

-- Functions --
function Door.new(Model: Model)
	local self = setmetatable({}, Door)
	
	self.Model = Model
	self.HingePart = Model:WaitForChild("HingePart") :: BasePart
	self.Prompt = Model:FindFirstChildWhichIsA("ProximityPrompt", true)
	
	-- State
	self.IsLocked = Model:GetAttribute("IsLocked") or false
	self.KeyName = Model:GetAttribute("KeyName") or ""
	self.IsOpen = false
	self.IsTweening = false
	
	self.ClosedCFrame = self.HingePart.CFrame
	self.OpenCFrame = self.ClosedCFrame * CFrame.Angles(0, math.rad(OPEN_ANGLE), 0)
	
	self:Initialize()
	
	return self
end

function Door:Initialize()
	if self.Prompt then
		self.Prompt.Style = Enum.ProximityPromptStyle.Custom
		
		self.Prompt.Triggered:Connect(function(Player)
			self:OnInteract(Player)
		end)
		self:UpdatePromptVisuals()
	end
end

function Door:UpdatePromptVisuals()
	if not self.Prompt then return end
	
	if self.IsOpen then
		self.Prompt.Enabled = false
		return
	end
	
	self.Prompt.Enabled = true
	
	if self.IsLocked then
		if self.KeyName ~= "" then
			self.Prompt.ActionText = "Unlock"
			self.Prompt.ObjectText = "Locked Door"
		else
			self.Prompt.ActionText = "Open"
			self.Prompt.ObjectText = "Door"
		end
	else
		self.Prompt.ActionText = "Open"
		self.Prompt.ObjectText = "Door"
	end
end

function Door:OnInteract(Player: Player)
	if self.IsOpen or self.IsTweening then return end
	
	if self.IsLocked then
		if self.KeyName ~= "" then
			local RequestEvent = ReplicatedStorage.Network:FindFirstChild("RequestKeySelection")
			if RequestEvent then
				RequestEvent:FireClient(Player, self.Model, self.KeyName)
			end
			self:PlaySound("LockedDoor")
		else
			self:Unlock()
			self:Open()
		end
		return
	end
	
	self:Open()
end

function Door:PlaySound(soundName: string)
	local SoundTemplate = SOUNDS:FindFirstChild(soundName)
	if SoundTemplate then
		local Sound = SoundTemplate:Clone()
		Sound.Parent = self.HingePart
		Sound:Play()
		game.Debris:AddItem(Sound, Sound.TimeLength + 1)
	else
		warn("Sound not found in Assets/Sounds: " .. soundName)
	end
end

function Door:Unlock()
	self.IsLocked = false
	self.Model:SetAttribute("IsLocked", false)
	self:UpdatePromptVisuals()
end

function Door:Open()
	if self.IsOpen then return end
	
	self.IsTweening = true
	self.IsOpen = true
	
	self:PlaySound("OpenDoor")
	
	local Tween = TweenService:Create(self.HingePart, TWEEN_INFO, {
		CFrame = self.OpenCFrame
	})
	
	Tween:Play()
	
	Tween.Completed:Connect(function()
		self.IsTweening = false
		self:UpdatePromptVisuals()
	end)
end

function Door.Start()
	local function Setup(instance)
		if instance:IsA("Model") then Door.new(instance) end
	end
	
	for _, instance in ipairs(CollectionService:GetTagged("Door")) do
		Setup(instance)
	end
	
	CollectionService:GetInstanceAddedSignal("Door"):Connect(Setup)
end

return Door