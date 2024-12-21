const std = @import("std");
const Connection = std.net.Server.Connection;

pub fn send_200(connection: Connection) !void {
    const message = 
        "HTTP/1.1 200 OK\r\n" ++
        "Content-Length: 48\r\n" ++
        "Content-Type: text/html\r\n" ++
        "Connection: Closed\r\n\r\n" ++
        "<html><body><h1>Success!</h1></body></html>";
    _ = try connection.stream.write(message);
}

pub fn send_404(connection: Connection) !void {
    const message = 
        "HTTP/1.1 404 Not Found\r\n" ++
        "Content-Length: 48\r\n" ++
        "Content-Type: text/html\r\n" ++
        "Connection: Closed\r\n\r\n" ++
        "<html><body><h1>404 File not Found</h1></body></html>";
    _ = try connection.stream.write(message);
}
