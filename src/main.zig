const std = @import("std");
const spotify = @import("spotify.zig");

pub fn main() !void {
    try spotify.getAccessToken();
}
