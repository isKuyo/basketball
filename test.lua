-- Script principal único com suporte automático a jogos
-- Funciona offline sem dependências externas

-- Get current game info
local player = game:GetService("Players").LocalPlayer
local current_place_id = game.PlaceId

local _identify_executor = identifyexecutor or getexecutorname or function() return "Unknown" end
local executor_name = _identify_executor()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

-- Instâncias
local Wisper = Instance.new("ScreenGui")
local Background = Instance.new("Frame")
local UIGradientBackground = Instance.new("UIGradient")
local UICornerBackground = Instance.new("UICorner")
local TextLabelMain = Instance.new("TextLabel")
local TitleLabel = Instance.new("TextLabel")
local Icon = Instance.new("ImageLabel")
local SecondsLabel = Instance.new("TextLabel")
local BackgroundAspectRatio = Instance.new("UIAspectRatioConstraint")
local BackgroundStroke = Instance.new("UIStroke")
local BackgroundStrokeGradient = Instance.new("UIGradient")

-- Configuração GUI
Wisper.Name = "Wisper"
Wisper.Parent = Player:WaitForChild("PlayerGui")
Wisper.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Background
Background.Name = "Background"
Background.Parent = Wisper
Background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Background.BorderSizePixel = 0
Background.Size = UDim2.new(0.0963, 0, 0.0799, 0)
Background.Position = UDim2.new(-1, 0, 0.9128, 0) -- começa escondido à esquerda

UIGradientBackground.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(17, 16, 26)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 19, 43))
}
UIGradientBackground.Rotation = 60
UIGradientBackground.Parent = Background

UICornerBackground.Parent = Background

BackgroundAspectRatio.AspectRatio = 2.949
BackgroundAspectRatio.Parent = Background

-- Stroke animado
BackgroundStroke.Parent = Background
BackgroundStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BackgroundStroke.Color = Color3.fromRGB(255, 255, 255)
BackgroundStroke.Thickness = 1
BackgroundStroke.Transparency = 0.6

BackgroundStrokeGradient.Parent = BackgroundStroke
BackgroundStrokeGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 170, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 170, 255))
}
BackgroundStrokeGradient.Rotation = 0

spawn(function()
	local Rotation = 0
	while true do
		local Delta = RunService.RenderStepped:Wait()
		Rotation = (Rotation + Delta * 50) % 360
		BackgroundStrokeGradient.Rotation = Rotation
	end
end)

-- Texto principal
TextLabelMain.Name = "Text"
TextLabelMain.Parent = Background
TextLabelMain.BackgroundTransparency = 1
TextLabelMain.Position = UDim2.new(0.048, 0, 0.343, 0)
TextLabelMain.Size = UDim2.new(0.897, 0, 0.369, 0)
TextLabelMain.Font = Enum.Font.SourceSans
TextLabelMain.Text = "Checking game support... (" .. executor_name .. ")"
TextLabelMain.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabelMain.TextScaled = true
TextLabelMain.TextWrapped = true

-- Title com shine
TitleLabel.Name = "Title"
TitleLabel.Parent = Background
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0.016, 2, 0.034, 0)
TitleLabel.Size = UDim2.new(0.136, 0, 0.163, 0)
TitleLabel.Font = Enum.Font.SourceSans
TitleLabel.Text = "wisper"
TitleLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
TitleLabel.TextScaled = true
TitleLabel.TextWrapped = true
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local ShineWidth = 0.15
local ShineSpeed = 1
local TitleShine = Instance.new("UIGradient")
TitleShine.Parent = TitleLabel
TitleShine.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0.0, Color3.fromRGB(160, 160, 160)),
	ColorSequenceKeypoint.new(0.5 - ShineWidth, Color3.fromRGB(160, 160, 160)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.5 + ShineWidth, Color3.fromRGB(160, 160, 160)),
	ColorSequenceKeypoint.new(1.0, Color3.fromRGB(160, 160, 160))
}
TitleShine.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0.0, 0),
	NumberSequenceKeypoint.new(0.5 - ShineWidth, 0),
	NumberSequenceKeypoint.new(0.5, 0),
	NumberSequenceKeypoint.new(0.5 + ShineWidth, 0),
	NumberSequenceKeypoint.new(1.0, 0)
}

spawn(function()
	local Offset = 0
	while true do
		local Delta = RunService.RenderStepped:Wait()
		Offset = Offset + Delta * ShineSpeed
		TitleShine.Offset = Vector2.new(-0.5 + Offset, 0)
		if Offset >= 1.5 then
			Offset = 0
			wait(1)
		end
	end
end)

-- Ícone do jogo
Icon.Name = "Icon"
Icon.Parent = Background
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0.45, 0,0.043, 2)
Icon.Size = UDim2.new(0.0931, 0, 0.2917, 0)
Icon.Image = "rbxthumb://type=GameIcon&id=" .. tostring(current_place_id) .. "&w=150&h=150"

SecondsLabel.Name = "Seconds"
SecondsLabel.Parent = Background
SecondsLabel.BackgroundTransparency = 1
SecondsLabel.Position = UDim2.new(0.455, 0, 0.7122, 0)
SecondsLabel.Size = UDim2.new(0.0878, 0, 0.2317, 0)
SecondsLabel.Visible = false
SecondsLabel.Font = Enum.Font.SourceSans
SecondsLabel.Text = "3s"
SecondsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SecondsLabel.TextScaled = true
SecondsLabel.TextWrapped = true

-- Tween de entrada do Background
local FinalPosition = UDim2.new(0.0032, 0, 0.9128, 0)
local ShowTween = TweenService:Create(
	Background,
	TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	{Position = FinalPosition}
)
ShowTween:Play()

-- Function to update GUI
local function updateGui(gameName, status)
	TitleLabel.Text = "wisper"
	TextLabelMain.Text = (status or "") .. (executor_name and (" (" .. executor_name .. ")") or "")
end

-- Tween de entrada do container
do
	local TweenService = game:GetService("TweenService")
	local finalPos = UDim2.new(0.0032, 0, 0.9128, 0)
	local showTween = TweenService:Create(Background, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = finalPos})
	showTween:Play()
end

-- Função de saída opcional (move para fora e oculta)
local function hideAndCleanup()
	local TweenService = game:GetService("TweenService")
	local hideTween = TweenService:Create(Background, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(-1, 0, 0.9128, 0)})
	hideTween:Play()
	hideTween.Completed:Wait()
	Background.Visible = false
end

-- Função de animação e limpeza (compatibilidade com build_hub.py)
local function animateAndDestroy()
	task.wait(2) -- Aguarda um pouco antes de ocultar
	hideAndCleanup()
end

-- Esta função será substituída durante o build com os scripts dos jogos
local function loadGameScript()
    -- O build_hub.py irá integrar os scripts aqui baseado nos PlaceIDs de cada arquivo
    updateGui("Unknown", "Game not supported")
    hideAndCleanup()
    return
end

-- Execute the game script
loadGameScript()
