local socket = require("socket")
local host = "127.0.0.1"
local port = 5346

local s = assert(socket.tcp())
assert(s:connect(host, port))

assert(s:send("IMAGE100.LXFML,out/output.png"))
local msg, status, partial = s:receive()
s:close()