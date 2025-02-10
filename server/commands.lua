local commands = {}

---@param name string
---@param eventType string
---@param event string
---@param params number
---@param helpText string
---@param cArgs table
function createCommand(name, eventType, event, params, helpText, cArgs)
  commands[name] = {
    eventType = eventType,
    event = event,
    helpText = helpText,
    params = params
  }

  RegisterCommand(name, function(source, args)
    if #args > params then
      print('Too many arguments')
      return
    end

    local finalArgs = #args > 0 and args or cArgs or {}

    if eventType == 'client' then
      TriggerClientEvent(event, source, table.unpack(finalArgs))
      print(table.unpack(finalArgs))
    else
      TriggerEvent(event, source, table.unpack(finalArgs))
    end
  end, false)

  print('Command ' .. name .. ' created!')
end

exports('createCommand', createCommand)


---@param playerId number
local function addCommandSuggestions(playerId)
  print("Adding command suggestions for player ID:", playerId)

  for name, command in pairs(commands) do
    TriggerClientEvent('chat:addSuggestion', playerId, '/' .. name, command.helpText, command.help)
  end
end
exports('addCommandSuggestions', addCommandSuggestions)

RegisterNetEvent('arc_core:addCommandSuggestions', function()
  local src = source
  addCommandSuggestions(src)
end)

RegisterCommand('GetCommands', function()
  print(json.encode(commands, { indent = true }))
end, false)


