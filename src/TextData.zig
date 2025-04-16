const std = @import("std");
const builtin = @import("builtin");
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
    var start: usize = 0;
    var end: usize = 0;
    while (start < data.len) {
        end = start +% self.getEndOfCurrLine(start);
        const line = data[start..end];
        std.debug.print("Line: {s}\n", .{line});
        const linetype = determineLineType(line) orelse {
            start = end +% 1;
            continue;
        };
        std.debug.print("LineType: {s}\n", .{@tagName(linetype)});
        switch (linetype) {
            .inline_vk_fn => start = (try self.processInlineVkFn(start)) +% 1,
            .inline_fn => start = (try self.processInlineFn(start)) +% 1,
            .extern_vk_fn => start = (try self.processExternVkFn(start)) +% 1,
            .extern_fn => start = (try self.processExternFn(start)) +% 1,
            .extern_var => start = (try self.processExternVar(start)) +% 1,
            .extern_const => start = (try self.processExternConst(start)) +% 1,
            .export_var => start = (try self.processExportVar(start)) +% 1,
            .@"fn" => start = (try self.processFn(start)) +% 1,
            .pfn => start = (try self.processPFN(start)) +% 1,
            .import => start = (try self.processImport(start)) +% 1,
            .@"opaque" => start = (try self.processOpaque(start)) +% 1,
            .vk_extern_struct => start = (try self.processVkExternStruct(start)) +% 1,
            .extern_struct => start = (try self.processExternStruct(start)) +% 1,

            .skip => start = end +% 1,
            else => {},
        }
        std.debug.print("Start: {}\n", .{start});
        break;
    }
}

const LineType = enum {
    inline_vk_fn,
    inline_fn,

    extern_vk_fn,
    extern_fn,

    extern_var,
    extern_const,

    export_var,

    @"fn",
    pfn,
    import,
    @"opaque",

    vk_extern_struct,
    extern_struct,

    enum1,
    enum2,

    base,

    skip,
};

fn determineLineType(line: []const u8) ?LineType {
    const strs = [_][]const u8{ "pub", "const" };
    if (!std.mem.startsWith(u8, line, strs[0])) return null;

    const line1 = line[strs[0].len +% 1 .. line.len];
    if (isInlineVkFn(line1)) return .inline_vk_fn;
    if (isInlineFn(line1)) return .inline_fn;
    if (isExternVkFn(line1)) return .extern_vk_fn;
    if (isExternFn(line1)) return .extern_fn;
    if (isExternVar(line1)) return .extern_var;
    if (isFn(line1)) return .@"fn";
    if (isExternConst(line1)) return .extern_const;
    if (isExportVar(line1)) return .export_var;

    if (!std.mem.startsWith(u8, line1, strs[1])) return null;
    const line2 = line1[strs[1].len +% 1 .. line1.len];
    if (isPFN(line2)) return .pfn;
    if (isImport(line2)) return .import;
    if (isOpaque(line2)) return .@"opaque";
    if (isExternStruct(line2)) return .extern_struct;
    if (isSkip(line2)) return .skip;
    if (isEnum1(line2)) return .enum1;
    if (isEnum2(line2)) return .enum2;
    return .base;
}

fn isInlineVkFn(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "inline fn VK_");
}

fn isInlineFn(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "inline fn");
}

fn isExternVkFn(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "extern fn vk");
}

fn isExternFn(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "extern fn");
}

fn isExternVar(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "extern var");
}

fn isFn(line: []const u8) bool {
    // MarkAllocaS - example to check - two nested brackets
    return std.mem.startsWith(u8, line, "fn");
}

fn isExternConst(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "extern const");
}

fn isExportVar(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "export var");
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
    const newline = if (builtin.os.tag == .windows) std.mem.trimRight(u8, line, "\r\n") else line;
    return std.mem.endsWith(u8, newline, "opaque {};");
}

fn isVkExternStruct(line: []const u8) bool {
    const newline = if (builtin.os.tag == .windows) std.mem.trimRight(u8, line, "\r\n") else line;
    const startswith = std.mem.startsWith(u8, newline, "struct_Vk");
    const endswith = std.mem.endsWith(u8, newline, "extern struct {");
    return startswith and endswith;
}

fn isExternStruct(line: []const u8) bool {
    const newline = if (builtin.os.tag == .windows) std.mem.trimRight(u8, line, "\r\n") else line;
    return std.mem.endsWith(u8, newline, "extern struct {");
}

fn isEnum1(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "enum_Vk");
}

fn isEnum2(line: []const u8) bool {
    const newline = if (builtin.os.tag == .windows) std.mem.trimRight(u8, line, "\r\n") else line;
    const eql_idx = (std.mem.indexOfScalar(u8, newline, '=') orelse return false) - 1;
    const name = newline[0..eql_idx];
    const is_ver_2 = std.mem.endsWith(u8, name, "2");
    const is_flag_ver_2 = std.mem.endsWith(u8, newline, "VkFlags64;");
    return is_ver_2 and is_flag_ver_2;
}

fn isType(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "Vk");
}

fn processInlineVkFn(self: *const TextData, idx: usize) !usize {
    var start: usize = idx;
    {
        const line = self.getNextLine(start);
        start +%= line.len;

        // get title
        const title_end = std.mem.indexOfScalar(u8, line, '(').?;
        const title_start = std.mem.lastIndexOfScalar(u8, line[0..title_end], ' ').?;
        const old_title = line[title_start +% 1 .. title_end];
        const title = old_title[3..];

        // change title
        const new_title = try cc.convert(self.allo, title, .camel);
        defer self.allo.free(new_title);

        // write new title line
        const new_line = try std.mem.replaceOwned(u8, self.allo, line, old_title, new_title);
        defer self.allo.free(new_line);
        try self.write(new_line);
    }

    while (true) {
        const line = self.getNextLine(start);
        start +%= line.len;
        try self.write(line);
        if (std.mem.eql(u8, line, "}")) break;
    }

    return start;
}

fn processInlineFn(self: *const TextData, idx: usize) !usize {
    const len: usize = self.data.len;
    var start: usize = idx;
    while (start < len) {
        const line = self.getNextLine(start);
        start +%= line.len;
        try self.write(line);
        if (std.mem.eql(u8, line, "}")) break;
    }
    return start;
}

fn processExternVkFn(self: *const TextData, idx: usize) !usize {
    var start = idx;
    const line = self.getNextLine(start);
    start +%= line.len;

    var rline = try replaceVkStrs(self.allo, line);
    defer self.allo.free(rline);
    const prefix = "pub extern fn ";
    rline[prefix.len] = std.ascii.toLower(rline[prefix.len]);

    // change case
    var curr_idx = std.mem.indexOfScalar(u8, rline, '(').?;
    while (true) {
        const colon_idx = std.mem.indexOfScalar(u8, rline[curr_idx..], ':') orelse break;
        curr_idx +%= colon_idx +% 1;

        const prev_space_idx = std.mem.lastIndexOfScalar(u8, rline[0..curr_idx], ' ') orelse 0;
        const prev_paren_idx = std.mem.lastIndexOfScalar(u8, rline[0..curr_idx], '(') orelse 0;

        const max_idx = @max(prev_space_idx, prev_paren_idx) +% 1;
        const old_str = rline[max_idx .. curr_idx -% 1];
        const new_str = try cc.convert(self.allo, old_str, .snake);
        defer self.allo.free(new_str);

        const temp = try std.mem.replaceOwned(u8, self.allo, rline, old_str, new_str);
        self.allo.free(rline);
        rline = temp;
    }
    try self.write(rline);

    return start;
}

fn processExternFn(self: *const TextData, idx: usize) !usize {
    // TODO: write line as is, but needs to import data at top: const DWORD = std.os.windows.DWORD;
    var start = idx;
    const line = self.getNextLine(start);
    start +%= line.len;
    try self.write(line);
    return start;
}

fn processExternVar(self: *const TextData, idx: usize) !usize {
    // TODO: write line as is, but needs to import data at top: const DWORD = std.os.windows.DWORD;
    var start = idx;
    const line = self.getNextLine(start);
    start +%= line.len;
    try self.write(line);
    return start;
}

fn processExternConst(self: *const TextData, idx: usize) !usize {
    // TODO: write line as is, but needs to import data at top: const DWORD = std.os.windows.DWORD;
    var start = idx;
    const line = self.getNextLine(start);
    start +%= line.len;
    try self.write(line);
    return start;
}

fn processExportVar(self: *const TextData, idx: usize) !usize {
    // TODO: write line as is, but need to import data at top;
    var start = idx;
    const line = self.getNextLine(start);
    start +%= line.len;
    try self.write(line);
    return start;
}

fn processFn(self: *const TextData, idx: usize) !usize {
    var start: usize = idx;
    while (true) {
        const line = self.getNextLine(start);
        start +%= line.len;
        try self.write(line);
        if (std.mem.eql(u8, line, "}")) break;
    }
    return start;
}

fn processPFN(self: *const TextData, idx: usize) !usize {
    var start = idx;
    const line = self.getNextLine(start);
    start +%= line.len;

    var rline = try replaceVkStrs(self.allo, line);
    defer self.allo.free(rline);
    const prefix = "pub extern fn ";
    rline[prefix.len] = std.ascii.toLower(rline[prefix.len]);

    // change case
    var curr_idx = std.mem.indexOfScalar(u8, rline, '(').?;
    while (true) {
        const colon_idx = std.mem.indexOfScalar(u8, rline[curr_idx..], ':') orelse break;
        curr_idx +%= colon_idx +% 1;

        const prev_space_idx = std.mem.lastIndexOfScalar(u8, rline[0..curr_idx], ' ') orelse 0;
        const prev_paren_idx = std.mem.lastIndexOfScalar(u8, rline[0..curr_idx], '(') orelse 0;

        const max_idx = @max(prev_space_idx, prev_paren_idx) +% 1;
        const old_str = rline[max_idx .. curr_idx -% 1];
        const new_str = try cc.convert(self.allo, old_str, .snake);
        defer self.allo.free(new_str);

        const temp = try std.mem.replaceOwned(u8, self.allo, rline, old_str, new_str);
        self.allo.free(rline);
        rline = temp;
    }
    try self.write(rline);

    return start;
}

fn processImport(self: *const TextData, idx: usize) !usize {
    var start = idx;
    const line = self.getNextLine(start);
    start +%= line.len;
    try self.write(line);
    return start;
}

fn processOpaque(self: *const TextData, idx: usize) !usize {
    var start = idx;
    const line = self.getNextLine(start);
    start +%= line.len;
    const line1 = self.getNextLine(start);
    start +%= line1.len;

    const prefix = "pub const ";
    const space_idx = std.mem.indexOfScalar(u8, line1[prefix.len..], ' ').?;
    const name = line1[prefix.len .. prefix.len +% space_idx];

    const line2 = try std.fmt.allocPrint(self.allo, "pub const {s} = enum(u64){{ null=0, _ }};\n", .{name});
    defer self.allo.free(line2);
    try self.write(line2);

    return start;
}

fn processVkExternStruct(self: *const TextData, idx: usize) !usize {
    var start = idx;
    { // title
        const line = self.getNextLine(start);
        start +%= line.len;
    }

    // body
    while (true) {
        const line = self.getNextLine(start);
        start +%= line.len;
        if (std.mem.eql(u8, line, "}")) break;

        const rline = try replaceVkStrs(self.allo, line);
        defer self.allo.free(rline);
        try self.write(rline);
    }

    return start;
}

// fn processExternStruct(self: *const TextData, idx: usize) !usize {
//     var start = idx;
//     {
//         const line = self.getNextLine(start);
//         start +%= line.len;
//         try self.write(line);
//     }
//
//     while (true) {
//         const line = self.getNextLine(start);
//         start +%= line.len;
//     }
//
//     return start;
// }

// fn processEnum1(self: *const TextData, start: u32) !u32 {
//     std.debug.print("Inside Enum 1\n", .{});
//
//     const end = self.getNextNewLine(start);
// const line = self.getNextLine(start, end);
//     const data = self.data[start..end];
//     std.debug.print("Data: {s}\n", .{data});
//
//     // extract title
//     const next_start = end +% 1;
//     const next_end = self.getNextNewLine(next_start);
//     const next_data = self.data[next_start..next_end];
//     std.debug.print("Next Data: {s}\n", .{next_data});
//
//     const curr_end: u32 = start -% 1;
//     while (true) {
//         const prev_start = self.getStartOfPrevLine(curr_end);
//         const line =
//         std.debug.print("Line: {s}\n", .{line});
//
//         const semicolon_idx = std.mem.indexOfScalar(u8, line, ':') orelse break;
//         const screaming_snake_name = line[0..semicolon_idx];
//         if (!cc.isCase(screaming_snake_name, .screaming_snake)) break;
//         std.debug.print("Screaming Snake Name: {s}\n", .{screaming_snake_name});
//
//         const snake_name = try self.allo.alloc(u8, screaming_snake_name.len);
//         defer self.allo.free(snake_name);
//         _ = try cc.convert(snake_name, screaming_snake_name, .snake, .screaming_snake);
//         std.debug.print("Snake Name: {s}\n", .{snake_name});
//
//         break;
//     }
//
//     // var curr: u32 = start;
//     // while (true) {
//     //     const prev_start: u32 = @truncate(std.mem.lastIndexOf(u8, data[0..curr], "pub const") orelse break);
//     //     const prev_end: u32 = @truncate(std.mem.lastIndexOfScalar(u8, data[0..curr], ';') orelse break);
//     //     if (prev_start >= prev_end) break;
//     //     std.debug.print("{s}\n", .{self.data[prev_start..prev_end]});
//     //     curr = prev_start;
//     // }
//
//     try self.write(data);
//     return len;
// }

// fn processEnum2(self: *const TextData, start: u32) !u32 {
//     const end = self.getEndOfCurrLine(start);
//     const line = self.data[start..end];
// const line = self.getNextLine(start, end);
//     std.debug.print("{s}\n", .{line});
//     return end;
// }
//
// fn processType(self: *const TextData, start: u32) !u32 {
//     const end = self.getEndOfCurrLine(start);
//     const line = self.data[start..end];
// const line = self.getNextLine(start, end);
//     try self.write(line);
//     return end;
// }
//
// fn processBase(self: *const TextData, start: u32) !u32 {
//     const end = self.getEndOfCurrLine(start);
//     const line = self.data[start..end];
// const line = self.getNextLine(start, end);
//     try self.write(line);
//     return end;
// }

inline fn write(self: *const TextData, line: []const u8) !void {
    _ = try self.wfile.write(line);
    _ = try self.wfile.write("\n");
}

fn replaceVkStrs(allo: std.mem.Allocator, data: []const u8) ![]u8 {
    var rdata = try allo.dupe(u8, data);
    for ([_][]const u8{ " vk", "_vk", "]Vk", " Vk" }) |str| {
        const temp = try std.mem.replaceOwned(u8, allo, rdata, str, str[0..1]);
        allo.free(rdata);
        rdata = temp;
    }
    return rdata;
}

fn getEndOfCurrLine(self: *const TextData, start: usize) usize {
    return std.mem.indexOfScalar(u8, self.data[start..], '\n') orelse self.data.len;
}

fn getStartOfPrevLine(self: *const TextData, start: usize) usize {
    return std.mem.lastIndexOfScalar(u8, self.data[0..start], '\n') orelse 0;
}

fn getNextLine(self: *const TextData, start: usize) []const u8 {
    const end = start +% self.getEndOfCurrLine(start);
    return if (builtin.os.tag == .windows) std.mem.trimRight(u8, self.data[start..end], "\r\n") else self.data[start..end];
}
