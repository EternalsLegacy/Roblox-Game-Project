local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local CameraManager = {}
CameraManager.__index = CameraManager

type CameraManagerType = typeof(setmetatable({}, CameraManager))

-- Constructor --
function CameraManager.new(): CameraManagerType
	local self = setmetatable({}, CameraManager)
	
	self.CurrentCamera = Workspace.CurrentCamera
	self.IsActive = false
	self.CurrentViewPart = nil
	
	return self
end

-- Functions --
function CameraManager:SetView(TargetPart: BasePart, TransitionTime: number?)
	if not TargetPart then
		warn("CameraManager: TargetPart is nil")
		return
	end
	
	self.CurrentViewPart = TargetPart
	self.CurrentCamera.CameraType = Enum.CameraType.Scriptable
	
	if TransitionTime and TransitionTime > 0 then
		local TweenInfoConfig = TweenInfo.new(
			TransitionTime,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		)
		
		local Tween = TweenService:Create(self.CurrentCamera, TweenInfoConfig, {
			CFrame = TargetPart.CFrame
		})
		Tween:Play()
	else
		self.CurrentCamera.CFrame  = TargetPart.CFrame
	end
end

function CameraManager:ResetToPlayer()
	self.CurrentCamera.CameraType = Enum.CameraType.Custom
	self.CurrentViewPart = nil
end

return CameraManager