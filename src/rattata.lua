local ffi = require("ffi")

local f_rattata = ffi.load("rattata")

ffi.cdef[[
  const int8_t *ffi_location(void);
  const int8_t *ffi_hostname(void);
]]

local rattata = {}

-- get the current setings dir (which has tor stuff in it)
function rattata:location()
  return ffi.string(f_rattata.ffi_location())
end

-- get the current onion-hostname from running tor-server
function rattata:hostname()
  return ffi.string(f_rattata.ffi_hostname())
end

-- given a platform's target runtime filename path, get the target runtime (as a string) for current manager instance
function rattata:runtime(runtime_filename)
  local fin = io.open(runtime_filename, "rb")
  local contents = fin:read("*all")
  fin:close()
  local c = contents:gsub("ONION_ADDRESS........................................................", string.format("ONION_ADDRESS%-56s", rattata:hostname()))
  return c
end

return rattata
