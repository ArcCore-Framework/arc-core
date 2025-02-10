---@param ent number
---@param data vector4
local function setEntityCoordsAndHeading(ent, data)
  SetEntityCoords(ent, data.x, data.y, data.z, true, false, false)

  if data.w ~= nil then
    SetEntityHeading(ent, data.w)
  else
    SetEntityHeading(ent, 0)
  end
end
exports('setEntityCoordsAndHeading', setEntityCoordsAndHeading)

---@param dict string
local function loadAnimDict(dict)
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do
      Wait(1)
      RequestAnimDict(dict)
      print('Reuqesting : ' .. dict)
  end
end
exports('loadAnimDict', loadAnimDict)
