const std = @import("std");

pub const EncodingMode = enum {
  numeric = 0b0001,
  alphanumeric = 0b0010,
  byte = 0b0100,
  kanji = 0b0111
};

pub fn getEncodingMode(link: []const u8) u4 {
  if (isNumeric) {
    return 0b0001;
  }

  if (isAlphanumeric) {
    return 0b0010;  
  }

  if (isByte) {
    return 0b0100;
  }

  if (isKanji) {
    return 0b1000;
  }

  return 0b0111;
}

pub fn encodeData(allocator: std.mem.Allocator, data: []const u8, mode: EncodingMode) ![]const u8 {
  
}
