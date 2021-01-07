local ffi = require("ffi")

local f_rattata = ffi.load("rattata")

ffi.cdef[[
  const int8_t* ffi_location(void);
  const int8_t* ffi_hostname(void);
  const int16_t ffi_start(int16_t port);
  const int16_t ffi_choose_port();
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

-- get the current setings dir (which has tor stuff in it)
function rattata:location()
  return ffi.string(f_rattata.ffi_location())
end

-- get the current onion-hostname from running tor-server
function rattata:hostname()
  return ffi.string(f_rattata.ffi_hostname())
end

-- start a tor server & the local service connected to it
function rattata:start(port)
  return f_rattata.ffi_start(port)
end

-- choose a free port
function rattata:choose_port()
  return f_rattata.ffi_choose_port()
end


-- given a platform's target runtime filename path, get the target runtime (as a string) for current manager instance
function rattata:runtime(runtime_filename)
  local fin = io.open(runtime_filename, "rb")
  local contents = fin:read("*all")
  fin:close()
  local c = contents:gsub("ONION_ADDRESS........................................................", string.format("ONION_ADDRESS%-56s", self:hostname()))
  return c:gsub("MY_UUIID....................................", string.format("MY_UUIID%s", uuid()))
end

return rattata
