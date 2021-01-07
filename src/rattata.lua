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

-- given a platform, get the target runtime for current manager instance
-- assumes runmtime is in runtimes/PLATFORM/runtime
function rattata:runtime(platform)
  local file = "runtimes/" .. platform .. "/runtime"
  if platform == "x86_64-pc-windows-gnu" then
    file = file .. ".exe"
  end
  local fin = io.open(file, "rb")
  local contents = fin:read("*all")
  fin:close()
  -- TODO: should properly pad address with spaces?
  return contents:gsub("ONION_ADDRESS........................................................", "ONION_ADDRESS" .. rattata:hostname() .. "\0")
end

return rattata
