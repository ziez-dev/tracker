# ziez-tracker

Request logging with UA parsing for [ziez](https://github.com/ziez-dev/ziez).

## Requirements

- Zig 0.16.0+

## Installation

In `build.zig.zon`:

```zig
.dependencies = .{
    .ziez = .{
        .url = "https://github.com/ziez-dev/ziez/archive/refs/tags/v0.0.1.tar.gz",
        .hash = "ziez-0.0.1-zH20Gh1jAwADi2a_88hnfVHclInMW1YPLF_y7SS7CJ5Y",
    },
    .@"ziez-ua-parser" = .{
        .url = "https://github.com/ziez-dev/ua-parser/archive/refs/tags/v0.0.1.tar.gz",
        .hash = "ziez_ua_parser-0.0.1-oBQnYjkdMwAeXfqkHP8HfJTYksqLL5lKkvhrIyqyGFtw",
    },
    .@"ziez-tracker" = .{
        .url = "https://github.com/ziez-dev/tracker/archive/refs/tags/v0.0.1.tar.gz",
        .hash = "1220b1fe03d61a1cc83ee28e918e1a2e4f0e0d6d1e23844e0c0e28194a8bbbe9d2e8",
    },
},
```

In `build.zig`:

```zig
const tracker_dep = b.dependency("ziez-tracker", .{
    .target = target,
    .optimize = optimize,
});
exe_mod.addImport("ziez_tracker", tracker_dep.module("ziez-tracker"));
```

## Quick Start

```zig
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

    try app.listen( "0.0.0.0:3000");
}
```

## Configuration

**TrackerConfig:**

| Option | Type | Default | Description |
|---|---|---|---|
| `auto_request_log` | `bool` | `false` | Automatically log every request |
| `lifecycle_trace` | `bool` | `false` | Enable request lifecycle tracing |
| `ua_parser_enabled` | `bool` | `true` | Enable User-Agent parsing |

## Known Issue — Arch Linux

This plugin depends on [ziez-ua-parser](https://github.com/ziez-dev/ua-parser) which uses PCRE2 C bindings. On Arch Linux, building with the default glibc target fails. Use the MUSL target instead:

```bash
zig build -Dtarget=native-native-musl
zig build test -Dtarget=native-native-musl --summary all
```

## License

MIT — Note: the [ziez-ua-parser](https://github.com/ziez-dev/ua-parser) dependency is licensed under AGPL-3.0.
