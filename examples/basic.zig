const std = @import("std");
const ziez = @import("ziez");
const tracker = @import("ziez_tracker");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var app = ziez.init(allocator);
    defer app.deinit();

    tracker.setup(&app, .{ .ua_parser_enabled = true });

    app.get("/", struct {
        fn h(_: *ziez.Request, res: *ziez.Response) !void {
            res.json(.{ .message = "Request tracking active!" });
        }
    }.h);

    try app.listen("0.0.0.0:3000");
}
