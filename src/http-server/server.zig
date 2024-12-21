const std = @import("std");
const SocketConf = @import("config.zig");
const Request = @import("request.zig");
const net = std.net;
const mem = std.mem;
const stdout = std.io.getStdOut().writer();

pub fn startServer() !void {
  // var gpa_alloc = std.heap.GeneralPurposeAllocator(.{}){};
  // defer if (gpa_alloc.deinit() == .leak) {
  //   std.log.warn("Memory leak\n", .{});
  // };
  // const gpa = gpa_alloc.allocator();

  const socket = try SocketConf.Socket.init();
  std.log.info("Server running on: {}\n", .{socket._address});
  var server = try socket._address.listen(.{});
  const connection = try server.accept();
  
  var buffer: [1000]u8 = undefined;
  for (0..buffer.len) |i| {
    buffer[i] = 0;
  }
  try Request.read_request(connection, buffer[0..buffer.len]);
  const request = Request.parse_request(buffer[0..buffer.len]);

  try stdout.print("{any}\n", .{request});
}
