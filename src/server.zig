const std = @import("std");
const net = std.net;
const mem = std.mem;

const Socket = struct {
  _address: std.net.Address,
  _stream: std.net.Stream,

  pub fn init() !Socket {
    const host = [4]u8{ 127, 0, 0, 1 };
    const port = 8080; 
    const addr = net.Address.initIp4(host, port);
    const socket = try std.posix.socket(addr.any.family, std.posix.SOCK.STREAM, std.posix.IPPROTO.TCP); 
    const stream = net.Stream{ .handle = socket };
    return Socket{ ._address = addr, ._stream = stream };
  }
};

pub fn startServer(port: u16) !void {
  var gpa_alloc = std.heap.GeneralPurposeAllocator(.{}){};
  defer if (gpa_alloc.deinit() == .leak) {
    std.log.warn("Memory leak\n", .{});
  };
  const gpa = gpa_alloc.allocator();

  const localhost = [4]u8{ 127, 0, 0, 1 };
  const address = net.Address.initIp4(localhost, port);

  
}
