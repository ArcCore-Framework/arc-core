AddEventHandler('playerSpawned', function()
  TriggerServerEvent('arc_core:addCommandSuggestions')
  print('Player spawned, requesting command suggestions')
end)
