const std = @import("std");
const TextData = @import("TextData.zig");

pub fn main() !void {
    var da = std.heap.DebugAllocator(.{}){};
    const allo = da.allocator();
    defer std.debug.assert(.ok == da.deinit());

    const dirpath = "src/test/src";
    const dir = try std.fs.cwd().openDir(dirpath, .{ .iterate = true });

    var walker = try dir.walk(allo);
    defer walker.deinit();

    var filenames = std.ArrayList([]const u8).init(allo);
    defer filenames.deinit();
    defer for (filenames.items) |filename| allo.free(filename);

    // while (try walker.next()) |item| {
    //     if (!std.mem.startsWith(u8, item.basename, "vulkan_")) continue;
    //     const new_name = try allo.dupe(u8, item.basename);
    //     try filenames.append(new_name);
    // }
    //
    // for (filenames.items) |filename| {
    //     const src_filepath = try std.fmt.allocPrint(allo, "{s}/{s}", .{ dirpath, filename });
    //     defer allo.free(src_filepath);
    //
    //     const dst_filepath = try std.fmt.allocPrint(allo, "{s}/{s}_{s}", .{ dirpath, "parsed", filename });
    //     defer allo.free(dst_filepath);
    //
    //     var text = try TextData.init(allo, src_filepath, dst_filepath);
    //     defer text.deinit();
    //     try text.parse();
    // }

    const src_filepath = "src/test/src/vulkan_inline_vk_fn.zig";
    const dst_filepath = "src/test/dst/vulkan_inline_vk_fn.zig";
    // const src_filepath = "src/test/src/vulkan_inline_fn.zig";
    // const dst_filepath = "src/test/dst/vulkan_inline_fn.zig";
    var text = try TextData.init(allo, src_filepath, dst_filepath);
    defer text.deinit();
    try text.parse();
}
