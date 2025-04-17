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

    const src_dir = "src/test/src/";
    const dst_dir = "src/test/dst/";

    // const filepath = "inline_fn_vk.zig";
    // const filepath = "inline_fn.zig";
    // const filepath = "extern_fn_vk.zig";
    // const filepath = "extern_fn.zig";
    // const filepath = "extern_var.zig";
    // const filepath = "extern_const.zig";
    // const filepath = "export_var.zig";
    // const filepath = "fn.zig";
    // const filepath = "pfn.zig";
    // const filepath = "import.zig";
    // const filepath = "opaque.zig";
    // const filepath = "extern_struct_vk.zig";
    // const filepath = "extern_struct.zig";
    const filepath = "enum1.zig";
    // const filepath = "enum2.zig";

    const src_path = src_dir.* ++ filepath.*;
    const dst_path = dst_dir.* ++ filepath.*;

    var text = try TextData.init(allo, &src_path, &dst_path);
    defer text.deinit();
    try text.parse();
}
