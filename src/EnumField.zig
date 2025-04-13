const std = @import("std");
const EnumField = @This();

name: []const u8,
value: []const u8,

pub fn init(allo: std.mem.Allocator, name: []const u8, value: []const u8) !EnumField {
    return EnumField{
        .name = try allo.dupe(u8, name),
        .value = try allo.dupe(u8, value),
    };
}

pub fn deinit(self: *EnumField, allo: std.mem.Allocator) void {
    allo.free(self.name);
    allo.free(self.value);
}
