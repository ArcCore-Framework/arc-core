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

local function generateReadableID(fName, lName)
  local initials = string.upper(string.sub(fName, 1, 1) .. string.sub(lName, 1, 1))
  local randomNum = math.random(1000, 9999)   -- 4-digit unique number
  return initials .. "-" .. randomNum
end

RegisterNetEvent('arc_core:server:createCharacter', function(fName, lName, coords, model)
  local src = source
  local license = GetPlayerIdentifierByType(src, 'license')
  local nbid = generateReadableID(fName, lName)

  print('creating character')

  local charInfo = { firstName = fName, lastName = lName, model = model }

  MySQL.insert('INSERT INTO `players` (`license`, `nbid`, `char_data`, `coords`) VALUES (?, ?, ?, ?)',
    { license, nbid, json.encode(charInfo), json.encode(coords) }, function(insertId)
      if insertId then
        print("Character created with NBID:", nbid)
      else
        print("Failed to create character.")
      end
    end)
end)

AddEventHandler('playerDropped', function(reason, resourceName, clientDropReason)
  local src = source
  local license = GetPlayerIdentifierByType(src, 'license')

  -- Get the player's current coordinates
  local coords = GetEntityCoords(GetPlayerPed(src))

  -- Update the player's coords in the database
  MySQL.update('UPDATE `players` SET `coords` = ? WHERE `license` = ?',
    { json.encode(coords), license }, function(affectedRows)
      if affectedRows > 0 then
        print("Coordinates updated for player:", src)
      else
        print("Failed to update coordinates for player:", src)
      end
    end)
end)
