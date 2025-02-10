---@param ent number
---@param data vector4
local function setEntityCoordsAndHeading(ent, data)
  SetEntityCoords(ent, data.x, data.y, data.z, true, false, false)
  SetEntityHeading(ent, data.w)
end
exports('setEntityCoordsAndHeading', setEntityCoordsAndHeading)
