const std = @import("std");
const cc = @import("..\\helpers\\codingCase.zig");

const TextData = @This();
const ExtensionName = @import("ExtensionName.zig");
const EnumField = @import("EnumField.zig");

allo: std.mem.Allocator,
data: []const u8,
wfilename: []const u8,

pub fn init(
    allo: std.mem.Allocator,
    rfilename: []const u8,
    wfilename: []const u8,
) !TextData {
    var rfile = try std.fs.cwd().openFile(rfilename, .{});
    defer rfile.close();

    const stat = try rfile.stat();

    const data = try allo.alloc(u8, stat.size);
    _ = try rfile.readAll(data);

    return TextData{
        .allo = allo,
        .wfilename = wfilename,
        .data = data,
    };
}

pub fn deinit(self: *TextData) void {
    self.allo.free(self.data);
}

pub fn parse(self: *const TextData) void {
    const data = self.data;

    var i: u32 = 0;
    const len: u32 = @truncate(self.data.len);
    while (i < len) : (i += 64) {
        const vdata = @as(@Vector(64, u8), data[i..][0..64].*);

        var has_pub: u64 = @as(u64, 0) -% @as(u64, 1);
        for ("pub", 0..) |ch, j| {
            has_pub &= (@as(u64, @bitCast(@as(@Vector(64, u8), @splat(ch)) == vdata)) >> @truncate(j));
        }

        if (has_pub > 0) {
            std.debug.print("{s}\n", .{data[i..][0..64]});
            break;
        }

        // var is_const: u64 = 0 -% 1;
        // for ("const", 0..) |ch, j| {
        //     is_const &= (@as(u64, @bitCast(@as(@Vector(64, u8), @splat(ch)) == vdata)) >> @truncate(j));
        // }
    }
}
