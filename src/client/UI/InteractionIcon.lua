-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Imports
local UIBuilder = require(ReplicatedStorage:WaitForChild("Common"):WaitForChild("Utils"):WaitForChild("UIBuilder"))

local InteractionIcon = {}
InteractionIcon.__index = InteractionIcon

-- Visual Constants
local TWEEN_IN = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local TWEEN_OUT = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local SIZE_PIXELS = 40

export type InteractionIcon = {
	Prompt: ProximityPrompt,
	Billboard: BillboardGui?,
	Container: Frame?,
	IsDestroyed: boolean
}

-- Functions --
function InteractionIcon.new(Prompt: ProximityPrompt)
	local self = setmetatable({}, InteractionIcon)
	
	self.Prompt = Prompt
	self.Billboard = nil
	self.Container = nil
	self.IsDestroyed = false
	
	self:Build()
	
	return self
end

function InteractionIcon:Build()
	if self.IsDestroyed then return end
	
	self.Billboard = UIBuilder.Create("BillboardGui", {
		Name = "CustomPromptUI",
		AlwaysOnTop = true,
		Size = UDim2.fromOffset(SIZE_PIXELS, SIZE_PIXELS),
		SizeOffset = Vector2.new(0.5, 0.5),
		StudsOffset = Vector3.new(0, 0, 0),
		Adornee = self.Prompt.Parent,
		Parent = self.Prompt
	})

	self.Container = UIBuilder.Create("Frame", {
		Name = "Container",
		Size = UDim2.fromScale(0, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BackgroundTransparency = 0.2,
		Parent = self.Billboard
	}, {
		UIBuilder.Create("UICorner", { CornerRadius = UDim.new(0.2, 0) }),
		
		UIBuilder.Create("UIStroke", {
			Color = Color3.new(1, 1, 1),
			Thickness = 2,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		}),
		
		UIBuilder.Create("TextLabel", {
			Text = self.Prompt.KeyboardKeyCode.Name,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.GothamBold,
			TextSize = 18,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, -1)
		})
	})
end

function InteractionIcon:Show()
	if not self.Container or self.IsDestroyed then return end
	
	local Tween = TweenService:Create(self.Container, TWEEN_IN, {
		Size = UDim2.fromScale(1, 1)
	})
	Tween:Play()
end

function InteractionIcon:HideAndDestroy()
	if self.IsDestroyed then return end
	self.IsDestroyed = true
	
	if self.Container then
		local Tween = TweenService:Create(self.Container, TWEEN_OUT, {
			Size = UDim2.fromScale(0, 0)
		})
		Tween:Play()
		
		Tween.Completed:Connect(function()
			if self.Billboard then
				self.Billboard:Destroy()
			end
		end)
	else
		if self.Billboard then self.Billboard:Destroy() end
	end
end

function InteractionIcon:UpdateInputType(inputType: Enum.ProximityPromptInputType)
	
end

return InteractionIcon