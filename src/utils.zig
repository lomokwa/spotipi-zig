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

pub fn generateRandomString(charCount: u16) ![]const u8 {
  const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

  var random = std.rand.DefaultPrng.init(std.time.nanoTimestamp());

  const allocator = std.heap.page_allocator;
  const buffer = try allocator.alloc(u8, charCount);
  defer allocator.free(buffer);

  for (buffer) |*char| {
    const index = random.random.usize() % charset.len;
    char.* = charset[index];
  }

  return buffer;
}

fn isNumericString(input: []const u8) bool {
  for (input) |char| {
    if (char < '0' or char > '9') {
      return false;
    }
  }
  return true;
}


