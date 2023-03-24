import std/[asyncdispatch, asynchttpserver]

# posix has too many symbols that'll lead to a lot of annoying conflicts, so
# just import what we need
from std/posix import In6Addr, htonl
# it's in std/posix defined with -d:lwip, but lwip also activates other stuff so we just copy the implementation
proc IN6_IS_ADDR_V4MAPPED*(ipv6_address: ptr In6Addr): cint {.exportc.} =
  var bits32: ptr array[4, uint32] = cast[ptr array[4, uint32]](ipv6_address)
  return (bits32[1] == 0'u32 and bits32[2] == htonl(0x0000FFFF)).cint

proc main {.async.} =
  const port = 8080
  var server = newAsyncHttpServer()
  proc cb(req: Request) {.async.} =
    echo (req.reqMethod, req.url, req.headers)
    let headers = {"Content-type": "text/plain; charset=utf-8"}
    await req.respond(Http200, "Hello World", headers.newHttpHeaders())

  echo "test this with: curl localhost:" & $port & "/"
  server.listen(Port(port))
  while true:
    if server.shouldAcceptRequest():
      await server.acceptRequest(cb)
    else:
      # too many concurrent connections, `maxFDs` exceeded
      # wait 500ms for FDs to be closed
      await sleepAsync(500)

waitFor main()