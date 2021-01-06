local ffi = require("ffi")

local f_rattata = ffi.load("rattata")

ffi.cdef[[
  const int8_t *rattata_location(void);
  const int8_t *rattata_hostname(void);
]]

local rattata = {}

function rattata:hostname()
  return ffi.string(f_rattata.rattata_hostname())
end

function rattata:location()
  return ffi.string(f_rattata.rattata_location())
end

return rattata
