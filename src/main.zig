const std = @import("std");
const TextData = @import("TextData.zig");

// pub fn main() !void {
//     var da = std.heap.DebugAllocator(.{}){};
//     const allo = da.allocator();
//     defer std.debug.assert(.ok == da.deinit());
//
//     const src_path = "src/translated_vulkan.zig";
//     const dst_path = "src/vulkan.zig";
//
//     var text = try TextData.init(allo, src_path, dst_path);
//     defer text.deinit();
//     try text.parse();
// }

pub fn main() !void {
    var da = std.heap.DebugAllocator(.{}){};
    const allo = da.allocator();
    defer std.debug.assert(.ok == da.deinit());

    const src_dir = "src/test/src/";
    const dst_dir = "src/test/dst/";
    const ext = ".zig";

    const filepaths = [_][]const u8{
        // "inline_fn_vk",
        // "inline_fn",
        // "extern",
        // "extern_fn_vk",
        // "extern_fn",
        // "extern_var",
        // "extern_const",
        // "export_var",
        // "fn",
        // "extension_name",
        // "spec_version",
        // "type_name",
        // "pfn",
        // "import",
        // "opaque",
        // "opaque_vk",
        // "extern_union_vk",
        // "extern_union",
        // "extern_struct_vk",
        // "extern_struct",
        // "flag1",
        // "flag2",
        // "type",
        // "unknown",
        // "all",
    };

    for (filepaths) |filepath| {
        const src_path = try std.fmt.allocPrint(allo, "{s}{s}{s}", .{ src_dir, filepath, ext });
        defer allo.free(src_path);

        const dst_path = try std.fmt.allocPrint(allo, "{s}{s}{s}", .{ dst_dir, filepath, ext });
        defer allo.free(dst_path);

        var text = try TextData.init(allo, src_path, dst_path);
        defer text.deinit();
        try text.parse();
    }
}

test "Parse different text files" {
    const allo = std.testing.allocator;

    const src_dir = "src/test/src/";
    const dst_dir = "src/test/dst/";
    const ext = ".zig";

    const filepaths = [_][]const u8{
        "inline_fn_vk",
        "inline_fn",
        "extern_fn_vk",
        "extern_fn",
        "extern_var",
        "extern_const",
        "export_var",
        "fn",
        "extension_name",
        "spec_version",
        "type_name",
        "pfn",
        "import",
        "opaque_vk",
        "opaque",
        "extern_struct_vk",
        "extern_struct",
        "enum1",
        "enum2",
        "type",
    };

    for (filepaths) |filepath| {
        const src_path = try std.fmt.allocPrint(allo, "{s}{s}{s}", .{ src_dir, filepath, ext });
        defer allo.free(src_path);

        const dst_path = try std.fmt.allocPrint(allo, "{s}{s}{s}", .{ dst_dir, filepath, ext });
        defer allo.free(dst_path);

        var text = try TextData.init(allo, src_path, dst_path);
        defer text.deinit();
        try text.parse();
    }

    try std.testing.expect(true);
}
