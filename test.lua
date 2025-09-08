-- Script principal único com suporte automático a jogos
-- Funciona offline sem dependências externas
-- Gerado automaticamente pelo build_hub.py

-- Get current game info
local player = game:GetService("Players").LocalPlayer
local current_place_id = game.PlaceId

local _identify_executor = identifyexecutor or getexecutorname or function() return "Unknown" end
local executor_name = _identify_executor()

-- Verificar se existe ScreenGui "Wisper", senão criar
local playerGui = player:WaitForChild("PlayerGui")
local WisperGui = playerGui:FindFirstChild("Wisper")

if not WisperGui then
    -- Criar novo ScreenGui se não existir
    WisperGui = Instance.new("ScreenGui")
    WisperGui.Name = "Wisper"
    WisperGui.Parent = playerGui
    WisperGui.ResetOnSpawn = false
    WisperGui.DisplayOrder = 100
end

-- Instâncias principais do novo design
local WisperExec = Instance.new("Frame")
local UIGradientBackground = Instance.new("UIGradient")
local UICornerBackground = Instance.new("UICorner")
local BackgroundStroke = Instance.new("UIStroke")
local BackgroundStrokeGradient = Instance.new("UIGradient")
local BackgroundAspectRatio = Instance.new("UIAspectRatioConstraint")

-- Filhos
local Title = Instance.new("TextLabel")
local Text = Instance.new("TextLabel")
local Icon = Instance.new("ImageLabel")

-- Propriedades do container
WisperExec.Name = "Frame"
WisperExec.Parent = WisperGui
WisperExec.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
WisperExec.BorderSizePixel = 0
WisperExec.Size = UDim2.new(0.0963, 0, 0.0799, 0)
WisperExec.Position = UDim2.new(-1, 0, 0.9128, 0)
WisperExec.ZIndex = 1 -- manter abaixo de outros overlays

UIGradientBackground.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(17, 16, 26)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 19, 43))
}
UIGradientBackground.Rotation = 60
UIGradientBackground.Parent = WisperExec

UICornerBackground.Parent = WisperExec

BackgroundAspectRatio.AspectRatio = 2.949
BackgroundAspectRatio.Parent = WisperExec

BackgroundStroke.Parent = WisperExec
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
	while WisperExec.Parent do
		local Delta = game:GetService("RunService").RenderStepped:Wait()
		Rotation = (Rotation + Delta * 50) % 360
		BackgroundStrokeGradient.Rotation = Rotation
	end
end)

-- Título com shine
Title.Name = "Title"
Title.Parent = WisperExec
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.016, 2, 0.034, 0)
Title.Size = UDim2.new(0.136, 0, 0.163, 0)
Title.Font = Enum.Font.SourceSans
Title.Text = "wisper"
Title.TextColor3 = Color3.fromRGB(160, 160, 160)
Title.TextScaled = true
Title.TextWrapped = true
Title.TextXAlignment = Enum.TextXAlignment.Left

do
	local ShineWidth = 0.15
	local ShineSpeed = 1
	local TitleShine = Instance.new("UIGradient")
	TitleShine.Parent = Title
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
		while Title.Parent do
			local Delta = game:GetService("RunService").RenderStepped:Wait()
			Offset = Offset + Delta * ShineSpeed
			TitleShine.Offset = Vector2.new(-0.5 + Offset, 0)
			if Offset >= 1.5 then
				Offset = 0
				wait(1)
			end
		end
	end)
end

-- Texto principal/status
Text.Name = "Text"
Text.Parent = WisperExec
Text.BackgroundTransparency = 1
Text.Position = UDim2.new(0.048, 0, 0.343, 0)
Text.Size = UDim2.new(0.897, 0, 0.369, 0)
Text.Font = Enum.Font.SourceSans
Text.Text = "Checking game support... (" .. executor_name .. ")"
Text.TextColor3 = Color3.fromRGB(255, 255, 255)
Text.TextScaled = true
Text.TextWrapped = true

-- Ícone com imagem do jogo (sem tween)
Icon.Name = "Icon"
Icon.Parent = WisperExec
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0.4497, 0, 0.0429, 0)
Icon.Size = UDim2.new(0.0931, 0, 0.2917, 0)
Icon.Image = "rbxthumb://type=GameIcon&id=" .. tostring(current_place_id) .. "&w=150&h=150"
Icon.ScaleType = Enum.ScaleType.Fit

-- Function to update GUI
local function updateGui(gameName, status)
	Title.Text = "wisper"
	Text.Text = (status or "") .. (executor_name and (" (" .. executor_name .. ")") or "")
end

-- Tween de entrada do container
do
	local TweenService = game:GetService("TweenService")
	local finalPos = UDim2.new(0.0032, 0, 0.9128, 0)
	local showTween = TweenService:Create(WisperExec, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = finalPos})
	showTween:Play()
end

-- Função de saída opcional (move para fora e oculta)
local function hideAndCleanup()
	local TweenService = game:GetService("TweenService")
	local hideTween = TweenService:Create(WisperExec, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(-1, 0, 0.9128, 0)})
	hideTween:Play()
	hideTween.Completed:Wait()
	WisperExec.Visible = false
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

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/1%20Tokyo%20Lib%20(FIXED)/Tokyo%20Lib%20Source.lua"))({
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

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/1%20Tokyo%20Lib%20(FIXED)/Tokyo%20Lib%20Source.lua"))({
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

-- SCRIPT COMPLETO COM UI FUNCIONAL - rip cw
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

-- =========================
-- UI LIB (Tokyo)
-- =========================
local Decimals = 4
local Clock = os.clock()
local ValueText = "Value Is Now :"

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/1%20Tokyo%20Lib%20(FIXED)/Tokyo%20Lib%20Source.lua"))({
    cheatname = "rip cw", -- watermark text
    gamename  = "Combat Warriors", -- watermark text
})

Library:init()

local WindowMain = Library.NewWindow({
    title = "rip cw | Combat Warriors",
    size  = UDim2.new(0, 510, 0, 520)
})

local MainTab     = WindowMain:AddTab("  Main  ")
local SettingsTab = Library:CreateSettingsTab(WindowMain)

-- Helpers para "mostrar/ocultar" elementos
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

local function RefreshUI()
    pcall(function()
        if WindowMain and WindowMain.Refresh then WindowMain:Refresh() end
    end)
    pcall(function()
        if MainTab and MainTab.Refresh then MainTab:Refresh() end
    end)
    pcall(function()
        if MainTab and MainTab.UpdateSections then MainTab:UpdateSections() end
    end)
    if SettingsTab and SettingsTab.SetActive and MainTab and MainTab.SetActive then
        pcall(function() SettingsTab:SetActive() end)
        task.wait(0.03)
        pcall(function() MainTab:SetActive() end)
    end
end

-- Força atualização imediata do layout
task.spawn(function()
    -- Forçar refresh múltiplas vezes para garantir
    for i = 1, 3 do
        task.wait(0.1)
        pcall(function() if WindowMain and WindowMain.Refresh then WindowMain:Refresh() end end)
        pcall(function() if MainTab and MainTab.Refresh then MainTab:Refresh() end end)
        pcall(function() if MainTab and MainTab.UpdateSections then MainTab:UpdateSections() end end)
        -- Simular troca de aba para forçar refresh
        if SettingsTab then
            pcall(function() SettingsTab:SetActive() end)
            task.wait(0.05)
            pcall(function() MainTab:SetActive() end)
        end
    end
end)

-- =========================
-- GRUPOS NA ABA PRINCIPAL
-- =========================
local SectionPlayer         = MainTab:AddSection("Player Features", 3)
local SectionSilentAim      = MainTab:AddSection("Silent Aim Settings", 1)
local SectionAutoParry      = MainTab:AddSection("Auto Parry Settings", 2)

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

-- Estados das funcionalidades (flags de controle)
local InfiniteStaminaEnabled = false
local AutoParryEnabled = false
local SilentAimEnabled = false
local WhitelistFriendsEnabled = false
local OnlyWhenEquippedEnabled = false
local DirectionCheckEnabled = false
local GhostCheckEnabled = false
local ShowTargetSAEnabled = false
local ResolverEnabled = false
local DesyncEnabled = false
local ShowArrowEnabled = false
local AvoidProjectilesEnabled = false

-- Variáveis de controle
local ParryingCharacters = {}
local GhostedCharacters = {}
local LastParryTime = 0
local ParryCooldown = 0.5
local cache = {}
local chanceCache = {}
local currentSilentAimTarget = nil
local oldCf = CFrame.new()
local oldCfCheck = false

-- Configurações de valores (sliders/inputs)
local HitChance = 50
local FOVSize = 500
local SilentAimRange = 20
local ParryChance = 50
local MaxAngle = 60
local MaxRange = 15
local ClosestType = "Closest To Mouse"
local SilentHitPart = "Torso"

-- Backup das funções originais
local OriginalPlaySound = SoundHandler.playSound
local OriginalCalculateFireDirection = RangedWeaponHandler.calculateFireDirection
local OriginalSimulateCast = nil
local OriginalSetStamina = nil
local OriginalGetStamina = nil
local OriginalSpendStamina = nil

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
        if WhitelistFriendsEnabled and LocalPlayer:IsFriendsWith(v.UserId) then continue end
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

function Framework:GetClosestCharacterToOrigin(originPosition, maxDistance)
    if not PlayerCharacters then return nil, math.huge end
    local closestCharacter = nil
    local closestDistance = math.huge
    for _, character in pairs(PlayerCharacters:GetChildren()) do
        local player = Players:GetPlayerFromCharacter(character)
        if player and player ~= LocalPlayer then
            if not WhitelistFriendsEnabled or not LocalPlayer:IsFriendsWith(player.UserId) then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - originPosition).Magnitude
                    if dist < maxDistance and dist < closestDistance then
                        closestDistance = dist
                        closestCharacter = character
                    end
                end
            end
        end
    end
    return closestCharacter, closestDistance
end

function Framework:GetClosestCharactersToOrigin(originPosition, maxDistance)
    local characters = {}
    if not PlayerCharacters then return characters end
    for _, character in pairs(PlayerCharacters:GetChildren()) do
        local player = Players:GetPlayerFromCharacter(character)
        if player and player ~= LocalPlayer then
            if not WhitelistFriendsEnabled or not LocalPlayer:IsFriendsWith(player.UserId) then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - originPosition).Magnitude < maxDistance then
                    table.insert(characters, character)
                end
            end
        end
    end
    return characters
end

-- SISTEMA DE AUTO PARRY
local function CanParry(targetCharacter)
    if not AutoParryEnabled then return false end
    if not targetCharacter then return false end
    if targetCharacter == LocalPlayer.Character then return false end
    if table.find(ParryingCharacters, targetCharacter) then return false end
    if GhostCheckEnabled and Framework:IsGhosted(targetCharacter) then return false end
    if tick() - LastParryTime < ParryCooldown then return false end
    
    local player = Players:GetPlayerFromCharacter(targetCharacter)
    if WhitelistFriendsEnabled and player and LocalPlayer:IsFriendsWith(player.UserId) then
        return false
    end
    
    if OnlyWhenEquippedEnabled then
        local weapon, _ = Framework:GetWeapon()
        if not weapon then return false end
    end
    
    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return false end
    if not Framework:IsPartClose(targetRoot, MaxRange) then return false end
    
    local localCharacter = Framework:GetLocalCharacter()
    if not localCharacter then return false end
    
    if DirectionCheckEnabled and not Framework:CheckDirection(targetCharacter, localCharacter, MaxAngle) then
        return false
    end
    
    if not Framework:Chance(ParryChance) then return false end
    
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
    if ShowTargetSAEnabled and target then
        SilentAimHighlight.Adornee = target.Character
    else
        SilentAimHighlight.Adornee = nil
    end
end

local function InitializeSilentAim()
    -- Hook do FastCast
    if ActiveCast then
        pcall(function()
            -- Find simulate cast upvalue dynamically to support different FastCast builds
            local foundIndex = nil
            for i = 1, 20 do
                local uv = getupvalue(ActiveCast.new, i)
                if type(uv) == "function" then
                    foundIndex = i
                    break
                end
            end
            if foundIndex then
                OriginalSimulateCast = getupvalue(ActiveCast.new, foundIndex)
            end
            
            local function newSimulateCast(...)
                local args = {...}
                local caster = args[1]
                
                if not caster then
                    return OriginalSimulateCast and OriginalSimulateCast(...) or nil
                end

                local weapon, weaponClient, metadata = Framework:GetRanged()
                
                local Chance = Framework:Chance(HitChance)
                if not Chance then
                    table.insert(chanceCache, caster)
                end

                -- Evitar projéteis
                if AvoidProjectilesEnabled and caster and caster.UserData and caster.UserData.tool ~= weapon then
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
                if SilentAimEnabled and weapon and metadata and not table.find(chanceCache, caster) and Chance then
                    local pos = caster:GetPosition()
                    local Player = nil
                    
                    if ClosestType == "Closest To Mouse" then
                        Player = Framework:GetClosestToMouse(FOVSize)
                        if Player then
                            Player = Player.Character
                        end
                    elseif ClosestType == "Closest To Arrow" then
                        Player = select(1, Framework:GetClosestCharacterToOrigin(pos, SilentAimRange))
                    elseif ClosestType == "Only Redirect To Target" then
                        local nearby = Framework:GetClosestCharactersToOrigin(pos, SilentAimRange)
                        if table.find(nearby, currentSilentAimTarget) then
                            Player = currentSilentAimTarget
                        end
                    end
                    
                    if Player then
                        local hitPartName = SilentHitPart
                        if hitPartName == "Random" then
                            hitPartName = R6BodyParts[math.random(1, #R6BodyParts)]
                        end
                        
                        local HitPart = Player:FindFirstChild(hitPartName)
                        if HitPart and (HitPart.Position - pos).Magnitude <= SilentAimRange then
                            ShowInformation(Players:GetPlayerFromCharacter(Player))
                            
                            local direction = (HitPart.Position - pos).Unit
                            local speed = 3000
                            local newVel = direction * speed
                            
                            caster:SetVelocity(newVel)
                        end
                    end
                end

                if ShowArrowEnabled and caster and caster.SetStaticFastCastReference and not cache[caster] then
                    cache[caster] = true
                    caster.SetStaticFastCastReference({
                        DebugLogging = false,
                        VisualizeCasts = true
                    })
                end

                return OriginalSimulateCast(...)
            end

            if foundIndex then
                setupvalue(ActiveCast.new, foundIndex, newSimulateCast)
            end
        end)
    end

    -- Hook backup do calculateFireDirection
    local function newCalculateFireDirection(fireCFrame, minSpread, maxSpread, speed)
        local target = Framework:GetClosestToMouse(FOVSize)
        local ranged, weaponClient, weaponMeta = Framework:GetRanged()

        if SilentAimEnabled and target and ranged and weaponMeta and Framework:Chance(HitChance) and not Framework:InMenu(target) then
            ShowInformation(target)
            currentSilentAimTarget = target.Character
            
            local hitPartName = SilentHitPart
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
                if ResolverEnabled then
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

-- =========================
-- UI CONTROLS - PLAYER TAB
-- =========================

local InfiniteStaminaToggle = SectionPlayer:AddToggle({
    text = "Infinite Stamina",
    state = false,
    tooltip = "Gives unlimited stamina",
    flag = "InfiniteStamina",
    callback = function(v)
        InfiniteStaminaEnabled = v
        if v then
            if not SetupInfiniteStamina() then
                Library:SendNotification("Failed to enable Infinite Stamina!", 5)
            else
                Library:SendNotification("Infinite Stamina enabled!", 3)
            end
        else
            Library:SendNotification("Infinite Stamina disabled", 3)
        end
    end
})

-- =========================
-- UI CONTROLS - SILENT AIM TAB
-- =========================

-- ENABLE TOGGLE FIRST - Silent Aim
local EnableSilentAimToggle = SectionSilentAim:AddToggle({
    text = "Enable Silent Aim",
    state = false,
    tooltip = "Enables silent aim functionality",
    flag = "EnableSilentAim",
    callback = function(v)
        SilentAimEnabled = v
        if v then
            Library:SendNotification("Silent Aim enabled!", 3)
        else
            Library:SendNotification("Silent Aim disabled", 3)
        end
    end
})

-- Always-visible Silent Aim toggles and lists
SectionSilentAim:AddToggle({
    text = "Resolver",
    state = false,
    tooltip = "Predicts player movement",
    flag = "Resolver",
    callback = function(v)
        ResolverEnabled = v
    end
})

SectionSilentAim:AddToggle({
    text = "Show Target",
    state = false,
    tooltip = "Highlights the target",
    flag = "ShowTarget",
    callback = function(v)
        ShowTargetSAEnabled = v
    end
})

SectionSilentAim:AddToggle({
    text = "Desync",
    state = false,
    tooltip = "Enables desync movement",
    flag = "Desync",
    callback = function(v)
        DesyncEnabled = v
    end
})

SectionSilentAim:AddToggle({
    text = "Show Arrow",
    state = false,
    tooltip = "Shows projectile trajectory",
    flag = "ShowArrow",
    callback = function(v)
        ShowArrowEnabled = v
    end
})

SectionSilentAim:AddToggle({
    text = "Avoid Projectiles",
    state = false,
    tooltip = "Automatically dodges incoming projectiles",
    flag = "AvoidProjectiles",
    callback = function(v)
        AvoidProjectilesEnabled = v
    end
})

SectionSilentAim:AddToggle({
    text = "Whitelist Friends",
    state = false,
    tooltip = "Ignores friends in targeting",
    flag = "WhitelistFriends",
    callback = function(v)
        WhitelistFriendsEnabled = v
    end
})

SectionSilentAim:AddList({
    text = "Closest Type",
    tooltip = "Target selection method",
    selected = "Closest To Mouse",
    multi = false,
    values = {"Closest To Mouse", "Closest To Arrow", "Only Redirect To Target"},
    callback = function(v)
        ClosestType = v
    end
})

SectionSilentAim:AddList({
    text = "Hit Part",
    tooltip = "Body part to target",
    selected = "Torso",
    multi = false,
    values = {"Head", "Torso", "Random"},
    callback = function(v)
        SilentHitPart = v
    end
})

-- Silent Aim Sliders - LAST
local FOVSlider = SectionSilentAim:AddSlider({
    text = "FOV Size",
    tooltip = "Field of view for targeting",
    flag = "FOVSize",
    suffix = " px",
    min = 0,
    max = 500,
    increment = 10,
    callback = function(v)
        FOVSize = v
    end
})
FOVSlider:SetValue(500)

local HitChanceSlider = SectionSilentAim:AddSlider({
    text = "Hit Chance",
    tooltip = "Percentage chance to hit",
    flag = "HitChance",
    suffix = "%",
    min = 10,
    max = 100,
    increment = 1,
    callback = function(v)
        HitChance = v
    end
})
HitChanceSlider:SetValue(50)

local SilentRangeSlider = SectionSilentAim:AddSlider({
    text = "Silent Range",
    tooltip = "Maximum range for silent aim",
    flag = "SilentRange",
    suffix = " studs",
    min = 10,
    max = 50,
    increment = 1,
    callback = function(v)
        SilentAimRange = v
    end
})
SilentRangeSlider:SetValue(20)


-- =========================
-- UI CONTROLS - AUTO PARRY TAB
-- =========================

-- ENABLE TOGGLE FIRST - Auto Parry
local EnableAutoParryToggle = SectionAutoParry:AddToggle({
    text = "Enable Auto Parry",
    state = false,
    tooltip = "Automatically parries incoming attacks",
    flag = "EnableAutoParry",
    callback = function(v)
        AutoParryEnabled = v
        if v then
            Library:SendNotification("Auto Parry enabled!", 3)
        else
            Library:SendNotification("Auto Parry disabled", 3)
        end
    end
})

-- Always-visible Auto Parry toggles
SectionAutoParry:AddToggle({
    text = "Only When Equipped",
    state = false,
    tooltip = "Only parry when weapon is equipped",
    flag = "OnlyEquipped",
    callback = function(v)
        OnlyWhenEquippedEnabled = v
    end
})

SectionAutoParry:AddToggle({
    text = "Direction Check",
    state = false,
    tooltip = "Check enemy direction before parrying",
    flag = "DirectionCheck",
    callback = function(v)
        DirectionCheckEnabled = v
    end
})

SectionAutoParry:AddToggle({
    text = "Ghost Check",
    state = false,
    tooltip = "Ignore ghosted/parried enemies",
    flag = "GhostCheck",
    callback = function(v)
        GhostCheckEnabled = v
    end
})

-- Auto Parry Sliders - LAST
local ParryChanceSlider = SectionAutoParry:AddSlider({
    text = "Parry Chance",
    tooltip = "Parry chance percentage",
    flag = "ParryChance",
    suffix = "%",
    min = 10,
    max = 100,
    increment = 1,
    callback = function(v)
        ParryChance = v
    end
})
ParryChanceSlider:SetValue(50)

local MaxAngleSlider = SectionAutoParry:AddSlider({
    text = "Max Angle",
    tooltip = "Maximum angle for direction check",
    flag = "MaxAngle",
    suffix = "°",
    min = 10,
    max = 100,
    increment = 1,
    callback = function(v)
        MaxAngle = v
    end
})
MaxAngleSlider:SetValue(60)

local MaxRangeSlider = SectionAutoParry:AddSlider({
    text = "Max Range",
    tooltip = "Maximum range for parrying",
    flag = "MaxRange",
    suffix = " studs",
    min = 10,
    max = 20,
    increment = 1,
    callback = function(v)
        MaxRange = v
    end
})
MaxRangeSlider:SetValue(15)

local ParryCooldownSlider = SectionAutoParry:AddSlider({
    text = "Parry Cooldown",
    tooltip = "Cooldown between parries",
    flag = "ParryCooldown",
    suffix = " s",
    min = 0,
    max = 2,
    increment = 0.1,
    callback = function(v)
        ParryCooldown = v
    end
})
ParryCooldownSlider:SetValue(0.5)
    if not slider then return end
    
    print("[Debug] ForceDestroy starting for slider:", tostring(slider))
    
    -- Tokyo UI Library specific destruction
    pcall(function()
        -- Method 1: Try Tokyo-specific removal
        if slider.Object and slider.Object.Parent then
            local parent = slider.Object.Parent
            slider.Object:Destroy()
            print("[Debug] Destroyed slider.Object from parent:", parent.Name)
        end
        
        -- Method 2: Find and destroy the actual GUI frame
        if slider.Object then
            local obj = slider.Object
            -- Look for the slider frame in the object hierarchy
            for _, child in pairs(obj:GetDescendants()) do
                if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextBox") then
                    child:Destroy()
                    print("[Debug] Destroyed child:", child.Name, child.ClassName)
                end
            end
        end
        
        -- Method 3: Access the section and try to remove the slider from its elements
        if SectionAutoParry and SectionAutoParry.Elements then
            for i, element in ipairs(SectionAutoParry.Elements) do
                if element == slider then
                    table.remove(SectionAutoParry.Elements, i)
                    print("[Debug] Removed slider from SectionAutoParry.Elements at index:", i)
                    break
                end
            end
        end
        
        if SectionSilentAim and SectionSilentAim.Elements then
            for i, element in ipairs(SectionSilentAim.Elements) do
                if element == slider then
                    table.remove(SectionSilentAim.Elements, i)
                    print("[Debug] Removed slider from SectionSilentAim.Elements at index:", i)
                    break
                end
            end
        end
        
        -- Method 4: Try to access MainTab elements
        if MainTab and MainTab.Elements then
            for i, element in ipairs(MainTab.Elements) do
                if element == slider then
                    table.remove(MainTab.Elements, i)
                    print("[Debug] Removed slider from MainTab.Elements at index:", i)
                    break
                end
            end
        end
        
        -- Method 5: Direct GUI destruction by finding slider frames
        if WindowMain and WindowMain.Window then
            for _, descendant in pairs(WindowMain.Window:GetDescendants()) do
                if descendant:IsA("Frame") and (descendant.Name:find("Slider") or descendant.Name:find("slider")) then
                    -- Check if this frame belongs to our slider
                    local shouldDestroy = false
                    for _, child in pairs(descendant:GetChildren()) do
                        if child:IsA("TextLabel") then
                            local text = child.Text
                            if text == "Parry Chance" or text == "Max Angle" or text == "Max Range" or text == "Parry Cooldown" or
                               text == "FOV Size" or text == "Hit Chance" or text == "Silent Range" then
                                shouldDestroy = true
                                break
                            end
                        end
                    end
                    
                    if shouldDestroy then
                        descendant:Destroy()
                        print("[Debug] Destroyed slider frame:", descendant.Name)
                    end
                end
            end
        end
        
        print("[Debug] ForceDestroy completed for slider")
    end)
local function RebuildSectionWithoutSliders(isAutoParry)
    print("[Debug] Rebuilding section without sliders:", isAutoParry and "AutoParry" or "SilentAim")
    
    pcall(function()
        local section = isAutoParry and SectionAutoParry or SectionSilentAim
        
        if section and section.Container then
            -- Find and destroy slider-related frames
            for _, child in pairs(section.Container:GetDescendants()) do
                if child:IsA("Frame") then
                    -- Check if this frame contains slider text
                    for _, subchild in pairs(child:GetChildren()) do
                        if subchild:IsA("TextLabel") then
                            local text = subchild.Text
                            local isSliderText = false
                            
                            if isAutoParry then
                                isSliderText = (text == "Parry Chance" or text == "Max Angle" or 
                                              text == "Max Range" or text == "Parry Cooldown")
                            else
                                isSliderText = (text == "FOV Size" or text == "Hit Chance" or 
                                              text == "Silent Range")
                            end
                            
                            if isSliderText then
                                child:Destroy()
                                print("[Debug] Destroyed slider frame for:", text)
                                break
                            end
                        end
                    end
                end
            end
        end
    end)
end
    if _autoParrySliders then 
        print("[Debug] Auto Parry sliders already exist, skipping creation")
        return 
    end
    
    print("[Debug] Creating Auto Parry sliders...")
    _autoParrySliders = {}

    local ParryChanceSlider = SectionAutoParry:AddSlider({
        text = "Parry Chance",
        tooltip = "Parry chance percentage",
        flag = "ParryChance",
        suffix = "%",
        min = 10,
        max = 100,
        increment = 1,
        callback = function(v)
            ParryChance = v
        end
    })
    ParryChanceSlider:SetValue(50)
    table.insert(_autoParrySliders, ParryChanceSlider)

    local MaxAngleSlider = SectionAutoParry:AddSlider({
        text = "Max Angle",
        tooltip = "Maximum angle for direction check",
        flag = "MaxAngle",
        suffix = "°",
        min = 10,
        max = 100,
        increment = 1,
        callback = function(v)
            MaxAngle = v
        end
    })
    MaxAngleSlider:SetValue(60)
    table.insert(_autoParrySliders, MaxAngleSlider)

    local MaxRangeSlider = SectionAutoParry:AddSlider({
        text = "Max Range",
        tooltip = "Maximum range for parrying",
        flag = "MaxRange",
        suffix = " studs",
        min = 10,
        max = 20,
        increment = 1,
        callback = function(v)
            MaxRange = v
        end
    })
    MaxRangeSlider:SetValue(15)
    table.insert(_autoParrySliders, MaxRangeSlider)

    local ParryCooldownSlider = SectionAutoParry:AddSlider({
        text = "Parry Cooldown",
        tooltip = "Cooldown between parries",
        flag = "ParryCooldown",
        suffix = " s",
        min = 0,
        max = 2,
        increment = 0.1,
        callback = function(v)
            ParryCooldown = v
        end
    })
    ParryCooldownSlider:SetValue(0.5)


-- ENABLE TOGGLE FIRST - Silent Aim
local EnableSilentAimToggle = SectionSilentAim:AddToggle({
    text = "Enable Silent Aim",
    state = false,
    tooltip = "Enables silent aim functionality",
    flag = "EnableSilentAim",
    callback = function(v)
        SilentAimEnabled = v
        if v then
            Library:SendNotification("Silent Aim enabled!", 3)
            CreateSilentAimSliders()
        else
            Library:SendNotification("Silent Aim disabled", 3)
            DestroySilentAimSliders()
        end
    end
})

-- Always-visible Silent Aim toggles and lists
SectionSilentAim:AddToggle({
    text = "Resolver",
    state = false,
    tooltip = "Predicts player movement",
    flag = "Resolver",
    callback = function(v)
        ResolverEnabled = v
    end
})

SectionSilentAim:AddToggle({
    text = "Show Target",
    state = false,
    tooltip = "Highlights the target",
    flag = "ShowTarget",
    callback = function(v)
        ShowTargetSAEnabled = v
    end
})

SectionSilentAim:AddToggle({
    text = "Desync",
    state = false,
    tooltip = "Enables desync movement",
    flag = "Desync",
    callback = function(v)
        DesyncEnabled = v
    end
})

SectionSilentAim:AddToggle({
    text = "Show Arrow",
    state = false,
    tooltip = "Shows projectile trajectory",
    flag = "ShowArrow",
    callback = function(v)
        ShowArrowEnabled = v
    end
})

SectionSilentAim:AddToggle({
    text = "Avoid Projectiles",
    state = false,
    tooltip = "Automatically dodges incoming projectiles",
    flag = "AvoidProjectiles",
    callback = function(v)
        AvoidProjectilesEnabled = v
    end
})

SectionSilentAim:AddToggle({
    text = "Whitelist Friends",
    state = false,
    tooltip = "Ignores friends in targeting",
    flag = "WhitelistFriends",
    callback = function(v)
        WhitelistFriendsEnabled = v
    end
})

SectionSilentAim:AddList({
    text = "Closest Type",
    tooltip = "Target selection method",
    selected = "Closest To Mouse",
    multi = false,
    values = {"Closest To Mouse", "Closest To Arrow", "Only Redirect To Target"},
    callback = function(v)
        ClosestType = v
    end
})

SectionSilentAim:AddList({
    text = "Hit Part",
    tooltip = "Body part to target",
    selected = "Torso",
    multi = false,
    values = {"Head", "Torso", "Random"},
    callback = function(v)
        SilentHitPart = v
    end
})

-- =========================
-- UI CONTROLS - AUTO PARRY TAB
-- =========================

-- ENABLE TOGGLE FIRST - Auto Parry
local EnableAutoParryToggle = SectionAutoParry:AddToggle({
    text = "Enable Auto Parry",
    state = false,
    tooltip = "Automatically parries incoming attacks",
    flag = "EnableAutoParry",
    callback = function(v)
        AutoParryEnabled = v
        if v then
            Library:SendNotification("Auto Parry enabled!", 3)
            CreateAutoParrySliders()
        else
            Library:SendNotification("Auto Parry disabled", 3)
            DestroyAutoParrySliders()
        end
    end
})

-- Always-visible Auto Parry toggles
SectionAutoParry:AddToggle({
    text = "Only When Equipped",
    state = false,
    tooltip = "Only parry when weapon is equipped",
    flag = "OnlyEquipped",
    callback = function(v)
        OnlyWhenEquippedEnabled = v
    end
})

SectionAutoParry:AddToggle({
    text = "Direction Check",
    state = false,
    tooltip = "Check enemy direction before parrying",
    flag = "DirectionCheck",
    callback = function(v)
        DirectionCheckEnabled = v
    end
})

-- Sliders will be created dynamically when feature is enabled

-- Aguardar a criação completa da UI antes de configurar elementos
task.spawn(function()
    task.wait(0.2) -- Aguardar mais tempo para UI estabilizar
    
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
    
    -- Simular mudança de aba para forçar layout refresh
    pcall(function()
        if SettingsTab and WindowMain then
            task.wait(0.1)
            if SettingsTab.SetActive then
                SettingsTab:SetActive()
                task.wait(0.05)
                MainTab:SetActive()
            end
        end
    end)
end)

-- Sistema de Desync
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()

        if DesyncEnabled then
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

-- Configuração da pasta de visualização FastCast
pcall(function()
    local VisualizerFolder = Instance.new("Folder", Workspace.Terrain)
    VisualizerFolder.Name = "FastCastVisualizationObjects"
    VisualizerFolder.ChildAdded:Connect(function(child)
        task.wait()
        Debris:AddItem(child, 0.7)
    end)
end)

-- Instala os hooks
SoundHandler.playSound = SoundHook
InitializeSilentAim()

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
    
    if SilentAimHighlight then
        SilentAimHighlight:Destroy()
    end
    
    -- Limpa variáveis
    ParryingCharacters = {}
    GhostedCharacters = {}
    cache = {}
    chanceCache = {}
    currentSilentAimTarget = nil
    InfiniteStaminaEnabled = false
    AutoParryEnabled = false
    SilentAimEnabled = false
    
    print("[Script] Limpeza concluída - todas as funcionalidades desativadas")
end

-- Notificação de inicialização
local Time = (string.format("%." .. tostring(Decimals) .. "f", os.clock() - Clock))
Library:SendNotification(("rip cw loaded in " .. tostring(Time) .. "s"), 6)

print("[Script] rip cw carregado com sucesso!")
print("Funcionalidades disponíveis:")
print("- Infinite Stamina:", DefaultStaminaHandlerClient and "✓" or "✗")
print("- Auto Parry: ✓")
print("- Silent Aim:", ActiveCast and "✓ (FastCast)" or "✓ (Backup)")
print("Use _G.ScriptCleanup() para remover o script completamente.")

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
