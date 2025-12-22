-- Services --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local CharacterController = {}

-- Constants --
local WALK_SPEED = 11
local JUMP_POWER = 0
local LERP_SPEED = 0.1
local MAX_LOOK_ANGLE_Y = 60
local MAX_LOOK_ANGLE_X = 45

-- State --
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local IsAiming = false

-- Functions --
local function ClampAngle(Angle: number, Min: number, Max: number): number
    return math.clamp(Angle, math.rad(Min), math.rad(Max))
end

function CharacterController:Start()
    Player.CharacterAdded:Connect(function(Char)
        self:SetupCharacter(Char)
    end)

    if Player.Character then
        self:SetupCharacter(Player.Character)
    end

    RunService.RenderStepped:Connect(function()
        self:UpdateHeadTracking()
    end)
end

function CharacterController:SetupCharacter(Character: Model)
    local Humanoid = Character:WaitForChild("Humanoid") :: Humanoid

    Humanoid.WalkSpeed = WALK_SPEED
    Humanoid.JumpPower = JUMP_POWER
    Humanoid.UseJumpPower = true

    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)

    Humanoid.AutoRotate = true
end

function CharacterController:UpdateHeadTracking()
	local Character = Player.Character
	if not Character or not Character:FindFirstChild("Head") then return end
	
	local RootPart = Character:WaitForChild("HumanoidRootPart") :: BasePart
	local Head = Character:WaitForChild("Head") :: BasePart
	local UpperTorso = Character:FindFirstChild("UpperTorso") :: BasePart
	
	local Neck = Head:FindFirstChild("Neck") :: Motor6D
	local Waist = UpperTorso and UpperTorso:FindFirstChild("Waist") :: Motor6D
	
	if not Neck or not Waist then return end
	
	local MousePos = Mouse.Hit.Position
	
	local LookVector = (MousePos - Head.Position).Unit
	local LookCFrame = CFrame.lookAt(Vector3.zero, LookVector)
	local RelativeCFrame = RootPart.CFrame:ToObjectSpace(LookCFrame)
	
	local X, Y, Z = RelativeCFrame:ToOrientation()
	
	local ClampedY = math.clamp(Y, math.rad(-MAX_LOOK_ANGLE_Y), math.rad(MAX_LOOK_ANGLE_Y))
	local ClampedX = math.clamp(X, math.rad(-MAX_LOOK_ANGLE_X), math.rad(MAX_LOOK_ANGLE_X))
	
	local GoalNeckC0 = CFrame.new(0, 0.8, 0) * CFrame.Angles(ClampedX * 0.5, ClampedY * 0.6, 0)
	local GoalWaistC0 = CFrame.new(0, 0.2, 0) * CFrame.Angles(ClampedX * 0.5, ClampedY * 0.4, 0) 
	
	Neck.C0 = Neck.C0:Lerp(GoalNeckC0, LERP_SPEED)
	Waist.C0 = Waist.C0:Lerp(GoalWaistC0, LERP_SPEED)
end

CharacterController:Start()

return CharacterController