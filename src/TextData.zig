const std = @import("std");

const builtin = @import("builtin");
const newline_chars = if (builtin.os.tag == .windows) "\r\n" else "\n";

const BitTricks = @import("BitTricks");
const cc = @import("CodingCase");
const NameValue = @import("NameValue.zig");

const TextData = @This();

allo: std.mem.Allocator,
data: []const u8,
wfile: std.fs.File,

type_names: std.ArrayList(NameValue),
extension_names: std.ArrayList(NameValue),
spec_versions: std.ArrayList(NameValue),

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

        .type_names = std.ArrayList(NameValue).init(allo),
        .extension_names = std.ArrayList(NameValue).init(allo),
        .spec_versions = std.ArrayList(NameValue).init(allo),
    };
}

pub fn deinit(self: *TextData) void {
    self.wfile.close();
    self.allo.free(self.data);

    if (self.type_names.items.len > 0) {
        for (self.type_names.items) |tn| {
            self.allo.free(tn.name);
            self.allo.free(tn.value);
        }
    }
    self.type_names.deinit();

    if (self.extension_names.items.len > 0) {
        for (self.extension_names.items) |en| {
            self.allo.free(en.name);
            self.allo.free(en.value);
        }
    }
    self.extension_names.deinit();

    if (self.spec_versions.items.len > 0) {
        for (self.spec_versions.items) |sv| {
            self.allo.free(sv.name);
            self.allo.free(sv.value);
        }
    }
    self.spec_versions.deinit();
}

pub fn parse(self: *TextData) !void {
    var start: usize = 0;
    while (true) {
        const line = self.getNextLine(start);
        start +%= line.len +% newline_chars.len;
        std.debug.print("Line: {s}\n", .{line});

        const linetype = determineLineType(line) orelse continue;
        std.debug.print("LineType: {s}\n", .{@tagName(linetype)});
        switch (linetype) {
            .inline_fn_vk => start = (try self.processInlineFnVk(start)) +% 1,
            .inline_fn => start = (try self.processInlineFn(start)) +% 1,
            .extern_fn_vk => start = (try self.processExternFnVk(start)) +% 1,
            .extern_fn => start = (try self.processExternFn(start)) +% 1,
            .extern_var => start = (try self.processExternVar(start)) +% 1,
            .extern_const => start = (try self.processExternConst(start)) +% 1,
            .export_var => start = (try self.processExportVar(start)) +% 1,
            .@"fn" => start = (try self.processFn(start)) +% 1,

            .type_name => try self.processTypeName(start),
            .extension_name => try self.processExtensionName(start),
            .spec_version => try self.processSpecVersion(start),

            .pfn => start = (try self.processPFN(start)) +% 1,
            .import => start = (try self.processImport(start)) +% 1,
            .@"opaque" => start = (try self.processOpaque(start)) +% 1,
            .extern_struct_vk => start = (try self.processExternStructVk(start)) +% 1,
            .extern_struct => start = (try self.processExternStruct(start)) +% 1,
            .enum1 => start = (try self.processEnum1(start)) +% 1,
            .enum2 => start = (try self.processEnum2(start)) +% 1,

            .skip => continue,
            else => {},
        }
        break;
    }

    if (self.type_names.items.len > 0) try self.writeTypeNames();
    if (self.extension_names.items.len > 0) try self.writeExtensionNames();
    if (self.spec_versions.items.len > 0) try self.writeSpecVersions();
}

const LineType = enum {
    inline_fn_vk,
    inline_fn,
    extern_fn_vk,
    extern_fn,
    extern_var,
    extern_const,
    export_var,
    @"fn",

    type_name,
    extension_name,
    spec_version,
    pfn,
    import,
    @"opaque",
    extern_struct_vk,
    extern_struct,
    enum1,
    enum2,
    type,

    base,
    skip,
};

fn determineLineType(line: []const u8) ?LineType {
    const strs = [_][]const u8{ "pub", "const" };
    if (!std.mem.startsWith(u8, line, strs[0])) return null;

    const line1 = line[strs[0].len +% 1 .. line.len];
    if (isInlineFnVk(line1)) return .inline_fn_vk;
    if (isInlineFn(line1)) return .inline_fn;
    if (isExternFnVk(line1)) return .extern_fn_vk;
    if (isExternFn(line1)) return .extern_fn;
    if (isExternVar(line1)) return .extern_var;
    if (isFn(line1)) return .@"fn";
    if (isExternConst(line1)) return .extern_const;
    if (isExportVar(line1)) return .export_var;

    if (!std.mem.startsWith(u8, line1, strs[1])) return null;
    const line2 = line1[strs[1].len +% 1 .. line1.len];
    if (isTypeName(line2)) return .type_name;
    if (isExtensionName(line2)) return .extension_name;
    if (isSpecVersion(line2)) return .spec_version;
    if (isPFN(line2)) return .pfn;
    if (isImport(line2)) return .import;
    if (isOpaque(line2)) return .@"opaque";
    if (isExternStructVk(line2)) return .extern_struct_vk;
    if (isExternStruct(line2)) return .extern_struct;
    if (isSkip(line2)) return .skip;
    if (isEnum1(line2)) return .enum1;
    if (isEnum2(line2)) return .enum2;
    if (isType(line2)) return .type;
    return .base;
}

fn isInlineFnVk(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "inline fn VK_");
}

fn isInlineFn(line: []const u8) bool {
    return std.mem.startsWith(u8, line, "inline fn");
}

fn isExternFnVk(line: []const u8) bool {
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

fn isTypeName(line: []const u8) bool {
    const eql_idx = std.mem.indexOfScalar(u8, line, '=').?;
    const name = line[0..eql_idx];
    const semicolon_idx = std.mem.lastIndexOfScalar(u8, line, ';').?;
    const value = line[eql_idx +% 1 .. semicolon_idx];
    return cc.isCase(name, .screaming_snake) and std.mem.startsWith(u8, value, "@as(");
}

fn isExtensionName(line: []const u8) bool {
    const space_idx = std.mem.indexOfScalar(u8, line, ' ').?;
    const name = line[0..space_idx];
    return std.mem.endsWith(u8, name, "_EXTENSION_NAME");
}

fn isSpecVersion(line: []const u8) bool {
    const space_idx = std.mem.indexOfScalar(u8, line, ' ').?;
    const name = line[0..space_idx];
    return std.mem.endsWith(u8, name, "_SPEC_VERSION");
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

fn isExternStructVk(line: []const u8) bool {
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
    const types = [_][]const u8{ "u32;", "u64;" };
    for (types) |t| if (std.mem.endsWith(u8, line, t)) return true;
    return false;
}

fn processInlineFnVk(self: *const TextData, idx: usize) !usize {
    var start: usize = idx;
    {
        const line = self.getNextLine(start);
        start +%= line.len +% newline_chars.len;

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
        start +%= line.len +% newline_chars.len;
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
        start +%= line.len +% newline_chars.len;
        try self.write(line);
        if (std.mem.eql(u8, line, "}")) break;
    }
    return start;
}

fn processExternFnVk(self: *const TextData, idx: usize) !usize {
    var start = idx;
    const line = self.getNextLine(start);
    start +%= line.len +% newline_chars.len;

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
    start +%= line.len +% newline_chars.len;
    try self.write(line);
    return start;
}

fn processExternVar(self: *const TextData, idx: usize) !usize {
    // TODO: write line as is, but needs to import data at top: const DWORD = std.os.windows.DWORD;
    var start = idx;
    const line = self.getNextLine(start);
    start +%= line.len +% newline_chars.len;
    try self.write(line);
    return start;
}

fn processExternConst(self: *const TextData, idx: usize) !usize {
    // TODO: write line as is, but needs to import data at top: const DWORD = std.os.windows.DWORD;
    var start = idx;
    const line = self.getNextLine(start);
    start +%= line.len +% newline_chars.len;
    try self.write(line);
    return start;
}

fn processExportVar(self: *const TextData, idx: usize) !usize {
    // TODO: write line as is, but need to import data at top;
    var start = idx;
    const line = self.getNextLine(start);
    start +%= line.len +% newline_chars.len;
    try self.write(line);
    return start;
}

fn processFn(self: *const TextData, idx: usize) !usize {
    var start: usize = idx;
    while (true) {
        const line = self.getNextLine(start);
        start +%= line.len +% newline_chars.len;
        try self.write(line);
        if (std.mem.eql(u8, line, "}")) break;
    }
    return start;
}

fn processTypeName(self: *TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);

    const screaming_snake_name = blk: {
        const eql_idx = std.mem.indexOfScalar(u8, line, '=').? -% 1;
        const space_idx = std.mem.lastIndexOfScalar(u8, line[0..eql_idx], ' ').? +% 1;
        const name = line[space_idx..eql_idx];
        break :blk try self.allo.dupe(u8, name);
    };
    defer self.allo.free(screaming_snake_name);

    const tss_name = try replaceVkStrs(self.allo, screaming_snake_name);
    defer self.allo.free(tss_name);

    const snake_name = try cc.convert(self.allo, tss_name, .snake);
    defer self.allo.free(snake_name);

    const type_name = blk: {
        const open_paren_idx = std.mem.lastIndexOfScalar(u8, line, '(').? +% 1;
        const comma_idx = std.mem.lastIndexOfScalar(u8, line, ',').?;
        const type_name = line[open_paren_idx..comma_idx];
        break :blk try self.allo.dupe(u8, type_name);
    };
    defer self.allo.free(type_name);

    const new_field_name = try std.fmt.allocPrint(self.allo, "{s}: {s}", .{ snake_name, type_name });

    const new_field_value = blk: {
        const close_paren_idx = std.mem.lastIndexOfScalar(u8, line, ')').?;
        const space_idx = std.mem.lastIndexOfScalar(u8, line, ' ').? +% 1;
        const value = line[space_idx..close_paren_idx];
        break :blk try self.allo.dupe(u8, value);
    };

    try self.type_names.append(.{
        .name = new_field_name,
        .value = new_field_value,
    });
}

fn writeTypeNames(self: *const TextData) !void {
    try self.write("pub const TypeName = struct {");
    for (self.type_names.items) |tn| {
        const newline = try std.fmt.allocPrint(self.allo, "{s} = {s},", .{ tn.name, tn.value });
        defer self.allo.free(newline);
        try self.write(newline);
    }
    try self.write("};");
}

fn processExtensionName(self: *TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);

    const screaming_snake_name = blk: {
        const eql_idx = std.mem.indexOfScalar(u8, line, '=').? -% 1;
        const space_idx = std.mem.lastIndexOfScalar(u8, line[0..eql_idx], ' ').? +% 1;
        const name = line[space_idx..eql_idx];
        break :blk try self.allo.dupe(u8, name);
    };
    defer self.allo.free(screaming_snake_name);

    const trim_vk_prefix = try replaceVkStrs(self.allo, screaming_snake_name);
    defer self.allo.free(trim_vk_prefix);

    const suffix = "_EXTENSION_NAME";
    const trim_ext_suffix = trim_vk_prefix[0 .. trim_vk_prefix.len -% suffix.len];

    const new_field_name = try cc.convert(self.allo, trim_ext_suffix, .snake);

    const new_field_value = blk: {
        const semicolon_idx = std.mem.lastIndexOfScalar(u8, line, ';').?;
        const space_idx = std.mem.lastIndexOfScalar(u8, line[0..semicolon_idx], ' ').? +% 1;
        const value = line[space_idx..semicolon_idx];
        break :blk try self.allo.dupe(u8, value);
    };

    try self.extension_names.append(.{
        .name = new_field_name,
        .value = new_field_value,
    });
}

fn writeExtensionNames(self: *const TextData) !void {
    try self.write("pub const ExtensionNames = struct {");
    for (self.extension_names.items) |en| {
        const newline = try std.fmt.allocPrint(
            self.allo,
            "{s}:{s},",
            .{ en.name, en.value },
        );
        defer self.allo.free(newline);
        try self.write(newline);
    }
    try self.write("};");
}

fn processSpecVersion(self: *TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);
    // std.debug.print("Line: {s}\n", .{line});

    const snake_name = blk: {
        const eql_idx = std.mem.indexOfScalar(u8, line, '=').? -% 1;
        const space_idx = std.mem.lastIndexOfScalar(u8, line[0..eql_idx], ' ').? +% 1;
        const name = line[space_idx..eql_idx];
        break :blk try cc.convert(self.allo, name, .snake);
    };
    defer self.allo.free(snake_name);

    const trim_vk_prefix = try replaceVkStrs(self.allo, snake_name);
    defer self.allo.free(trim_vk_prefix);

    const suffix = "_SPEC_VERSION";
    const trim_suffix = trim_vk_prefix[0 .. trim_vk_prefix.len -% suffix.len];

    const field_name = try self.allo.dupe(u8, trim_suffix);
    defer self.allo.free(field_name);

    const field_type = blk: {
        const open_paren_idx = std.mem.lastIndexOfScalar(u8, line, '(').? +% 1;
        const comma_idx = std.mem.lastIndexOfScalar(u8, line, ',').?;
        const type_name = line[open_paren_idx..comma_idx];
        const type_name2 = if (std.mem.eql(u8, type_name, "c_int")) "i32" else if (std.mem.eql(u8, type_name, "c_uint")) "u32" else unreachable;
        break :blk try self.allo.dupe(u8, type_name2);
    };
    defer self.allo.free(field_type);

    const new_field_name = try std.fmt.allocPrint(self.allo, "{s}:{s}", .{ field_name, field_type });
    // defer self.allo.free(new_field_name);
    // std.debug.print("Field Name: {s}\n", .{new_field_name});

    const new_field_value = blk: {
        const space_idx = std.mem.lastIndexOfScalar(u8, line, ' ').? +% 1;
        const close_paren_idx = std.mem.lastIndexOfScalar(u8, line, ')').?;
        const value = line[space_idx..close_paren_idx];
        break :blk try self.allo.dupe(u8, value);
    };
    // defer self.allo.free(new_field_value);
    // std.debug.print("Field Value: {s}\n", .{new_field_value});

    try self.spec_versions.append(.{
        .name = new_field_name,
        .value = new_field_value,
    });
}

fn writeSpecVersions(self: *const TextData) !void {
    try self.write("pub const SpecVersion = struct {");
    for (self.spec_versions.items) |sv| {
        const newline = try std.fmt.allocPrint(
            self.allo,
            "{s} = {s},",
            .{ sv.name, sv.value },
        );
        defer self.allo.free(newline);
        try self.write(newline);
    }
    try self.write("};");
}

fn processPFN(self: *const TextData, idx: usize) !usize {
    var start = idx;
    const line = self.getNextLine(start);
    start +%= line.len +% newline_chars.len;

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
    start +%= line.len +% newline_chars.len;
    try self.write(line);
    return start;
}

fn processOpaque(self: *const TextData, idx: usize) !usize {
    var start = idx;
    const line = self.getNextLine(start);
    start +%= line.len +% newline_chars.len;
    const line1 = self.getNextLine(start);
    start +%= line1.len +% newline_chars.len;

    const prefix = "pub const ";
    const space_idx = std.mem.indexOfScalar(u8, line1[prefix.len..], ' ').?;
    const name = line1[prefix.len .. prefix.len +% space_idx];

    const line2 = try std.fmt.allocPrint(self.allo, "pub const {s} = enum(u64){{ null=0, _ }};\n", .{name});
    defer self.allo.free(line2);
    try self.write(line2);

    return start;
}

fn processExternStructVk(self: *const TextData, idx: usize) !usize {
    var start = idx;
    { // title
        const line = self.getNextLine(start);
        start +%= line.len +% newline_chars.len;

        const prefix = "pub const struct_Vk";
        const space_idx = std.mem.indexOfScalar(u8, line[prefix.len..], ' ').?;
        const new_name = line[prefix.len .. prefix.len +% space_idx];

        const new_title = try std.fmt.allocPrint(
            self.allo,
            "pub const {s} = extern struct {{\n",
            .{new_name},
        );
        defer self.allo.free(new_title);
        try self.write(new_title);
    }

    // body
    while (true) {
        const line = self.getNextLine(start);
        start +%= line.len +% newline_chars.len;

        const rline = try replaceVkStrs(self.allo, line);
        defer self.allo.free(rline);
        try self.write(rline);

        if (std.mem.eql(u8, line, "};")) break;
    }

    // skip next line
    const line1 = self.getNextLine(start);
    start +%= line1.len +% newline_chars.len;
    return start;
}

fn processExternStruct(self: *const TextData, idx: usize) !usize {
    var start = idx;
    { // title
        const line = self.getNextLine(start);
        start +%= line.len +% newline_chars.len;
        try self.write(line);
    }

    while (true) {
        const line = self.getNextLine(start);
        start +%= line.len +% newline_chars.len;

        const maybe_colon_idx = std.mem.indexOfScalar(u8, line, ':');
        if (maybe_colon_idx) |colon_idx| {
            const start_idx = std.mem.lastIndexOfScalar(u8, line[0..colon_idx], ' ').?;
            const name = line[start_idx +% 1 .. colon_idx];

            const name1 = cc.convert(self.allo, name, .snake) catch {
                try self.write(line);
                continue;
            };
            defer self.allo.free(name1);

            const newline = try std.mem.replaceOwned(u8, self.allo, line, name, name1);
            defer self.allo.free(newline);
            try self.write(newline);
            continue;
        }

        try self.write(line);
        if (std.mem.eql(u8, line, "};")) break;
    }

    return start;
}

fn processEnum1(self: *const TextData, idx: usize) !usize {
    const prev_line = self.getPrevLine(idx);
    const found_type = blk: {
        const semicolon_idx = std.mem.lastIndexOfScalar(u8, prev_line, ';').?;
        const space_idx = std.mem.lastIndexOfScalar(u8, prev_line, ' ').?;
        break :blk prev_line[space_idx +% 1 .. semicolon_idx];
    };
    const title_type = if (std.mem.eql(u8, found_type, "c_uint")) "u32" else if (std.mem.eql(u8, found_type, "c_int")) "i32" else unreachable;

    const next_line = self.getNextLine(idx);
    const found_name = blk: {
        const eql_idx = std.mem.indexOfScalar(u8, next_line, '=').? -% 1;
        const space_idx = std.mem.lastIndexOfScalar(u8, next_line[0..eql_idx], ' ').? +% 1;
        break :blk next_line[space_idx..eql_idx];
    };
    const title_name = try replaceFlag(self.allo, found_name);
    defer self.allo.free(title_name);

    const title_line = try std.fmt.allocPrint(
        self.allo,
        "pub const {s} = enum({s}) {{",
        .{ title_name, title_type },
    );
    defer self.allo.free(title_line);
    try self.write(title_line);

    const title_words = try cc.split2Words(self.allo, found_name);
    defer title_words.deinit();
    defer for (title_words.items) |title_word| self.allo.free(title_word);

    var fields = std.ArrayList(NameValue).init(self.allo);
    defer fields.deinit();
    defer {
        for (fields.items) |field| {
            self.allo.free(field.name);
            self.allo.free(field.value);
        }
    }

    var unique_names = std.StringHashMap(void).init(self.allo);
    defer unique_names.deinit();

    var unique_values = std.StringHashMap(void).init(self.allo);
    defer unique_values.deinit();

    var curr = idx -% prev_line.len -% newline_chars.len;
    outer: while (curr > 0) {
        var line = self.getPrevLine(curr);
        curr = curr -% line.len -% newline_chars.len;

        const screaming_snake_name = blk: {
            const colon_idx = std.mem.indexOfScalar(u8, line, ':') orelse break :outer;
            const space_idx = std.mem.lastIndexOfScalar(u8, line[0..colon_idx], ' ').?;
            break :blk line[space_idx +% 1 .. colon_idx];
        };

        if (!cc.isCase(screaming_snake_name, .screaming_snake)) break;

        const new_name = try cc.convert(self.allo, screaming_snake_name, .snake);
        defer self.allo.free(new_name);

        var name_words = try cc.split2Words(self.allo, new_name);
        defer name_words.deinit();
        defer for (name_words.items) |name_word| self.allo.free(name_word);

        const matches = try getMatches(self.allo, name_words, title_words);
        defer self.allo.free(matches);
        if (!anyMatches(matches)) break;

        for (0..matches.len) |i| {
            const j = matches.len -% i -% 1;
            if (!matches[j]) continue;
            const word = name_words.orderedRemove(j);
            self.allo.free(word);
        }

        const temp_field_name = if (name_words.items.len > 0) try cc.words2Snake(self.allo, name_words) else try self.allo.dupe(u8, "_base");
        defer self.allo.free(temp_field_name);

        const new_field_name = blk: {
            var new_field_name: []u8 = undefined;
            if (isKeyword(temp_field_name) or std.ascii.isDigit(temp_field_name[0])) {
                new_field_name = try std.fmt.allocPrint(self.allo, "_{s}", .{temp_field_name});
            } else {
                new_field_name = try self.allo.dupe(u8, temp_field_name);
            }
            break :blk new_field_name;
        };

        const new_field_value = blk: {
            const semicolon_idx = std.mem.indexOfScalar(u8, line, ';').?;
            const space_idx = std.mem.lastIndexOfScalar(u8, line[0..semicolon_idx], ' ').? +% 1;
            break :blk try self.allo.dupe(u8, line[space_idx..semicolon_idx]);
        };

        if (unique_names.get(new_field_name)) |_| {
            self.allo.free(new_field_name);
            self.allo.free(new_field_value);
            continue;
        }

        if (unique_values.get(new_field_value)) |_| {
            self.allo.free(new_field_name);
            self.allo.free(new_field_value);
            continue;
        }

        try unique_names.put(new_field_name, {});
        try unique_values.put(new_field_value, {});

        try fields.append(.{
            .name = new_field_name,
            .value = new_field_value,
        });
    }

    for (0..fields.items.len) |i| {
        const j = fields.items.len -% i -% 1;
        const field = fields.items[j];
        const field_line = try std.fmt.allocPrint(
            self.allo,
            "{s} = {s},",
            .{ field.name, field.value },
        );
        defer self.allo.free(field_line);
        try self.write(field_line);
    }

    try self.write("};");

    return idx +% next_line.len +% newline_chars.len;
}

fn processEnum2(self: *const TextData, idx: usize) !usize {
    var start: usize = idx;

    const prev_line = self.getPrevLine(start);
    const found_name = blk: {
        const eql_idx = std.mem.indexOfScalar(u8, prev_line, '=').? -% 1;
        const name_space_idx = std.mem.lastIndexOfScalar(u8, prev_line[0..eql_idx], ' ').? +% 1;
        break :blk prev_line[name_space_idx..eql_idx];
    };
    const title_name = try replaceFlag(self.allo, found_name);
    defer self.allo.free(title_name);

    const found_type = blk: {
        const semicolon_idx = std.mem.lastIndexOfScalar(u8, prev_line, ';').?;
        const type_space_idx = std.mem.lastIndexOfScalar(u8, prev_line[0..semicolon_idx], ' ').? +% 1;
        break :blk prev_line[type_space_idx..semicolon_idx];
    };
    const title_type = if (std.mem.eql(u8, found_type, "VkFlags")) "u32" else if (std.mem.eql(u8, found_type, "VkFlags64")) "u64" else unreachable;

    const title_line = try std.fmt.allocPrint(self.allo, "pub const {s} = enum({s}) {{", .{ title_name, title_type });
    defer self.allo.free(title_line);
    try self.write(title_line);

    var title_words = try cc.split2Words(self.allo, found_name);
    defer title_words.deinit();
    for (title_words.items, 0..) |*title_word, i| {
        const word = title_word.*;
        if (word.len > 1 and std.ascii.isDigit(word[word.len -% 1])) {
            const new_digit = try self.allo.dupe(u8, word[word.len -% 1 .. word.len]);
            try title_words.insert(i +% 1, new_digit);

            const new_word = try self.allo.alloc(u8, word.len -% 1);
            @memcpy(new_word, word[0 .. word.len -% 1]);
            self.allo.free(title_word.*);
            title_word.* = new_word;
        }
    }
    defer for (title_words.items) |title_word| self.allo.free(title_word);

    var line: []const u8 = undefined;
    while (true) {
        line = self.getNextLine(start);
        if (std.mem.indexOfScalar(u8, line, ':') != null) break;
        start +%= line.len +% newline_chars.len;
    }

    var fields = std.ArrayList(NameValue).init(self.allo);
    defer fields.deinit();
    defer for (fields.items) |field| {
        self.allo.free(field.name);
        self.allo.free(field.value);
    };

    var unique_names = std.StringHashMap(void).init(self.allo);
    defer unique_names.deinit();

    var unique_values = std.StringHashMap(void).init(self.allo);
    defer unique_values.deinit();

    while (true) {
        line = self.getNextLine(start);
        start +%= line.len +% newline_chars.len;

        const screaming_snake_name = blk: {
            const colon_idx = std.mem.indexOfScalar(u8, line, ':') orelse break;
            const space_idx = std.mem.lastIndexOfScalar(u8, line[0..colon_idx], ' ').? +% 1;
            break :blk line[space_idx..colon_idx];
        };

        if (!cc.isCase(screaming_snake_name, .screaming_snake)) break;

        var name_words = try cc.split2Words(self.allo, screaming_snake_name);
        defer name_words.deinit();
        defer for (name_words.items) |name_word| self.allo.free(name_word);

        const matches = try getMatches(self.allo, name_words, title_words);
        defer self.allo.free(matches);
        if (!anyMatches(matches)) break;
        for (0..matches.len) |i| {
            const j = matches.len -% i -% 1;
            if (!matches[j]) continue;
            const word = name_words.orderedRemove(j);
            self.allo.free(word);
        }

        const temp_field_name = if (name_words.items.len > 0) try cc.words2Snake(self.allo, name_words) else try self.allo.dupe(u8, "_base");
        defer self.allo.free(temp_field_name);

        const new_field_name = blk: {
            var new_field_name: []u8 = undefined;
            if (isKeyword(temp_field_name) or std.ascii.isDigit(temp_field_name[0])) {
                new_field_name = try self.allo.alloc(u8, temp_field_name.len +% 1);
                @memcpy(new_field_name[1..new_field_name.len], new_field_name);
                new_field_name[0] = '_';
            } else {
                new_field_name = try self.allo.dupe(u8, temp_field_name);
            }
            break :blk new_field_name;
        };

        const new_field_value = blk: {
            const semicolon_idx = std.mem.lastIndexOfScalar(u8, line, ';').?;
            const value_space_idx = std.mem.lastIndexOfScalar(u8, line[0..semicolon_idx], ' ').? +% 1;
            break :blk try self.allo.dupe(u8, line[value_space_idx..semicolon_idx]);
        };

        if (unique_names.get(new_field_name)) |_| {
            self.allo.free(new_field_name);
            self.allo.free(new_field_value);
            continue;
        }

        if (unique_values.get(new_field_value)) |_| {
            self.allo.free(new_field_name);
            self.allo.free(new_field_value);
            continue;
        }

        try unique_names.put(new_field_name, {});
        try unique_values.put(new_field_value, {});

        try fields.append(.{
            .name = new_field_name,
            .value = new_field_value,
        });
    }

    for (fields.items) |field| {
        const newline = try std.fmt.allocPrint(
            self.allo,
            "{s} = {s},",
            .{ field.name, field.value },
        );
        defer self.allo.free(newline);
        try self.write(newline);
    }

    try self.write("};");

    return start;
}

fn processType(self: *const TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);

    const temp_name = blk: {
        const eql_idx = std.mem.indexOfScalar(u8, line, '=').? -% 1;
        const space_idx = std.mem.lastIndexOfScalar(u8, line[0..eql_idx], ' ').? +% 1;
        const name = line[space_idx..eql_idx];
        break :blk try self.allo.dupe(u8, name);
    };
    defer self.allo.free(temp_name);

    const name = try replaceVkStrs(self.allo, temp_name);
    defer self.allo.free(name);

    const value = blk: {
        const semicolon_idx = std.mem.lastIndexOfScalar(u8, line, ';').?;
        const space_idx = std.mem.indexOfScalar(u8, line[0..semicolon_idx], ' ').? +% 1;
        const value = line[space_idx..semicolon_idx];
        break :blk try self.allo.dupe(u8, value);
    };
    defer self.allo.free(value);

    const newline = try std.fmt.allocPrint(
        self.allo,
        "pub const {s} = {s};",
        .{ name, value },
    );
    defer self.allo.free(newline);
    try self.write(newline);
}

inline fn write(self: *const TextData, line: []const u8) !void {
    _ = try self.wfile.write(line);
    _ = try self.wfile.write("\n");
}

fn replaceVkStrs(allo: std.mem.Allocator, data: []const u8) ![]u8 {
    var rdata = try allo.dupe(u8, data);
    for (
        [_][]const u8{ "VK_KHR_", "vk_khr_", "vk", "_vk", "]Vk", " Vk" },
        [_][]const u8{ "", "", " ", "_", "]", " " },
    ) |m_str, r_str| {
        if (std.mem.indexOf(u8, rdata, m_str)) |_| {
            const temp = try std.mem.replaceOwned(u8, allo, rdata, m_str, r_str);
            allo.free(rdata);
            rdata = temp;
        }
    }
    return rdata;
}

// fn replaceStdStrs(allo: std.mem.Allocator, data: []const u8) ![]u8 {
//     var rdata = try allo.dupe(u8, data);
// }

fn removePrefixes(data: []const u8) []const u8 {
    for ([_][]const u8{ "Vk", "Std", "VK_", "STD_" }) |start_str| {
        if (std.mem.startsWith(u8, data, start_str)) {
            return std.mem.trimLeft(u8, data, start_str);
        }
    } else return data;
}

fn replaceFlag(allo: std.mem.Allocator, data: []const u8) ![]u8 {
    const pdata = removePrefixes(data);
    const rdata = try allo.dupe(u8, pdata);

    for ([_][]const u8{ "FlagBits2KR", "FlagBits2" }) |end_str| {
        if (std.mem.endsWith(u8, rdata, end_str)) {
            defer allo.free(rdata);
            const temp = try std.mem.replaceOwned(u8, allo, rdata, end_str, "Flags2");
            return temp;
        }
    }

    for ([_][]const u8{ "FlagBitsKH", "FlagBits" }) |end_str| {
        if (std.mem.endsWith(u8, rdata, end_str)) {
            defer allo.free(rdata);
            const temp = try std.mem.replaceOwned(u8, allo, rdata, end_str, "Flags");
            return temp;
        }
    }

    return rdata;
}

fn getEndOfCurrLine(self: *const TextData, start: usize) usize {
    return std.mem.indexOfScalar(u8, self.data[start..], '\n') orelse (self.data.len -% start);
}

fn getStartOfPrevLine(self: *const TextData, end: usize) usize {
    const maybe_prev_idx = std.mem.lastIndexOfScalar(u8, self.data[0..end], '\n');
    return if (maybe_prev_idx) |prev_idx| prev_idx +% 1 else 0;
}

inline fn trimLineEnd(data: []const u8) []const u8 {
    return std.mem.trimRight(u8, data, newline_chars);
}

fn getNextLine(self: *const TextData, start: usize) []const u8 {
    const end = start +% self.getEndOfCurrLine(start);
    return trimLineEnd(self.data[start..end]);
}

fn getPrevLine(self: *const TextData, end: usize) []const u8 {
    const start = self.getStartOfPrevLine(end -% 1);
    return trimLineEnd(self.data[start..end]);
}

fn getMatches(
    allo: std.mem.Allocator,
    self: std.ArrayList([]const u8),
    other: std.ArrayList([]const u8),
) ![]bool {
    var matches = try allo.alloc(bool, self.items.len);
    outer: for (self.items, 0..) |s, i| {
        for (other.items) |o| {
            if (std.mem.eql(u8, s, o)) {
                matches[i] = true;
                continue :outer;
            }
        }
    }
    return matches;
}

fn anyMatches(matches: []const bool) bool {
    for (matches) |match| if (match) return true;
    return false;
}

fn isKeyword(word: []const u8) bool {
    const map = std.StaticStringMap(void).initComptime(.{
        .{ "addrspace", {} },
        .{ "align", {} },
        .{ "allowzero", {} },
        .{ "and", {} },
        .{ "anyframe", {} },
        .{ "anytype", {} },
        .{ "asm", {} },
        .{ "async", {} },
        .{ "await", {} },
        .{ "break", {} },
        .{ "callconv", {} },
        .{ "catch", {} },
        .{ "comptime", {} },
        .{ "const", {} },
        .{ "continue", {} },
        .{ "defer", {} },
        .{ "else", {} },
        .{ "enum", {} },
        .{ "errdefer", {} },
        .{ "error", {} },
        .{ "export", {} },
        .{ "extern", {} },
        .{ "fn", {} },
        .{ "for", {} },
        .{ "if", {} },
        .{ "inline", {} },
        .{ "linksection", {} },
        .{ "noalias", {} },
        .{ "noinline", {} },
        .{ "nosuspend", {} },
        .{ "opaque", {} },
        .{ "or", {} },
        .{ "orelse", {} },
        .{ "packed", {} },
        .{ "pub", {} },
        .{ "resume", {} },
        .{ "return", {} },
        .{ "struct", {} },
        .{ "suspend", {} },
        .{ "switch", {} },
        .{ "test", {} },
        .{ "threadlocal", {} },
        .{ "try", {} },
        .{ "union", {} },
        .{ "unreachable", {} },
        .{ "usingnamespace", {} },
        .{ "var", {} },
        .{ "volatile", {} },
        .{ "while", {} },
    });
    return map.has(word);
}
