lib.callback.register('arc_core:server:getPlayerCharacters', function(source)
  local src = source
  local license = GetPlayerIdentifierByType(src, 'license')
  local characters = MySQL.query.await('SELECT * FROM `players` WHERE `license` = ?', { license })

  if #characters <= 0 then
    return false     -- No characters found
  else
    return characters
  end
end)

lib.callback.register('arc_core:server:deleteCharacter', function(source, nbid)
  local src = source
  local license = GetPlayerIdentifierByType(src, 'license')

  local character = MySQL.single.await('SELECT `license` FROM `players` WHERE `nbid` = ?', { nbid })

  if character.license ~= license then
    print('how are you douing this')
  else
    MySQL.query.await('DELETE FROM `players` WHERE `nbid` = ?', { nbid })
    TriggerClientEvent('arc_core:client:deleteCharacter', src)
  end
end)



local function GetPlayerSourceFromNBID(nbid)
  local character = MySQL.query.await('SELECT `srv_id` FROM `players` WHERE `nbid` = ? AND NOT `srv_id` = ?', { nbid, 0 })

  print(json.encode(character))

  return character[1].srv_id
end
exports('GetPlayerSourceFromNBID', GetPlayerSourceFromNBID)

local function generateReadableID(fName, lName)
  local initials = string.upper(string.sub(fName, 1, 1) .. string.sub(lName, 1, 1))
  local randomNum = math.random(1000, 9999)   -- 4-digit unique number
  return initials .. randomNum
end

lib.callback.register('arc_core:server:createCharacter', function(source, fName, lName, coords, model)
  local src = source
  local license = GetPlayerIdentifierByType(src, 'license')
  local nbid = generateReadableID(fName, lName)

  print('creating character')

  local charInfo = { firstName = fName, lastName = lName, model = model }
  local metadata = { health = 100.0, hunger = 100.0, thirst = 100.0, armour = 0 }

  MySQL.insert('INSERT INTO `players` (`license`, `nbid`, `char_data`, `meta_data`, `coords`) VALUES (?, ?, ?, ?, ?)',
    { license, nbid, json.encode(charInfo), json.encode(metadata), json.encode(coords) }, function(insertId)
      if insertId then
        print("Character created with NBID:", nbid)
      else
        print("Failed to create character.")
      end
    end)
  return nbid
end)


local function UpdateMetaData(source, toUpdate, newValue)
  local metadata = MySQL.single.await('SELECT `meta_data` FROM `players` WHERE `srv_id` = ?', { source })
  local decoded = json.decode(metadata.meta_data)

  decoded[toUpdate] = newValue

  if decoded[toUpdate] < 0 then
    decoded[toUpdate] = 0
  end
  MySQL.update('UPDATE `players` SET `meta_data` = ? WHERE `srv_id` = ?', { json.encode(decoded), source })
end

local function GetMetaData(source, getType)
  local metadata = MySQL.single.await('SELECT `meta_data` FROM `players` WHERE `srv_id` = ?', { source })
  local decoded = json.decode(metadata.meta_data)

  return decoded[getType]
end

local function UpdateFoodAndWater()
  local activePlayers = MySQL.query.await('SELECT `meta_data`, `srv_id` FROM `players` WHERE NOT `srv_id` = 0', {})

  -- print(activePlayers[1].srv_id)

  for i = 1, #activePlayers do
    local food = GetMetaData(activePlayers[i].srv_id, 'hunger')
    local thirst = GetMetaData(activePlayers[i].srv_id, 'thirst')

    UpdateMetaData(activePlayers[i].srv_id, 'hunger', food - SV_Config.HungerRate)

    Wait(500)

    UpdateMetaData(activePlayers[i].srv_id, 'thirst', thirst - SV_Config.ThirstRate)

    TriggerClientEvent('arc_hud:client:updateHud', activePlayers[i].srv_id,
      { type = 'hunger', value = GetMetaData(activePlayers[i].srv_id, 'hunger') })
    TriggerClientEvent('arc_hud:client:updateHud', activePlayers[i].srv_id,
      { type = 'thirst', value = GetMetaData(activePlayers[i].srv_id, 'thirst') })
  end

  -- print(json.encode(activePlayers))
end

Citizen.CreateThread(function()
    while true do
      Wait(5 * 1000)
      UpdateFoodAndWater()
    end
end)

RegisterNetEvent('arc_core:server:updateSrvId', function(nbid)
  local src = source
  MySQL.update('UPDATE `players` SET `srv_id` = ? WHERE `nbid` = ?', { src, nbid } )

  -- set hud values
  TriggerClientEvent('arc_hud:client:updateHud', src,
    { type = 'health', value = GetMetaData(src, 'health') })
  TriggerClientEvent('arc_hud:client:updateHud', src,
    { type = 'hunger', value = GetMetaData(src, 'hunger') })
  TriggerClientEvent('arc_hud:client:updateHud', src,
    { type = 'thirst', value = GetMetaData(src, 'thirst') })
  TriggerClientEvent('arc_hud:client:updateHud', src,
    { type = 'armour', value = GetMetaData(src, 'armour') })
end)

AddEventHandler('playerDropped', function(reason, resourceName, clientDropReason)
  local src = source
  local license = GetPlayerIdentifierByType(src, 'license')

  -- Get the player's current coordinates
  local coords = GetEntityCoords(GetPlayerPed(src))

  -- Update the player's coords in the database
  MySQL.update('UPDATE `players` SET `coords` = ?, `srv_id` = ? WHERE `license` = ?',
    { json.encode(coords), 0, license }, function(affectedRows)
      if affectedRows > 0 then
        print("Coordinates updated for player:", src)
      else
        print("Failed to update coordinates for player:", src)
      end
    end)
end)

-- AddEventHandler('onResourceStop', function(resource)
--   if resource ~= GetCurrentResourceName() then return end

--   MySQL.update('UPDATE `players` SET `srv_id` = ?', { 0 })
-- end)

RegisterCommand('testl', function(source)

  UpdateMetaData(source, 'armour', 50)

  TriggerClientEvent('arc_hud:client:updateHud', source,
    { type = 'armour', value = GetMetaData(source, 'armour') })
end, false)
