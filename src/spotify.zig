const std = @import("std");
const fetch = @import("FetchRequest.zig");
const utils = @import("utils.zig");

const http = std.http;
const heap = std.heap;

pub const AccessToken = struct {
    access_token: []const u8,
    token_type: []const u8,
    expires_in: u16,
};

pub fn getAccessToken(allocator: std.mem.Allocator) !AccessToken {
    var gpa_impl = heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa_impl.deinit() == .leak) {
        std.log.warn("Memory leak\n", .{});
    };
    const gpa = gpa_impl.allocator();

    const secrets = try utils.loadSecrets();

    var req = fetch.FetchRequest.init(gpa);
    defer req.deinit();

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

    std.debug.print("expires in: {d}\nType: {}\n", .{parsed.value.expires_in, @TypeOf(parsed.value.expires_in)});

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

pub fn refreshAccessToken() !void {
    
}
