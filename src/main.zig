const std = @import("std");
const print = std.debug.print;
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
    const exp_dir = "src/test/exp/";
    const ext = ".zig";

    const filepaths = [_][]const u8{
        "inline_fn_vk",
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
        // "compile_error",
        // "enum",
        // "flag1",
        // "flag2",
        // "type",
        // "type_vk",
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

        // load files to compare results
        const dfile = try std.fs.cwd().openFile(dst_path, .{});
        defer dfile.close();
        const ddata = try dfile.readToEndAlloc(allo, 1 * 1024 * 1024);
        defer allo.free(ddata);
        print("{s}\n", .{ddata});

        const exp_path = try std.fmt.allocPrint(allo, "{s}{s}{s}", .{ exp_dir, filepath, ext });
        defer allo.free(exp_path);
        const efile = try std.fs.cwd().openFile(exp_path, .{});
        defer efile.close();
        const edata = try efile.readToEndAlloc(allo, 1 * 1024 * 1024);
        defer allo.free(edata);
        print("{s}\n", .{edata});

        const match = std.mem.eql(u8, ddata, edata);

        print("Matches: {}\n", .{match});
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
        "extern",
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
        "opaque",
        "opaque_vk",
        "extern_union_vk",
        "extern_union",
        "extern_struct_vk",
        "extern_struct",
        "flag1",
        "flag2",
        "type",
        "unknown",
        "all",
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
