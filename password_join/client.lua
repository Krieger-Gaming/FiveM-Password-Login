local authed = false

-- Check immediately with the server if the player has been authenticated
Citizen.CreateThread(function()
    TriggerServerEvent("checkIfAuthed")
    Citizen.Wait(1000)  -- wait a bit for the server response
    if not authed then
        SetNuiFocus(true, true)
        SendNUIMessage({ action = "show" })
    end
end)

-- This thread disables controls until the player is authenticated.
Citizen.CreateThread(function()
    while not authed do
        Citizen.Wait(0)
        DisableAllControlActions(0)
    end
end)

-- Successful authentication callback from the server.
RegisterNetEvent("passwordAuth:success")
AddEventHandler("passwordAuth:success", function()
    authed = true
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hide" })
end)

-- Failure callback (usually the player will be kicked).
RegisterNetEvent("passwordAuth:failed")
AddEventHandler("passwordAuth:failed", function(message)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "show", error = message })
end)

-- Called by the NUI when a password is submitted.
RegisterNUICallback("submitPassword", function(data, cb)
    local password = data.password
    TriggerServerEvent("checkPassword", password)
    cb("ok")
end)
