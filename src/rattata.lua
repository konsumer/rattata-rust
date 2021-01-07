local ffi = require("ffi")

local f_rattata = ffi.load("rattata")

ffi.cdef[[
  const int8_t *ffi_location(void);
  const int8_t *ffi_hostname(void);
]]

local rattata = {}

function rattata:hostname()
  return ffi.string(f_rattata.ffi_hostname())
end

function rattata:location()
  return ffi.string(f_rattata.ffi_location())
end

return rattata
