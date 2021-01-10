-- load from this file's dir
package.path = string.match(arg[0], '^(.-)[^/\\]*$') .. '/?.lua;' .. package.path

local Rattata = require('rattata')

local rattata = Rattata:new()

print(string.format("Server running on %s", rattata.info().hostname))

