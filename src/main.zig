const std = @import("std");
const TextData = @import("TextData.zig");

pub fn main() !void {
    var da = std.heap.DebugAllocator(.{}){};
    const allo = da.allocator();
    defer std.debug.assert(.ok == da.deinit());

    var text = try TextData.init(allo, "src/vulkan.zig", "src/vulkan2.zig");
    defer text.deinit();
    try text.parse();
}
