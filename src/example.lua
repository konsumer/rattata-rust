-- load from this file's dir
package.path = string.match(arg[0], '^(.-)[^/\\]*$') .. '/?.lua;' .. package.path

local rattata = require('rattata')

-- ugh http://lua-users.org/wiki/SleepFunction
local function sleep(s)
  local ntime = os.time() + s
  repeat until os.time() > ntime
end

print("Server Location: " .. rattata:location())

-- this will fail if the tor server has never been run, needs server to run in thread then return in a little while
print("Server address: " .. rattata:hostname())

rattata:start(8000)
