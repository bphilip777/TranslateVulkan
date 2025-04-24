const std = @import("std");
const trimRight = std.mem.trimRight;
const builtin = @import("builtin");

pub const newline_chars = if (builtin.os.tag == .windows) "\r\n" else "\n";

pub inline fn trimLine(data: []const u8) []const u8 {
    return trimRight(u8, data, newline_chars);
}
