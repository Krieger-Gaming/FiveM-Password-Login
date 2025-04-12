local correctPassword = "supersecret"  -- your chosen password
local authorizedPlayers = {}           -- will store players' unique identifiers upon successful auth

-- Helper function to get a player's unique identifier (e.g., their license)
local function getUniqueIdentifier(src)
    local identifiers = GetPlayerIdentifiers(src)
    for _, id in ipairs(identifiers) do
        if string.find(id, "license:") then
            return id
        end
    end
    return nil
end

-- Event to check and record the password
RegisterNetEvent("checkPassword")
AddEventHandler("checkPassword", function(password)
    local src = source
    local identifier = getUniqueIdentifier(src)
    if password == correctPassword then
        if identifier then
            authorizedPlayers[identifier] = true
        end
        TriggerClientEvent("passwordAuth:success", src)
        print("Player " .. src .. " authenticated successfully.")
    else
        TriggerClientEvent("passwordAuth:failed", src, "Incorrect password. You have been kicked.")
        DropPlayer(src, "Incorrect password. You have been kicked.")
    end
end)

-- Event to check if the player has already been authenticated
RegisterNetEvent("checkIfAuthed")
AddEventHandler("checkIfAuthed", function()
    local src = source
    local identifier = getUniqueIdentifier(src)
    if identifier and authorizedPlayers[identifier] then
        TriggerClientEvent("passwordAuth:success", src)
    end
end)
