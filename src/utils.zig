const std = @import("std");

pub const Secrets = struct {
    client_id: []const u8,
    client_secret: []const u8,
};

var secrets: ?Secrets = null;

pub fn loadSecrets() !Secrets {
  if (secrets) |s| return s;

  const allocator = std.heap.page_allocator;

  const file = try std.fs.cwd().openFile("secrets.json", .{});
  defer file.close();

  const content = try file.readToEndAlloc(allocator, std.math.maxInt(usize));
  defer allocator.free(content);

  const parsed = try std.json.parseFromSlice(Secrets, allocator, content, .{});
  defer parsed.deinit();

  const client_id = try allocator.dupe(u8, parsed.value.client_id);
  const client_secret = try allocator.dupe(u8, parsed.value.client_secret);

  secrets = Secrets{
    .client_id = client_id,
    .client_secret = client_secret,
  };
  
  return secrets.?;
}

fn isNumericString(input: []const u8) bool {
  for (input) |char| {
    if (char < '0' or char > '9') {
      return false;
    }
  }
  return true;
}


