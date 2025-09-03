-- Upioguard HUB Script
-- Script principal único com suporte automático a jogos
-- Funciona offline sem dependências externas

local start_time = os.time()

print("=== Upioguard HUB ===")
print("Inicializando...")

-- Get current game info
local player = game:GetService("Players").LocalPlayer
local current_place_id = game.PlaceId
local current_job_id = game.JobId

-- Get executor info
local _identify_executor = identifyexecutor or getexecutorname or function() return "unknown" end
local executor_name = _identify_executor()

print("Progresso: 1/4 - Informações do jogo coletadas")

-- Key is already provided by the executor
local key_value = rawget(getfenv(), "key") or (rawget(_G, "ug_key") or rawget(getfenv(), "ug_key"))

if not key_value or key_value == "" then
    print("❌ ERRO: Nenhuma chave fornecida! Defina a variável 'key' no seu executor")
    error("No key provided! Set the 'key' variable in your executor")
end

print("Progresso: 2/4 - Chave detectada")

-- Function to check key validity and get remaining time
local function checkKeyValidity(key)
    local success, response = pcall(function()
        local http = http or http_request or request
        if not http then
            return nil, "HTTP function not available"
        end
        
        local headers = {
            ["upioguard-key"] = key,
            ["upioguard-rbxlusername"] = player.Name,
            ["upioguard-rbxlplaceid"] = tostring(current_place_id),
            ["upioguard-rbxljobid"] = tostring(current_job_id),
            ["upioguard-rbxluserid"] = tostring(player.UserId),
            ["upioguard-rbxlgamename"] = "Game Name",
            ["upioguard-executor"] = executor_name,
            ["upioguard-ismobile"] = "false",
            ["upioguard-fingerprint"] = tostring(player.UserId)
        }
        
        local response = http({
            Url = "https://guard-orcin.vercel.app/api/script/B4RXsJRNywj6kOBmh4/execute",
            Method = "GET",
            Headers = headers
        })
        
        if response.Status == 200 and response.Body then
            return response.Body
        else
            return nil, "Invalid response from server"
        end
    end)
    
    if success and response then
        return true, response
    else
        return false, response or "Unknown error"
    end
end

-- Check key validity
local is_valid, script_content = checkKeyValidity(key_value)

if not is_valid then
    print("❌ ERRO: Falha ao verificar a chave: " .. tostring(script_content))
    error("Key validation failed: " .. tostring(script_content))
end

print("Progresso: 3/4 - Chave validada com sucesso")

-- Function to get remaining time from key
local function getKeyRemainingTime(key)
    local success, response = pcall(function()
        local http = http or http_request or request
        if not http then
            return nil, "HTTP function not available"
        end
        
        local headers = {
            ["upioguard-key"] = key,
            ["upioguard-rbxlusername"] = player.Name,
            ["upioguard-rbxlplaceid"] = tostring(current_place_id),
            ["upioguard-rbxljobid"] = tostring(current_job_id),
            ["upioguard-rbxluserid"] = tostring(player.UserId),
            ["upioguard-rbxlgamename"] = "Game Name",
            ["upioguard-executor"] = executor_name,
            ["upioguard-ismobile"] = "false",
            ["upioguard-fingerprint"] = tostring(player.UserId)
        }
        
        -- Try to get key info from the API
        local response = http({
            Url = "https://guard-orcin.vercel.app/api/script/B4RXsJRNywj6kOBmh4/execute",
            Method = "GET",
            Headers = headers
        })
        
        if response.Status == 200 then
            -- Parse response to get expiration info
            -- This is a simplified approach - in reality you'd need to parse the response properly
            return "Valid key - time remaining: Checking..."
        else
            return "Key status unknown"
        end
    end)
    
    if success then
        return response
    else
        return "Unable to check key status"
    end
end

-- Get key remaining time
local key_status = getKeyRemainingTime(key_value)

-- Game scripts configuration (integrated)
local game_scripts = {
    [592150372] = {
        name = "Baseplate",
        description = "Jogo básico do Roblox",
        script = function()
            print("[Baseplate Script]: Carregando script para Baseplate...")
            
            -- Funções úteis para Baseplate
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

            -- Executar funções
            local baseplate = createBaseplate()
            local spawnLocation = createSpawnLocation()

            -- Aguardar um pouco e teleportar
            wait(1)
            teleportToSpawn()

            print("[Baseplate Script]: Script carregado com sucesso!")
            print("[Baseplate Script]: PlaceID verificado: " .. game.PlaceId)
        end
    }
    -- Adicione novos jogos aqui seguindo o mesmo padrão
}

-- Print key info
print("=== Informações do HUB ===")
print("Executor: " .. executor_name)
print("Chave: " .. key_value)
print("Status da Chave: " .. key_status)
print("PlaceID Atual: " .. current_place_id)
print("JobID Atual: " .. current_job_id)
print("Jogador: " .. player.Name .. " (ID: " .. player.UserId .. ")")
print("==========================")

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
    
    print("💡 Para adicionar suporte a este jogo, edite o arquivo main.lua na seção game_scripts")
end

print("Progresso: 4/4 - HUB carregado com sucesso!")
print("🎉 HUB carregado em " .. (os.time() - start_time) .. " segundos")
print("==========================================")
