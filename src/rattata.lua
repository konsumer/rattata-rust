local ffi = require("ffi")

local rattata = {}

ffi.cdef[[
  const int8_t *rattata_location(void);
  const int8_t *rattata_hostname(void);
]]

function rattata:hostname()
  return ffi.C.rattata_hostname()
end

function rattata:location()
  return ffi.C.rattata_location()
end

return rattata
