const std = @import("std");
const spotify = @import("spotify.zig");
const server = @import("http-server/server.zig");

pub fn main() !void {
    var gpa_alloc = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa_alloc.deinit();
    // const gpa = gpa_alloc.allocator();

    try spotify.getUserAuth();
    
    try server.startServer();
    // const res = try spotify.getAccessToken(gpa);
    // defer {
    //     gpa.free(res.access_token);
    //     gpa.free(res.token_type);
    // }

    // std.debug.print("========================================================\nSPOTIFY DATA:\n\naccess_token = {s},\ntoken_type = {s},\nexpires_in = {d}\n", .{res.access_token, res.token_type, res.expires_in});
}
