-- Upioguard HUB Script
-- Script principal único com suporte automático a jogos
-- Funciona offline sem dependências externas
-- Gerado automaticamente pelo build_hub.py

print("=== Upioguard HUB ===")
print("Inicializando...")

-- Get current game info
local player = game:GetService("Players").LocalPlayer
local current_place_id = game.PlaceId

print("Verificando suporte para o jogo atual...")

-- Game scripts configuration (integrated)
local game_scripts = {
    [592150372] = {
        name = "Baseplate",
        description = "Script para Baseplate",
        script = function()
            print("[Baseplate Script]: Carregando script para Baseplate...")
            
            -- Script integrado do Baseplate
if game.PlaceId ~= PlaceID then
print("[Baseplate Script]: Este script é apenas para o jogo Baseplate!")
return
end
print("[Baseplate Script]: Carregando script para Baseplate...")
local function createBaseplate()
local baseplate = Instance.new("Part")
baseplate.Name = "Baseplate"
baseplate.Size = Vector3.new(512, 1, 512)
baseplate.Position = Vector3.new(0, -0.5, 0)
baseplate.Anchored = true
baseplate.Material = Enum.Material.Grass
baseplate.Parent = workspace
print("[Baseplate Script]: Baseplate criada!")
return baseplate
end
local function createSpawnLocation()
local spawnLocation = Instance.new("SpawnLocation")
spawnLocation.Name = "SpawnLocation"
spawnLocation.Size = Vector3.new(6, 1, 6)
spawnLocation.Position = Vector3.new(0, 1, 0)
spawnLocation.Anchored = true
spawnLocation.Material = Enum.Material.Neon
spawnLocation.BrickColor = BrickColor.new("Bright blue")
spawnLocation.Parent = workspace
print("[Baseplate Script]: Spawn location criada!")
return spawnLocation
end
local function teleportToSpawn()
local player = game:GetService("Players").LocalPlayer
if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
print("[Baseplate Script]: Teleportado para o spawn!")
end
end
local baseplate = createBaseplate()
local spawnLocation = createSpawnLocation()
wait(1)
teleportToSpawn()
print("[Baseplate Script]: Script carregado com sucesso!")
print("[Baseplate Script]: PlaceID verificado: " .. game.PlaceId)
            
            print("[Baseplate Script]: Script carregado com sucesso!")
            print("[Baseplate Script]: PlaceID verificado: " .. game.PlaceId)
        end
    },
    [123456789] = {
        name = "ExampleGame",
        description = "Script para ExampleGame",
        script = function()
            print("[ExampleGame Script]: Carregando script para ExampleGame...")
            
            -- Script integrado do ExampleGame
if game.PlaceId ~= PlaceID then
print("[ExampleGame Script]: Este script é apenas para o jogo ExampleGame!")
return
end
local function setupGame()
print("[ExampleGame Script]: Configurando o jogo...")
local success, result = pcall(function()
return "Game configured successfully"
end)
if success then
print("[ExampleGame Script]: " .. result)
else
print("[ExampleGame Script]: Erro ao configurar o jogo: " .. tostring(result))
end
end
local function createUI()
print("[ExampleGame Script]: Criando interface do usuário...")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExampleGameUI"
screenGui.Parent = game:GetService("CoreGui")
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = screenGui
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.Text = "ExampleGame Script\nAtivo!"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.BackgroundTransparency = 1
textLabel.Parent = frame
print("[ExampleGame Script]: Interface criada!")
end
local function startGameLoop()
print("[ExampleGame Script]: Iniciando loop do jogo...")
spawn(function()
while wait(5) do -- Executa a cada 5 segundos
print("[ExampleGame Script]: Game loop tick - " .. os.date("%H:%M:%S"))
end
end)
end
setupGame()
createUI()
startGameLoop()
print("[ExampleGame Script]: Script carregado com sucesso!")
print("[ExampleGame Script]: PlaceID verificado: " .. game.PlaceId)
            
            print("[ExampleGame Script]: Script carregado com sucesso!")
            print("[ExampleGame Script]: PlaceID verificado: " .. game.PlaceId)
        end
    }
}

-- Check if we have a script for this game
local game_info = game_scripts[current_place_id]

if game_info then
    print("✅ Script encontrado para este jogo: " .. game_info.name)
    print("📝 Descrição: " .. game_info.description)
    print("📜 Executando script...")
    
    -- Execute the game-specific script
    local success, err = pcall(function()
        if game_info.script and type(game_info.script) == "function" then
            game_info.script()
        else
            error("Script function not found for game: " .. game_info.name)
        end
    end)
    
    if not success then
        print("❌ Falha ao executar script do jogo: " .. tostring(err))
    end
else
    print("❌ Nenhum script encontrado para PlaceID: " .. current_place_id)
    print("📋 Jogos disponíveis:")
    
    for place_id, info in pairs(game_scripts) do
        print("  - " .. info.name .. " (PlaceID: " .. place_id .. "): " .. info.description)
    end
    
    print("💡 Para adicionar suporte a este jogo, crie um arquivo na pasta Games/ e execute build_hub.py")
end

print("✅ HUB carregado com sucesso!")
print("==========================================")
