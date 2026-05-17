const std = @import("std");
const ziez = @import("ziez");
const tracker = @import("tracker.zig");

pub const TrackerConfig = tracker.TrackerConfig;
pub const RequestSummary = tracker.RequestSummary;
pub const logRequestSummary = tracker.logRequestSummary;
pub const buildSummary = tracker.buildSummary;

/// Registers the request tracker on the app.
pub fn setup(app: *ziez.App, config: TrackerConfig) void {
    app.registerTracker(tracker.logRequestFn);
    if (config.lifecycle_trace) {
        app.router.lifecycle_trace = true;
    }
}
