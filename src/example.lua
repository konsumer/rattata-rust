-- load from this file's dir
package.path = string.match(arg[0], '^(.-)[^/\\]*$') .. '/?.lua;' .. package.path

local rattata = require('rattata')

-- this can be called any time to get a free port
local port = rattata:choose_port()

-- This will fail if the server has never been started
print(string.format("Server running on %s:%d", rattata:hostname(), port))

-- this is last because it blocks
rattata:start(port)
