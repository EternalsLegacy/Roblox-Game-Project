-- Services --
local ProximityPromptService = game:GetService("ProximityPromptService")
local Players = game:GetService("Players")

-- Imports
local InteractionIconClass = require(Players.LocalPlayer.PlayerScripts:WaitForChild("UI"):WaitForChild("InteractionIcon"))

local InteractionController = {}

-- State --
local ActiveIcons: {[ProximityPrompt]: any} = {}

-- Functions --
function InteractionController:Start()
	ProximityPromptService.PromptShown:Connect(function(Prompt, InputType)
		if Prompt.Style == Enum.ProximityPromptStyle.Custom then
			self:OnPromptShown(Prompt, InputType)
		end
	end)

	ProximityPromptService.PromptHidden:Connect(function(Prompt)
		self:OnPromptHidden(Prompt)
	end)
end

function InteractionController:OnPromptShown(Prompt: ProximityPrompt, InputType: Enum.ProximityPromptInputType)
	if ActiveIcons[Prompt] then return end
	
	local Icon = InteractionIconClass.new(Prompt)
	
	Icon:Show()
	
	ActiveIcons[Prompt] = Icon
end

function InteractionController:OnPromptHidden(Prompt: ProximityPrompt)
	local Icon = ActiveIcons[Prompt]
	
	if Icon then
		Icon:HideAndDestroy()
		
		ActiveIcons[Prompt] = nil
	end
end

InteractionController:Start()

return InteractionController