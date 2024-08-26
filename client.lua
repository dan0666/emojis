-- Initialize the pedDisplaying table
local pedDisplaying = {}
local display = false -- Track whether the UI is open or not

-- Function to draw text in 3D space
local function DrawText3D(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    local scale = 300 / (GetGameplayCamFov() * dist)

    SetTextColour(230, 230, 230, 255)
    SetTextScale(0.0, 0.5 * scale)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

-- Function to display emoji above the ped's head
local function Display(ped, text)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)

    if dist <= 250 then
        pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1
        local display = true

        Citizen.CreateThread(function()
            Wait(5000) -- Display time in milliseconds
            display = false
        end)

        local offset = 1.0 + pedDisplaying[ped] * 0.1
        while display do
            if HasEntityClearLosToEntity(playerPed, ped, 17 ) then
                local x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
                DrawText3D(vector3(x, y, z), text)
            end
            Wait(0)
        end

        pedDisplaying[ped] = pedDisplaying[ped] - 1
    end
end

-- Event to handle emoji display
RegisterNetEvent('intersystems_emoji:shareDisplay')
AddEventHandler('intersystems_emoji:shareDisplay', function(text, serverId)
    local player = GetPlayerFromServerId(serverId)
    if player ~= -1 then
        local ped = GetPlayerPed(player)
        Display(ped, text)
    end
end)

-- Command to open the emoji UI
RegisterCommand('emoji', function()
    if not display then
        display = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "openEmojiUI"
        })
    end
end)

-- NUI callback for emoji selection
RegisterNUICallback('selectEmoji', function(data, cb)
    local selectedEmoji = data.emoji
    TriggerServerEvent('intersystems_emoji:shareDisplay', selectedEmoji)
    SetNuiFocus(false, false)
    display = false
    cb('ok')
end)

-- NUI callback for closing the UI
RegisterNUICallback('closeEmojiUI', function(data, cb)
    SetNuiFocus(false, false)
    display = false
    cb('ok')
end)
