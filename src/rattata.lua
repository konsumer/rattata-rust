local ffi = require("ffi")

local f_rattata = ffi.load("rattata")

ffi.cdef[[
  typedef struct Rattata {
    const char *hostname;
    uint16_t clients[255];
    uint16_t port;
    const void *threads;
  } Rattata;

  typedef struct Client {
    uint16_t id;
    const char *ip;
    const char *os;
    const char *arch;
  } Client;

  struct Rattata *rattata_new(uint16_t port);
  void rattata_free(struct Rattata *ptr);
  const char *rattata_command(struct Rattata *ptr, uint16_t client_id, const char *command, const char *args);
  struct Client *rattata_info(struct Rattata *ptr, uint16_t client_id);
]]

local rattata = {}

-- start a server on a specific port
function rattata:new(port)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  self.pointer = f_rattata.rattata_new(port or 0)
  return o
end

-- stop running server
function rattata:free()
  f_rattata.rattata_free(self.pointer)
end

-- send a command to a specific client
function rattata:command(clientID, command, args)
  return f_rattata.rattata_command(self.pointer, clientID, command, args)
end

-- get info about a specific client
function rattata:info(clientID)
  -- TODO: need to convert types here
  return f_rattata.rattata_info(self.pointer, clientID)
end

return rattata
