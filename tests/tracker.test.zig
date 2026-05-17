const std = @import("std");
const tracker = @import("ziez_tracker");

test "buildSummary - basic fields"
{
    const summary = tracker.buildSummary(
        "req-001",
        "GET",
        "/api/users",
        200,
        12.5,
        null,
        1024,
        .{ .ua_parser_enabled = false },
    );
    try std.testing.expectEqualStrings("req-001", summary.req_id);
    try std.testing.expectEqualStrings("GET", summary.method);
    try std.testing.expectEqualStrings("/api/users", summary.path);
    try std.testing.expect(summary.status == 200);
    try std.testing.expect(summary.response_time_ms == 12.5);
    try std.testing.expect(summary.content_length != null);
    try std.testing.expect(summary.content_length.? == 1024);
}

test "buildSummary - without UA parser"
{
    const summary = tracker.buildSummary(
        "req-002",
        "POST",
        "/api/data",
        201,
        5.0,
        "Mozilla/5.0",
        null,
        .{ .ua_parser_enabled = false },
    );
    try std.testing.expect(summary.browser_name == null);
    try std.testing.expect(summary.os_name == null);
}

test "TrackerConfig defaults"
{
    const config = tracker.TrackerConfig{};
    try std.testing.expect(config.auto_request_log == false);
    try std.testing.expect(config.lifecycle_trace == false);
    try std.testing.expect(config.ua_parser_enabled == true);
}

test "RequestSummary fields"
{
    const summary = tracker.RequestSummary{
        .req_id = "r1",
        .method = "GET",
        .path = "/",
        .status = 200,
        .response_time_ms = 1.0,
    };
    try std.testing.expectEqualStrings("r1", summary.req_id);
    try std.testing.expect(summary.user_agent == null);
    try std.testing.expect(summary.content_length == null);
    try std.testing.expect(summary.browser_name == null);
}
