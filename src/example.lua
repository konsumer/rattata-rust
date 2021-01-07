-- load from this file's dir
package.path = string.match(arg[0], '^(.-)[^/\\]*$') .. '/?.lua;' .. package.path

local rattata = require('rattata')

-- ugh http://lua-users.org/wiki/SleepFunction
local function sleep(s)
  local ntime = os.time() + s
  repeat until os.time() > ntime
end

print("Server Location: " .. rattata:location())
rattata:start(8000)

