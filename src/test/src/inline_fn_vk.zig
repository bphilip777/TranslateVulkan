pub inline fn VK_MAKE_API_VERSION(variant: anytype, major: anytype, minor: anytype, patch: anytype) @TypeOf((((@import("std").zig.c_translation.cast(u32, variant) << @as(c_uint, 29)) | (@import("std").zig.c_translation.cast(u32, major) << @as(c_uint, 22))) | (@import("std").zig.c_translation.cast(u32, minor) << @as(c_uint, 12))) | @import("std").zig.c_translation.cast(u32, patch)) {
    _ = &variant;
    _ = &major;
    _ = &minor;
    _ = &patch;
    return (((@import("std").zig.c_translation.cast(u32, variant) << @as(c_uint, 29)) | (@import("std").zig.c_translation.cast(u32, major) << @as(c_uint, 22))) | (@import("std").zig.c_translation.cast(u32, minor) << @as(c_uint, 12))) | @import("std").zig.c_translation.cast(u32, patch);
}
