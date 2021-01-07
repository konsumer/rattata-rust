-- load from this file's dir
package.path = string.match(arg[0], '^(.-)[^/\\]*$') .. '/?.lua;' .. package.path

local rattata = require('rattata')

local port = rattata:choose_port()

-- TODO: this will fail if this is the first time running the server
print(string.format("Server running on %s:%d", rattata:hostname(), port))

rattata:start(port)
