const std = @import("std");
const TextData = @import("TextData.zig");

pub fn main() !void {
    var da = std.heap.DebugAllocator(.{}){};
    const allo = da.allocator();
    defer std.debug.assert(.ok == da.deinit());

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
    // const filepath = "enum1.zig";
    // const filepath = "enum2.zig";
    // const filepath = "extension_name.zig";
    // const filepath = "spec_version.zig";
    const filepath = "type_name.zig";
    // const filepath = "type.zig";

    const src_path = src_dir.* ++ filepath.*;
    const dst_path = dst_dir.* ++ filepath.*;

    var text = try TextData.init(allo, &src_path, &dst_path);
    defer text.deinit();
    try text.parse();
}
