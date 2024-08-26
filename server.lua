-- Server-side script to handle emoji display event

RegisterNetEvent('intersystems_emoji:shareDisplay')
AddEventHandler('intersystems_emoji:shareDisplay', function(text)
    local source = source
    -- Broadcast the emoji to all clients
    TriggerClientEvent('intersystems_emoji:shareDisplay', -1, text, source)
end)
