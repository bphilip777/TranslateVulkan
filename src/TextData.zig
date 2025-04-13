const std = @import("std");
const BitTricks = @import("BitTricks");
const cc = @import("..\\helpers\\codingCase.zig");
// assumes valid vulkan.zig or input file is valid zig code

const TextData = @This();
// const ExtensionName = @import("ExtensionName.zig");
// const EnumField = @import("EnumField.zig");

allo: std.mem.Allocator,
data: []const u8,
wfile: std.fs.File,

pub fn init(
    allo: std.mem.Allocator,
    rfilename: []const u8,
    wfilename: []const u8,
) !TextData {
    const rfile = try std.fs.cwd().openFile(rfilename, .{});
    defer rfile.close();

    const stat = try rfile.stat();

    const data = try allo.alloc(u8, stat.size);
    _ = try rfile.readAll(data);

    const wfile = try std.fs.cwd().createFile(wfilename, .{});

    return TextData{
        .allo = allo,
        .wfile = wfile,
        .data = data,
    };
}

pub fn deinit(self: *TextData) void {
    self.wfile.close();
    self.allo.free(self.data);
}

pub fn parse(self: *const TextData) !void {
    const data = self.data;
    const len = @as(u32, @truncate(data.len));
    const strs = [_][]const u8{ "pub", "const", ";", "{" };

    var i: u32 = 0;
    while (true) {
        const pub_idx = indexOf(data[i..], @truncate(strs[0].len), strs[0].ptr) orelse break;
        const start: u32 = i +% pub_idx;
        i = start +% @as(u32, @truncate(strs[0].len));

        const semicolon_idx = (indexOf(data[i..], @truncate(strs[2].len), strs[2].ptr) orelse len) +% @as(u32, @truncate(strs[2].len));
        const bracket_idx = (indexOf(data[i..], @truncate(strs[3].len), strs[3].ptr) orelse len) +% @as(u32, @truncate(strs[3].len));
        const min_idx = @min(semicolon_idx, bracket_idx);

        const end: u32 = i +% min_idx;
        i = end;

        const line = data[start..end];
        const line_type: LineType = determineLineType(line) catch continue;

        switch (line_type) {
            // .inline_fn => _ = try self.processInlineFn(start),
            .inline_vk_fn => _ = try self.processInlineVkFn(start),
            // .extern_fn => try self.processExternFn(start),
            // .extern_vk_fn => try self.processVkFn(start),
            //
            // .pfn => try self.processPFN(start),
            // .import => try self.processImport(start),
            // .@"opaque" => try self.processOpaque(start),
            // .extern_struct => try self.processExternStruct(start),
            // .@"enum" => try self.processEnum(start),
            else => continue,
        }

        break;
    }
}

const LineType = enum {
    inline_fn,
    inline_vk_fn,
    extern_fn,
    extern_vk_fn,

    pfn,
    import,
    @"opaque",
    extern_struct,
    @"enum",
};

fn determineLineType(line: []const u8) !LineType {
    var line_type: ?LineType = null;

    if (isInlineFn(line)) line_type = .inline_fn;
    if (isInlineVkFn(line)) line_type = try tagnameCollision(line_type, .inline_vk_fn);
    if (isExternFn(line)) line_type = try tagnameCollision(line_type, .extern_fn);
    if (isExternVkFn(line)) line_type = try tagnameCollision(line_type, .extern_vk_fn);

    if (isPubConst(line)) {
        const line1 = line[pub_const.len..line.len];
        if (isPFN(line1)) line_type = try tagnameCollision(line_type, .pfn);
        if (isImport(line1)) line_type = try tagnameCollision(line_type, .import);
        if (isOpaque(line1)) line_type = try tagnameCollision(line_type, .@"opaque");
        if (isExternStruct(line1)) line_type = try tagnameCollision(line_type, .extern_struct);
        if (isEnum(line1)) line_type = try tagnameCollision(line_type, .@"enum");
    }

    // TODO: remove this once all enum fields are filled out
    return line_type orelse error.UnidentifiedLineType;
}

fn tagnameCollision(line_type: ?LineType, new_linetype: LineType) !LineType {
    if (line_type) |lt| {
        std.debug.print("Collision: Line Type already assigned {s}:{s}\n", .{ @tagName(lt), @tagName(new_linetype) });
        return error.LineTypeAssignedTwice;
    }
    return new_linetype;
}

const pub_const = "pub const ";
fn isPubConst(line: []const u8) bool {
    return std.mem.startsWith(u8, line, pub_const) and !isInlineVkFn(line);
}

fn isInlineFn(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "pub inline fn");
}

fn isInlineVkFn(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "pub inline fn VK_");
}

fn isExternFn(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "pub extern fn") and !isExternVkFn(line);
}

fn isExternVkFn(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "pub extern fn vk");
}

fn isPFN(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "PFN_vk");
}

fn isImport(line: []const u8) bool {
    return std.mem.indexOf(u8, line, "@import") != null;
}

fn isOpaque(line: []const u8) bool {
    return std.mem.endsWith(u8, line, "opaque {};");
}

fn isExternStruct(line: []const u8) bool {
    return std.mem.endsWith(u8, line, "extern struct {");
}

fn isEnum(line: []const u8) bool {
    return std.mem.indexOf(u8, line, "enum_Vk") != null;
}

fn isType(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "Vk");
}

fn processInlineFn(self: *const TextData, start: u32) !u32 {
    // works
    const end = indexOf(self.data[start..], 1, "}").?;
    try self.write(self.data[start .. start +% end +% 1]);
    return end;
}

fn processInlineVkFn(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, "}").?;

    const data = self.data[start .. start +% end +% 1];
    const rdata = try std.mem.replaceOwned(u8, self.allo, data, "VK_", "");
    defer self.allo.free(rdata);
    try self.write(rdata);

    return end;
}

fn processExternFn(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, ";").?;
    try self.write(self.data[start .. start +% end +% 1]);
    return end;
}

fn processExternVkFn(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, ";").?;
    try self.write(self.data[start .. start +% end +% 1]);
    return end;
}

fn processPFN(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, ";").?;
    try self.write(self.data[start .. start +% end +% 1]);
    return end;
}

fn processVkFn(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, ";").?;
    try self.write(self.data[start .. start +% end +% 1]);
    return end;
}

fn processImport(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, ";").?;
    try self.write(self.data[start .. start +% end +% 1]);
    return end;
}

fn processOpaque(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, ";").?;
    try self.write(self.data[start .. start +% end +% 1]);
    return end;
}

fn processExternStruct(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], "}").?;
    try self.write(self.data[start .. start +% end +% 2]);
    return end;
}

fn processEnum(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], ";").?;
    try self.write(self.data[start .. start +% end +% 1]);
    return end;
}

fn processType(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], ";").?;
    try self.write(self.data[start .. start +% end +% 1]);
    return end;
}

fn indexOf(data: []const u8, comptime phrase_len: u32, phrase: [*]const u8) ?u32 {
    if (data.len == 0) unreachable;
    if (phrase_len < 1 or phrase_len > 255) unreachable;
    if (data.len < phrase_len) unreachable;
    if (data.len == phrase_len and std.mem.eql(u8, data, phrase[0..phrase_len])) return 0;

    var i: u32 = 0;
    const len: u32 = @truncate(data.len);
    const vphrase = @as(@Vector(phrase_len, u8), phrase[0..][0..phrase_len].*);

    if (len >= 64) {
        while (i +% 64 < len) : (i +%= 64) {
            const vdata_0 = @as(@Vector(64, u8), data[i..][0..64].*);

            const maybe_match = @as(u64, @bitCast(@as(@Vector(64, u8), @splat(phrase[0])) == vdata_0));
            if (maybe_match == 0) continue;

            const match: u32 = @as(u32, @truncate(BitTricks.indexOfRightmostBit(u64, maybe_match))) -% 1;
            const vdata_1 = @as(@Vector(phrase_len, u8), data[i +% match ..][0..phrase_len].*);

            if (@reduce(.And, vdata_1 == vphrase)) {
                return i +% match;
            }
        }
    } else if (i != len) {
        var temp: [64]u8 = undefined;
        @memcpy(temp[0 .. len -% i], data[i..len]);
        @memset(temp[len -% i .. 64], 0);

        const vdata_0 = @as(@Vector(64, u8), temp);

        const maybe_match = @as(u64, @bitCast(@as(@Vector(64, u8), @splat(phrase[0])) == vdata_0));
        if (maybe_match == 0) return null;

        const match: u32 = @as(u32, @truncate(BitTricks.indexOfRightmostBit(u64, maybe_match))) -% 1;
        if (match +% phrase_len > len) return null;
        const vdata_1 = @as(@Vector(phrase_len, u8), data[i +% match ..][0..phrase_len].*);

        if (@reduce(.And, vdata_1 == vphrase)) {
            return i +% match;
        }
    }

    return null;
}

inline fn write(self: *const TextData, line: []const u8) !void {
    _ = try self.wfile.write(line);
}
