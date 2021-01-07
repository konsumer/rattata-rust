local ffi = require("ffi")

local f_rattata = ffi.load("rattata")

ffi.cdef[[
  const int8_t *ffi_location(void);
  const int8_t *ffi_hostname(void);
]]

-- simple right-pad string fucntion
local function rpad (s, l, c)
  local res = s .. string.rep(c or ' ', l - #s)
  return res, res ~= s
end

local rattata = {}

-- get the current setings dir (which has tor stuff in it)
function rattata:location()
  return ffi.string(f_rattata.ffi_location())
end

-- get the current onion-hostname from running tor-server
function rattata:hostname()
  return ffi.string(f_rattata.ffi_hostname())
end

-- given a platform, get the target runtime for current manager instance
function rattata:runtime(runtime_filename)
  local fin = io.open(runtime_filename, "rb")
  local contents = fin:read("*all")
  fin:close()
  return contents:gsub("ONION_ADDRESS........................................................", "ONION_ADDRESS" .. rpad(rattata:hostname(), 56, " "))
end

return rattata
