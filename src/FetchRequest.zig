// Request code from https://github.com/BrookJeynes/zig-fetch/blob/main/src/main.zig#L81

const std = @import("std");
const http = std.http;
const heap = std.heap;

const Client = http.Client;
const RequestOptions = Client.RequestOptions;

pub const FetchRequest = struct {
  const Self = @This();
  const Allocator = std.mem.Allocator;

  allocator: Allocator,
  client: Client,
  body: std.ArrayList(u8),

  pub fn init(allocator: Allocator) Self {
    const c = Client{ .allocator = allocator };
    return Self{ 
			.allocator = allocator, 
			.client = c, 
			.body = std.ArrayList(u8).init(allocator) 
		};
  }

	pub fn deinit(self: *Self) void {
		self.client.deinit();
		self.body.deinit();
	}

	//TODO: get request

	pub fn post(self: *Self, url: []const u8, body: []const u8, headers: []http.Header) !Client.FetchResult {
		const fetch_options = Client.FetchOptions{
			.location = Client.FetchOptions.Location {
				.url = url,
			},
			.extra_headers = headers,
			.method = .POST,
			.payload = body,
			.response_storage = .{ .dynamic = &self.body },
		};

		const res = try self.client.fetch(fetch_options);
		return res;
	}
};

