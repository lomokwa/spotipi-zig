const std = @import("std");
const fetch = @import("FetchRequest.zig");
const utils = @import("utils.zig");

const http = std.http;
const heap = std.heap;

pub const AccessToken = struct {
    access_token: []const u8,
    token_type: []const u8,
    // scope: ?[]const u8,
    expires_in: u16,
    // refresh_token: ?[]const u8
};

pub fn getAccessToken(allocator: std.mem.Allocator) !AccessToken {
    var gpa_alloc = heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa_alloc.deinit() == .leak) {
        std.log.warn("Memory leak\n", .{});
    };
    const gpa = gpa_alloc.allocator();

    var req = fetch.FetchRequest.init(gpa);
    defer req.deinit();

    const secrets = try utils.loadSecrets();

    const url = "https://accounts.spotify.com/api/token";
    var headers = [_]http.Header{.{ .name = "content-type", .value = "application/x-www-form-urlencoded"}};
    const req_body = try std.fmt.allocPrint(gpa, "grant_type=client_credentials&client_id={s}&client_secret={s}", .{secrets.client_id, secrets.client_secret});
    defer gpa.free(req_body);

    const res = try req.post(url, req_body, &headers);
    const body = try req.body.toOwnedSlice();
    defer req.allocator.free(body);

    if (res.status == .forbidden) {
        std.log.err("POST request failed - {?s}\n", .{body});
        std.process.exit(1);
    }

    std.debug.print("POST res body - {s}\n", .{body});

    const parsed = try std.json.parseFromSlice(AccessToken, gpa, body, .{});
    defer parsed.deinit();

    const access_token = try allocator.dupe(u8, parsed.value.access_token);
    const token_type = try allocator.dupe(u8, parsed.value.token_type);
    const expires_in = parsed.value.expires_in;

    const data = AccessToken{
        .access_token = access_token, 
        .token_type = token_type,
        .expires_in = expires_in
    };

    return data;
}

pub fn getUserAuth() !void {
    var gpa_alloc = heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa_alloc.deinit() == .leak) {
        std.log.warn("Memory leak\n", .{});
    };
    const gpa = gpa_alloc.allocator();

    var req = fetch.FetchRequest.init(gpa);
    defer req.deinit();

    const secrets = try utils.loadSecrets();

    const state = try utils.generateRandomString(16);
    const scope = "user-read-currently-playing";
    const redirect_uri = "http://localhost:8080/spotify-auth";

    const url = try std.fmt.allocPrint(gpa, "https://accounts.spotify.com/authorize?response_type=code&client_id={s}&scope={s}&redirect_uri={s}&state={s}", .{secrets.client_id, scope, redirect_uri, state});  
    defer gpa.free(url);

    std.debug.print("Click here to auth spotify: {s}\n", .{url});
}

pub fn refreshAccessToken() !void {
    
}
