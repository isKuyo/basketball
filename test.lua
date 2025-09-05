-- Upioguard HUB Script
-- Script principal único com suporte automático a jogos
-- Funciona offline sem dependências externas
-- Gerado automaticamente pelo build_hub.py

-- Get current game info
local player = game:GetService("Players").LocalPlayer
local current_place_id = game.PlaceId

-- Get executor info
local _identify_executor = identifyexecutor or getexecutorname or function() return "Unknown" end
local executor_name = _identify_executor()

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Top = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Down = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Text = Instance.new("TextLabel")
local Bar = Instance.new("Frame")

-- Properties:
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(27, 27, 28)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.00365130068, 0, 0.908758104, 0)
Frame.Size = UDim2.new(0, 192, 0, 71)

UICorner.Parent = Frame

Top.Name = "Top"
Top.Parent = Frame
Top.BackgroundColor3 = Color3.fromRGB(44, 44, 46)
Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
Top.BorderSizePixel = 0
Top.Size = UDim2.new(0, 192, 0, 17)

UICorner_2.Parent = Top

Down.Name = "Down"
Down.Parent = Top
Down.BackgroundColor3 = Color3.fromRGB(44, 44, 46)
Down.BorderColor3 = Color3.fromRGB(0, 0, 0)
Down.BorderSizePixel = 0
Down.Position = UDim2.new(0, 0, 0.682656705, 0)
Down.Size = UDim2.new(0, 192, 0, 7)

Title.Name = "Title"
Title.Parent = Top
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title.BorderSizePixel = 0
Title.Position = UDim2.new(0.0206915941, 0, 0.121251725, 0)
Title.Size = UDim2.new(0, 180, 0, 14)
Title.Font = Enum.Font.SourceSans
Title.Text = "Unknown"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.TextSize = 14.000
Title.TextWrapped = true
Title.TextXAlignment = Enum.TextXAlignment.Left

Text.Name = "Text"
Text.Parent = Frame
Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Text.BackgroundTransparency = 1.000
Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
Text.BorderSizePixel = 0
Text.Position = UDim2.new(0.076854229, 0, 0.421218216, 0)
Text.Size = UDim2.new(0, 161, 0, 21)
Text.Font = Enum.Font.SourceSans
Text.Text = "Checking game support... (" .. executor_name .. ")"
Text.TextColor3 = Color3.fromRGB(255, 255, 255)
Text.TextScaled = true
Text.TextSize = 14.000
Text.TextWrapped = true

Bar.Name = "Bar"
Bar.Parent = Frame
Bar.BackgroundColor3 = Color3.fromRGB(86, 134, 254)
Bar.BorderColor3 = Color3.fromRGB(0, 0, 0)
Bar.BorderSizePixel = 0
Bar.Position = UDim2.new(0, 0, 0.991847098, 0)
Bar.Size = UDim2.new(0, 192, 0, -4)

-- Function to update GUI
local function updateGui(gameName, status)
    Title.Text = gameName
    Text.Text = status .. " (" .. executor_name .. ")"
end

-- Function to animate bar and destroy GUI
local function animateAndDestroy()
    local startTime = tick()
    local duration = 5 -- 5 seconds
    local initialSize = 192
    
    game:GetService("RunService").RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        if elapsed >= duration then
            ScreenGui:Destroy()
            return
        end
        
        local progress = elapsed / duration
        local newSize = initialSize * (1 - progress)
        Bar.Size = UDim2.new(0, newSize, 0, -4)
    end)
end

-- Esta função será substituída durante o build com os scripts dos jogos
local function loadGameScript()
    -- Game scripts configuration (integrated)
    local game_scripts = {
    [73708914208963] = {
        name = "BasketballZero",
        description = "Script for BasketballZero",
        script = function()
            local isValidPlace = false
            for _, placeId in pairs(PlaceIDs) do
                if game.PlaceId == placeId then
                    isValidPlace = true
                    break
                end
            end
            if not isValidPlace then
                return
            end
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
            local SectionAimbot         = TabMain:AddSection("Aimbot (Perfect Shot)", 1)        -- Left column, first section
            local SectionNoAbility      = TabMain:AddSection("No Ability Cooldown", 2)          -- Right column
            local SectionAutoDribble    = TabMain:AddSection("Auto Dribble", 1)                 -- Left column
            local SectionAutoBlock     = TabMain:AddSection("Auto Block", 2)
            task.spawn(function()
                for i = 1, 3 do
                    task.wait(0.1)
                    pcall(function() if WindowMain and WindowMain.Refresh then WindowMain:Refresh() end end)
                    pcall(function() if TabMain and TabMain.Refresh then TabMain:Refresh() end end)
                    pcall(function() if TabMain and TabMain.UpdateSections then TabMain:UpdateSections() end end)
                    if SettingsTab then
                        pcall(function() SettingsTab:SetActive() end)
                        task.wait(0.05)
                        pcall(function() TabMain:SetActive() end)
                    end
                end
            end)
            local AimbotToggleFlag        = false
            local SubtleCorrectionFlag    = false
            local AutoDribbleToggleFlag   = false
            local NoAbilityCooldownFlag   = false
            local DetectionRangeValue = 18
            local PanicRangeValue     = 5
            local CriticalRangeValue  = 4
            local UltraRangeValue     = 1.5
            local PlayerCooldownValue = 1
            local AimbotToggle = SectionAimbot:AddToggle({
                text = "Perfect Shot",
                state = false,
                tooltip = "Enable/disable aimbot shooting",
                flag = "Aimbot_Enabled",
                callback = function(v)
                    AimbotToggleFlag = v
                    AIMBOT_ENABLED = v  -- Ativar diretamente a variável global
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
            SetGroupVisible({SubtleToggle, AimbotHint}, false)
            local NoAbilityCooldownConnection = nil
            local NoAbilityCooldownToggle = SectionNoAbility:AddToggle({
                text = "No Ability Cooldown",
                state = false,
                tooltip = "Remove cooldowns from all abilities",
                flag = "NoAbility_Enabled",
                callback = function(v)
                    NoAbilityCooldownFlag = v
                    if v then
                        local success, errorMsg = pcall(function()
                            local ReplicatedStorage = game:GetService("ReplicatedStorage")
                            local RunService = game:GetService("RunService")
                            local packages = ReplicatedStorage:WaitForChild("Packages", 5)
                            if packages then
                                local knitModule = packages:FindFirstChild("Knit")
                                if knitModule then
                                    local Knit = require(knitModule)
                                    Knit.OnStart():await()
                                    local AbilityController = require(ReplicatedStorage.Controllers.AbilityController)
                                    local function NoCooldowns(ClientAbilityController)
                                        NoAbilityCooldownConnection = RunService.RenderStepped:Connect(function()
                                            if ClientAbilityController.CDS then
                                                for i = 1, 4 do
                                                    ClientAbilityController.CDS[i] = tick() - 1
                                                end
                                            end
                                        end)
                                    end
                                    NoCooldowns(AbilityController)
                                    if AbilityController.CooldownUI then
                                        AbilityController.CooldownUI(AbilityController)
                                    end
                                end
                            end
                        end)
                        if not success then
                        end
                    else
                        if NoAbilityCooldownConnection then
                            NoAbilityCooldownConnection:Disconnect()
                            NoAbilityCooldownConnection = nil
                        end
                    end
                end
            })
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
                SetGroupVisible({BlockShootsToggle, BlockPassesToggle, SliderBlockRange, SliderBlockAngle, SliderBlockCooldown}, false)
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
            task.spawn(function()
                task.wait(0.2) -- Aguardar mais tempo para UI estabilizar completamente
                SetGroupVisible({SliderDetection, SliderPanic, SliderCritical, SliderUltra, SliderCooldown}, false)
                task.wait(0.1)
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
                pcall(function()
                    if SettingsTab and WindowMain then
                        task.wait(0.1)
                        if SettingsTab.SetActive then
                            SettingsTab:SetActive()
                            task.wait(0.05)
                            TabMain:SetActive()
                        end
                    end
                end)
            end)
            local Time = (string.format("%." .. tostring(Decimals) .. "f", os.clock() - Clock))
            Library:SendNotification(("Loaded In " .. tostring(Time)), 6)
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Workspace = game:GetService("Workspace")
            local UIS = game:GetService("UserInputService")
            local LocalPlayer = Players.LocalPlayer
            DetectionRange = 18
            PanicRange = 5
            CriticalRange = 4
            UltraRange = 1.5
            PlayerCooldown = 1
            local StealAnimationId = "rbxassetid://132607768946898"
            AIMBOT_ENABLED = false
            SUBTLE_CORRECTION = false
            local function getSafeKnit()
                local success, knit = pcall(function()
                    local packages = ReplicatedStorage:WaitForChild("Packages", 5)
                    if not packages then return nil end
                    local knitModule = packages:FindFirstChild("Knit")
                    if not knitModule then return nil end
                    local knitService = require(knitModule)
                    return knitService
                end)
                if success and knit then
                    return knit
                end
                return nil
            end
            local function getSafeBallController()
                local knit = getSafeKnit()
                if not knit then return nil end
                local success, controller = pcall(function()
                    knit.OnStart():await()
                    return knit.GetController("BallController")
                end)
                if success then
                    return controller
                end
                return nil
            end
            local Knit = nil
            local BallController = nil
            spawn(function()
                wait(2) -- Aguardar o jogo carregar completamente
                Knit = getSafeKnit()
                if Knit then
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
            local LastDebugTime = 0
            local PlayerLastDribble = {}
            local UltraAttempts = {}
            local PanicAttempts = {}
            local GlobalLastDribble = 0
            local CharacterCache = {}
            local RootPartCache = {}
            local ballTrajectoryData = {}
            if getgenv().AutoDribbleConnection then
                getgenv().AutoDribbleConnection:Disconnect()
                getgenv().AutoDribbleConnection = nil
            end
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
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    CharacterCache[player] = player.Character
                    RootPartCache[player] = player.Character:FindFirstChild("HumanoidRootPart")
                end
            end
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
            local function safeHasBall()
                if not BallController then return false end
                local success, hasBall = pcall(function()
                    return BallController:LocalPlayerPossessesBall()
                end)
                return success and hasBall
            end
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
            local function getCurrentBall()
                local ball = nil
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
            local function calculateOriginalTrajectory(ballPosition, targetDirection, distance, isClose)
                local baseMultiplier = 0.75
                local distanceMultiplier
                if distance <= 30 then
                    distanceMultiplier = distance * 0.0455
                    baseMultiplier = 1.35
                else
                    distanceMultiplier = distance * 0.045
                end
                local totalMultiplier = baseMultiplier + distanceMultiplier
                local logMultiplier = math.log(totalMultiplier)
                local baseVelocity = targetDirection / logMultiplier
                local gravityCompensation = workspace.Gravity * logMultiplier * 0.5
                return baseVelocity + Vector3.new(0, gravityCompensation, 0)
            end
            local function setupSubtleCorrection()
                return nil
            end
            local function setupFallbackSystem()
                local lastBallVelocity = Vector3.new()
                local throwDetectionTime = 0
                local lastCorrectionTime = 0
                local lastBasketTime = 0
                local ballHeightHistory = {}
                local function isNormalShot()
                    if not BallController then return true end
                    local success, result = pcall(function()
                        return not (BallController.States and BallController.States.Dunking)
                    end)
                    return success and result
                end
                local function detectBasket(ball, hoop)
                    local ballPos = ball.Position
                    local hoopPos = hoop.Position
                    local distance = (ballPos - hoopPos).Magnitude
                    if distance < 3 then
                        local ballHeight = ballPos.Y
                        local hoopHeight = hoopPos.Y
                        table.insert(ballHeightHistory, ballHeight)
                        if #ballHeightHistory > 10 then
                            table.remove(ballHeightHistory, 1)
                        end
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
                        if detectBasket(ball, hoop) then
                            lastBasketTime = currentTime
                            ballHeightHistory = {} -- Limpar histórico
                            return -- Não fazer mais correções após cesta
                        end
                        if currentTime - lastBasketTime < 3 then
                            return
                        end
                        if velocityChange > 20 and currentVel.Magnitude > 15 and isNormalShot() and (currentTime - lastCorrectionTime) > 2 then
                            throwDetectionTime = currentTime
                            lastCorrectionTime = currentTime
                            local ballPos = ball.Position
                            local hoopPos = hoop.Position
                            local targetDirection = hoopPos - ballPos
                            local distance = targetDirection.Magnitude
                            if ball.Parent then
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
                        lastBallVelocity = currentVel
                    end
                end)
            end
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
                                    return
                                end
                            end
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
            _G.__StartAutoDribble = function()
                spawn(startAutoDribble)
            end
            spawn(startAutoDribble)
            do
                local Player = LocalPlayer
                local Character = Player.Character or Player.CharacterAdded:Wait()
                local Humanoid = Character:FindFirstChildOfClass("Humanoid") or Character:WaitForChild("Humanoid")
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart")
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
                            if velocityChange > SHOOT_VELOCITY_CHANGE_THRESHOLD and ballVelocity.Magnitude > MIN_SHOOT_VELOCITY and ballPosition.Y > SHOOT_MIN_HEIGHT then
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
                            elseif ballVelocity.Magnitude > MIN_PASS_VELOCITY and ballPosition.Y < PASS_MAX_HEIGHT then
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
                        lastBallPosition = ballPosition
                        lastBallVelocity = ballVelocity
                    end
                end
                local function DetectShootingStance()
                    if not isEnabledAutoBlock or not Character or not HumanoidRootPart then return end
                    if Player.Team == nil then return end
                    for _, ply in ipairs(Players:GetPlayers()) do
                        if IsEnemy(ply) and ply.Character then
                            local enemyChar = ply.Character
                            local enemyRoot = enemyChar:FindFirstChild("HumanoidRootPart")
                            local enemyHumanoid = enemyChar:FindFirstChildOfClass("Humanoid")
                            if enemyRoot and enemyHumanoid and enemyHumanoid.Health > 0 then
                                local distance = (HumanoidRootPart.Position - enemyRoot.Position).Magnitude
                                if distance <= AUTO_BLOCK_RANGE then
                                    local toMe = (HumanoidRootPart.Position - enemyRoot.Position)
                                    if toMe.Magnitude > 0 then
                                        local toMeUnit = toMe.Unit
                                        local enemyLook = enemyRoot.CFrame.LookVector
                                        local dotProduct = enemyLook:Dot(toMeUnit)
                                        local angle = math.deg(math.acos(math.clamp(dotProduct, -1, 1)))
                                        if angle <= BLOCK_ANGLE then
                                            local isShooting = false
                                            if enemyHumanoid:GetState() == Enum.HumanoidStateType.Jumping then isShooting = true end
                                            local enemyVelocity = enemyRoot.AssemblyLinearVelocity
                                            if enemyVelocity.Y > 12 then isShooting = true end
                                            if enemyRoot.Position.Y > HumanoidRootPart.Position.Y + 6 then isShooting = true end
                                            if isShooting then
                                                if shootEnabled then
                                                    Jump()
                                                end
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
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
            local function initializePerfectShot()
                if not LocalPlayer.Character then
                    LocalPlayer.CharacterAdded:Wait()
                end
                setupFallbackSystem()
                setupSubtleCorrection()
            end
            spawn(function()
                wait(3) -- Aguardar mais tempo para estabilizar
                local success, errorMsg = pcall(initializePerfectShot)
                if not success then
                end
            end)
        end
    },
    [1111111111111] = {
        name = "ExampleGame",
        description = "Script for ExampleGame",
        script = function()
            if game.PlaceId ~= PlaceID then
                return
            end
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
