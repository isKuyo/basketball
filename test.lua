-- Script principal único com suporte automático a jogos
-- Funciona offline sem dependências externas
-- Gerado automaticamente pelo build_hub.py

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
    -- Game scripts configuration (integrated)
    local game_scripts = {
    [73708914208963] = {
        name = "BasketballZero",
        description = "Script for BasketballZero",
        script = function()
            --// Basketball.lua

local PlaceIDs = {73708914208963, 130739873848552}
local isValidPlace = false
for _, placeId in ipairs(PlaceIDs) do
    if game.PlaceId == placeId then
        isValidPlace = true
        break
    end
end

if not isValidPlace then
    return
end

-- =========================
-- UI LIB (Tokyo)
-- =========================
local Decimals = 4
local Clock = os.clock()
local ValueText = "Value Is Now :"

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/isKuyo/UI/refs/heads/main/Source.lua"))({
    cheatname = "Basketball Script v2.0", 
    gamename  = "Basketball",
})

Library:init()

local WindowMain = Library.NewWindow({
    title = "Basketball Script v2.0",
    size  = UDim2.new(0, 510, 0.6, 6)
})

local TabMain      = WindowMain:AddTab("  Main  ")
local SettingsTab  = Library:CreateSettingsTab(WindowMain)

-- Helpers para “mostrar/ocultar” elementos (compat com libs que não expõem SetVisible)
local function SetVisible(Element, Visible)
    local ok = false
    if Element and typeof(Element) == "table" then
        ok = pcall(function()
            if Element.SetVisible then
                Element:SetVisible(Visible)
            elseif Element.Object and Element.Object.Visible ~= nil then
                Element.Object.Visible = Visible
            elseif Element.Main and Element.Main.Visible ~= nil then
                Element.Main.Visible = Visible
            elseif Element.Frame and Element.Frame.Visible ~= nil then
                Element.Frame.Visible = Visible
            end
        end)
    end
    return ok
end

local function SetGroupVisible(GroupArray, Visible)
    for _, el in ipairs(GroupArray) do
        SetVisible(el, Visible)
    end
end

-- =========================
-- GRUPOS NA TAB MAIN
-- =========================
local SectionAimbot         = TabMain:AddSection("Aimbot (Perfect Shot)", 1)        -- Left column, first section
local SectionNoAbility      = TabMain:AddSection("No Ability Cooldown", 2)          -- Right column
local SectionAutoDribble    = TabMain:AddSection("Auto Dribble", 1)                 -- Left column

-- Auto Block section (Right column)
local SectionAutoBlock     = TabMain:AddSection("Auto Block", 2)

-- Força atualização imediata do layout
task.spawn(function()
    -- Forçar refresh múltiplas vezes para garantir
    for i = 1, 3 do
        task.wait(0.1)
        pcall(function() if WindowMain and WindowMain.Refresh then WindowMain:Refresh() end end)
        pcall(function() if TabMain and TabMain.Refresh then TabMain:Refresh() end end)
        pcall(function() if TabMain and TabMain.UpdateSections then TabMain:UpdateSections() end end)
        -- Simular troca de aba para forçar refresh
        if SettingsTab then
            pcall(function() SettingsTab:SetActive() end)
            task.wait(0.05)
            pcall(function() TabMain:SetActive() end)
        end
    end
end)

-- Flags de controle (UI → lógica) - TUDO INICIALMENTE DESATIVADO
local AimbotToggleFlag        = false
local SubtleCorrectionFlag    = false
local AutoDribbleToggleFlag   = false
local NoAbilityCooldownFlag   = false

-- Sliders/inputs (valores default devem casar com o script)
local DetectionRangeValue = 18
local PanicRangeValue     = 5
local CriticalRangeValue  = 4
local UltraRangeValue     = 1.5
local PlayerCooldownValue = 1

-- =========================
-- AIMBOT: elementos base
-- =========================
local AimbotToggle = SectionAimbot:AddToggle({
    text = "Perfect Shot",
    state = false,
    tooltip = "Enable/disable aimbot shooting",
    flag = "Aimbot_Enabled",
    callback = function(v)
        AimbotToggleFlag = v
        AIMBOT_ENABLED = v  -- Ativar diretamente a variável global
        -- Aguardar um frame antes de mostrar/ocultar para evitar bug de posição
        task.wait(0.01)
        SetGroupVisible({SubtleToggle, AimbotHint}, v)
    end
})

local SubtleToggle = SectionAimbot:AddToggle({
    text = "Subtle Correction",
    state = false,
    tooltip = "Subtle trajectory correction during flight",
    flag = "Aimbot_Subtle",
    callback = function(v)
        SubtleCorrectionFlag = v
        SUBTLE_CORRECTION = v  -- Ativar diretamente a variável global
    end
})

local AimbotHint = SectionAimbot:AddBox({
    enabled = false,
    name = "Info",
    flag = "Aimbot_Info",
    input = "GUI control only",
    focused = false,
    risky = false,
    callback = function() end
})

-- Revelar/ocultar controles do aimbot quando liga/desliga - INICIALMENTE OCULTOS
SetGroupVisible({SubtleToggle, AimbotHint}, false)

-- =========================
-- NO ABILITY COOLDOWN: elementos
-- =========================

-- Variáveis para No Ability Cooldown
local NoAbilityCooldownConnection = nil

local NoAbilityCooldownToggle = SectionNoAbility:AddToggle({
    text = "No Ability Cooldown",
    state = false,
    tooltip = "Remove cooldowns from all abilities",
    flag = "NoAbility_Enabled",
    callback = function(v)
        NoAbilityCooldownFlag = v
        
        if v then
            -- Ativar No Ability Cooldown
            local success, errorMsg = pcall(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local RunService = game:GetService("RunService")
                
                -- Aguardar Knit estar disponível
                local packages = ReplicatedStorage:WaitForChild("Packages", 5)
                if packages then
                    local knitModule = packages:FindFirstChild("Knit")
                    if knitModule then
                        local Knit = require(knitModule)
                        
                        -- Aguardar Knit inicializar
                        Knit.OnStart():await()
                        
                        -- Obter AbilityController
                        local AbilityController = require(ReplicatedStorage.Controllers.AbilityController)
                        
                        -- Função para remover cooldowns
                        local function NoCooldowns(ClientAbilityController)
                            NoAbilityCooldownConnection = RunService.RenderStepped:Connect(function()
                                if ClientAbilityController.CDS then
                                    for i = 1, 4 do
                                        ClientAbilityController.CDS[i] = tick() - 1
                                    end
                                end
                            end)
                        end
                        
                        -- Executar o patch
                        NoCooldowns(AbilityController)
                        
                        -- Atualizar UI se disponível
                        if AbilityController.CooldownUI then
                            AbilityController.CooldownUI(AbilityController)
                        end
                        

                    end
                end
            end)
            
            if not success then

            end
        else
            -- Desativar No Ability Cooldown
            if NoAbilityCooldownConnection then
                NoAbilityCooldownConnection:Disconnect()
                NoAbilityCooldownConnection = nil

            end
        end
    end
})

-- =========================
-- AUTO DRIBBLE: elementos base
-- =========================
local AutoDribbleToggle = SectionAutoDribble:AddToggle({
    text = "Auto Dribble",
    state = false,
    tooltip = "Enable/disable automatic dribbling system",
    flag = "AD_Enabled",
    callback = function(v)
        AutoDribbleToggleFlag = v
        if getgenv().AutoDribbleConnection then
            getgenv().AutoDribbleConnection:Disconnect()
            getgenv().AutoDribbleConnection = nil
        end
        if v and _G.__StartAutoDribble then
            _G.__StartAutoDribble() -- reconecta loop com os valores atuais
        end
    end
})

    -- =========================
    -- AUTO BLOCK: UI CONTROLS
    -- =========================
    local AutoBlockToggleFlag = false
    local BlockShootsFlag = false
    local BlockPassesFlag = false

    local AutoBlockToggle = SectionAutoBlock:AddToggle({
        text = "Auto Block",
        state = false,
        tooltip = "Enable/disable Auto Block (shoots & passes)",
        flag = "AutoBlock_Enabled",
        callback = function(v)
            AutoBlockToggleFlag = v
            if getgenv().AutoBlock and getgenv().AutoBlock.Enable and not v then
                getgenv().AutoBlock.Disable()
            end
            if getgenv().AutoBlock and getgenv().AutoBlock.Enable and v then
                getgenv().AutoBlock.Enable()
            end
            -- show/hide child controls
            SetGroupVisible({BlockShootsToggle, BlockPassesToggle, SliderBlockRange, SliderBlockAngle, SliderBlockCooldown}, v)
        end
    })

    local BlockShootsToggle = SectionAutoBlock:AddToggle({
        text = "Block Shoots",
        state = false,
        tooltip = "Automatically block enemy shots",
        flag = "AutoBlock_BlockShoots",
        callback = function(v)
            BlockShootsFlag = v
            if rawget(getgenv(), "AutoBlock") and getgenv().AutoBlock.SetMode then
                getgenv().AutoBlock.SetMode(BlockShootsFlag, BlockPassesFlag)
            end
        end
    })

    local BlockPassesToggle = SectionAutoBlock:AddToggle({
        text = "Block Passes",
        state = false,
        tooltip = "Automatically block incoming passes",
        flag = "AutoBlock_BlockPasses",
        callback = function(v)
            BlockPassesFlag = v
            if rawget(getgenv(), "AutoBlock") and getgenv().AutoBlock.SetMode then
                getgenv().AutoBlock.SetMode(BlockShootsFlag, BlockPassesFlag)
            end
        end
    })

    local SliderBlockRange = SectionAutoBlock:AddSlider({
        enabled = true,
        text = "Block Range",
        tooltip = "Range to detect shots/passes",
        flag = "AutoBlock_Range",
        suffix = " studs",
        dragging = true,
        min = 4, max = 60, increment = 0.5,
        callback = function(v)
            if rawget(getgenv(), "AutoBlock") and getgenv().AutoBlock.SetRange then
                getgenv().AutoBlock.SetRange(v)
            end
        end
    })
    SliderBlockRange:SetValue(22)

    local SliderBlockAngle = SectionAutoBlock:AddSlider({
        enabled = true,
        text = "Block Angle",
        tooltip = "Angle cone to consider for blocking",
        flag = "AutoBlock_Angle",
        suffix = "°",
        dragging = true,
        min = 10, max = 180, increment = 1,
        callback = function(v)
            if rawget(getgenv(), "AutoBlock") and getgenv().AutoBlock.SetAngle then
                getgenv().AutoBlock.SetAngle(v)
            end
        end
    })
    SliderBlockAngle:SetValue(90)

    local SliderBlockCooldown = SectionAutoBlock:AddSlider({
        enabled = true,
        text = "Block Cooldown",
        tooltip = "Cooldown between blocks (s)",
        flag = "AutoBlock_Cooldown",
        suffix = " s",
        dragging = true,
        min = 0.1, max = 3, increment = 0.05,
        callback = function(v)
            if rawget(getgenv(), "AutoBlock") and getgenv().AutoBlock.SetCooldown then
                getgenv().AutoBlock.SetCooldown(v)
            end
        end
    })
    SliderBlockCooldown:SetValue(1.2)

    -- start hidden
    SetGroupVisible({BlockShootsToggle, BlockPassesToggle, SliderBlockRange, SliderBlockAngle, SliderBlockCooldown}, false)

-- Criar os sliders (eles serão mantidos ocultos por padrão)
local SliderDetection = SectionAutoDribble:AddSlider({
    enabled = true,
    text = "Detection Range",
    tooltip = "Distance to detect enemies",
    flag = "AD_DetectionRange",
    suffix = " studs",
    dragging = true,
    min = 4, max = 50, increment = 0.5,
    callback = function(v)
        DetectionRangeValue = v
        if rawget(_G, "DetectionRange") ~= nil then DetectionRange = v end
    end
})
SliderDetection:SetValue(DetectionRangeValue)

local SliderPanic = SectionAutoDribble:AddSlider({
    enabled = true,
    text = "Panic Range",
    tooltip = "Range for panic mode",
    flag = "AD_PanicRange",
    suffix = " studs",
    dragging = true,
    min = 2, max = 12, increment = 0.5,
    callback = function(v)
        PanicRangeValue = v
        if rawget(_G, "PanicRange") ~= nil then PanicRange = v end
    end
})
SliderPanic:SetValue(PanicRangeValue)

local SliderCritical = SectionAutoDribble:AddSlider({
    enabled = true,
    text = "Critical Range",
    tooltip = "Range for critical double dribble",
    flag = "AD_CriticalRange",
    suffix = " studs",
    dragging = true,
    min = 2, max = 10, increment = 0.5,
    callback = function(v)
        CriticalRangeValue = v
        if rawget(_G, "CriticalRange") ~= nil then CriticalRange = v end
    end
})
SliderCritical:SetValue(CriticalRangeValue)

local SliderUltra = SectionAutoDribble:AddSlider({
    enabled = true,
    text = "Ultra Range",
    tooltip = "Range for ULTRA dribble",
    flag = "AD_UltraRange",
    suffix = " studs",
    dragging = true,
    min = 0.5, max = 3, increment = 0.1,
    callback = function(v)
        UltraRangeValue = v
        if rawget(_G, "UltraRange") ~= nil then UltraRange = v end
    end
})
SliderUltra:SetValue(UltraRangeValue)

local SliderCooldown = SectionAutoDribble:AddSlider({
    enabled = true,
    text = "Player Cooldown",
    tooltip = "Base cooldown per player",
    flag = "AD_PlayerCooldown",
    suffix = " s",
    dragging = true,
    min = 0, max = 2, increment = 0.05,
    callback = function(v)
        PlayerCooldownValue = v
        if rawget(_G, "PlayerCooldown") ~= nil then PlayerCooldown = v end
    end
})
SliderCooldown:SetValue(PlayerCooldownValue)

-- Aguardar a criação completa da UI antes de ocultar elementos
task.spawn(function()
    task.wait(0.2) -- Aguardar mais tempo para UI estabilizar completamente
    SetGroupVisible({SliderDetection, SliderPanic, SliderCritical, SliderUltra, SliderCooldown}, false)
    
    -- Forçar refresh completo da UI após tudo estar criado
    task.wait(0.1)
    
    -- Métodos de refresh da UI
    pcall(function()
        if WindowMain and WindowMain.Refresh then
            WindowMain:Refresh()
        end
    end)
    
    pcall(function()
        if Library and Library.Refresh then
            Library:Refresh()
        end
    end)
    
    pcall(function()
        if TabMain and TabMain.Refresh then
            TabMain:Refresh()
        end
    end)
    
    -- Simular mudança de aba para forçar layout refresh
    pcall(function()
        if SettingsTab and WindowMain then
            -- Mudar para settings e voltar para forçar refresh
            task.wait(0.1)
            if SettingsTab.SetActive then
                SettingsTab:SetActive()
                task.wait(0.05)
                TabMain:SetActive()
            end
        end
    end)
end)

-- =========================
-- NOTIFICAÇÃO DE LOAD
-- =========================
local Time = (string.format("%." .. tostring(Decimals) .. "f", os.clock() - Clock))
Library:SendNotification(("Loaded In " .. tostring(Time)), 6)

-- ======================================================================
--  A PARTIR DAQUI: SISTEMA EXATO FORNECIDO (NÃO ALTERAR NENHUMA FUNÇÃO)
-- ======================================================================

-- SISTEMA COMPLETO: Auto Dribble Ultra Responsivo + Arremesso 100% Certeiro
-- Versão corrigida com bypass para detecção anti-exploit do Knit

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- =======================
-- CONFIGURAÇÕES GLOBAIS
-- =======================

-- Auto Dribble Configurações
DetectionRange = 18
PanicRange = 5
CriticalRange = 4
UltraRange = 1.5
PlayerCooldown = 1
local StealAnimationId = "rbxassetid://132607768946898"

-- Perfect Shot Configurações - INICIALMENTE DESATIVADAS
AIMBOT_ENABLED = false
SUBTLE_CORRECTION = false

-- =======================
-- BYPASS PARA KNIT ANTI-DETECTION
-- =======================

-- Função segura para obter o Knit sem triggar detecções
local function getSafeKnit()
    local success, knit = pcall(function()
        -- Aguardar o Knit estar disponível
        local packages = ReplicatedStorage:WaitForChild("Packages", 5)
        if not packages then return nil end
        
        local knitModule = packages:FindFirstChild("Knit")
        if not knitModule then return nil end
        
        -- Usar require seguro
        local knitService = require(knitModule)
        return knitService
    end)
    
    if success and knit then
        return knit
    end
    return nil
end

-- Função para obter controller de forma segura
local function getSafeBallController()
    local knit = getSafeKnit()
    if not knit then return nil end
    
    local success, controller = pcall(function()
        -- Aguardar o Knit inicializar
        knit.OnStart():await()
        return knit.GetController("BallController")
    end)
    
    if success then
        return controller
    end
    return nil
end

-- =======================
-- INICIALIZAÇÃO SEGURA DO KNIT
-- =======================

local Knit = nil
local BallController = nil

-- Tentar inicializar de forma segura
spawn(function()
    wait(2) -- Aguardar o jogo carregar completamente
    
    Knit = getSafeKnit()
    if Knit then

        
        -- Aguardar inicialização
        local success = pcall(function()
            Knit.OnStart():await()
        end)
        
        if success then
            BallController = getSafeBallController()
            if BallController then

            else

            end
        else

        end
    else

    end
end)

-- =======================
-- VARIÁVEIS AUTO DRIBBLE
-- =======================

-- Controle de tempo
local LastDebugTime = 0
local PlayerLastDribble = {}
local UltraAttempts = {}
local PanicAttempts = {}
local GlobalLastDribble = 0

-- Cache de personagens
local CharacterCache = {}
local RootPartCache = {}

-- =======================
-- VARIÁVEIS PERFECT SHOT
-- =======================

local ballTrajectoryData = {}

-- =======================
-- LIMPEZA DE CONEXÕES ANTIGAS
-- =======================

-- Desconectar conexão antiga do Auto Dribble
if getgenv().AutoDribbleConnection then
    getgenv().AutoDribbleConnection:Disconnect()
    getgenv().AutoDribbleConnection = nil

end

-- =======================
-- SISTEMA DE CACHE DE PERSONAGENS
-- =======================

-- Atualizar cache de personagens
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        CharacterCache[player] = character
        character:WaitForChild("HumanoidRootPart", 5)
        RootPartCache[player] = character:FindFirstChild("HumanoidRootPart")
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    CharacterCache[player] = nil
    RootPartCache[player] = nil
end)

-- Inicializar cache
for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        CharacterCache[player] = player.Character
        RootPartCache[player] = player.Character:FindFirstChild("HumanoidRootPart")
    end
end

-- =======================
-- FUNÇÕES AUTO DRIBBLE
-- =======================

local function ArePlayersEnemies(player1, player2)
    if not player1 or not player2 then return false end
    local team1, team2 = player1.Team, player2.Team
    if not team1 or not team2 then return true end
    return team1 ~= team2
end

local function IsPlayingStealAnimation(humanoid)
    if not humanoid then return false end
    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        if track.Animation and track.Animation.AnimationId == StealAnimationId then
            return true
        end
    end
    return false
end

-- Função segura para verificar se o jogador tem a bola
local function safeHasBall()
    if not BallController then return false end
    
    local success, hasBall = pcall(function()
        return BallController:LocalPlayerPossessesBall()
    end)
    
    return success and hasBall
end

-- Função segura para driblar
local function safeDribble()
    if not BallController or not safeHasBall() then return false end
    
    local success = pcall(function()
        BallController:Dribble()
    end)
    
    return success
end

local function PanicDribble(player, distance)
    local playerKey = player.Name
    local currentTime = tick()
    local lastAttempt = PanicAttempts[playerKey] or 0
    if currentTime - lastAttempt < 0.005 then return false end

    if safeHasBall() then
        -- Triplo dribble
        for i = 1, 3 do
            if safeHasBall() then
                safeDribble()
                task.wait(0.003)
            end
        end

        PanicAttempts[playerKey] = currentTime
        PlayerLastDribble[playerKey] = currentTime
        GlobalLastDribble = currentTime

        return true
    end
    return false
end

local function UltraDribble(player, distance)
    local playerKey = player.Name
    local currentTime = tick()
    local lastAttempt = UltraAttempts[playerKey] or 0
    if currentTime - lastAttempt < 0.01 then return false end

    if safeHasBall() then
        safeDribble()
        UltraAttempts[playerKey] = currentTime
        PlayerLastDribble[playerKey] = currentTime
        GlobalLastDribble = currentTime

        return true
    end
    return false
end

local function CriticalDribble(player, distance)
    if safeHasBall() then
        safeDribble()
        task.wait(0.005)
        if safeHasBall() then
            safeDribble()
        end
        PlayerLastDribble[player.Name] = tick()
        GlobalLastDribble = tick()

        return true
    end
    return false
end

-- Predição agressiva para zonas próximas
local function PredictDistance(myRoot, enemyRoot, enemyVelocity)
    if not myRoot or not enemyRoot then return math.huge end
    local currentDistance = (myRoot.Position - enemyRoot.Position).Magnitude
    if not enemyVelocity or enemyVelocity.Magnitude < 1 then
        return currentDistance
    end

    local factor = 0.1
    if currentDistance <= CriticalRange then factor = 0.2 end
    if currentDistance <= UltraRange then factor = 0.3 end

    local predictedPosition = enemyRoot.Position + (enemyVelocity * factor)
    local predictedDistance = (myRoot.Position - predictedPosition).Magnitude
    return math.min(currentDistance, predictedDistance)
end

-- =======================
-- FUNÇÕES PERFECT SHOT
-- =======================

-- Função para encontrar a bola atual
local function getCurrentBall()
    local ball = nil
    
    -- Método do script original
    if ReplicatedStorage:FindFirstChild("GameValues") then
        local gameValues = ReplicatedStorage.GameValues
        if gameValues:FindFirstChild("Basketball") then
            ball = gameValues.Basketball.Value
        end
    end
    
    if not ball then
        ball = Workspace:FindFirstChild("Basketball") or Workspace:FindFirstChild("Ball")
    end
    
    return ball
end

-- Função para obter o aro alvo
local function getTargetHoop()
    if not LocalPlayer.Team or LocalPlayer.Team.Name == "Visitor" then 
        return nil 
    end
    
    local hoops = Workspace:FindFirstChild("Hoops")
    if hoops then
        local teamHoop = hoops:FindFirstChild(LocalPlayer.Team.Name)
        if teamHoop then
            return teamHoop:FindFirstChild("Hoop")
        end
    end
    
    return nil
end

-- Função que replica o cálculo original mas com alvo garantido
local function calculateOriginalTrajectory(ballPosition, targetDirection, distance, isClose)
    -- Valores base do script original (exatamente como no BallController.lua)
    local baseMultiplier = 0.75
    local distanceMultiplier
    
    -- Ajustar multiplicadores baseado na distância (como no original)
    if distance <= 30 then
        distanceMultiplier = distance * 0.0455
        baseMultiplier = 1.35
    else
        distanceMultiplier = distance * 0.045
    end
    
    -- Calcular o multiplicador total (como no original)
    local totalMultiplier = baseMultiplier + distanceMultiplier
    local logMultiplier = math.log(totalMultiplier)
    
    -- Calcular velocidade base na direção do alvo (exatamente como no original)
    local baseVelocity = targetDirection / logMultiplier
    
    -- Ajustar componente vertical para garantir que chegue na cesta (como no original)
    local gravityCompensation = workspace.Gravity * logMultiplier * 0.5
    
    -- Retornar exatamente como o script original, sem ajustes extras
    return baseVelocity + Vector3.new(0, gravityCompensation, 0)
end

-- Sistema de correção sutil durante o voo (desabilitado para evitar comportamento de parada)
local function setupSubtleCorrection()
    -- Sistema de correção desabilitado para manter comportamento natural
    -- O aimbot agora funciona apenas no momento do arremesso, sem correções durante o voo
    return nil
end

-- Sistema de fallback que respeita a física original
local function setupFallbackSystem()
    local lastBallVelocity = Vector3.new()
    local throwDetectionTime = 0
    local lastCorrectionTime = 0
    local lastBasketTime = 0
    local ballHeightHistory = {}
    
    -- Verificar se é um arremesso normal (não dunk)
    local function isNormalShot()
        if not BallController then return true end
        local success, result = pcall(function()
            -- Verificar se está em animação de dunk
            return not (BallController.States and BallController.States.Dunking)
        end)
        return success and result
    end
    
    -- Detectar se a bola passou pelo aro
    local function detectBasket(ball, hoop)
        local ballPos = ball.Position
        local hoopPos = hoop.Position
        local distance = (ballPos - hoopPos).Magnitude
        
        -- Verificar se está próximo do aro
        if distance < 3 then
            local ballHeight = ballPos.Y
            local hoopHeight = hoopPos.Y
            
            -- Armazenar histórico de altura da bola
            table.insert(ballHeightHistory, ballHeight)
            if #ballHeightHistory > 10 then
                table.remove(ballHeightHistory, 1)
            end
            
            -- Detectar se a bola passou pelo aro (altura diminuiu após estar no nível do aro)
            if #ballHeightHistory >= 3 then
                local wasAboveHoop = ballHeightHistory[#ballHeightHistory - 2] > hoopHeight + 1
                local isBelowHoop = ballHeight < hoopHeight - 1
                local isNearHoop = distance < 2
                
                if wasAboveHoop and isBelowHoop and isNearHoop then
                    return true
                end
            end
        end
        
        return false
    end
    
    RunService.Heartbeat:Connect(function()
        if not AIMBOT_ENABLED then return end
        
        local ball = getCurrentBall()
        local hoop = getTargetHoop()
        
        if ball and hoop then
            local currentVel = ball.AssemblyLinearVelocity
            local velocityChange = (currentVel - lastBallVelocity).Magnitude
            local currentTime = tick()
            
            -- Detectar se a bola passou pelo aro
            if detectBasket(ball, hoop) then
                lastBasketTime = currentTime
                ballHeightHistory = {} -- Limpar histórico
                return -- Não fazer mais correções após cesta
            end
            
            -- Não fazer correções se acabou de acertar a cesta
            if currentTime - lastBasketTime < 3 then
                return
            end
            
            -- Detectar novo arremesso (mudança brusca na velocidade) e verificar se é arremesso normal
            -- Apenas corrigir uma vez por arremesso para evitar comportamento de parada
            if velocityChange > 20 and currentVel.Magnitude > 15 and isNormalShot() and (currentTime - lastCorrectionTime) > 2 then
                throwDetectionTime = currentTime
                lastCorrectionTime = currentTime
                
                local ballPos = ball.Position
                local hoopPos = hoop.Position
                local targetDirection = hoopPos - ballPos
                local distance = targetDirection.Magnitude
                
                -- Aplicar lógica do script original com alvo correto
                -- Sem delay para evitar comportamento de parada
                if ball.Parent then
                    -- Verificar último possuidor da bola; só aplicar correção se for inimigo
                    local lastPlayer = nil
                    pcall(function()
                        if BallController and BallController.GetLastPlayerToPossessBall then
                            lastPlayer = BallController:GetLastPlayerToPossessBall()
                        elseif BallController and BallController.GetLastCharacterToPossessBall then
                            local char = BallController:GetLastCharacterToPossessBall()
                            if char and char.Parent then
                                lastPlayer = Players:GetPlayerFromCharacter(char)
                            end
                        end
                    end)

                    local function lastPlayerIsEnemy()
                        if not lastPlayer then return false end
                        if lastPlayer == LocalPlayer then return false end
                        if not lastPlayer.Team then return true end
                        return lastPlayer.Team ~= LocalPlayer.Team
                    end

                    if lastPlayerIsEnemy() then
                        local perfectVelocity = calculateOriginalTrajectory(ballPos, targetDirection, distance, distance <= 30)
                        ball.AssemblyLinearVelocity = perfectVelocity

                        ballTrajectoryData = {
                            startTime = currentTime,
                            startPos = ballPos,
                            targetPos = hoopPos,
                            originalVelocity = perfectVelocity,
                            isActive = false -- Desabilitar sistema de correção ativa
                        }
                    end
                end
            end
            
            lastBallVelocity = currentVel
        end
    end)
end

-- =======================
-- LOOP PRINCIPAL AUTO DRIBBLE
-- =======================

-- Aguardar BallController estar disponível antes de iniciar o loop
local function startAutoDribble()
    local attempts = 0
    local maxAttempts = 30
    
    local function tryStart()
        attempts = attempts + 1
        
        if BallController and safeHasBall ~= nil then

            
            getgenv().AutoDribbleConnection = RunService.Heartbeat:Connect(function()
                if not AutoDribbleToggleFlag then return end -- controle via UI
                local CurrentTime = tick()
                local Character = LocalPlayer.Character
                if not Character or not safeHasBall() then return end
                local RootPart = Character:FindFirstChild("HumanoidRootPart")
                if not RootPart then return end

                local NearbyEnemies = {}

                for _, Player in ipairs(Players:GetPlayers()) do
                    if Player ~= LocalPlayer and ArePlayersEnemies(Player, LocalPlayer) then
                        local EnemyChar = CharacterCache[Player]
                        if EnemyChar and EnemyChar.Parent then
                            local EnemyRoot = RootPartCache[Player]
                            local EnemyHumanoid = EnemyChar:FindFirstChildOfClass("Humanoid")
                            if EnemyRoot and EnemyHumanoid and EnemyHumanoid.Health > 0 then
                                local Distance = PredictDistance(RootPart, EnemyRoot, EnemyRoot.Velocity)
                                if Distance <= DetectionRange then
                                    table.insert(NearbyEnemies, {
                                        player = Player,
                                        distance = Distance,
                                        humanoid = EnemyHumanoid,
                                        isSteal = IsPlayingStealAnimation(EnemyHumanoid)
                                    })
                                end
                            end
                        end
                    end
                end

                table.sort(NearbyEnemies, function(a, b) return a.distance < b.distance end)

                for _, enemy in ipairs(NearbyEnemies) do
                    local playerKey = enemy.player.Name
                    local lastDribbleTime = PlayerLastDribble[playerKey] or 0

                    -- Cooldown adaptativo
                    local adaptiveCooldown = PlayerCooldown
                    if enemy.distance <= UltraRange then
                        adaptiveCooldown = 0.05
                    elseif enemy.distance <= CriticalRange then
                        adaptiveCooldown = 0.1
                    elseif enemy.distance <= PanicRange then
                        adaptiveCooldown = 0.2
                    end

                    if CurrentTime - lastDribbleTime < adaptiveCooldown then
                        continue
                    end

                    -- Prioridade Ultra > Crítico > Pânico
                    if enemy.distance <= UltraRange and enemy.isSteal then
                        if UltraDribble(enemy.player, enemy.distance) then return end
                    elseif enemy.distance <= CriticalRange and enemy.isSteal then
                        if CriticalDribble(enemy.player, enemy.distance) then return end
                    elseif enemy.distance <= PanicRange and enemy.isSteal then
                        if PanicDribble(enemy.player, enemy.distance) then return end
                    elseif enemy.isSteal and CurrentTime - GlobalLastDribble >= 0.1 then
                        safeDribble()
                        PlayerLastDribble[playerKey] = CurrentTime
                        GlobalLastDribble = CurrentTime
                        local emoji = enemy.distance <= 8 and "⚡" or "🎯"

                        return
                    end
                end

                -- Debug Auto Dribble
                if #NearbyEnemies > 0 and CurrentTime - LastDebugTime > 3 then

                    for i, enemy in ipairs(NearbyEnemies) do
                        if i <= 2 then
                            local lastTime = PlayerLastDribble[enemy.player.Name] or 0
                            local cooldownLeft = math.max(0, PlayerCooldown - (CurrentTime - lastTime))

                        end
                    end
                    LastDebugTime = CurrentTime
                end
            end)
            return
        elseif attempts < maxAttempts then

            wait(1)
            tryStart()
        else

        end
    end
    
    tryStart()
end

-- Expor para a UI poder reativar quando precisar
_G.__StartAutoDribble = function()
    spawn(startAutoDribble)
end

-- Iniciar Auto Dribble
spawn(startAutoDribble)

-- =======================
-- AUTO BLOCK: runtime module
-- =======================

do
    -- reuse existing services/locals: Players, RunService, ReplicatedStorage, Workspace, LocalPlayer

    local Player = LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:FindFirstChildOfClass("Humanoid") or Character:WaitForChild("Humanoid")
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart")

    -- Configurações do Auto Block (defaults match sliders)
    local AUTO_BLOCK_RANGE = 22
    local BLOCK_ANGLE = 90
    local COOLDOWN = 1.2
    local BALL_SPEED_THRESHOLD = 60
    local TRAJECTORY_PREDICTION_DISTANCE = 6
    local MIN_SHOOT_VELOCITY = 80
    local MIN_PASS_VELOCITY = 45

    local SHOOT_VELOCITY_CHANGE_THRESHOLD = 50
    local SHOOT_MIN_HEIGHT = 10
    local PASS_MAX_HEIGHT = 8

    local lastBlockTime = 0
    local isEnabledAutoBlock = false
    local lastBallPosition = Vector3.new()
    local lastBallVelocity = Vector3.new()
    local ballAcceleration = Vector3.new()
    local isBlocking = false
    local shootEnabled = true
    local passEnabled = true

    local connectionAutoBlock = nil

    local function Jump()
        if not isBlocking and Humanoid and Humanoid.FloorMaterial ~= Enum.Material.Air and tick() - lastBlockTime > COOLDOWN then
            isBlocking = true
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            lastBlockTime = tick()
            task.delay(0.5, function() isBlocking = false end)
            return true
        end
        return false
    end

    local function IsEnemy(player)
        if not player or not player.Team then return false end
        return player.Team ~= Player.Team and player.Team ~= nil
    end

    local function DetectBallShots(ball)
        if not isEnabledAutoBlock or not Character or not HumanoidRootPart then return end
        if Player.Team == nil then return end

        if ball and ball:IsA("BasePart") then
            local ballVelocity = ball.AssemblyLinearVelocity
            local ballPosition = ball.Position

            if lastBallVelocity ~= Vector3.new() then
                local velocityChange = (ballVelocity - lastBallVelocity).Magnitude

                -- obter o último jogador que possuía a bola (se disponível)
                local lastPlayer = nil
                pcall(function()
                    if BallController and BallController.GetLastPlayerToPossessBall then
                        lastPlayer = BallController:GetLastPlayerToPossessBall()
                    elseif BallController and BallController.GetLastCharacterToPossessBall then
                        local char = BallController:GetLastCharacterToPossessBall()
                        if char and char.Parent then
                            lastPlayer = Players:GetPlayerFromCharacter(char)
                        end
                    end
                end)

                local function lastPlayerIsEnemy()
                    if not lastPlayer then return false end
                    if lastPlayer == Player then return false end
                    if not lastPlayer.Team then return true end
                    return lastPlayer.Team ~= Player.Team
                end

                -- Detectar tiro (mudança brusca de velocidade para cima)
                if velocityChange > SHOOT_VELOCITY_CHANGE_THRESHOLD and ballVelocity.Magnitude > MIN_SHOOT_VELOCITY and ballPosition.Y > SHOOT_MIN_HEIGHT then
                    -- só reagir se soubermos quem lançou/passou e for inimigo
                    if not lastPlayerIsEnemy() then
                        -- ignorar tiros feitos por nós ou por aliados / ou se desconhecido
                    else
                        local toBall = (ballPosition - HumanoidRootPart.Position)
                        if toBall.Magnitude > 0 then
                            local ballDirection = ballVelocity.Unit
                            local dotProduct = ballDirection:Dot(-toBall.Unit)
                            if dotProduct > 0.4 then
                                local distance = toBall.Magnitude
                                if distance <= AUTO_BLOCK_RANGE then
                                    if shootEnabled then Jump() end
                                end
                            end
                        end
                    end
                -- Detectar passes (velocidade menor, próximo do chão)
                elseif ballVelocity.Magnitude > MIN_PASS_VELOCITY and ballPosition.Y < PASS_MAX_HEIGHT then
                    -- validar possuidor do passe; ignorar se for nós
                    if lastPlayer and lastPlayer ~= Player and lastPlayerIsEnemy() then
                        local toBall = (ballPosition - HumanoidRootPart.Position)
                        if ballVelocity.Magnitude > 0 then
                            local timeToReach = toBall.Magnitude / ballVelocity.Magnitude
                            local predictedPosition = ballPosition + ballVelocity * timeToReach
                            local distanceToTrajectory = (HumanoidRootPart.Position - predictedPosition).Magnitude
                            if distanceToTrajectory <= TRAJECTORY_PREDICTION_DISTANCE then
                                if passEnabled then Jump() end
                            end
                        end
                    end
                end
            end

            lastBallPosition = ballPosition
            lastBallVelocity = ballVelocity
        end
    end

    local function DetectShootingStance()
        -- Only attempt stance-based detection when we have a reliable BallController available.
        -- BallController exposes the last player who possessed/threw the ball; we rely on that
        -- to avoid triggering on players who are only moving/dribbling or doing pumpfakes.
        if not isEnabledAutoBlock or not Character or not HumanoidRootPart then return end
        if Player.Team == nil then return end

        -- If BallController isn't available, skip stance detection to avoid false positives.
        if not BallController then
            return
        end

        -- Try to get the last player who possessed the ball. If it matches an enemy in range
        -- and they are actually in a shooting pose, perform the block. This ignores pumpfakes
        -- because we require the ball-controller to have recent possession data.
        local success, lastPlayer = pcall(function()
            if BallController.GetLastPlayerToPossessBall then
                return BallController:GetLastPlayerToPossessBall()
            elseif BallController.GetLastPlayerToPossessBallName then
                return nil
            end
        end)

        if not success or not lastPlayer then
            return
        end

        -- Only consider blocking if the last possessor is an enemy (and not ourselves)
        if lastPlayer == Player or not IsEnemy(lastPlayer) then
            return
        end

        -- Validate that this enemy is near and roughly facing us within the block angle
        local enemyChar = lastPlayer.Character
        if not enemyChar then return end
        local enemyRoot = enemyChar:FindFirstChild("HumanoidRootPart")
        local enemyHumanoid = enemyChar:FindFirstChildOfClass("Humanoid")
        if not enemyRoot or not enemyHumanoid or enemyHumanoid.Health <= 0 then return end

        local distance = (HumanoidRootPart.Position - enemyRoot.Position).Magnitude
        if distance > AUTO_BLOCK_RANGE then return end

        local toMe = (HumanoidRootPart.Position - enemyRoot.Position)
        if toMe.Magnitude <= 0 then return end
        local toMeUnit = toMe.Unit
        local enemyLook = enemyRoot.CFrame.LookVector
        local dotProduct = enemyLook:Dot(toMeUnit)
        local angle = math.deg(math.acos(math.clamp(dotProduct, -1, 1)))
        if angle > BLOCK_ANGLE then return end

        -- Basic checks to ensure the enemy appears to be shooting (jumping or upward velocity)
        local isShooting = false
        if enemyHumanoid:GetState() == Enum.HumanoidStateType.Jumping then isShooting = true end
        local enemyVelocity = enemyRoot.AssemblyLinearVelocity
        if enemyVelocity.Y > 12 then isShooting = true end
        if enemyRoot.Position.Y > HumanoidRootPart.Position.Y + 6 then isShooting = true end

        if isShooting and shootEnabled then
            Jump()
        end
    end

    local function StartAutoBlock()
        if connectionAutoBlock then connectionAutoBlock:Disconnect() connectionAutoBlock = nil end
        connectionAutoBlock = RunService.Heartbeat:Connect(function()
            if not isEnabledAutoBlock then return end
            DetectShootingStance()
            local ball = Workspace:FindFirstChild("Basketball") or Workspace:FindFirstChild("Ball")
            if ball then DetectBallShots(ball) end
        end)
    end

    -- Reconnect handlers
    Player.CharacterAdded:Connect(function(newChar)
        Character = newChar
        Humanoid = newChar:WaitForChild("Humanoid")
        HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
        lastBallPosition = Vector3.new()
        lastBallVelocity = Vector3.new()
        ballAcceleration = Vector3.new()
        isBlocking = false
        task.wait(1)
        if isEnabledAutoBlock then StartAutoBlock() end
    end)

    Player:GetPropertyChangedSignal("Team"):Connect(function()
        task.wait(0.5)
        if Player.Team and isEnabledAutoBlock then StartAutoBlock() end
    end)

    -- API
    local module = {
        Enable = function()
            isEnabledAutoBlock = true
            StartAutoBlock()
        end,
        Disable = function()
            isEnabledAutoBlock = false
            if connectionAutoBlock then connectionAutoBlock:Disconnect() connectionAutoBlock = nil end
        end,
        SetRange = function(range) AUTO_BLOCK_RANGE = range end,
        SetAngle = function(angle) BLOCK_ANGLE = angle end,
        SetCooldown = function(cooldown) COOLDOWN = cooldown end,
        SetMode = function(shoots, passes)
            BlockShootsFlag = shoots
            BlockPassesFlag = passes
            shootEnabled = shoots
            passEnabled = passes
        end,
        GetStatus = function() return isEnabledAutoBlock end
    }

    getgenv().AutoBlock = module
end

-- =======================
-- INICIALIZAÇÃO PERFECT SHOT
-- =======================

local function initializePerfectShot()
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    

    
    setupFallbackSystem()
    setupSubtleCorrection()
end

-- Sistema de fallback direto para Perfect Shot (simplificado para evitar comportamento de parada)
-- Removido para manter comportamento natural do script original

-- =======================
-- INICIALIZAÇÃO E LOGS
-- =======================

-- Executar Perfect Shot
spawn(function()
    wait(3) -- Aguardar mais tempo para estabilizar
    local success, errorMsg = pcall(initializePerfectShot)
    if not success then

    end
end)


        end
    },
    [130739873848552] = {
        name = "BasketballZero",
        description = "Script for BasketballZero",
        script = function()
            --// Basketball.lua

local PlaceIDs = {73708914208963, 130739873848552}
local isValidPlace = false
for _, placeId in ipairs(PlaceIDs) do
    if game.PlaceId == placeId then
        isValidPlace = true
        break
    end
end

if not isValidPlace then
    return
end

-- =========================
-- UI LIB (Tokyo)
-- =========================
local Decimals = 4
local Clock = os.clock()
local ValueText = "Value Is Now :"

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/isKuyo/UI/refs/heads/main/Source.lua"))({
    cheatname = "Basketball Script v2.0", 
    gamename  = "Basketball",
})

Library:init()

local WindowMain = Library.NewWindow({
    title = "Basketball Script v2.0",
    size  = UDim2.new(0, 510, 0.6, 6)
})

local TabMain      = WindowMain:AddTab("  Main  ")
local SettingsTab  = Library:CreateSettingsTab(WindowMain)

-- Helpers para “mostrar/ocultar” elementos (compat com libs que não expõem SetVisible)
local function SetVisible(Element, Visible)
    local ok = false
    if Element and typeof(Element) == "table" then
        ok = pcall(function()
            if Element.SetVisible then
                Element:SetVisible(Visible)
            elseif Element.Object and Element.Object.Visible ~= nil then
                Element.Object.Visible = Visible
            elseif Element.Main and Element.Main.Visible ~= nil then
                Element.Main.Visible = Visible
            elseif Element.Frame and Element.Frame.Visible ~= nil then
                Element.Frame.Visible = Visible
            end
        end)
    end
    return ok
end

local function SetGroupVisible(GroupArray, Visible)
    for _, el in ipairs(GroupArray) do
        SetVisible(el, Visible)
    end
end

-- =========================
-- GRUPOS NA TAB MAIN
-- =========================
local SectionAimbot         = TabMain:AddSection("Aimbot (Perfect Shot)", 1)        -- Left column, first section
local SectionNoAbility      = TabMain:AddSection("No Ability Cooldown", 2)          -- Right column
local SectionAutoDribble    = TabMain:AddSection("Auto Dribble", 1)                 -- Left column

-- Auto Block section (Right column)
local SectionAutoBlock     = TabMain:AddSection("Auto Block", 2)

-- Força atualização imediata do layout
task.spawn(function()
    -- Forçar refresh múltiplas vezes para garantir
    for i = 1, 3 do
        task.wait(0.1)
        pcall(function() if WindowMain and WindowMain.Refresh then WindowMain:Refresh() end end)
        pcall(function() if TabMain and TabMain.Refresh then TabMain:Refresh() end end)
        pcall(function() if TabMain and TabMain.UpdateSections then TabMain:UpdateSections() end end)
        -- Simular troca de aba para forçar refresh
        if SettingsTab then
            pcall(function() SettingsTab:SetActive() end)
            task.wait(0.05)
            pcall(function() TabMain:SetActive() end)
        end
    end
end)

-- Flags de controle (UI → lógica) - TUDO INICIALMENTE DESATIVADO
local AimbotToggleFlag        = false
local SubtleCorrectionFlag    = false
local AutoDribbleToggleFlag   = false
local NoAbilityCooldownFlag   = false

-- Sliders/inputs (valores default devem casar com o script)
local DetectionRangeValue = 18
local PanicRangeValue     = 5
local CriticalRangeValue  = 4
local UltraRangeValue     = 1.5
local PlayerCooldownValue = 1

-- =========================
-- AIMBOT: elementos base
-- =========================
local AimbotToggle = SectionAimbot:AddToggle({
    text = "Perfect Shot",
    state = false,
    tooltip = "Enable/disable aimbot shooting",
    flag = "Aimbot_Enabled",
    callback = function(v)
        AimbotToggleFlag = v
        AIMBOT_ENABLED = v  -- Ativar diretamente a variável global
        -- Aguardar um frame antes de mostrar/ocultar para evitar bug de posição
        task.wait(0.01)
        SetGroupVisible({SubtleToggle, AimbotHint}, v)
    end
})

local SubtleToggle = SectionAimbot:AddToggle({
    text = "Subtle Correction",
    state = false,
    tooltip = "Subtle trajectory correction during flight",
    flag = "Aimbot_Subtle",
    callback = function(v)
        SubtleCorrectionFlag = v
        SUBTLE_CORRECTION = v  -- Ativar diretamente a variável global
    end
})

local AimbotHint = SectionAimbot:AddBox({
    enabled = false,
    name = "Info",
    flag = "Aimbot_Info",
    input = "GUI control only",
    focused = false,
    risky = false,
    callback = function() end
})

-- Revelar/ocultar controles do aimbot quando liga/desliga - INICIALMENTE OCULTOS
SetGroupVisible({SubtleToggle, AimbotHint}, false)

-- =========================
-- NO ABILITY COOLDOWN: elementos
-- =========================

-- Variáveis para No Ability Cooldown
local NoAbilityCooldownConnection = nil

local NoAbilityCooldownToggle = SectionNoAbility:AddToggle({
    text = "No Ability Cooldown",
    state = false,
    tooltip = "Remove cooldowns from all abilities",
    flag = "NoAbility_Enabled",
    callback = function(v)
        NoAbilityCooldownFlag = v
        
        if v then
            -- Ativar No Ability Cooldown
            local success, errorMsg = pcall(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local RunService = game:GetService("RunService")
                
                -- Aguardar Knit estar disponível
                local packages = ReplicatedStorage:WaitForChild("Packages", 5)
                if packages then
                    local knitModule = packages:FindFirstChild("Knit")
                    if knitModule then
                        local Knit = require(knitModule)
                        
                        -- Aguardar Knit inicializar
                        Knit.OnStart():await()
                        
                        -- Obter AbilityController
                        local AbilityController = require(ReplicatedStorage.Controllers.AbilityController)
                        
                        -- Função para remover cooldowns
                        local function NoCooldowns(ClientAbilityController)
                            NoAbilityCooldownConnection = RunService.RenderStepped:Connect(function()
                                if ClientAbilityController.CDS then
                                    for i = 1, 4 do
                                        ClientAbilityController.CDS[i] = tick() - 1
                                    end
                                end
                            end)
                        end
                        
                        -- Executar o patch
                        NoCooldowns(AbilityController)
                        
                        -- Atualizar UI se disponível
                        if AbilityController.CooldownUI then
                            AbilityController.CooldownUI(AbilityController)
                        end
                        

                    end
                end
            end)
            
            if not success then

            end
        else
            -- Desativar No Ability Cooldown
            if NoAbilityCooldownConnection then
                NoAbilityCooldownConnection:Disconnect()
                NoAbilityCooldownConnection = nil

            end
        end
    end
})

-- =========================
-- AUTO DRIBBLE: elementos base
-- =========================
local AutoDribbleToggle = SectionAutoDribble:AddToggle({
    text = "Auto Dribble",
    state = false,
    tooltip = "Enable/disable automatic dribbling system",
    flag = "AD_Enabled",
    callback = function(v)
        AutoDribbleToggleFlag = v
        if getgenv().AutoDribbleConnection then
            getgenv().AutoDribbleConnection:Disconnect()
            getgenv().AutoDribbleConnection = nil
        end
        if v and _G.__StartAutoDribble then
            _G.__StartAutoDribble() -- reconecta loop com os valores atuais
        end
    end
})

    -- =========================
    -- AUTO BLOCK: UI CONTROLS
    -- =========================
    local AutoBlockToggleFlag = false
    local BlockShootsFlag = false
    local BlockPassesFlag = false

    local AutoBlockToggle = SectionAutoBlock:AddToggle({
        text = "Auto Block",
        state = false,
        tooltip = "Enable/disable Auto Block (shoots & passes)",
        flag = "AutoBlock_Enabled",
        callback = function(v)
            AutoBlockToggleFlag = v
            if getgenv().AutoBlock and getgenv().AutoBlock.Enable and not v then
                getgenv().AutoBlock.Disable()
            end
            if getgenv().AutoBlock and getgenv().AutoBlock.Enable and v then
                getgenv().AutoBlock.Enable()
            end
            -- show/hide child controls
            SetGroupVisible({BlockShootsToggle, BlockPassesToggle, SliderBlockRange, SliderBlockAngle, SliderBlockCooldown}, v)
        end
    })

    local BlockShootsToggle = SectionAutoBlock:AddToggle({
        text = "Block Shoots",
        state = false,
        tooltip = "Automatically block enemy shots",
        flag = "AutoBlock_BlockShoots",
        callback = function(v)
            BlockShootsFlag = v
            if rawget(getgenv(), "AutoBlock") and getgenv().AutoBlock.SetMode then
                getgenv().AutoBlock.SetMode(BlockShootsFlag, BlockPassesFlag)
            end
        end
    })

    local BlockPassesToggle = SectionAutoBlock:AddToggle({
        text = "Block Passes",
        state = false,
        tooltip = "Automatically block incoming passes",
        flag = "AutoBlock_BlockPasses",
        callback = function(v)
            BlockPassesFlag = v
            if rawget(getgenv(), "AutoBlock") and getgenv().AutoBlock.SetMode then
                getgenv().AutoBlock.SetMode(BlockShootsFlag, BlockPassesFlag)
            end
        end
    })

    local SliderBlockRange = SectionAutoBlock:AddSlider({
        enabled = true,
        text = "Block Range",
        tooltip = "Range to detect shots/passes",
        flag = "AutoBlock_Range",
        suffix = " studs",
        dragging = true,
        min = 4, max = 60, increment = 0.5,
        callback = function(v)
            if rawget(getgenv(), "AutoBlock") and getgenv().AutoBlock.SetRange then
                getgenv().AutoBlock.SetRange(v)
            end
        end
    })
    SliderBlockRange:SetValue(22)

    local SliderBlockAngle = SectionAutoBlock:AddSlider({
        enabled = true,
        text = "Block Angle",
        tooltip = "Angle cone to consider for blocking",
        flag = "AutoBlock_Angle",
        suffix = "°",
        dragging = true,
        min = 10, max = 180, increment = 1,
        callback = function(v)
            if rawget(getgenv(), "AutoBlock") and getgenv().AutoBlock.SetAngle then
                getgenv().AutoBlock.SetAngle(v)
            end
        end
    })
    SliderBlockAngle:SetValue(90)

    local SliderBlockCooldown = SectionAutoBlock:AddSlider({
        enabled = true,
        text = "Block Cooldown",
        tooltip = "Cooldown between blocks (s)",
        flag = "AutoBlock_Cooldown",
        suffix = " s",
        dragging = true,
        min = 0.1, max = 3, increment = 0.05,
        callback = function(v)
            if rawget(getgenv(), "AutoBlock") and getgenv().AutoBlock.SetCooldown then
                getgenv().AutoBlock.SetCooldown(v)
            end
        end
    })
    SliderBlockCooldown:SetValue(1.2)

    -- start hidden
    SetGroupVisible({BlockShootsToggle, BlockPassesToggle, SliderBlockRange, SliderBlockAngle, SliderBlockCooldown}, false)

-- Criar os sliders (eles serão mantidos ocultos por padrão)
local SliderDetection = SectionAutoDribble:AddSlider({
    enabled = true,
    text = "Detection Range",
    tooltip = "Distance to detect enemies",
    flag = "AD_DetectionRange",
    suffix = " studs",
    dragging = true,
    min = 4, max = 50, increment = 0.5,
    callback = function(v)
        DetectionRangeValue = v
        if rawget(_G, "DetectionRange") ~= nil then DetectionRange = v end
    end
})
SliderDetection:SetValue(DetectionRangeValue)

local SliderPanic = SectionAutoDribble:AddSlider({
    enabled = true,
    text = "Panic Range",
    tooltip = "Range for panic mode",
    flag = "AD_PanicRange",
    suffix = " studs",
    dragging = true,
    min = 2, max = 12, increment = 0.5,
    callback = function(v)
        PanicRangeValue = v
        if rawget(_G, "PanicRange") ~= nil then PanicRange = v end
    end
})
SliderPanic:SetValue(PanicRangeValue)

local SliderCritical = SectionAutoDribble:AddSlider({
    enabled = true,
    text = "Critical Range",
    tooltip = "Range for critical double dribble",
    flag = "AD_CriticalRange",
    suffix = " studs",
    dragging = true,
    min = 2, max = 10, increment = 0.5,
    callback = function(v)
        CriticalRangeValue = v
        if rawget(_G, "CriticalRange") ~= nil then CriticalRange = v end
    end
})
SliderCritical:SetValue(CriticalRangeValue)

local SliderUltra = SectionAutoDribble:AddSlider({
    enabled = true,
    text = "Ultra Range",
    tooltip = "Range for ULTRA dribble",
    flag = "AD_UltraRange",
    suffix = " studs",
    dragging = true,
    min = 0.5, max = 3, increment = 0.1,
    callback = function(v)
        UltraRangeValue = v
        if rawget(_G, "UltraRange") ~= nil then UltraRange = v end
    end
})
SliderUltra:SetValue(UltraRangeValue)

local SliderCooldown = SectionAutoDribble:AddSlider({
    enabled = true,
    text = "Player Cooldown",
    tooltip = "Base cooldown per player",
    flag = "AD_PlayerCooldown",
    suffix = " s",
    dragging = true,
    min = 0, max = 2, increment = 0.05,
    callback = function(v)
        PlayerCooldownValue = v
        if rawget(_G, "PlayerCooldown") ~= nil then PlayerCooldown = v end
    end
})
SliderCooldown:SetValue(PlayerCooldownValue)

-- Aguardar a criação completa da UI antes de ocultar elementos
task.spawn(function()
    task.wait(0.2) -- Aguardar mais tempo para UI estabilizar completamente
    SetGroupVisible({SliderDetection, SliderPanic, SliderCritical, SliderUltra, SliderCooldown}, false)
    
    -- Forçar refresh completo da UI após tudo estar criado
    task.wait(0.1)
    
    -- Métodos de refresh da UI
    pcall(function()
        if WindowMain and WindowMain.Refresh then
            WindowMain:Refresh()
        end
    end)
    
    pcall(function()
        if Library and Library.Refresh then
            Library:Refresh()
        end
    end)
    
    pcall(function()
        if TabMain and TabMain.Refresh then
            TabMain:Refresh()
        end
    end)
    
    -- Simular mudança de aba para forçar layout refresh
    pcall(function()
        if SettingsTab and WindowMain then
            -- Mudar para settings e voltar para forçar refresh
            task.wait(0.1)
            if SettingsTab.SetActive then
                SettingsTab:SetActive()
                task.wait(0.05)
                TabMain:SetActive()
            end
        end
    end)
end)

-- =========================
-- NOTIFICAÇÃO DE LOAD
-- =========================
local Time = (string.format("%." .. tostring(Decimals) .. "f", os.clock() - Clock))
Library:SendNotification(("Loaded In " .. tostring(Time)), 6)

-- ======================================================================
--  A PARTIR DAQUI: SISTEMA EXATO FORNECIDO (NÃO ALTERAR NENHUMA FUNÇÃO)
-- ======================================================================

-- SISTEMA COMPLETO: Auto Dribble Ultra Responsivo + Arremesso 100% Certeiro
-- Versão corrigida com bypass para detecção anti-exploit do Knit

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- =======================
-- CONFIGURAÇÕES GLOBAIS
-- =======================

-- Auto Dribble Configurações
DetectionRange = 18
PanicRange = 5
CriticalRange = 4
UltraRange = 1.5
PlayerCooldown = 1
local StealAnimationId = "rbxassetid://132607768946898"

-- Perfect Shot Configurações - INICIALMENTE DESATIVADAS
AIMBOT_ENABLED = false
SUBTLE_CORRECTION = false

-- =======================
-- BYPASS PARA KNIT ANTI-DETECTION
-- =======================

-- Função segura para obter o Knit sem triggar detecções
local function getSafeKnit()
    local success, knit = pcall(function()
        -- Aguardar o Knit estar disponível
        local packages = ReplicatedStorage:WaitForChild("Packages", 5)
        if not packages then return nil end
        
        local knitModule = packages:FindFirstChild("Knit")
        if not knitModule then return nil end
        
        -- Usar require seguro
        local knitService = require(knitModule)
        return knitService
    end)
    
    if success and knit then
        return knit
    end
    return nil
end

-- Função para obter controller de forma segura
local function getSafeBallController()
    local knit = getSafeKnit()
    if not knit then return nil end
    
    local success, controller = pcall(function()
        -- Aguardar o Knit inicializar
        knit.OnStart():await()
        return knit.GetController("BallController")
    end)
    
    if success then
        return controller
    end
    return nil
end

-- =======================
-- INICIALIZAÇÃO SEGURA DO KNIT
-- =======================

local Knit = nil
local BallController = nil

-- Tentar inicializar de forma segura
spawn(function()
    wait(2) -- Aguardar o jogo carregar completamente
    
    Knit = getSafeKnit()
    if Knit then

        
        -- Aguardar inicialização
        local success = pcall(function()
            Knit.OnStart():await()
        end)
        
        if success then
            BallController = getSafeBallController()
            if BallController then

            else

            end
        else

        end
    else

    end
end)

-- =======================
-- VARIÁVEIS AUTO DRIBBLE
-- =======================

-- Controle de tempo
local LastDebugTime = 0
local PlayerLastDribble = {}
local UltraAttempts = {}
local PanicAttempts = {}
local GlobalLastDribble = 0

-- Cache de personagens
local CharacterCache = {}
local RootPartCache = {}

-- =======================
-- VARIÁVEIS PERFECT SHOT
-- =======================

local ballTrajectoryData = {}

-- =======================
-- LIMPEZA DE CONEXÕES ANTIGAS
-- =======================

-- Desconectar conexão antiga do Auto Dribble
if getgenv().AutoDribbleConnection then
    getgenv().AutoDribbleConnection:Disconnect()
    getgenv().AutoDribbleConnection = nil

end

-- =======================
-- SISTEMA DE CACHE DE PERSONAGENS
-- =======================

-- Atualizar cache de personagens
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        CharacterCache[player] = character
        character:WaitForChild("HumanoidRootPart", 5)
        RootPartCache[player] = character:FindFirstChild("HumanoidRootPart")
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    CharacterCache[player] = nil
    RootPartCache[player] = nil
end)

-- Inicializar cache
for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        CharacterCache[player] = player.Character
        RootPartCache[player] = player.Character:FindFirstChild("HumanoidRootPart")
    end
end

-- =======================
-- FUNÇÕES AUTO DRIBBLE
-- =======================

local function ArePlayersEnemies(player1, player2)
    if not player1 or not player2 then return false end
    local team1, team2 = player1.Team, player2.Team
    if not team1 or not team2 then return true end
    return team1 ~= team2
end

local function IsPlayingStealAnimation(humanoid)
    if not humanoid then return false end
    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        if track.Animation and track.Animation.AnimationId == StealAnimationId then
            return true
        end
    end
    return false
end

-- Função segura para verificar se o jogador tem a bola
local function safeHasBall()
    if not BallController then return false end
    
    local success, hasBall = pcall(function()
        return BallController:LocalPlayerPossessesBall()
    end)
    
    return success and hasBall
end

-- Função segura para driblar
local function safeDribble()
    if not BallController or not safeHasBall() then return false end
    
    local success = pcall(function()
        BallController:Dribble()
    end)
    
    return success
end

local function PanicDribble(player, distance)
    local playerKey = player.Name
    local currentTime = tick()
    local lastAttempt = PanicAttempts[playerKey] or 0
    if currentTime - lastAttempt < 0.005 then return false end

    if safeHasBall() then
        -- Triplo dribble
        for i = 1, 3 do
            if safeHasBall() then
                safeDribble()
                task.wait(0.003)
            end
        end

        PanicAttempts[playerKey] = currentTime
        PlayerLastDribble[playerKey] = currentTime
        GlobalLastDribble = currentTime

        return true
    end
    return false
end

local function UltraDribble(player, distance)
    local playerKey = player.Name
    local currentTime = tick()
    local lastAttempt = UltraAttempts[playerKey] or 0
    if currentTime - lastAttempt < 0.01 then return false end

    if safeHasBall() then
        safeDribble()
        UltraAttempts[playerKey] = currentTime
        PlayerLastDribble[playerKey] = currentTime
        GlobalLastDribble = currentTime

        return true
    end
    return false
end

local function CriticalDribble(player, distance)
    if safeHasBall() then
        safeDribble()
        task.wait(0.005)
        if safeHasBall() then
            safeDribble()
        end
        PlayerLastDribble[player.Name] = tick()
        GlobalLastDribble = tick()

        return true
    end
    return false
end

-- Predição agressiva para zonas próximas
local function PredictDistance(myRoot, enemyRoot, enemyVelocity)
    if not myRoot or not enemyRoot then return math.huge end
    local currentDistance = (myRoot.Position - enemyRoot.Position).Magnitude
    if not enemyVelocity or enemyVelocity.Magnitude < 1 then
        return currentDistance
    end

    local factor = 0.1
    if currentDistance <= CriticalRange then factor = 0.2 end
    if currentDistance <= UltraRange then factor = 0.3 end

    local predictedPosition = enemyRoot.Position + (enemyVelocity * factor)
    local predictedDistance = (myRoot.Position - predictedPosition).Magnitude
    return math.min(currentDistance, predictedDistance)
end

-- =======================
-- FUNÇÕES PERFECT SHOT
-- =======================

-- Função para encontrar a bola atual
local function getCurrentBall()
    local ball = nil
    
    -- Método do script original
    if ReplicatedStorage:FindFirstChild("GameValues") then
        local gameValues = ReplicatedStorage.GameValues
        if gameValues:FindFirstChild("Basketball") then
            ball = gameValues.Basketball.Value
        end
    end
    
    if not ball then
        ball = Workspace:FindFirstChild("Basketball") or Workspace:FindFirstChild("Ball")
    end
    
    return ball
end

-- Função para obter o aro alvo
local function getTargetHoop()
    if not LocalPlayer.Team or LocalPlayer.Team.Name == "Visitor" then 
        return nil 
    end
    
    local hoops = Workspace:FindFirstChild("Hoops")
    if hoops then
        local teamHoop = hoops:FindFirstChild(LocalPlayer.Team.Name)
        if teamHoop then
            return teamHoop:FindFirstChild("Hoop")
        end
    end
    
    return nil
end

-- Função que replica o cálculo original mas com alvo garantido
local function calculateOriginalTrajectory(ballPosition, targetDirection, distance, isClose)
    -- Valores base do script original (exatamente como no BallController.lua)
    local baseMultiplier = 0.75
    local distanceMultiplier
    
    -- Ajustar multiplicadores baseado na distância (como no original)
    if distance <= 30 then
        distanceMultiplier = distance * 0.0455
        baseMultiplier = 1.35
    else
        distanceMultiplier = distance * 0.045
    end
    
    -- Calcular o multiplicador total (como no original)
    local totalMultiplier = baseMultiplier + distanceMultiplier
    local logMultiplier = math.log(totalMultiplier)
    
    -- Calcular velocidade base na direção do alvo (exatamente como no original)
    local baseVelocity = targetDirection / logMultiplier
    
    -- Ajustar componente vertical para garantir que chegue na cesta (como no original)
    local gravityCompensation = workspace.Gravity * logMultiplier * 0.5
    
    -- Retornar exatamente como o script original, sem ajustes extras
    return baseVelocity + Vector3.new(0, gravityCompensation, 0)
end

-- Sistema de correção sutil durante o voo (desabilitado para evitar comportamento de parada)
local function setupSubtleCorrection()
    -- Sistema de correção desabilitado para manter comportamento natural
    -- O aimbot agora funciona apenas no momento do arremesso, sem correções durante o voo
    return nil
end

-- Sistema de fallback que respeita a física original
local function setupFallbackSystem()
    local lastBallVelocity = Vector3.new()
    local throwDetectionTime = 0
    local lastCorrectionTime = 0
    local lastBasketTime = 0
    local ballHeightHistory = {}
    
    -- Verificar se é um arremesso normal (não dunk)
    local function isNormalShot()
        if not BallController then return true end
        local success, result = pcall(function()
            -- Verificar se está em animação de dunk
            return not (BallController.States and BallController.States.Dunking)
        end)
        return success and result
    end
    
    -- Detectar se a bola passou pelo aro
    local function detectBasket(ball, hoop)
        local ballPos = ball.Position
        local hoopPos = hoop.Position
        local distance = (ballPos - hoopPos).Magnitude
        
        -- Verificar se está próximo do aro
        if distance < 3 then
            local ballHeight = ballPos.Y
            local hoopHeight = hoopPos.Y
            
            -- Armazenar histórico de altura da bola
            table.insert(ballHeightHistory, ballHeight)
            if #ballHeightHistory > 10 then
                table.remove(ballHeightHistory, 1)
            end
            
            -- Detectar se a bola passou pelo aro (altura diminuiu após estar no nível do aro)
            if #ballHeightHistory >= 3 then
                local wasAboveHoop = ballHeightHistory[#ballHeightHistory - 2] > hoopHeight + 1
                local isBelowHoop = ballHeight < hoopHeight - 1
                local isNearHoop = distance < 2
                
                if wasAboveHoop and isBelowHoop and isNearHoop then
                    return true
                end
            end
        end
        
        return false
    end
    
    RunService.Heartbeat:Connect(function()
        if not AIMBOT_ENABLED then return end
        
        local ball = getCurrentBall()
        local hoop = getTargetHoop()
        
        if ball and hoop then
            local currentVel = ball.AssemblyLinearVelocity
            local velocityChange = (currentVel - lastBallVelocity).Magnitude
            local currentTime = tick()
            
            -- Detectar se a bola passou pelo aro
            if detectBasket(ball, hoop) then
                lastBasketTime = currentTime
                ballHeightHistory = {} -- Limpar histórico
                return -- Não fazer mais correções após cesta
            end
            
            -- Não fazer correções se acabou de acertar a cesta
            if currentTime - lastBasketTime < 3 then
                return
            end
            
            -- Detectar novo arremesso (mudança brusca na velocidade) e verificar se é arremesso normal
            -- Apenas corrigir uma vez por arremesso para evitar comportamento de parada
            if velocityChange > 20 and currentVel.Magnitude > 15 and isNormalShot() and (currentTime - lastCorrectionTime) > 2 then
                throwDetectionTime = currentTime
                lastCorrectionTime = currentTime
                
                local ballPos = ball.Position
                local hoopPos = hoop.Position
                local targetDirection = hoopPos - ballPos
                local distance = targetDirection.Magnitude
                
                -- Aplicar lógica do script original com alvo correto
                -- Sem delay para evitar comportamento de parada
                if ball.Parent then
                    -- Verificar último possuidor da bola; só aplicar correção se for inimigo
                    local lastPlayer = nil
                    pcall(function()
                        if BallController and BallController.GetLastPlayerToPossessBall then
                            lastPlayer = BallController:GetLastPlayerToPossessBall()
                        elseif BallController and BallController.GetLastCharacterToPossessBall then
                            local char = BallController:GetLastCharacterToPossessBall()
                            if char and char.Parent then
                                lastPlayer = Players:GetPlayerFromCharacter(char)
                            end
                        end
                    end)

                    local function lastPlayerIsEnemy()
                        if not lastPlayer then return false end
                        if lastPlayer == LocalPlayer then return false end
                        if not lastPlayer.Team then return true end
                        return lastPlayer.Team ~= LocalPlayer.Team
                    end

                    if lastPlayerIsEnemy() then
                        local perfectVelocity = calculateOriginalTrajectory(ballPos, targetDirection, distance, distance <= 30)
                        ball.AssemblyLinearVelocity = perfectVelocity

                        ballTrajectoryData = {
                            startTime = currentTime,
                            startPos = ballPos,
                            targetPos = hoopPos,
                            originalVelocity = perfectVelocity,
                            isActive = false -- Desabilitar sistema de correção ativa
                        }
                    end
                end
            end
            
            lastBallVelocity = currentVel
        end
    end)
end

-- =======================
-- LOOP PRINCIPAL AUTO DRIBBLE
-- =======================

-- Aguardar BallController estar disponível antes de iniciar o loop
local function startAutoDribble()
    local attempts = 0
    local maxAttempts = 30
    
    local function tryStart()
        attempts = attempts + 1
        
        if BallController and safeHasBall ~= nil then

            
            getgenv().AutoDribbleConnection = RunService.Heartbeat:Connect(function()
                if not AutoDribbleToggleFlag then return end -- controle via UI
                local CurrentTime = tick()
                local Character = LocalPlayer.Character
                if not Character or not safeHasBall() then return end
                local RootPart = Character:FindFirstChild("HumanoidRootPart")
                if not RootPart then return end

                local NearbyEnemies = {}

                for _, Player in ipairs(Players:GetPlayers()) do
                    if Player ~= LocalPlayer and ArePlayersEnemies(Player, LocalPlayer) then
                        local EnemyChar = CharacterCache[Player]
                        if EnemyChar and EnemyChar.Parent then
                            local EnemyRoot = RootPartCache[Player]
                            local EnemyHumanoid = EnemyChar:FindFirstChildOfClass("Humanoid")
                            if EnemyRoot and EnemyHumanoid and EnemyHumanoid.Health > 0 then
                                local Distance = PredictDistance(RootPart, EnemyRoot, EnemyRoot.Velocity)
                                if Distance <= DetectionRange then
                                    table.insert(NearbyEnemies, {
                                        player = Player,
                                        distance = Distance,
                                        humanoid = EnemyHumanoid,
                                        isSteal = IsPlayingStealAnimation(EnemyHumanoid)
                                    })
                                end
                            end
                        end
                    end
                end

                table.sort(NearbyEnemies, function(a, b) return a.distance < b.distance end)

                for _, enemy in ipairs(NearbyEnemies) do
                    local playerKey = enemy.player.Name
                    local lastDribbleTime = PlayerLastDribble[playerKey] or 0

                    -- Cooldown adaptativo
                    local adaptiveCooldown = PlayerCooldown
                    if enemy.distance <= UltraRange then
                        adaptiveCooldown = 0.05
                    elseif enemy.distance <= CriticalRange then
                        adaptiveCooldown = 0.1
                    elseif enemy.distance <= PanicRange then
                        adaptiveCooldown = 0.2
                    end

                    if CurrentTime - lastDribbleTime < adaptiveCooldown then
                        continue
                    end

                    -- Prioridade Ultra > Crítico > Pânico
                    if enemy.distance <= UltraRange and enemy.isSteal then
                        if UltraDribble(enemy.player, enemy.distance) then return end
                    elseif enemy.distance <= CriticalRange and enemy.isSteal then
                        if CriticalDribble(enemy.player, enemy.distance) then return end
                    elseif enemy.distance <= PanicRange and enemy.isSteal then
                        if PanicDribble(enemy.player, enemy.distance) then return end
                    elseif enemy.isSteal and CurrentTime - GlobalLastDribble >= 0.1 then
                        safeDribble()
                        PlayerLastDribble[playerKey] = CurrentTime
                        GlobalLastDribble = CurrentTime
                        local emoji = enemy.distance <= 8 and "⚡" or "🎯"

                        return
                    end
                end

                -- Debug Auto Dribble
                if #NearbyEnemies > 0 and CurrentTime - LastDebugTime > 3 then

                    for i, enemy in ipairs(NearbyEnemies) do
                        if i <= 2 then
                            local lastTime = PlayerLastDribble[enemy.player.Name] or 0
                            local cooldownLeft = math.max(0, PlayerCooldown - (CurrentTime - lastTime))

                        end
                    end
                    LastDebugTime = CurrentTime
                end
            end)
            return
        elseif attempts < maxAttempts then

            wait(1)
            tryStart()
        else

        end
    end
    
    tryStart()
end

-- Expor para a UI poder reativar quando precisar
_G.__StartAutoDribble = function()
    spawn(startAutoDribble)
end

-- Iniciar Auto Dribble
spawn(startAutoDribble)

-- =======================
-- AUTO BLOCK: runtime module
-- =======================

do
    -- reuse existing services/locals: Players, RunService, ReplicatedStorage, Workspace, LocalPlayer

    local Player = LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:FindFirstChildOfClass("Humanoid") or Character:WaitForChild("Humanoid")
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart")

    -- Configurações do Auto Block (defaults match sliders)
    local AUTO_BLOCK_RANGE = 22
    local BLOCK_ANGLE = 90
    local COOLDOWN = 1.2
    local BALL_SPEED_THRESHOLD = 60
    local TRAJECTORY_PREDICTION_DISTANCE = 6
    local MIN_SHOOT_VELOCITY = 80
    local MIN_PASS_VELOCITY = 45

    local SHOOT_VELOCITY_CHANGE_THRESHOLD = 50
    local SHOOT_MIN_HEIGHT = 10
    local PASS_MAX_HEIGHT = 8

    local lastBlockTime = 0
    local isEnabledAutoBlock = false
    local lastBallPosition = Vector3.new()
    local lastBallVelocity = Vector3.new()
    local ballAcceleration = Vector3.new()
    local isBlocking = false
    local shootEnabled = true
    local passEnabled = true

    local connectionAutoBlock = nil

    local function Jump()
        if not isBlocking and Humanoid and Humanoid.FloorMaterial ~= Enum.Material.Air and tick() - lastBlockTime > COOLDOWN then
            isBlocking = true
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            lastBlockTime = tick()
            task.delay(0.5, function() isBlocking = false end)
            return true
        end
        return false
    end

    local function IsEnemy(player)
        if not player or not player.Team then return false end
        return player.Team ~= Player.Team and player.Team ~= nil
    end

    local function DetectBallShots(ball)
        if not isEnabledAutoBlock or not Character or not HumanoidRootPart then return end
        if Player.Team == nil then return end

        if ball and ball:IsA("BasePart") then
            local ballVelocity = ball.AssemblyLinearVelocity
            local ballPosition = ball.Position

            if lastBallVelocity ~= Vector3.new() then
                local velocityChange = (ballVelocity - lastBallVelocity).Magnitude

                -- obter o último jogador que possuía a bola (se disponível)
                local lastPlayer = nil
                pcall(function()
                    if BallController and BallController.GetLastPlayerToPossessBall then
                        lastPlayer = BallController:GetLastPlayerToPossessBall()
                    elseif BallController and BallController.GetLastCharacterToPossessBall then
                        local char = BallController:GetLastCharacterToPossessBall()
                        if char and char.Parent then
                            lastPlayer = Players:GetPlayerFromCharacter(char)
                        end
                    end
                end)

                local function lastPlayerIsEnemy()
                    if not lastPlayer then return false end
                    if lastPlayer == Player then return false end
                    if not lastPlayer.Team then return true end
                    return lastPlayer.Team ~= Player.Team
                end

                -- Detectar tiro (mudança brusca de velocidade para cima)
                if velocityChange > SHOOT_VELOCITY_CHANGE_THRESHOLD and ballVelocity.Magnitude > MIN_SHOOT_VELOCITY and ballPosition.Y > SHOOT_MIN_HEIGHT then
                    -- só reagir se soubermos quem lançou/passou e for inimigo
                    if not lastPlayerIsEnemy() then
                        -- ignorar tiros feitos por nós ou por aliados / ou se desconhecido
                    else
                        local toBall = (ballPosition - HumanoidRootPart.Position)
                        if toBall.Magnitude > 0 then
                            local ballDirection = ballVelocity.Unit
                            local dotProduct = ballDirection:Dot(-toBall.Unit)
                            if dotProduct > 0.4 then
                                local distance = toBall.Magnitude
                                if distance <= AUTO_BLOCK_RANGE then
                                    if shootEnabled then Jump() end
                                end
                            end
                        end
                    end
                -- Detectar passes (velocidade menor, próximo do chão)
                elseif ballVelocity.Magnitude > MIN_PASS_VELOCITY and ballPosition.Y < PASS_MAX_HEIGHT then
                    -- validar possuidor do passe; ignorar se for nós
                    if lastPlayer and lastPlayer ~= Player and lastPlayerIsEnemy() then
                        local toBall = (ballPosition - HumanoidRootPart.Position)
                        if ballVelocity.Magnitude > 0 then
                            local timeToReach = toBall.Magnitude / ballVelocity.Magnitude
                            local predictedPosition = ballPosition + ballVelocity * timeToReach
                            local distanceToTrajectory = (HumanoidRootPart.Position - predictedPosition).Magnitude
                            if distanceToTrajectory <= TRAJECTORY_PREDICTION_DISTANCE then
                                if passEnabled then Jump() end
                            end
                        end
                    end
                end
            end

            lastBallPosition = ballPosition
            lastBallVelocity = ballVelocity
        end
    end

    local function DetectShootingStance()
        -- Only attempt stance-based detection when we have a reliable BallController available.
        -- BallController exposes the last player who possessed/threw the ball; we rely on that
        -- to avoid triggering on players who are only moving/dribbling or doing pumpfakes.
        if not isEnabledAutoBlock or not Character or not HumanoidRootPart then return end
        if Player.Team == nil then return end

        -- If BallController isn't available, skip stance detection to avoid false positives.
        if not BallController then
            return
        end

        -- Try to get the last player who possessed the ball. If it matches an enemy in range
        -- and they are actually in a shooting pose, perform the block. This ignores pumpfakes
        -- because we require the ball-controller to have recent possession data.
        local success, lastPlayer = pcall(function()
            if BallController.GetLastPlayerToPossessBall then
                return BallController:GetLastPlayerToPossessBall()
            elseif BallController.GetLastPlayerToPossessBallName then
                return nil
            end
        end)

        if not success or not lastPlayer then
            return
        end

        -- Only consider blocking if the last possessor is an enemy (and not ourselves)
        if lastPlayer == Player or not IsEnemy(lastPlayer) then
            return
        end

        -- Validate that this enemy is near and roughly facing us within the block angle
        local enemyChar = lastPlayer.Character
        if not enemyChar then return end
        local enemyRoot = enemyChar:FindFirstChild("HumanoidRootPart")
        local enemyHumanoid = enemyChar:FindFirstChildOfClass("Humanoid")
        if not enemyRoot or not enemyHumanoid or enemyHumanoid.Health <= 0 then return end

        local distance = (HumanoidRootPart.Position - enemyRoot.Position).Magnitude
        if distance > AUTO_BLOCK_RANGE then return end

        local toMe = (HumanoidRootPart.Position - enemyRoot.Position)
        if toMe.Magnitude <= 0 then return end
        local toMeUnit = toMe.Unit
        local enemyLook = enemyRoot.CFrame.LookVector
        local dotProduct = enemyLook:Dot(toMeUnit)
        local angle = math.deg(math.acos(math.clamp(dotProduct, -1, 1)))
        if angle > BLOCK_ANGLE then return end

        -- Basic checks to ensure the enemy appears to be shooting (jumping or upward velocity)
        local isShooting = false
        if enemyHumanoid:GetState() == Enum.HumanoidStateType.Jumping then isShooting = true end
        local enemyVelocity = enemyRoot.AssemblyLinearVelocity
        if enemyVelocity.Y > 12 then isShooting = true end
        if enemyRoot.Position.Y > HumanoidRootPart.Position.Y + 6 then isShooting = true end

        if isShooting and shootEnabled then
            Jump()
        end
    end

    local function StartAutoBlock()
        if connectionAutoBlock then connectionAutoBlock:Disconnect() connectionAutoBlock = nil end
        connectionAutoBlock = RunService.Heartbeat:Connect(function()
            if not isEnabledAutoBlock then return end
            DetectShootingStance()
            local ball = Workspace:FindFirstChild("Basketball") or Workspace:FindFirstChild("Ball")
            if ball then DetectBallShots(ball) end
        end)
    end

    -- Reconnect handlers
    Player.CharacterAdded:Connect(function(newChar)
        Character = newChar
        Humanoid = newChar:WaitForChild("Humanoid")
        HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
        lastBallPosition = Vector3.new()
        lastBallVelocity = Vector3.new()
        ballAcceleration = Vector3.new()
        isBlocking = false
        task.wait(1)
        if isEnabledAutoBlock then StartAutoBlock() end
    end)

    Player:GetPropertyChangedSignal("Team"):Connect(function()
        task.wait(0.5)
        if Player.Team and isEnabledAutoBlock then StartAutoBlock() end
    end)

    -- API
    local module = {
        Enable = function()
            isEnabledAutoBlock = true
            StartAutoBlock()
        end,
        Disable = function()
            isEnabledAutoBlock = false
            if connectionAutoBlock then connectionAutoBlock:Disconnect() connectionAutoBlock = nil end
        end,
        SetRange = function(range) AUTO_BLOCK_RANGE = range end,
        SetAngle = function(angle) BLOCK_ANGLE = angle end,
        SetCooldown = function(cooldown) COOLDOWN = cooldown end,
        SetMode = function(shoots, passes)
            BlockShootsFlag = shoots
            BlockPassesFlag = passes
            shootEnabled = shoots
            passEnabled = passes
        end,
        GetStatus = function() return isEnabledAutoBlock end
    }

    getgenv().AutoBlock = module
end

-- =======================
-- INICIALIZAÇÃO PERFECT SHOT
-- =======================

local function initializePerfectShot()
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    

    
    setupFallbackSystem()
    setupSubtleCorrection()
end

-- Sistema de fallback direto para Perfect Shot (simplificado para evitar comportamento de parada)
-- Removido para manter comportamento natural do script original

-- =======================
-- INICIALIZAÇÃO E LOGS
-- =======================

-- Executar Perfect Shot
spawn(function()
    wait(3) -- Aguardar mais tempo para estabilizar
    local success, errorMsg = pcall(initializePerfectShot)
    if not success then

    end
end)


        end
    },
    [4282985734] = {
        name = "CombatWarriors",
        description = "Script for CombatWarriors",
        script = function()
            local PlaceID = 4282985734

if game.PlaceId ~= PlaceID then
    return
end

-- SCRIPT COMPLETO COM UI FUNCIONAL
-- Limpa execuções anteriores
if _G.ScriptCleanup then
    _G.ScriptCleanup()
    _G.ScriptCleanup = nil
    task.wait(0.1)
end

-- Limpar console
if game:GetService("LogService") then
    game:GetService("LogService"):ClearOutput()
end

-- Tratamento de funções de obfuscação
if not LPH_OBFUSCATED then    
    LPH_JIT_MAX        = function(...) return ... end
    LPH_NO_UPVALUES    = function(...) return ... end 
    LPH_NO_VIRTUALIZE  = function(...) return ... end 
    LPH_CRASH          = function(...) return ... end 
    LPH_ENCSTR         = function(...) return ... end 
end

-- Carrega a UI Library
local Decimals = 4
local Clock = os.clock()
local ValueText = "Value Is Now :"

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/isKuyo/UI/refs/heads/main/Source.lua"))({
    cheatname = "Wisper Hub", -- watermark text
    gamename = "Combat Warriors", -- watermark text
})

library:init()

-- Serviços
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Módulos necessários
local SoundHandler = require(ReplicatedStorage.Shared.Source.Sound.SoundHandler)
local WeaponMetadata = require(ReplicatedStorage.Shared.Source.Weapon.WeaponMetadata)
local MeleeWeaponClient = require(ReplicatedStorage.Client.Source.Melee.MeleeWeaponClient)
local RangedWeaponHandler = require(ReplicatedStorage.Shared.Source.Ranged.RangedWeaponHandler)

-- Tenta carregar módulo de utilidades
local UtilityMetadata = nil
pcall(function()
    UtilityMetadata = require(ReplicatedStorage.Shared.Source.Utility.UtilityMetadata)
end)

-- Tenta carregar módulos de armas
local WeaponIds = nil
local WeaponsInOrder = nil
pcall(function()
    WeaponIds = require(ReplicatedStorage.Shared.Source.Weapon.WeaponIds)
    WeaponsInOrder = require(ReplicatedStorage.Shared.Source.Weapon.WeaponsInOrder)
end)

-- Tenta carregar módulos opcionais
local RangedWeaponClient = nil
local ActiveCast = nil
local DefaultStaminaHandlerClient = nil

pcall(function()
    RangedWeaponClient = require(ReplicatedStorage.Client.Source.Ranged.RangedWeaponClient)
end)

pcall(function()
    ActiveCast = require(ReplicatedStorage.Shared.Vendor.FastCast.ActiveCast)
end)

pcall(function()
    DefaultStaminaHandlerClient = require(ReplicatedStorage.Client.Source.DefaultStamina.DefaultStaminaHandlerClient)
end)

-- Variáveis globais
local PlayerCharacters = Workspace:FindFirstChild("PlayerCharacters")
local R6BodyParts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

-- Estados das funcionalidades
local InfiniteStaminaEnabled = false
local AutoParryEnabled = false
local SilentAimEnabled = false
local NoDashCooldownEnabled = false
local NoJumpCooldownEnabled = false
local InfiniteAirEnabled = false
local WalkOnWaterEnabled = false
local WallbangEnabled = false
local NoUtilitiesTriggerEnabled = false
local NoNameTagEnabled = false
local NoLowHealthEffectEnabled = false
local NoKnockbackEnabled = false
local InstantUseUtilitiesEnabled = false
local InstantChargeEnabled = false
local NoGhostPotionEffectEnabled = false
local NoFallDamageEnabled = false
local NoFlashEffectEnabled = false
local CanAlwaysJumpEnabled = false
local NoReloadCancelEnabled = false

-- Variáveis de controle
local ParryingCharacters = {}
local GhostedCharacters = {}
local LastParryTime = 0
local ParryCooldown = 0.3
local cache = {}
local chanceCache = {}
local currentSilentAimTarget = nil
local oldCf = CFrame.new()
local oldCfCheck = false
local waterParts = {}
local Map = Workspace:FindFirstChild("Map")
local CollectionService = game:GetService("CollectionService")
local renderSteppedConnection = nil
local nameTagConnections = {}
local hiddenGuis = {}
local healthConnections = {}
local knockbackConnections = {}
local utilityCachedData = {}
local rangedWeaponsOriginal = {}
local originalAddInst = nil
local originalRemoveInst = nil
local fallDamageConnections = {}
local flashEffectConnections = {}
local originalFlashbangData = nil
local canAlwaysJumpConnection = nil
local noReloadCancelConnections = {}
local noReloadCancelOriginalFunctions = {}
local noReloadCancelHookedInstances = {}

-- Backup das funções originais
local OriginalPlaySound = SoundHandler.playSound
local OriginalCalculateFireDirection = RangedWeaponHandler.calculateFireDirection
local OriginalSimulateCast = nil
local OriginalSetStamina = nil
local OriginalGetStamina = nil
local OriginalSpendStamina = nil
local OriginalDashCooldown = nil
local OriginalJumpDelay = nil
local OriginalAirValue = nil
local OriginalUpdateIgnoreList = nil
local OriginalGetRealHealth = nil

-- Criação da janela
local Window = library.NewWindow({
    title = "Wisper Hub", -- Mainwindow Text
    size = UDim2.new(0, 580, 0.6, 6)
})

-- Criação da aba principal
local MainTab = Window:AddTab("  Main  ")

local SettingsTab = library:CreateSettingsTab(Window)

-- Sistema para acessar valores dos controles
local Options = {}
function Options.GetValue(flag)
    return library.flags[flag]
end

-- SISTEMA DE INFINITE STAMINA
local function SetupInfiniteStamina()
    if not DefaultStaminaHandlerClient then 
        warn("[Infinite Stamina] DefaultStaminaHandlerClient não encontrado!")
        return false
    end
    
    pcall(function()
        DefaultStaminaHandlerClient._initModule()
        local Stamina = DefaultStaminaHandlerClient.getDefaultStamina()
        
        if Stamina then
            -- Salvar funções originais
            OriginalSetStamina = Stamina.setStamina
            OriginalGetStamina = Stamina.getStamina
            OriginalSpendStamina = DefaultStaminaHandlerClient.spendStamina
            
            -- Substituir setStamina para ignorar redução
            Stamina.setStamina = function(self, value)
                if not InfiniteStaminaEnabled then
                    return OriginalSetStamina(self, value)
                end
                
                local Max = self:getMaxStamina()
                if value < self:getStamina() then
                    -- Ignora quando tentam diminuir stamina
                    return
                end
                -- Permite só aumentar stamina
                OriginalSetStamina(self, math.min(value, Max))
            end
            
            -- Substituir getStamina para sempre retornar máximo
            Stamina.getStamina = function(self)
                if not InfiniteStaminaEnabled then
                    return OriginalGetStamina(self)
                end
                return self:getMaxStamina()
            end
            
            -- Bloquear gasto direto pela interface
            DefaultStaminaHandlerClient.spendStamina = function(amount)
                if not InfiniteStaminaEnabled then
                    return OriginalSpendStamina(amount)
                end
                -- Ignora gasto
            end
            
            print("[Infinite Stamina] Sistema configurado com sucesso!")
            return true
        end
    end)
    
    return false
end

-- SISTEMA DE NO DASH COOLDOWN
local DashConstants = nil
pcall(function()
    DashConstants = require(ReplicatedStorage.Shared.Source.Dash.DashConstants)
end)

local function SetupNoDashCooldown()
    if not DashConstants then 
        return false
    end
    
    pcall(function()
        if DashConstants.DASH_COOLDOWN then
            OriginalDashCooldown = DashConstants.DASH_COOLDOWN
        end
    end)
    
    return true
end

local function EnableNoDashCooldown()
    if not DashConstants then return false end
    
    pcall(function()
        DashConstants.DASH_COOLDOWN = 0
    end)
    
    return true
end

local function DisableNoDashCooldown()
    if not DashConstants or not OriginalDashCooldown then return false end
    
    pcall(function()
        DashConstants.DASH_COOLDOWN = OriginalDashCooldown
    end)
    
    return true
end

-- SISTEMA DE NO JUMP COOLDOWN
local JumpConstants = nil
pcall(function()
    JumpConstants = require(ReplicatedStorage.Shared.Source.Jump.JumpConstants)
end)

local function SetupNoJumpCooldown()
    if not JumpConstants then 
        return false
    end
    
    pcall(function()
        if JumpConstants.JUMP_DELAY_ADD then
            OriginalJumpDelay = JumpConstants.JUMP_DELAY_ADD
        end
    end)
    
    return true
end

local function EnableNoJumpCooldown()
    if not JumpConstants then return false end
    
    pcall(function()
        JumpConstants.JUMP_DELAY_ADD = 0
    end)
    
    return true
end

local function DisableNoJumpCooldown()
    if not JumpConstants or not OriginalJumpDelay then return false end
    
    pcall(function()
        JumpConstants.JUMP_DELAY_ADD = OriginalJumpDelay
    end)
    
    return true
end

-- SISTEMA DE INFINITE AIR
local AirConstants = nil
pcall(function()
    AirConstants = require(ReplicatedStorage.Shared.Source.Air.AirConstants)
end)

local function SetupInfiniteAir()
    if not AirConstants then 
        return false
    end
    
    pcall(function()
        if AirConstants.AIR_TO_ADD_PER_SECOND_WHILE_SWIMMING then
            OriginalAirValue = AirConstants.AIR_TO_ADD_PER_SECOND_WHILE_SWIMMING
        end
    end)
    
    return true
end

local function EnableInfiniteAir()
    if not AirConstants then return false end
    
    pcall(function()
        AirConstants.AIR_TO_ADD_PER_SECOND_WHILE_SWIMMING = 0
    end)
    
    return true
end

local function DisableInfiniteAir()
    if not AirConstants or not OriginalAirValue then return false end
    
    pcall(function()
        AirConstants.AIR_TO_ADD_PER_SECOND_WHILE_SWIMMING = OriginalAirValue
    end)
    
    return true
end

-- SISTEMA DE WALK ON WATER
local function FindWaterParts()
    waterParts = {}
    local currentMap = Workspace:FindFirstChild("Map")
    if currentMap then
        pcall(function()
            for i, v in pairs(currentMap:GetDescendants()) do
                if v:IsA("BasePart") and v.Name == "WaterArea" then
                    table.insert(waterParts, v)
                end
            end
        end)
    end
end

local function EnableWalkOnWater()
    pcall(function()
        FindWaterParts()
        
        for _, waterPart in pairs(waterParts) do
            if waterPart and waterPart.Parent then
                waterPart.CanCollide = true
            end
        end
    end)
    
    return true
end

local function DisableWalkOnWater()
    pcall(function()
        for _, waterPart in pairs(waterParts) do
            if waterPart and waterPart.Parent then
                waterPart.CanCollide = false
            end
        end
    end)
    
    return true
end

local function HandleMapChange()
    pcall(function()
        local currentMap = Workspace:FindFirstChild("Map")
        if currentMap then
            currentMap.ChildAdded:Connect(function()
                if WalkOnWaterEnabled then
                    task.wait(2)
                    FindWaterParts()
                    if #waterParts > 0 then
                        for _, waterPart in pairs(waterParts) do
                            if waterPart and waterPart.Parent then
                                waterPart.CanCollide = true
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- SISTEMA DE NO UTILITIES TRIGGER
local function EnableNoUtilitiesTrigger()
    if renderSteppedConnection then return false end
    
    pcall(function()
        renderSteppedConnection = RunService.RenderStepped:Connect(function()
            local Character = LocalPlayer.Character
            if Character then
                if not Character:FindFirstChild("ff") then
                    local force = Instance.new("ForceField", Character)
                    force.Visible = false
                    force.Name = "ff"
                end
            end
        end)
    end)
    
    return true
end

local function DisableNoUtilitiesTrigger()
    pcall(function()
        if renderSteppedConnection then
            renderSteppedConnection:Disconnect()
            renderSteppedConnection = nil
        end
        
        -- Remove existing forcefield
        local Character = LocalPlayer.Character
        if Character and Character:FindFirstChild("ff") then
            Character.ff:Destroy()
        end
    end)
    
    return true
end

local function HandleCharacterRespawn()
    LocalPlayer.CharacterAdded:Connect(function(character)
        if NoUtilitiesTriggerEnabled then
            task.wait(0.1)
            pcall(function()
                if character and not character:FindFirstChild("ff") then
                    local force = Instance.new("ForceField", character)
                    force.Visible = false
                    force.Name = "ff"
                end
            end)
        end
    end)
end

-- SISTEMA DE NO NAME TAG
local function HideNameTag(character)
    if not character then return end
    
    pcall(function()
        local head = character:FindFirstChild("Head")
        if head then
            -- Hide existing BillboardGuis
            for _, gui in pairs(head:GetChildren()) do
                if gui:IsA("BillboardGui") then
                    if not hiddenGuis[gui] then
                        hiddenGuis[gui] = gui.Enabled
                        gui.Enabled = false
                    end
                end
            end
        end
    end)
end

local function ShowNameTag(character)
    if not character then return end
    
    pcall(function()
        local head = character:FindFirstChild("Head")
        if head then
            -- Restore BillboardGuis
            for gui, originalState in pairs(hiddenGuis) do
                if gui.Parent == head then
                    gui.Enabled = originalState
                end
            end
            hiddenGuis = {}
        end
    end)
end

local function EnableNoNameTag()
    if #nameTagConnections > 0 then return false end
    
    pcall(function()
        -- Hide current name tag
        if LocalPlayer.Character then
            HideNameTag(LocalPlayer.Character)
        end
        
        -- Handle future character spawns
        nameTagConnections.characterAdded = LocalPlayer.CharacterAdded:Connect(function(character)
            task.wait(0.1) -- Wait for nametag to load
            HideNameTag(character)
        end)
        
        -- Monitor for new BillboardGuis being added
        nameTagConnections.renderStepped = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                HideNameTag(LocalPlayer.Character)
            end
        end)
    end)
    
    return true
end

local function DisableNoNameTag()
    pcall(function()
        -- Disconnect all connections
        for _, connection in pairs(nameTagConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        nameTagConnections = {}
        
        -- Show name tag again
        if LocalPlayer.Character then
            ShowNameTag(LocalPlayer.Character)
        end
    end)
    
    return true
end

-- SISTEMA DE NO LOW HEALTH EFFECT
local function GetHealthHandler()
    local success, result = pcall(function()
        return require(ReplicatedStorage.Shared.Source.Health.HealthHandler)
    end)
    
    if success and result then
        return result
    end
    
    -- Fallback: try Nevermore lookup
    success, result = pcall(function()
        local Nevermore = require(ReplicatedStorage.Framework.Nevermore)
        local _lookupTable = rawget(Nevermore, "_lookupTable")
        
        for i,v in _lookupTable do
            if i:find("HealthHandler") then
                return require(v)
            end
        end
    end)
    
    return success and result or nil
end

local function EnableNoLowHealthEffect()
    if #healthConnections > 0 then return false end
    
    pcall(function()
        local HealthHandler = GetHealthHandler()
        
        -- Hook the health handler to return a high value
        if HealthHandler and HealthHandler.getRealHealth then
            OriginalGetRealHealth = HealthHandler.getRealHealth
            HealthHandler.getRealHealth = function(...)
                return 115 -- Always return max health to prevent low health effects
            end
        else
            -- Alternative approach: monitor for low health effects
            healthConnections.heartbeat = RunService.Heartbeat:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health <= 25 then
                        -- Try to remove low health screen effects
                        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                        if playerGui then
                            for _, gui in pairs(playerGui:GetChildren()) do
                                if gui:IsA("ScreenGui") then
                                    -- Look for low health effect GUIs and hide them
                                    for _, frame in pairs(gui:GetDescendants()) do
                                        if frame:IsA("Frame") and (frame.Name:find("Health") or frame.Name:find("Damage") or frame.Name:find("Blood")) then
                                            frame.Visible = false
                                        elseif frame:IsA("ImageLabel") and frame.ImageColor3 == Color3.new(1, 0, 0) then
                                            frame.Visible = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
    
    return true
end

local function DisableNoLowHealthEffect()
    pcall(function()
        local HealthHandler = GetHealthHandler()
        
        -- Restore original health function
        if OriginalGetRealHealth and HealthHandler then
            HealthHandler.getRealHealth = OriginalGetRealHealth
        end
        
        -- Disconnect monitoring connections
        for _, connection in pairs(healthConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        healthConnections = {}
    end)
    
    return true
end

-- SISTEMA DE NO KNOCKBACK
local function PreventKnockback()
    if not LocalPlayer.Character then return end
    
    pcall(function()
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Monitor for sudden velocity changes that indicate knockback
            local currentVelocity = humanoidRootPart.Velocity
            
            -- If velocity is abnormally high, reset it
            if currentVelocity.Magnitude > 50 then
                humanoidRootPart.Velocity = Vector3.new(0, currentVelocity.Y > 0 and currentVelocity.Y or 0, 0)
            end
            
            -- Also check for BodyVelocity or similar objects that might cause knockback
            for _, child in pairs(humanoidRootPart:GetChildren()) do
                if child:IsA("BodyVelocity") or child:IsA("BodyPosition") or child:IsA("BodyThrust") then
                    if child.Name:find("Knockback") or child.Name:find("Push") then
                        child:Destroy()
                    end
                end
            end
        end
    end)
end

local function EnableNoKnockback()
    if #knockbackConnections > 0 then return false end
    
    pcall(function()
        -- Monitor for knockback effects
        knockbackConnections.renderStepped = RunService.RenderStepped:Connect(PreventKnockback)
        
        -- Handle character respawns
        knockbackConnections.characterAdded = LocalPlayer.CharacterAdded:Connect(function(character)
            task.wait(0.1)
            -- Reset connection for new character
            if knockbackConnections.renderStepped then
                knockbackConnections.renderStepped:Disconnect()
            end
            knockbackConnections.renderStepped = RunService.RenderStepped:Connect(PreventKnockback)
        end)
    end)
    
    return true
end

local function DisableNoKnockback()
    pcall(function()
        -- Disconnect all connections
        for _, connection in pairs(knockbackConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        knockbackConnections = {}
    end)
    
    return true
end

-- SISTEMA DE NO GHOST POTION EFFECT
local function GetInstancePropsHandler()
    local success, result = pcall(function()
        return require(ReplicatedStorage.Shared.Source.Instance.InstancePropsHandler)
    end)
    
    if success and result then
        return result
    end
    
    -- Fallback: try Nevermore lookup
    success, result = pcall(function()
        local Nevermore = require(ReplicatedStorage.Framework.Nevermore)
        local _lookupTable = rawget(Nevermore, "_lookupTable")
        
        for i,v in _lookupTable do
            if i:find("InstancePropsHandler") then
                return require(v)
            end
        end
    end)
    
    return success and result or nil
end

local function EnableNoGhostPotionEffect()
    pcall(function()
        local InstancePropsHandler = GetInstancePropsHandler()
        
        -- Hook the instance props handler to block ghost potion effects
        if InstancePropsHandler then
            if InstancePropsHandler.add then
                originalAddInst = InstancePropsHandler.add
                InstancePropsHandler.add = function(a, b, c, ...)
                    -- Block ghost potion effects on other players, but not on local player
                    if a ~= LocalPlayer.Character and c == "GHOST_POTION" then
                        return
                    end
                    return originalAddInst(a, b, c, ...)
                end
            end
            
            if InstancePropsHandler.remove then
                originalRemoveInst = InstancePropsHandler.remove
                InstancePropsHandler.remove = function(a, b, ...)
                    return originalRemoveInst(a, b, ...)
                end
            end
        end
    end)
    
    return true
end

local function DisableNoGhostPotionEffect()
    pcall(function()
        local InstancePropsHandler = GetInstancePropsHandler()
        
        -- Restore original functions
        if originalAddInst and InstancePropsHandler then
            InstancePropsHandler.add = originalAddInst
            originalAddInst = nil
        end
        
        if originalRemoveInst and InstancePropsHandler then
            InstancePropsHandler.remove = originalRemoveInst
            originalRemoveInst = nil
        end
    end)
    
    return true
end

-- SISTEMA DE NO FALL DAMAGE
local function GetSessionData()
    local success, result = pcall(function()
        -- Try direct access first
        local DataHandler = require(ReplicatedStorage.Shared.Source.Data.DataHandler)
        return DataHandler.getSessionDataRoduxStoreForPlayer(LocalPlayer)
    end)
    
    if success and result then
        return result
    end
    
    -- Fallback: try Nevermore lookup
    success, result = pcall(function()
        local Nevermore = require(ReplicatedStorage.Framework.Nevermore)
        local _lookupTable = rawget(Nevermore, "_lookupTable")
        
        for i,v in _lookupTable do
            if i:find("DataHandler") then
                local DataHandler = require(v)
                return DataHandler.getSessionDataRoduxStoreForPlayer(LocalPlayer)
            end
        end
    end)
    
    return success and result or nil
end

local function EnableNoFallDamage()
    pcall(function()
        local sessionData = GetSessionData()
        if sessionData then
            sessionData:getState().fallDamageClient.isDisabled = true
        else
            -- Alternative approach: monitor for fall damage and prevent it
            fallDamageConnections.heartbeat = RunService.Heartbeat:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if humanoid and rootPart then
                        -- Monitor velocity to detect potential fall damage
                        if rootPart.Velocity.Y < -50 then
                            -- Reduce velocity before hitting ground
                            local bodyVelocity = rootPart:FindFirstChild("NoFallDamageVel")
                            if not bodyVelocity then
                                bodyVelocity = Instance.new("BodyVelocity")
                                bodyVelocity.Name = "NoFallDamageVel"
                                bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                                bodyVelocity.Velocity = Vector3.new(0, -10, 0)
                                bodyVelocity.Parent = rootPart
                                
                                -- Remove after short time
                                task.delay(0.1, function()
                                    if bodyVelocity and bodyVelocity.Parent then
                                        bodyVelocity:Destroy()
                                    end
                                end)
                            end
                        end
                    end
                end
            end)
        end
        
        -- Handle character respawns
        fallDamageConnections.characterAdded = LocalPlayer.CharacterAdded:Connect(function()
            if NoFallDamageEnabled then
                task.wait(1) -- Wait for session data to load
                local sessionData = GetSessionData()
                if sessionData then
                    sessionData:getState().fallDamageClient.isDisabled = true
                end
            end
        end)
    end)
    
    return true
end

local function DisableNoFallDamage()
    pcall(function()
        local sessionData = GetSessionData()
        if sessionData then
            sessionData:getState().fallDamageClient.isDisabled = false
        end
        
        -- Disconnect monitoring connections
        for _, connection in pairs(fallDamageConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        fallDamageConnections = {}
    end)
    
    return true
end

-- SISTEMA DE NO FLASH EFFECT
local function GetFlashbangModule()
    local success, result = pcall(function()
        return require(ReplicatedStorage.Shared.Source.Utility.UtilityMetadata.Metadata.Flashbang)
    end)
    return success and result or nil
end

local function EnableNoFlashEffect()
    pcall(function()
        local flashbangModule = GetFlashbangModule()
        
        if flashbangModule then
            local flashbangData = flashbangModule()
            
            -- Store original values
            originalFlashbangData = {
                duration = flashbangData.duration,
                explosionRadius = flashbangData.explosionRadius
            }
            
            -- Disable flash effect by setting duration to 0
            flashbangData.duration = 0
            flashbangData.explosionRadius = 0
        else
            -- Fallback: Monitor for flash effects and remove them
            flashEffectConnections.heartbeat = RunService.Heartbeat:Connect(function()
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    -- Look for flash effect GUIs and remove them
                    for _, gui in pairs(playerGui:GetChildren()) do
                        if gui:IsA("ScreenGui") then
                            for _, frame in pairs(gui:GetDescendants()) do
                                -- Remove white/bright flash effects
                                if frame:IsA("Frame") and (frame.BackgroundColor3 == Color3.new(1, 1, 1) and frame.BackgroundTransparency < 0.5) then
                                    frame:Destroy()
                                elseif frame:IsA("ImageLabel") and (frame.Image:find("flash") or frame.Image:find("Flash")) then
                                    frame:Destroy()
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
    
    return true
end

local function DisableNoFlashEffect()
    pcall(function()
        local flashbangModule = GetFlashbangModule()
        
        if flashbangModule and originalFlashbangData then
            local flashbangData = flashbangModule()
            
            -- Restore original values
            flashbangData.duration = originalFlashbangData.duration
            flashbangData.explosionRadius = originalFlashbangData.explosionRadius
            
            originalFlashbangData = nil
        end
        
        -- Disconnect monitoring connections
        for _, connection in pairs(flashEffectConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        flashEffectConnections = {}
    end)
    
    return true
end

-- SISTEMA DE CAN ALWAYS JUMP
local function EnableCanAlwaysJump()
    if canAlwaysJumpConnection then return false end
    
    pcall(function()
        canAlwaysJumpConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.KeyCode == Enum.KeyCode.Space and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Force jump regardless of current state
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end)
    
    return true
end

local function DisableCanAlwaysJump()
    pcall(function()
        if canAlwaysJumpConnection then
            canAlwaysJumpConnection:Disconnect()
            canAlwaysJumpConnection = nil
        end
    end)
    
    return true
end

-- SISTEMA DE NO RELOAD CANCEL
local function getRangedWeaponClientForReload()
    local success, result = pcall(function()
        return require(ReplicatedStorage.Client.Source.Ranged.RangedWeaponClient)
    end)
    
    if success then
        return result
    end
    
    -- Fallback: tentar encontrar através do framework
    success, result = pcall(function()
        local Nevermore = require(ReplicatedStorage.Framework.Nevermore)
        local _lookupTable = rawget(Nevermore, "_lookupTable")
        
        for i,v in _lookupTable do
            if i:find("RangedWeaponClient") then
                return require(v)
            end
        end
    end)
    
    return success and result or nil
end

local function hookCancelMethodsForReload(instance)
    if not instance or noReloadCancelHookedInstances[instance] then return end
    
    noReloadCancelHookedInstances[instance] = true
    
    -- Hook cancelReload
    if instance.cancelReload then
        noReloadCancelOriginalFunctions[instance] = noReloadCancelOriginalFunctions[instance] or {}
        noReloadCancelOriginalFunctions[instance].cancelReload = instance.cancelReload
        
        instance.cancelReload = function(self, ...)
            -- Bloquear cancelamento de reload
            return
        end
    end
    
    -- Hook resetReload se existir (mais permissivo)
    if instance.resetReload then
        noReloadCancelOriginalFunctions[instance] = noReloadCancelOriginalFunctions[instance] or {}
        noReloadCancelOriginalFunctions[instance].resetReload = instance.resetReload
        
        instance.resetReload = function(self, ...)
            -- Sempre permitir resetReload para não quebrar o sistema
            return noReloadCancelOriginalFunctions[instance].resetReload(self, ...)
        end
    end
end

local function monitorRangedWeaponsForReload()
    local function checkForRangedWeapons()
        local character = LocalPlayer.Character
        if not character then return end
        
        local tool = character:FindFirstChildOfClass("Tool")
        if not tool then return end
        
        local itemType = tool:GetAttribute("ItemType")
        if itemType ~= "weapon" then return end
        
        local itemId = tool:GetAttribute("ItemId")
        if not itemId then return end
        
        -- Verificar se é arma ranged
        local isRanged = false
        for _, weaponData in pairs(require(ReplicatedStorage.Shared.Source.Weapon.WeaponsInOrder)) do
            if weaponData.id == itemId and weaponData.class == "ranged" then
                isRanged = true
                break
            end
        end
        
        if isRanged then
            -- Procurar por instâncias do RangedWeaponClient
            local RangedWeaponClient = getRangedWeaponClientForReload()
            if RangedWeaponClient and RangedWeaponClient.getObj then
                local weaponInstance = RangedWeaponClient.getObj(tool)
                if weaponInstance then
                    hookCancelMethodsForReload(weaponInstance)
                end
            end
        end
    end
    
    -- Verificar quando uma ferramenta é equipada
    noReloadCancelConnections.toolEquipped = LocalPlayer.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        noReloadCancelConnections.toolEquipped = humanoid.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                task.wait(0.1) -- Aguardar um pouco para a arma ser configurada
                checkForRangedWeapons()
            end
        end)
    end)
    
    -- Verificar periodicamente
    noReloadCancelConnections.periodicCheck = RunService.Heartbeat:Connect(function()
        checkForRangedWeapons()
    end)
end

local function blockReloadCancelingInputs()
    noReloadCancelConnections.inputBlock = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local tool = character:FindFirstChildOfClass("Tool")
        if not tool then return end
        
        local itemType = tool:GetAttribute("ItemType")
        if itemType ~= "weapon" then return end
        
        local itemId = tool:GetAttribute("ItemId")
        if not itemId then return end
        
        -- Verificar se é arma ranged
        local isRanged = false
        for _, weaponData in pairs(require(ReplicatedStorage.Shared.Source.Weapon.WeaponsInOrder)) do
            if weaponData.id == itemId and weaponData.class == "ranged" then
                isRanged = true
                break
            end
        end
        
        if not isRanged then return end
        
        -- Verificar se está em reload
        local isReloading = tool:GetAttribute("IsReloading")
        if not isReloading then return end
        
        -- Bloquear apenas troca de arma durante reload
        if input.KeyCode == Enum.KeyCode.Q then
            -- Bloquear troca de arma durante reload
            return
        end
    end)
end

local function hookDamageEventsForReload()
    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid")
        
        -- Hook para quando o personagem morre
        noReloadCancelConnections.healthChanged = humanoid.HealthChanged:Connect(function(health)
            if health <= 0 then
                -- Não fazer nada, deixar o reload continuar
                return
            end
        end)
    end
    
    if LocalPlayer.Character then
        onCharacterAdded(LocalPlayer.Character)
    end
    
    noReloadCancelConnections.characterAdded = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
end

local function EnableNoReloadCancel()
    if NoReloadCancelEnabled then return false end
    
    pcall(function()
        print("No Reload Cancel: HABILITANDO...")
        
        -- Monitorar armas ranged
        monitorRangedWeaponsForReload()
        
        -- Bloquear inputs
        blockReloadCancelingInputs()
        
        -- Hook eventos de dano
        hookDamageEventsForReload()
        
        NoReloadCancelEnabled = true
        print("No Reload Cancel: HABILITADO - Reload não será cancelado!")
    end)
    
    return true
end

local function DisableNoReloadCancel()
    if not NoReloadCancelEnabled then return false end
    
    pcall(function()
        print("No Reload Cancel: DESABILITANDO...")
        
        -- Restaurar funções originais
        for instance, funcs in pairs(noReloadCancelOriginalFunctions) do
            if instance and funcs then
                for methodName, originalFunc in pairs(funcs) do
                    if instance[methodName] then
                        instance[methodName] = originalFunc
                    end
                end
            end
        end
        noReloadCancelOriginalFunctions = {}
        
        -- Desconectar conexões
        for _, connection in pairs(noReloadCancelConnections) do
            if connection and connection.Disconnect then
                connection:Disconnect()
            end
        end
        noReloadCancelConnections = {}
        noReloadCancelHookedInstances = {}
        
        NoReloadCancelEnabled = false
        print("No Reload Cancel: DESABILITADO")
    end)
    
    return true
end

-- SISTEMA DE INSTANT USE UTILITIES
local function EnableInstantUseUtilities()
    if not UtilityMetadata then return false end
    
    pcall(function()
        for i, v in UtilityMetadata do
            if v.displayName ~= "Medkit" then
                -- Cache original values
                utilityCachedData[i] = {
                    cacheDur = v.preThrowDuration or 0.001,
                    cacheTime = v.useTime or 0
                }
                
                -- Set to instant
                v.preThrowDuration = 0.001
                v.useTime = 0
            end
        end
    end)
    
    return true
end

local function DisableInstantUseUtilities()
    if not UtilityMetadata then return false end
    
    pcall(function()
        for i, v in UtilityMetadata do
            if v.displayName ~= "Medkit" and utilityCachedData[i] then
                -- Restore original values
                v.preThrowDuration = utilityCachedData[i].cacheDur
                v.useTime = utilityCachedData[i].cacheTime
            end
        end
    end)
    
    return true
end

-- SISTEMA DE INSTANT CHARGE
local function SetupInstantCharge()
    if not WeaponIds or not WeaponsInOrder then return false end
    
    pcall(function()
        -- Get ranged weapons using direct module access
        local weaponOrder = {}
        local ranged = {}
        
        for i, v in pairs(WeaponsInOrder) do
            weaponOrder[v.id] = v
        end
        
        for weaponName, weaponId in pairs(WeaponIds) do
            if weaponOrder[weaponId] and weaponOrder[weaponId].class == "ranged" then
                table.insert(ranged, weaponName)
            end
        end
        
        -- Store original values
        for i, weaponName in pairs(ranged) do
            local weaponId = WeaponIds[weaponName]
            local metadata = WeaponMetadata[weaponId]
            if metadata then
                rangedWeaponsOriginal[weaponName] = {
                    chargeOnDuration = metadata.chargeOnDuration,
                    chargeOffDuration = metadata.chargeOffDuration
                }
            end
        end
    end)
    
    return true
end

local function ModifyRangedCharge(chargeOnDuration, chargeOffDuration)
    if not WeaponIds or not WeaponsInOrder then return false end
    
    pcall(function()
        local weaponOrder = {}
        local ranged = {}
        
        for i, v in pairs(WeaponsInOrder) do
            weaponOrder[v.id] = v
        end
        
        for weaponName, weaponId in pairs(WeaponIds) do
            if weaponOrder[weaponId] and weaponOrder[weaponId].class == "ranged" then
                table.insert(ranged, weaponName)
            end
        end
        
        for i, weaponName in pairs(ranged) do
            local weaponId = WeaponIds[weaponName]
            local metadata = WeaponMetadata[weaponId]
            if metadata then
                if metadata.chargeOnDuration then
                    metadata.chargeOnDuration = chargeOnDuration
                end
                if metadata.chargeOffDuration then
                    metadata.chargeOffDuration = chargeOffDuration
                end
            end
        end
    end)
    
    return true
end

local function EnableInstantCharge()
    if not SetupInstantCharge() then return false end
    
    return ModifyRangedCharge(0.01, 0.01)
end

local function DisableInstantCharge()
    pcall(function()
        -- Restore original values
        for weaponName, originalValues in pairs(rangedWeaponsOriginal) do
            local weaponId = WeaponIds[weaponName]
            local metadata = WeaponMetadata[weaponId]
            if metadata then
                if originalValues.chargeOnDuration then
                    metadata.chargeOnDuration = originalValues.chargeOnDuration
                end
                if originalValues.chargeOffDuration then
                    metadata.chargeOffDuration = originalValues.chargeOffDuration
                end
            end
        end
    end)
    
    return true
end

-- SISTEMA DE WALLBANG
local function SetupWallbang()
    if not RangedWeaponClient then 
        return false
    end
    
    pcall(function()
        if RangedWeaponClient.updateIgnoreList then
            OriginalUpdateIgnoreList = RangedWeaponClient.updateIgnoreList
        end
    end)
    
    return OriginalUpdateIgnoreList ~= nil
end

local function EnableWallbang()
    if not RangedWeaponClient or not OriginalUpdateIgnoreList then return false end
    
    pcall(function()
        RangedWeaponClient.updateIgnoreList = function(rangedData)
            if tick() - rangedData._lastIgnoreListUpdateTick < 5 then
                return rangedData._ignoreList
            end

            rangedData._lastIgnoreListUpdateTick = tick()
            local character = rangedData._character
            local tagged = CollectionService:GetTagged("RANGED_CASTER_IGNORE_LIST")

            table.insert(tagged, character)

            -- Add Map and Terrain to ignore list for wallbang
            local currentMap = Workspace:FindFirstChild("Map")
            if currentMap then
                table.insert(tagged, currentMap)
            end
            table.insert(tagged, Workspace.Terrain)

            rangedData._ignoreList = tagged
            return tagged
        end
    end)
    
    return true
end

local function DisableWallbang()
    if not RangedWeaponClient or not OriginalUpdateIgnoreList then return false end
    
    pcall(function()
        RangedWeaponClient.updateIgnoreList = OriginalUpdateIgnoreList
    end)
    
    return true
end

-- FRAMEWORK PARA AUTO PARRY E SILENT AIM
local Framework = {}

function Framework:GetLocalCharacter()
    return LocalPlayer.Character
end

function Framework:GetWeapon(Character)
    Character = Character or self:GetLocalCharacter()
    if not Character then return nil, nil end

    for _, tool in pairs(Character:GetChildren()) do
        if tool:IsA("Tool") and tool:GetAttribute("ItemType") == "weapon" and tool:GetAttribute("ItemId") then
            local weaponId = tool:GetAttribute("ItemId")
            local metadata = WeaponMetadata[weaponId]
            
            if metadata and metadata.class and metadata.class:lower():find("melee") then
                local weaponClient = MeleeWeaponClient.getObj(tool)
                return tool, weaponClient
            end
        end
    end
    return nil, nil
end

function Framework:GetRanged(Player)
    local Player = Player or LocalPlayer
    local Character = Player.Character
    if not Character then return nil, nil end

    for i, v in pairs(Character:GetChildren()) do
        if not v:IsA("Tool") then continue end
        if v:GetAttribute("ItemType") == "weapon" and v:GetAttribute("ItemId") then
            local weaponId = v:GetAttribute("ItemId")
            local metadata = WeaponMetadata[weaponId]
            
            if metadata and metadata.class and metadata.class:lower():find("ranged") then
                local weaponClient = nil
                if RangedWeaponClient then
                    pcall(function()
                        weaponClient = RangedWeaponClient.getObj(v)
                    end)
                end
                return v, weaponClient, metadata
            end
        end
    end
    return nil, nil, nil
end

function Framework:IsPartClose(part, maxDistance)
    local character = self:GetLocalCharacter()
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    if part and part:IsA('BasePart') then
        local distance = (part.Position - humanoidRootPart.Position).Magnitude
        return distance <= maxDistance
    end
    return false
end

function Framework:CheckDirection(enemyCharacter, localCharacter, maxAngle)
    local enemyRoot = enemyCharacter:FindFirstChild("HumanoidRootPart")
    local localRoot = localCharacter:FindFirstChild("HumanoidRootPart")
    
    if not enemyRoot or not localRoot then 
        return false 
    end
    
    local enemyPosition = enemyRoot.Position
    local localPosition = localRoot.Position
    local directionToLocal = (localPosition - enemyPosition).Unit
    local enemyLookDirection = enemyRoot.CFrame.LookVector
    local dotProduct = enemyLookDirection:Dot(directionToLocal)
    local clampedDot = math.clamp(dotProduct, -1, 1)
    local angle = math.deg(math.acos(clampedDot))
    
    return angle <= maxAngle
end

function Framework:GetCharacterFromHitbox(hitbox)
    local current = hitbox
    for i = 1, 15 do
        if not current or not current.Parent then break end
        current = current.Parent
        
        if current:IsA("Model") then
            local humanoid = current:FindFirstChildOfClass("Humanoid")
            if humanoid then
                return current
            end
        end
    end
    return nil
end

function Framework:IsGhosted(character)
    if table.find(GhostedCharacters, character) then
        return true
    end
    
    for _, child in pairs(character:GetChildren()) do
        if child:GetAttribute("ParryShieldId") then
            for _, part in pairs(child:GetChildren()) do
                if part:IsA("BasePart") and part.Transparency < 0.9 then
                    return true
                end
            end
        end
    end
    
    return false
end

function Framework:Chance(percentage)
    return math.random(1, 100) <= percentage
end

function Framework:InMenu(Player)
    local IsMenu = true
    if not Player.Character then 
        return IsMenu 
    end
    for i, v in pairs(Player.Character:GetChildren()) do
        if v:GetAttribute("ParryShieldId") then
            IsMenu = false
        end
    end
    return IsMenu
end

function Framework:GetClosestToMouse(Distance)
    local Distance = Distance or math.huge
    local TargetPlayer = nil
    local MousePosition = UserInputService:GetMouseLocation()

    for i, v in pairs(Players:GetPlayers()) do
        if v == LocalPlayer then continue end
        if Options.GetValue("WhitelistFriends") and LocalPlayer:IsFriendsWith(v.UserId) then continue end
        if not (v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0) then continue end
        if Framework:InMenu(v) then continue end

        local HRP = v.Character.HumanoidRootPart
        local vector, onScreen = Camera:WorldToScreenPoint(HRP.Position)
        
        if onScreen then
            local Magnitude = (MousePosition - Vector2.new(vector.X, vector.Y)).Magnitude
            if Magnitude < Distance then
                Distance = Magnitude
                TargetPlayer = v
            end
        end
    end

    return TargetPlayer
end

-- SISTEMA DE AUTO PARRY
local function CanParry(targetCharacter)
    if not AutoParryEnabled then return false end
    if not targetCharacter then return false end
    if targetCharacter == LocalPlayer.Character then return false end
    if table.find(ParryingCharacters, targetCharacter) then return false end
    if Framework:IsGhosted(targetCharacter) then return false end
    if tick() - LastParryTime < Options.GetValue("ParryCooldown") then return false end
    
    local player = Players:GetPlayerFromCharacter(targetCharacter)
    if Options.GetValue("WhitelistFriends") and player and LocalPlayer:IsFriendsWith(player.UserId) then
        return false
    end
    
    if Options.GetValue("OnlyWhenEquipped") then
        local weapon, _ = Framework:GetWeapon()
        if not weapon then return false end
    end
    
    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return false end
    if not Framework:IsPartClose(targetRoot, Options.GetValue("MaxRange")) then return false end
    
    local localCharacter = Framework:GetLocalCharacter()
    if not localCharacter then return false end
    
    if Options.GetValue("DirectionCheck") and not Framework:CheckDirection(targetCharacter, localCharacter, Options.GetValue("MaxAngle")) then
        return false
    end
    
    if not Framework:Chance(Options.GetValue("Chance")) then return false end
    
    return true
end

local function ExecuteParry()
    local weapon, metadata = Framework:GetWeapon()
    if not weapon or not metadata then return false end
    
    task.spawn(function()
        local success, error = pcall(function()
            MeleeWeaponClient.parry(metadata)
        end)
        
        if success then
            LastParryTime = tick()
        else
            warn("[AutoParry] Erro ao executar parry:", error)
        end
    end)
    
    return true
end

local function SoundHook(soundData)
    if not soundData or type(soundData) ~= "table" then
        return OriginalPlaySound(soundData)
    end
    
    local soundObject = soundData.soundObject
    local parent = soundData.parent
    
    if not soundObject or not parent then
        return OriginalPlaySound(soundData)
    end
    
    local parentName = "unknown"
    if parent and typeof(parent) == "Instance" and parent.Name then
        parentName = parent.Name
    end
    
    local isHitboxSound = parentName:lower():find("hitbox") ~= nil
    
    if isHitboxSound then
        local targetCharacter = Framework:GetCharacterFromHitbox(parent)
        
        if CanParry(targetCharacter) then
            ExecuteParry()
            
            if targetCharacter then
                table.insert(ParryingCharacters, targetCharacter)
                task.delay(1.5, function()
                    local index = table.find(ParryingCharacters, targetCharacter)
                    if index then
                        table.remove(ParryingCharacters, index)
                    end
                end)
            end
        end
    end
    
    if soundObject.Name == "Parry" then
        local character = Framework:GetCharacterFromHitbox(parent)
        if character then
            table.insert(GhostedCharacters, character)
            table.insert(ParryingCharacters, character)
            
            task.delay(0.8, function()
                local ghostIndex = table.find(GhostedCharacters, character)
                if ghostIndex then
                    table.remove(GhostedCharacters, ghostIndex)
                end
                
                local parryIndex = table.find(ParryingCharacters, character)
                if parryIndex then
                    table.remove(ParryingCharacters, parryIndex)
                end
            end)
        end
    end
    
    return OriginalPlaySound(soundData)
end

-- SISTEMA DE SILENT AIM
local SilentAimHighlight = Instance.new("Highlight", workspace.Terrain)
SilentAimHighlight.FillColor = Color3.new(1, 1, 1)

local function ShowInformation(target)
    if Options.GetValue("ShowTargetSA") and target then
        SilentAimHighlight.Adornee = target.Character
    else
        SilentAimHighlight.Adornee = nil
    end
end

local function InitializeSilentAim()
    -- Hook do FastCast
    if ActiveCast then
        pcall(function()
            OriginalSimulateCast = getupvalue(ActiveCast.new, 6)
            
            local function newSimulateCast(...)
                local args = {...}
                local caster = args[1]
                
                if not caster then
                    return OriginalSimulateCast(...)
                end

                local weapon, weaponClient, metadata = Framework:GetRanged()
                
                local Chance = Framework:Chance(Options.GetValue("HitChance"))
                if not Chance then
                    table.insert(chanceCache, caster)
                end

                -- Evitar projéteis
                if Options.GetValue("AvoidProjectiles") and caster and caster.UserData and caster.UserData.tool ~= weapon then
                    local pos = caster:GetPosition()
                    local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                    if rootPart and (rootPart.Position - pos).Magnitude <= 50 then
                        if not oldCfCheck then
                            oldCf = rootPart.CFrame
                        end
                        
                        task.spawn(function()
                            oldCfCheck = true
                            rootPart.CFrame *= CFrame.new(0, 30, 0)
                            RunService.RenderStepped:Wait()
                            rootPart.CFrame = oldCf
                            task.wait(1)
                            oldCfCheck = false
                        end)
                    end
                end

                -- Silent Aim principal
                if SilentAimEnabled and weapon and metadata and not table.find(chanceCache, caster) and Chance and caster and caster.UserData and caster.StateInfo and caster.UserData.tool == weapon then
                    local pos = caster:GetPosition()
                    local Player = nil
                    
                    if Options.GetValue("ClosestType") == "Closest To Mouse" then
                        Player = Framework:GetClosestToMouse(Options.GetValue("FOVSize"))
                        if Player then
                            Player = Player.Character
                        end
                    end
                    
                    if Player then
                        local hitPartName = Options.GetValue("SilentHitPart")
                        if hitPartName == "Random" then
                            hitPartName = R6BodyParts[math.random(1, #R6BodyParts)]
                        end
                        
                        local HitPart = Player:FindFirstChild(hitPartName)
                        if HitPart and (HitPart.Position - pos).Magnitude <= Options.GetValue("SilentAimRange") then
                            ShowInformation(Players:GetPlayerFromCharacter(Player))
                            
                            local direction = (HitPart.Position - pos).Unit
                            local speed = 3000
                            local newVel = direction * speed
                            
                            caster:SetVelocity(newVel)
                        end
                    end
                end

                if Options.GetValue("ShowArrow") and caster and caster.SetStaticFastCastReference and not cache[caster] then
                    table.insert(cache, caster)
                    caster.SetStaticFastCastReference({
                        DebugLogging = false,
                        VisualizeCasts = true
                    })
                end

                return OriginalSimulateCast(...)
            end

            setupvalue(ActiveCast.new, 6, newSimulateCast)
        end)
    end

    -- Hook backup do calculateFireDirection
    local function newCalculateFireDirection(fireCFrame, minSpread, maxSpread, speed)
        local target = Framework:GetClosestToMouse(Options.GetValue("FOVSize"))
        local ranged, weaponClient, weaponMeta = Framework:GetRanged()

        if SilentAimEnabled and target and ranged and weaponMeta and Framework:Chance(Options.GetValue("HitChance")) and not Framework:InMenu(target) then
            ShowInformation(target)
            currentSilentAimTarget = target.Character
            
            local hitPartName = Options.GetValue("SilentHitPart")
            if hitPartName == "Random" then
                hitPartName = R6BodyParts[math.random(1, #R6BodyParts)]
            end
            
            local hitPart = target.Character:FindFirstChild(hitPartName)
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            
            if hitPart and humanoid then
                local fireOrigin = Camera.CFrame.Position
                if ranged and ranged:FindFirstChild("Handle") then
                    fireOrigin = ranged.Handle.Position
                end
                
                local velocity = Vector3.zero
                if Options.GetValue("Resolver") then
                    velocity = humanoid.MoveDirection * 16
                else
                    velocity = hitPart.Velocity
                end
                
                local distance = (hitPart.Position - fireOrigin).Magnitude
                local travelTime = distance / (speed or 200)
                local predictedPos = hitPart.Position + velocity * travelTime
                
                local newDirection = (predictedPos - fireOrigin).Unit
                
                return newDirection * (speed or 200)
            end
        else
            ShowInformation(nil)
        end

        return OriginalCalculateFireDirection(fireCFrame, minSpread, maxSpread, speed)
    end

    RangedWeaponHandler.calculateFireDirection = newCalculateFireDirection
end

-- CONFIGURAÇÃO DA UI
-- Silent Aim Group
local SilentAimGroup = MainTab:AddSection("Silent Aim", 1)

SilentAimGroup:AddToggle({
    text = "Enable Silent Aim",
    state = false,
    tooltip = "Enables silent aim",
    flag = "EnableSilentAim",
    callback = function(v)
        SilentAimEnabled = v
        if v then
            library:SendNotification("Silent Aim ativado!", 3)
        else
            library:SendNotification("Silent Aim desativado", 3)
        end
    end
})

SilentAimGroup:AddToggle({
    text = "Resolver",
    state = false,
    tooltip = "Predicts player movement",
    flag = "Resolver"
})

SilentAimGroup:AddToggle({
    text = "Show Target SA",
    state = false,
    tooltip = "Shows silent aim target",
    flag = "ShowTargetSA"
})

SilentAimGroup:AddToggle({
    text = "Desyn",
    state = false,
    tooltip = "Desyncs your character",
    flag = "Desyn"
})

SilentAimGroup:AddToggle({
    text = "Show Arrow",
    state = false,
    tooltip = "Shows projectile arrows",
    flag = "ShowArrow"
})

SilentAimGroup:AddToggle({
    text = "Whitelist Friends",
    state = false,
    tooltip = "Ignores friends",
    flag = "WhitelistFriends"
})

SilentAimGroup:AddToggle({
    text = "Avoid Projectiles",
    state = false,
    tooltip = "Avoids incoming projectiles",
    flag = "AvoidProjectiles"
})

SilentAimGroup:AddList({
    enabled = true,
    text = "Closest Type", 
    tooltip = "Target selection method",
    selected = "Closest To Mouse",
    multi = false,
    open = false,
    max = 4,
    values = {"Closest To Mouse", "Closest To Arrow", "Only Redirect To Target"},
    flag = "ClosestType",
    callback = function(v)
        -- Callback for closest type selection
    end
})

SilentAimGroup:AddList({
    enabled = true,
    text = "Silent Hit Part", 
    tooltip = "Body part to target",
    selected = "Torso",
    multi = false,
    open = false,
    max = 4,
    values = {"Head", "Torso", "Random"},
    flag = "SilentHitPart",
    callback = function(v)
        -- Callback for hit part selection
    end
})

SilentAimGroup:AddSlider({
    enabled = true,
    text = "FOV Size",
    tooltip = "Field of view size",
    flag = "FOVSize",
    suffix = "",
    dragging = true,
    focused = false,
    min = 0,
    max = 500,
    increment = 1,
    value = 200,
    callback = function(v)
        -- Callback for FOV size
    end
})

SilentAimGroup:AddSlider({
    enabled = true,
    text = "Hit Chance",
    tooltip = "Hit chance percentage",
    flag = "HitChance",
    suffix = "%",
    dragging = true,
    focused = false,
    min = 10,
    max = 100,
    increment = 1,
    value = 85,
    callback = function(v)
        -- Callback for hit chance
    end
})

SilentAimGroup:AddSlider({
    enabled = true,
    text = "Silent Aim Range",
    tooltip = "Silent aim range",
    flag = "SilentAimRange",
    suffix = "",
    dragging = true,
    focused = false,
    min = 10,
    max = 50,
    increment = 1,
    value = 35,
    callback = function(v)
        -- Callback for silent aim range
    end
})

-- Auto Parry Group
local AutoParryGroup = MainTab:AddSection("Auto Parry", 3)

-- Misc Group
local MiscGroup = MainTab:AddSection("Misc", 1)

AutoParryGroup:AddToggle({
    text = "Enable Auto Parry",
    state = false,
    tooltip = "Enables auto parry",
    flag = "EnableAutoParry",
    callback = function(v)
        AutoParryEnabled = v
        if v then
            library:SendNotification("Auto Parry ativado!", 3)
        else
            library:SendNotification("Auto Parry desativado", 3)
        end
    end
})

AutoParryGroup:AddToggle({
    text = "Only When Equipped",
    state = false,
    tooltip = "Only parry when weapon equipped",
    flag = "OnlyWhenEquipped"
})

AutoParryGroup:AddToggle({
    text = "Direction Check",
    state = false,
    tooltip = "Checks attack direction",
    flag = "DirectionCheck"
})

AutoParryGroup:AddToggle({
    text = "Facing Check",
    state = false,
    tooltip = "Checks if facing attacker",
    flag = "FacingCheck"
})

AutoParryGroup:AddToggle({
    text = "Ghost Check",
    state = false,
    tooltip = "Checks for ghosted players",
    flag = "GhostCheck"
})

AutoParryGroup:AddSlider({
    enabled = true,
    text = "Chance",
    tooltip = "Parry chance percentage",
    flag = "Chance",
    suffix = "%",
    dragging = true,
    focused = false,
    min = 10,
    max = 100,
    increment = 1,
    value = 90,
    callback = function(v)
        -- Callback for chance
    end
})

AutoParryGroup:AddSlider({
    enabled = true,
    text = "Max Angle",
    tooltip = "Maximum angle for parry",
    flag = "MaxAngle",
    suffix = "°",
    dragging = true,
    focused = false,
    min = 10,
    max = 100,
    increment = 1,
    value = 45,
    callback = function(v)
        -- Callback for max angle
    end
})

AutoParryGroup:AddSlider({
    enabled = true,
    text = "Max Range",
    tooltip = "Maximum range for parry",
    flag = "MaxRange",
    suffix = "",
    dragging = true,
    focused = false,
    min = 10,
    max = 20,
    increment = 1,
    value = 15,
    callback = function(v)
        -- Callback for max range
    end
})

AutoParryGroup:AddSlider({
    enabled = true,
    text = "Parry Cooldown",
    tooltip = "Cooldown between parries",
    flag = "ParryCooldown",
    suffix = "s",
    dragging = true,
    focused = false,
    min = 0,
    max = 2,
    increment = 0.1,
    value = 0.3,
    callback = function(v)
        -- Callback for parry cooldown
    end
})

-- Player Group
local PlayerGroup = MainTab:AddSection("Player", 4)

PlayerGroup:AddToggle({
    text = "Infinite Stamina",
    state = false,
    tooltip = "Grants infinite stamina",
    flag = "InfiniteStamina",
    callback = function(v)
        InfiniteStaminaEnabled = v
        if v then
            if not SetupInfiniteStamina() then
                library:SendNotification("Não foi possível ativar Infinite Stamina", 5)
            else
                library:SendNotification("Infinite Stamina ativado com sucesso!", 3)
            end
        else
            library:SendNotification("Infinite Stamina desativado", 3)
        end
    end
})

PlayerGroup:AddToggle({
    text = "No Dash Cooldown",
    state = false,
    tooltip = "Removes dash cooldown",
    flag = "NoDashCooldown",
    callback = function(v)
        NoDashCooldownEnabled = v
        if v then
            if not SetupNoDashCooldown() then
                library:SendNotification("Não foi possível ativar No Dash Cooldown", 5)
            else
                if EnableNoDashCooldown() then
                    library:SendNotification("No Dash Cooldown ativado com sucesso!", 3)
                else
                    library:SendNotification("Erro ao ativar No Dash Cooldown", 5)
                end
            end
        else
            if DisableNoDashCooldown() then
                library:SendNotification("No Dash Cooldown desativado", 3)
            else
                library:SendNotification("Erro ao desativar No Dash Cooldown", 5)
            end
        end
    end
})

PlayerGroup:AddToggle({
    text = "No Jump Cooldown",
    state = false,
    tooltip = "Removes jump cooldown",
    flag = "NoJumpCooldown",
    callback = function(v)
        NoJumpCooldownEnabled = v
        if v then
            if not SetupNoJumpCooldown() then
                library:SendNotification("Não foi possível ativar No Jump Cooldown", 5)
            else
                if EnableNoJumpCooldown() then
                    library:SendNotification("No Jump Cooldown ativado com sucesso!", 3)
                else
                    library:SendNotification("Erro ao ativar No Jump Cooldown", 5)
                end
            end
        else
            if DisableNoJumpCooldown() then
                library:SendNotification("No Jump Cooldown desativado", 3)
            else
                library:SendNotification("Erro ao desativar No Jump Cooldown", 5)
            end
        end
    end
})

PlayerGroup:AddToggle({
    text = "Infinite Air",
    state = false,
    tooltip = "Never run out of air underwater",
    flag = "InfiniteAir",
    callback = function(v)
        InfiniteAirEnabled = v
        if v then
            if not SetupInfiniteAir() then
                library:SendNotification("Não foi possível ativar Infinite Air", 5)
            else
                if EnableInfiniteAir() then
                    library:SendNotification("Infinite Air ativado com sucesso!", 3)
                else
                    library:SendNotification("Erro ao ativar Infinite Air", 5)
                end
            end
        else
            if DisableInfiniteAir() then
                library:SendNotification("Infinite Air desativado", 3)
            else
                library:SendNotification("Erro ao desativar Infinite Air", 5)
            end
        end
    end
})

PlayerGroup:AddToggle({
    text = "Walk on Water",
    state = false,
    tooltip = "Allows walking on water areas",
    flag = "WalkOnWater",
    callback = function(v)
        WalkOnWaterEnabled = v
        if v then
            if EnableWalkOnWater() then
                library:SendNotification("Walk on Water ativado com sucesso!", 3)
            else
                library:SendNotification("Erro ao ativar Walk on Water", 5)
            end
        else
            if DisableWalkOnWater() then
                library:SendNotification("Walk on Water desativado", 3)
            else
                library:SendNotification("Erro ao desativar Walk on Water", 5)
            end
        end
    end
})

PlayerGroup:AddToggle({
    text = "No Name Tag",
    state = false,
    tooltip = "Removes name tag above your head",
    flag = "NoNameTag",
    callback = function(v)
        NoNameTagEnabled = v
        if v then
            if EnableNoNameTag() then
                library:SendNotification("No Name Tag ativado com sucesso!", 3)
            else
                library:SendNotification("Erro ao ativar No Name Tag", 5)
            end
        else
            if DisableNoNameTag() then
                library:SendNotification("No Name Tag desativado", 3)
            else
                library:SendNotification("Erro ao desativar No Name Tag", 5)
            end
        end
    end
})

PlayerGroup:AddToggle({
    text = "No Low Health Effect",
    state = false,
    tooltip = "Disables low health visual effects",
    flag = "NoLowHealthEffect",
    callback = function(v)
        NoLowHealthEffectEnabled = v
        if v then
            if EnableNoLowHealthEffect() then
                library:SendNotification("No Low Health Effect ativado com sucesso!", 3)
            else
                library:SendNotification("Erro ao ativar No Low Health Effect", 5)
            end
        else
            if DisableNoLowHealthEffect() then
                library:SendNotification("No Low Health Effect desativado", 3)
            else
                library:SendNotification("Erro ao desativar No Low Health Effect", 5)
            end
        end
    end
})

PlayerGroup:AddToggle({
    text = "No Ghost Potion Effect",
    state = false,
    tooltip = "Disables ghost potion visual effects on other players",
    flag = "NoGhostPotionEffect",
    callback = function(v)
        NoGhostPotionEffectEnabled = v
        if v then
            if EnableNoGhostPotionEffect() then
                library:SendNotification("No Ghost Potion Effect ativado com sucesso!", 3)
            else
                library:SendNotification("Erro ao ativar No Ghost Potion Effect", 5)
            end
        else
            if DisableNoGhostPotionEffect() then
                library:SendNotification("No Ghost Potion Effect desativado", 3)
            else
                library:SendNotification("Erro ao desativar No Ghost Potion Effect", 5)
            end
        end
    end
})

PlayerGroup:AddToggle({
    text = "No Fall Damage",
    state = false,
    tooltip = "Disables fall damage",
    flag = "NoFallDamage",
    callback = function(v)
        NoFallDamageEnabled = v
        if v then
            if EnableNoFallDamage() then
                library:SendNotification("No Fall Damage ativado com sucesso!", 3)
            else
                library:SendNotification("Erro ao ativar No Fall Damage", 5)
            end
        else
            if DisableNoFallDamage() then
                library:SendNotification("No Fall Damage desativado", 3)
            else
                library:SendNotification("Erro ao desativar No Fall Damage", 5)
            end
        end
    end
})

PlayerGroup:AddToggle({
    text = "No Flash Effect",
    state = false,
    tooltip = "Disables flashbang/stun grenade effects",
    flag = "NoFlashEffect",
    callback = function(v)
        NoFlashEffectEnabled = v
        if v then
            if EnableNoFlashEffect() then
                library:SendNotification("No Flash Effect ativado com sucesso!", 3)
            else
                library:SendNotification("Erro ao ativar No Flash Effect", 5)
            end
        else
            if DisableNoFlashEffect() then
                library:SendNotification("No Flash Effect desativado", 3)
            else
                library:SendNotification("Erro ao desativar No Flash Effect", 5)
            end
        end
    end
})

PlayerGroup:AddToggle({
    text = "Can Always Jump",
    state = false,
    tooltip = "Allows jumping even when downed",
    flag = "CanAlwaysJump",
    callback = function(v)
        CanAlwaysJumpEnabled = v
        if v then
            if EnableCanAlwaysJump() then
                library:SendNotification("Can Always Jump ativado com sucesso!", 3)
            else
                library:SendNotification("Erro ao ativar Can Always Jump", 5)
            end
        else
            if DisableCanAlwaysJump() then
                library:SendNotification("Can Always Jump desativado", 3)
            else
                library:SendNotification("Erro ao desativar Can Always Jump", 5)
            end
        end
    end
})

PlayerGroup:AddToggle({
    text = "No Knockback",
    state = false,
    tooltip = "Disables knockback effects",
    flag = "NoKnockback",
    callback = function(v)
        NoKnockbackEnabled = v
        if v then
            if EnableNoKnockback() then
                library:SendNotification("No Knockback ativado com sucesso!", 3)
            else
                library:SendNotification("Erro ao ativar No Knockback", 5)
            end
        else
            if DisableNoKnockback() then
                library:SendNotification("No Knockback desativado", 3)
            else
                library:SendNotification("Erro ao desativar No Knockback", 5)
            end
        end
    end
})

PlayerGroup:AddToggle({
    text = "No Reload Cancel",
    state = false,
    tooltip = "Prevents reload cancellation for ranged weapons",
    flag = "NoReloadCancel",
    callback = function(v)
        NoReloadCancelEnabled = v
        if v then
            if EnableNoReloadCancel() then
                library:SendNotification("No Reload Cancel ativado com sucesso!", 3)
            else
                library:SendNotification("Erro ao ativar No Reload Cancel", 5)
            end
        else
            if DisableNoReloadCancel() then
                library:SendNotification("No Reload Cancel desativado", 3)
            else
                library:SendNotification("Erro ao desativar No Reload Cancel", 5)
            end
        end
    end
})

-- Misc Group Toggles
MiscGroup:AddToggle({
    text = "Wallbang",
    state = false,
    tooltip = "Allows shooting through walls and only hitting players",
    flag = "Wallbang",
    callback = function(v)
        WallbangEnabled = v
        if v then
            if not SetupWallbang() then
                library:SendNotification("Não foi possível ativar Wallbang", 5)
            else
                if EnableWallbang() then
                    library:SendNotification("Wallbang ativado com sucesso!", 3)
                else
                    library:SendNotification("Erro ao ativar Wallbang", 5)
                end
            end
        else
            if DisableWallbang() then
                library:SendNotification("Wallbang desativado", 3)
            else
                library:SendNotification("Erro ao desativar Wallbang", 5)
            end
        end
    end
})

MiscGroup:AddToggle({
    text = "No Utilities Trigger",
    state = false,
    tooltip = "Disables beartrap and claymore triggers by adding ForceField",
    flag = "NoUtilitiesTrigger",
    callback = function(v)
        NoUtilitiesTriggerEnabled = v
        if v then
            if EnableNoUtilitiesTrigger() then
                library:SendNotification("No Utilities Trigger ativado com sucesso!", 3)
            else
                library:SendNotification("Erro ao ativar No Utilities Trigger", 5)
            end
        else
            if DisableNoUtilitiesTrigger() then
                library:SendNotification("No Utilities Trigger desativado", 3)
            else
                library:SendNotification("Erro ao desativar No Utilities Trigger", 5)
            end
        end
    end
})

MiscGroup:AddToggle({
    text = "Instant Use Utilities",
    state = false,
    tooltip = "Disables pre-throw duration and use time for all utilities except Medkit",
    flag = "InstantUseUtilities",
    callback = function(v)
        InstantUseUtilitiesEnabled = v
        if v then
            if not UtilityMetadata then
                library:SendNotification("Não foi possível ativar Instant Use Utilities", 5)
            else
                if EnableInstantUseUtilities() then
                    library:SendNotification("Instant Use Utilities ativado com sucesso!", 3)
                else
                    library:SendNotification("Erro ao ativar Instant Use Utilities", 5)
                end
            end
        else
            if DisableInstantUseUtilities() then
                library:SendNotification("Instant Use Utilities desativado", 3)
            else
                library:SendNotification("Erro ao desativar Instant Use Utilities", 5)
            end
        end
    end
})

MiscGroup:AddToggle({
    text = "Instant Charge",
    state = false,
    tooltip = "Removes charge time for ranged weapons",
    flag = "InstantCharge",
    callback = function(v)
        InstantChargeEnabled = v
        if v then
            if not WeaponIds or not WeaponsInOrder then
                library:SendNotification("Não foi possível ativar Instant Charge", 5)
            else
                if EnableInstantCharge() then
                    library:SendNotification("Instant Charge ativado com sucesso!", 3)
                else
                    library:SendNotification("Erro ao ativar Instant Charge", 5)
                end
            end
        else
            if DisableInstantCharge() then
                library:SendNotification("Instant Charge desativado", 3)
            else
                library:SendNotification("Erro ao desativar Instant Charge", 5)
            end
        end
    end
})

-- GUI Refresh para corrigir layout
task.spawn(function()
    for i = 1, 10 do
        task.wait(0.1)
        pcall(function()
            if Window and Window.Refresh then
                Window:Refresh()
            end
            if MainTab and MainTab.Refresh then
                MainTab:Refresh()
            end
        end)
    end
end)

-- Sistema de Desync
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()

        if Options.GetValue("Desyn") then
            local Character = LocalPlayer.Character
            if not Character then continue end
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            if not HumanoidRootPart then continue end

            local vel = HumanoidRootPart.Velocity
            HumanoidRootPart.Velocity = Vector3.new(
                math.random(-1500, 1500), 
                math.random(-300, 300), 
                math.random(-1500, 1500)
            )

            RunService.RenderStepped:Wait()
            HumanoidRootPart.Velocity = vel
        end
    end
end)

-- Monitor para mudanças de mapa
Workspace.ChildAdded:Connect(function(child)
    if child.Name == "Map" then
        task.wait(1)
        HandleMapChange()
        if WalkOnWaterEnabled then
            task.wait(1)
            EnableWalkOnWater()
        end
    end
end)

-- Inicializar monitoramento de mapa
HandleMapChange()

-- Inicializar monitoramento de respawn para No Utilities Trigger
HandleCharacterRespawn()

-- Configuração da pasta de visualização FastCast
pcall(function()
    local VisualizerFolder = Instance.new("Folder", Workspace.Terrain)
    VisualizerFolder.Name = "FastCastVisualizationObjects"
    VisualizerFolder.ChildAdded:Connect(function(child)
        task.wait()
        Debris:AddItem(child, 0.7)
    end)
end)

-- Configuração do SaveManager e InterfaceManager (removido - usando Tokyo Lib)

-- Instala os hooks
SoundHandler.playSound = SoundHook
InitializeSilentAim()

-- Seleciona a primeira aba (removido - Tokyo Lib não precisa)

-- Função de limpeza global
_G.ScriptCleanup = function()
    -- Restaura funções originais
    if OriginalPlaySound then
        SoundHandler.playSound = OriginalPlaySound
    end
    
    if OriginalCalculateFireDirection then
        RangedWeaponHandler.calculateFireDirection = OriginalCalculateFireDirection
    end
    
    if OriginalSimulateCast and ActiveCast then
        pcall(function()
            setupvalue(ActiveCast.new, 6, OriginalSimulateCast)
        end)
    end
    
    if OriginalSetStamina and DefaultStaminaHandlerClient then
        local Stamina = DefaultStaminaHandlerClient.getDefaultStamina()
        if Stamina then
            Stamina.setStamina = OriginalSetStamina
            Stamina.getStamina = OriginalGetStamina
            DefaultStaminaHandlerClient.spendStamina = OriginalSpendStamina
        end
    end
    
    if OriginalUpdateIgnoreList and RangedWeaponClient then
        RangedWeaponClient.updateIgnoreList = OriginalUpdateIgnoreList
    end
    
    if SilentAimHighlight then
        SilentAimHighlight:Destroy()
    end
    
    -- Limpa variáveis
    ParryingCharacters = {}
    GhostedCharacters = {}
    cache = {}
    chanceCache = {}
    currentSilentAimTarget = nil
    waterParts = {}
    renderSteppedConnection = nil
    nameTagConnections = {}
    hiddenGuis = {}
    healthConnections = {}
    knockbackConnections = {}
    utilityCachedData = {}
    rangedWeaponsOriginal = {}
    noReloadCancelConnections = {}
    noReloadCancelOriginalFunctions = {}
    noReloadCancelHookedInstances = {}
    InfiniteStaminaEnabled = false
    AutoParryEnabled = false
    SilentAimEnabled = false
    NoDashCooldownEnabled = false
    NoJumpCooldownEnabled = false
    InfiniteAirEnabled = false
    WalkOnWaterEnabled = false
    WallbangEnabled = false
    NoUtilitiesTriggerEnabled = false
    NoNameTagEnabled = false
    NoLowHealthEffectEnabled = false
    NoKnockbackEnabled = false
    InstantUseUtilitiesEnabled = false
    InstantChargeEnabled = false
    NoGhostPotionEffectEnabled = false
    NoFallDamageEnabled = false
    NoFlashEffectEnabled = false
    CanAlwaysJumpEnabled = false
    NoReloadCancelEnabled = false
    
end

-- Notificação de inicialização
local Time = (string.format("%."..tostring(Decimals).."f", os.clock() - Clock))
library:SendNotification("Wisper Hub loaded successfully! ("..tostring(Time).."s)", 8)
        end
    },
    [1111111111111] = {
        name = "ExampleGame",
        description = "Script for ExampleGame",
        script = function()
            local PlaceID = 1111111111111

if game.PlaceId ~= PlaceID then
    return
end

-- código aqui
        end
    }
    }

    -- Check if we have a script for this game
    local game_info = game_scripts[current_place_id]

    if game_info then
        updateGui(game_info.name, "Loading script...")
        
        -- Execute the game-specific script
        local success, err = pcall(function()
            if game_info.script and type(game_info.script) == "function" then
                game_info.script()
                updateGui(game_info.name, "Script loaded successfully!")
            else
                updateGui(game_info.name, "Error: Script not found")
                error("Script function not found for game: " .. game_info.name)
            end
        end)
        
        if not success then
            updateGui(game_info.name, "Error: " .. tostring(err))
        end
    else
        updateGui("Unknown", "Game not supported")
    end
    
    -- Start the GUI animation
    animateAndDestroy()
end

-- Execute the game script
loadGameScript()
