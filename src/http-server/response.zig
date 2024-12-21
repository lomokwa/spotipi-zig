const std = @import("std");
const Connection = std.net.Server.Connection;

pub fn send_200(connection: Connection) !void {
  const message = (
    "HTTP/1.1 200 OK\nContent-Length:48" ++
    "\nContent-Type: text/html\n" ++
    "Connection: Closed\n\n<html><body>" ++
    "<h1>Success!</h1></body></html>"
  );
  _ = try connection.stream.write(message);
}

pub fn send_400(connection: Connection) !void {
  const message = (
    "HTTP/1.1 404 Not Found\nContent-Length:48" ++
    "\nContent-Type: text/html\n" ++
    "Connection: Closed\n\n<html><body>" ++
    "<h1>404 File not Found</h1></body></html>"
  );
  _ = try connection.stream.write(message);
}
