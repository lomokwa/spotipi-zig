const std = @import("std");
const SocketConf = @import("config.zig");
const net = std.net;
const mem = std.mem;

pub fn startServer(port: u16) !void {
  var gpa_alloc = std.heap.GeneralPurposeAllocator(.{}){};
  defer if (gpa_alloc.deinit() == .leak) {
    std.log.warn("Memory leak\n", .{});
  };
  const gpa = gpa_alloc.allocator();

  const socket = try SocketConf.socket.init();
  try std.log.info("Server running on: {}\n", .{socket._address});
  var server = try socket._address.listen(.{});
  const connection = try server.accept();
  _ = connection;

}
