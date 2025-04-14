const std = @import("std");
const BitTricks = @import("BitTricks");
const cc = @import("CodingCase");
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
    while (i < len) {
        if (len -% i < strs[0].len) break;
        const pub_idx = indexOf(data[i..], @truncate(strs[0].len), strs[0].ptr) orelse break;
        const start: u32 = i +% pub_idx;
        i = start +% @as(u32, @truncate(strs[0].len));

        const semicolon_idx = (indexOf(data[i..], @truncate(strs[2].len), strs[2].ptr) orelse len) +% @as(u32, @truncate(strs[2].len));
        const bracket_idx = (indexOf(data[i..], @truncate(strs[3].len), strs[3].ptr) orelse len) +% @as(u32, @truncate(strs[3].len));
        const min_idx = @min(semicolon_idx, bracket_idx);

        const end: u32 = i +% min_idx;
        i = end;

        const line = data[start..end];
        std.debug.print("{s}\n", .{line});
        // const line_type: LineType = try determineLineType(line);
        const line_type: LineType = determineLineType(line) orelse continue;
        std.debug.print("Line Type: {s}\n", .{@tagName(line_type)});

        i +%= switch (line_type) {
            .inline_fn => try self.processInlineFn(start),
            .inline_vk_fn => try self.processInlineVkFn(start),
            .extern_fn => try self.processExternFn(start),
            .extern_vk_fn => try self.processExternVkFn(start),
            .extern_var => try self.processExternVar(start),
            .@"fn" => try self.processFn(start),
            .extern_const => try self.processExternConst(start),
            .export_var => try self.processExportVar(start),

            .pfn => try self.processPFN(start),
            .import => try self.processImport(start),
            .@"opaque" => try self.processOpaque(start),
            .extern_struct => try self.processExternStruct(start),
            .enum1 => try self.processEnum1(start),
            .enum2 => try self.processEnum2(start),
            .base => try self.processBase(start),

            .skip => try self.processSkip(start),
        };
    }
}

const LineType = enum {
    inline_fn,
    inline_vk_fn,
    extern_fn,
    extern_vk_fn,
    extern_var,
    @"fn",
    extern_const,
    export_var,

    pfn,
    import,
    @"opaque",
    extern_struct,
    enum1,
    enum2,
    base,

    skip,
};

fn determineLineType(line: []const u8) ?LineType {
    if (isInlineFn(line)) return .inline_fn;
    if (isInlineVkFn(line)) return .inline_vk_fn;
    if (isExternFn(line)) return .extern_fn;
    if (isExternVkFn(line)) return .extern_vk_fn;
    if (isExternVar(line)) return .extern_var;
    if (isFn(line)) return .@"fn";
    if (isExternConst(line)) return .extern_const;
    if (isExportVar(line)) return .export_var;

    if (isPubConst(line)) {
        const line1 = line[pub_const.len..line.len];
        if (isPFN(line1)) return .pfn;
        if (isImport(line1)) return .import;
        if (isOpaque(line1)) return .@"opaque";
        if (isExternStruct(line1)) return .extern_struct;
        if (isSkip(line1)) return .skip;
        if (isEnum1(line1)) return .enum1;
        if (isEnum2(line1)) return .enum2;
        return .base;
    }

    return null;
}

const pub_const = "pub const ";
fn isPubConst(line: []const u8) bool {
    return std.mem.startsWith(u8, line, pub_const);
}

fn isInlineFn(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "pub inline fn") and !isInlineVkFn(line);
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

fn isExternVar(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "pub extern var");
}

fn isFn(line: []const u8) bool {
    // MarkAllocaS - example to check - two nested brackets
    return std.mem.startsWith(u8, line, "pub fn");
}

fn isExternConst(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "pub extern const");
}

fn isExportVar(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "pub export var");
}

fn isSkip(line: []const u8) bool {
    const eql_sign = std.mem.indexOfScalar(u8, line, ':') orelse return false;
    return cc.isCase(line[0..eql_sign], .screaming_snake) and std.mem.startsWith(u8, line, "VK_");
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

fn isEnum1(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "enum_Vk");
}

fn isEnum2(line: []const u8) bool {
    const eql_idx = (std.mem.indexOfScalar(u8, line, '=') orelse return false) - 1;
    const name = line[0..eql_idx];
    return std.mem.endsWith(u8, name, "2") and std.mem.endsWith(u8, line, "VkFlags64;");
}

fn isType(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "Vk");
}

fn processInlineFn(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, "}").?;
    const data = self.data[start .. start +% end +% 1];
    try self.write(data);
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
    const data = self.data[start .. start +% end +% 1];

    var rdata = try relaceVkStrs(self.allo, data);
    for (
        [_][]const u8{ " vk", "]Vk", " Vk" },
        [_][]const u8{ " ", "]", " " },
    ) |ostr, nstr| {
        const temp = try std.mem.replaceOwned(u8, self.allo, rdata, ostr, nstr);
        self.allo.free(rdata);
        rdata = temp;
    }

    // lowercase first letter of fn
    {
        const prefix = "pub extern fn ";
        rdata[prefix.len] = std.ascii.toLower(rdata[prefix.len]);
    }

    // change case
    var curr_idx = std.mem.indexOfScalar(u8, rdata, '(').?;

    while (true) {
        const colon_idx = std.mem.indexOfScalar(u8, rdata[curr_idx..], ':') orelse break;
        curr_idx +%= colon_idx +% 1;

        const prev_space_idx = std.mem.lastIndexOfScalar(u8, rdata[0..curr_idx], ' ') orelse 0;
        const prev_paren_idx = std.mem.lastIndexOfScalar(u8, rdata[0..curr_idx], '(') orelse 0;
        const max_idx = @max(prev_space_idx, prev_paren_idx) +% 1;
        const old_str = rdata[max_idx .. curr_idx -% 1];

        var new_len: u8 = @truncate(old_str.len);
        for (old_str[0 .. old_str.len - 1], old_str[1..old_str.len]) |ch1, ch2| {
            if (std.ascii.isLower(ch1) and std.ascii.isUpper(ch2)) new_len +%= 1;
        }
        if (new_len == 0) return error.StringTooShort;
        const new_data: []u8 = try self.allo.alloc(u8, new_len);
        defer self.allo.free(new_data);
        const new_str = cc.convert(new_data, old_str, .snake, .camel) catch |err| {
            std.debug.print("{s}\n", .{old_str});
            return err;
        };

        const temp = try std.mem.replaceOwned(u8, self.allo, rdata, old_str, new_str);
        self.allo.free(rdata);
        rdata = temp;
    }

    try self.write(rdata);
    return end;
}

fn processExternVar(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, ";").?;
    try self.write(self.data[start .. start +% end +% 1]);
    return end;
}

fn processFn(self: *const TextData, start: u32) !u32 {
    var temp_start = start;

    var open_paren: u32 = undefined;
    var close_paren: u32 = undefined;
    while (true) {
        open_paren = indexOf(self.data[temp_start..], 1, "{") orelse @truncate(self.data.len);
        close_paren = indexOf(self.data[temp_start..], 1, "}").?;
        if (close_paren < open_paren) break;
        temp_start = close_paren +% 1;
    }
    const end: u32 = temp_start +% close_paren;
    try self.write(self.data[start .. start +% end +% 1]);
    return end;
}

fn processExternConst(self: *const TextData, start: u32) !u32 {
    // TODO: consider using an enum
    const end = indexOf(self.data[start..], 1, ";").?;
    const data = self.data[start .. start +% end +% 1];
    try self.write(data);
    return end;
}

fn processExportVar(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, ";").?;
    const data = self.data[start .. start +% end +% 1];
    try self.write(data);
    return end;
}

fn processPFN(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, ";").?;
    const data = self.data[start .. start +% end +% 1];

    const rdata = try relaceVkStrs(self.allo, data);
    defer self.allo.free(rdata);

    // const prefix = "pub const PFN_";
    // rdata[prefix.len] = std.ascii.toLower(rdata[prefix.len]);

    try self.write(rdata);
    return end;
}

fn processImport(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, ";").?;
    try self.write(self.data[start .. start +% end +% 1]);
    return end;
}

fn processOpaque(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, ";").?;
    const data = self.data[start .. start +% end +% 1];

    var rdata = try relaceVkStrs(self.allo, data);
    defer self.allo.free(rdata);

    const eql_pos = std.mem.indexOfScalar(u8, rdata, '=').?;
    const name = rdata[pub_const.len .. eql_pos - 1];

    const str = try std.fmt.allocPrint(self.allo, "pub const {s} = enum(u64){{null=0, _}};\n", .{name});
    defer self.allo.free(str);

    try self.write(str);
    return end;
}

fn processExternStruct(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, "};").?;
    const data = self.data[start .. start +% end +% 1];
    try self.write(data);
    return end;
}

fn processEnum1(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, ";").?;
    const data = self.data[start .. start +% end +% 1];
    std.debug.print("{s}\n", .{data});

    var curr: u32 = start;
    while (true) {
        const prev_start: u32 = @truncate(std.mem.lastIndexOf(u8, data[0..curr], "pub const") orelse break);
        const prev_end: u32 = @truncate(std.mem.lastIndexOfScalar(u8, data[0..curr], ';') orelse break);
        if (prev_start >= prev_end) break;
        std.debug.print("{s}\n", .{self.data[prev_start..prev_end]});
        curr = prev_start;
    }

    try self.write(data);
    return end;
}

fn processEnum2(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, ";").?;
    const data = self.data[start .. start +% end +% 1];
    std.debug.print("{s}\n", .{data});
    return end;
}

fn processType(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, ";").?;
    const data = self.data[start .. start +% end +% 1];
    try self.write(data);
    return end;
}

fn processBase(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, ";").?;
    const data = self.data[start .. start +% end +% 1];
    try self.write(data);
    return end;
}

fn processSkip(self: *const TextData, start: u32) !u32 {
    const end = indexOf(self.data[start..], 1, ";").?;
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
    _ = try self.wfile.write("\n");
}

fn relaceVkStrs(allo: std.mem.Allocator, data: []const u8) ![]u8 {
    var rdata = try allo.dupe(u8, data);
    for (
        [_][]const u8{ " vk", "_vk", "]Vk", " Vk" },
        [_][]const u8{ " ", "_", "]", " " },
    ) |ostr, nstr| {
        const temp = try std.mem.replaceOwned(u8, allo, rdata, ostr, nstr);
        allo.free(rdata);
        rdata = temp;
    }
    return rdata;
}
