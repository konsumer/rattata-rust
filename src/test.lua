-- load from current dir
package.path = string.match(arg[0], '^(.-)[^/\\]*$') .. '/?.lua;' .. package.path

local rattata = require('rattata')

print(rattata:location())