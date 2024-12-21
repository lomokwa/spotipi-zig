const std = @import("std");
const Connection = std.net.Server.Connection;
const Map = std.static_string_map.StaticStringMap;

pub const HttpMethod = enum {
  GET,
  POST,

  pub fn init(text: []const u8) !HttpMethod {
    return MethodMap.get(text).?;
  }

  pub fn is_supported(_method: []const u8) bool {
    const method = MethodMap.get(_method);
    if (method) |_| {
      return true;
    }
    return false;
  }
};

const MethodMap = Map(HttpMethod).initComptime(.{ .{"GET", HttpMethod.GET}, .{"POST", HttpMethod.POST} });

const Request = struct {
  method: HttpMethod,
  version: []const u8,
  uri: []const u8,

  pub fn init(method: HttpMethod, uri: []const u8, version: []const u8) Request {
    return Request{
      .method = method,
      .uri = uri,
      .version = version
    };
  }
};

pub fn parse_request(text: []u8) Request {
  const line_index = std.mem.indexOfScalar(u8, text, '\n') orelse text.len;
  var iterator = std.mem.splitScalar(u8, text[0..line_index], ' ');

  const method = try HttpMethod.init(iterator.next() orelse "");
  const uri = iterator.next() orelse "";
  const version = iterator.next() orelse "";
  const request = Request.init(method, uri, version);
  return request;
}

pub fn read_request(conn: Connection, buffer: []u8) !void {
  const reader = conn.stream.reader();
  _ = try reader.read(buffer);
}