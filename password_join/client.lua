local authed = false

Citizen.CreateThread(function()
    -- Immediately fade out the screen
    DoScreenFadeOut(0)
    
    -- Ask the server if this player has been authenticated already
    TriggerServerEvent("checkIfAuthed")
    Citizen.Wait(1000)
    
    if not authed then
        SetNuiFocus(true, true)
        SendNUIMessage({ action = "show" })
    end
end)

Citizen.CreateThread(function()
    while not authed do
        Citizen.Wait(0)
        DisableAllControlActions(0)
    end
end)

RegisterNetEvent("passwordAuth:success")
AddEventHandler("passwordAuth:success", function()
    authed = true
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hide" })
    Citizen.SetTimeout(100, function()
        DoScreenFadeIn(500)
    end)
    print("Authentication successful!")
end)

RegisterNetEvent("passwordAuth:failed")
AddEventHandler("passwordAuth:failed", function(message)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "show", error = message })
end)

RegisterNUICallback("submitPassword", function(data, cb)
    local password = data.password
    TriggerServerEvent("checkPassword", password)
    cb("ok")
end)
