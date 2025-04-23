const std = @import("std");

const Allocator = std.mem.Allocator;
const eql = std.mem.eql;
const startsWith = std.mem.startsWith;
const endsWith = std.mem.endsWith;
const indexOf = std.mem.indexOf;
const indexOfScalar = std.mem.indexOfScalar;
const lastIndexOfScalar = std.mem.lastIndexOfScalar;
const trimRight = std.mem.trimRight;
const trimLeft = std.mem.trimLeft;
const isDigit = std.ascii.isDigit;
const replaceOwned = std.mem.replaceOwned;
const allocPrint = std.fmt.allocPrint;
const print = std.debug.print;
const toLower = std.ascii.toLower;

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
    const rfile = std.fs.cwd().openFile(rfilename, .{}) catch |err| {
        print("File: {s}\n", .{rfilename});
        return err;
    };
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
    const len = self.data.len;
    while (start < len) {
        const line = self.getNextLine(start);
        // print("Line: {s}\n", .{line});
        start = self.getNextStart(start);
        const linetype = determineLineType(line) orelse continue;
        // print("Line Type: {s}\n", .{@tagName(linetype)});

        switch (linetype) {
            .inline_fn_vk => start = (try self.processInlineFnVk(start)),
            .inline_fn => start = (try self.processInlineFn(start)),
            .@"extern" => start = (try self.processExtern(start)),
            .extern_fn_vk => start = (try self.processExternFnVk(start)),
            .extern_fn => try self.processExternFn(start),
            .extern_var => try self.processExternVar(start),
            .extern_const => try self.processExternConst(start),
            .export_var => try self.processExportVar(start),
            .@"fn" => start = (try self.processFn(start)),

            .extension_name => try self.processExtensionName(start),
            .spec_version => try self.processSpecVersion(start),
            .type_name => try self.processTypeName(start),
            .pfn => try self.processPFN(start),
            .import => try self.processImport(start),
            .opaque_vk => start = (try self.processOpaqueVk(start)),
            .@"opaque" => try self.processOpaque(start),
            .extern_union_vk => start = (try self.processExternUnionVk(start)),
            .extern_union => start = (try self.processExternUnion(start)),
            .extern_struct_vk => start = (try self.processExternStructVk(start)),
            .extern_struct => start = (try self.processExternStruct(start)),
            .@"enum" => start = (try self.processEnum(start)),
            .flag1 => start = (try self.processFlag1(start)),
            .flag2 => start = (try self.processFlag2(start)),
            .type_vk => try self.processTypeVk(start),
            .type => try self.processType(start),

            .base => try self.processBase(start),
        }
    }

    if (self.type_names.items.len > 0) try self.writeTypeNames();
    if (self.extension_names.items.len > 0) try self.writeExtensionNames();
    if (self.spec_versions.items.len > 0) try self.writeSpecVersions();
}

const LineType = enum {
    inline_fn_vk,
    inline_fn,
    @"extern",
    extern_fn_vk,
    extern_fn,
    extern_var,
    extern_const,
    export_var,
    @"fn",

    extension_name,
    spec_version,
    type_name,
    pfn,
    import,
    opaque_vk,
    @"opaque",
    extern_union_vk,
    extern_union,
    extern_struct_vk,
    extern_struct,
    @"enum",
    flag1,
    flag2,
    type_vk,
    type,

    base,
};

fn determineLineType(line: []const u8) ?LineType {
    const strs = [_][]const u8{ "pub", "const" };

    var line1: []const u8 = undefined;
    if (startsWith(u8, line, strs[0])) {
        line1 = line[strs[0].len +% 1 .. line.len];
        if (isInlineFnVk(line1)) return .inline_fn_vk;
        if (isInlineFn(line1)) return .inline_fn;
        if (isExtern(line1)) return .@"extern";
        if (isExternFnVk(line1)) return .extern_fn_vk;
        if (isExternFn(line1)) return .extern_fn;
        if (isExternVar(line1)) return .extern_var;
        if (isFn(line1)) return .@"fn";
        if (isExternConst(line1)) return .extern_const;
        if (isExportVar(line1)) return .export_var;
    } else if (startsWith(u8, line, strs[1])) {
        line1 = line[strs[1].len +% 1 .. line.len];
        if (isExternUnion(line1)) return .extern_union;
        return null;
    } else {
        return null;
    }

    if (!startsWith(u8, line1, strs[1])) return null;
    const line2 = line1[strs[1].len +% 1 .. line1.len];
    if (isCompileError(line2)) return null;
    if (isExtensionName(line2)) return .extension_name;
    if (isSpecVersion(line2)) return .spec_version;
    if (isTypeName(line2)) return .type_name;
    if (isPFN(line2)) return .pfn;
    if (isImport(line2)) return .import;
    if (isOpaqueVk(line2)) return .opaque_vk;
    if (isOpaque(line2)) return .@"opaque";
    if (isExternUnionVk(line2)) return .extern_union_vk;
    if (isExternUnion(line2)) return .extern_union;
    if (isExternStructVk(line2)) return .extern_struct_vk;
    if (isExternStruct(line2)) return .extern_struct;
    if (isSkip(line2)) return null;
    if (isFlag1(line2)) return .flag1;
    if (isFlag2(line2)) return .flag2;
    if (isEnum(line2)) return .@"enum";
    if (isTypeVk(line2)) return .type_vk;
    if (isType(line2)) return .type;
    return .base;
}

fn isInlineFnVk(line: []const u8) bool {
    return startsWith(u8, line, "inline fn VK_");
}

fn isInlineFn(line: []const u8) bool {
    return startsWith(u8, line, "inline fn");
}

fn isExtern(line: []const u8) bool {
    return indexOf(u8, line, "@extern") != null;
}

fn isExternFnVk(line: []const u8) bool {
    return startsWith(u8, line, "extern fn vk");
}

fn isExternFn(line: []const u8) bool {
    return startsWith(u8, line, "extern fn");
}

fn isExternVar(line: []const u8) bool {
    return startsWith(u8, line, "extern var");
}

fn isFn(line: []const u8) bool {
    // MarkAllocaS - example to check - two nested brackets
    return startsWith(u8, line, "fn");
}

fn isExternConst(line: []const u8) bool {
    return startsWith(u8, line, "extern const");
}

fn isExportVar(line: []const u8) bool {
    return startsWith(u8, line, "export var");
}

fn isSkip(line: []const u8) bool {
    const name = getTrimName(line);
    const has_colon = name[name.len -% 1] == ':';
    const is_screaming_snake = cc.isCase(name[0 .. name.len -% 1], .screaming_snake);
    const vk_name = startsWith(u8, line, "VK_");
    return has_colon and is_screaming_snake and vk_name;
}

fn isCompileError(line: []const u8) bool {
    const open_paren_idx = indexOfScalar(u8, line, '(') orelse return false;
    const space_idx = lastIndexOfScalar(u8, line[0..open_paren_idx], ' ').? +% 1;
    const name = line[space_idx..open_paren_idx];
    return eql(u8, name, "@compileError");
}

fn isExtensionName(line: []const u8) bool {
    const name = getTrimName(line);
    return endsWith(u8, name, "_EXTENSION_NAME");
}

fn isSpecVersion(line: []const u8) bool {
    const name = getTrimName(line);
    return endsWith(u8, name, "_SPEC_VERSION");
}

fn isTypeName(line: []const u8) bool {
    const name = getTrimName(line);
    const is_screaming_snake = cc.isCase(name, .screaming_snake);
    const value = getFullValue(line, &.{}, &.{}) orelse return false;
    const is_at = startsWith(u8, value, "@as(");
    return is_screaming_snake and is_at;
}

fn isPFN(line: []const u8) bool {
    return startsWith(u8, line, "PFN_vk");
}

fn isImport(line: []const u8) bool {
    return indexOf(u8, line, "@import") != null;
}

fn isOpaqueVk(line: []const u8) bool {
    const name = getName(line, &.{}, &.{});
    const is_vk = startsWith(u8, name, "struct_Vk");
    const is_opaque = isOpaque(line);
    return is_vk and is_opaque;
}

fn isOpaque(line: []const u8) bool {
    const new_line = trimLineEnd(line);
    return endsWith(u8, new_line, "opaque {};");
}

fn isExternUnionVk(line: []const u8) bool {
    const is_vk = startsWith(u8, line, "union_Vk");
    const is_extern_union = isExternUnion(line);
    return is_vk and is_extern_union;
}

fn isExternUnion(line: []const u8) bool {
    return endsWith(u8, line, "extern union {");
}

fn isExternStructVk(line: []const u8) bool {
    const new_line = trimLineEnd(line);
    const is_vk = startsWith(u8, new_line, "struct_Vk");
    const is_extern_struct = isExternStruct(line);
    return is_vk and is_extern_struct;
}

fn isExternStruct(line: []const u8) bool {
    const new_line = trimLineEnd(line);
    return endsWith(u8, new_line, "extern struct {");
}

fn isFlag1(line: []const u8) bool {
    const space_idx = indexOfScalar(u8, line, ' ').?;
    const name = line[0..space_idx];
    const is_enum = isEnum(line);
    const is_flag1 = endsWith(u8, name, "FlagBitsKHR") or endsWith(u8, name, "FlagBits");
    return is_enum and is_flag1;
}

fn isFlag2(line: []const u8) bool {
    const space_idx = indexOfScalar(u8, line, ' ').?;
    const name = line[0..space_idx];
    const is_flag2 = endsWith(u8, name, "Flags2");
    const is_flags64 = endsWith(u8, line, "VkFlags64;");
    return is_flag2 and is_flags64;
}

fn isEnum(line: []const u8) bool {
    return startsWith(u8, line, "enum_Vk");
}

fn isTypeVk(line: []const u8) bool {
    const space_idx = std.mem.indexOfScalar(u8, line, ' ') orelse return false;
    const name = line[0..space_idx];
    const is_vk = startsWith(u8, name, "Vk");
    const is_type = isType(line);
    return is_vk and is_type;
}

fn isType(line: []const u8) bool {
    const types = std.StaticStringMap(void).initComptime(.{
        .{ "u8", {} },
        .{ "u32", {} },
        .{ "u64", {} },
        .{ "i8", {} },
        .{ "i32", {} },
        .{ "i64", {} },
        .{ "?*anyopaque", {} },
        .{ "?*const fn (c_int) callconv(.c) void", {} },
        .{ "c_short", {} },
        .{ "c_int", {} },
        .{ "c_long", {} },
        .{ "c_longlong", {} },
        .{ "c_ushort", {} },
        .{ "c_uint", {} },
        .{ "c_ulong", {} },
        .{ "c_ulonglong", {} },
        .{ "VkFlags", {} },
        .{ "VkFlags64", {} },
    });
    const start = (indexOfScalar(u8, line, '=') orelse return false) +% 2;
    const end = lastIndexOfScalar(u8, line, ';') orelse return false;
    const type_name = line[start..end];
    return types.has(type_name);
}

fn processInlineFnVk(self: *const TextData, idx: usize) !usize {
    var start: usize = idx;
    {
        const line = self.getPrevLine(start);
        const fn_name = getFnName(line, &.{}, &.{});
        const trim_fn_name = removeIxes(fn_name, &.{"VK_"}, &.{});
        const camel_fn_name = try cc.convert(self.allo, trim_fn_name, .camel);
        defer self.allo.free(camel_fn_name);
        const newline = try replaceOwned(u8, self.allo, line, fn_name, camel_fn_name);
        defer self.allo.free(newline);
        try self.write(newline);
    }
    while (true) {
        const line = self.getNextLine(start);
        start = self.getNextStart(start);
        try self.write(line);
        if (eql(u8, line, "}")) break;
    }
    return start;
}

fn processInlineFn(self: *const TextData, idx: usize) !usize {
    var start: usize = idx;
    var line = self.getPrevLine(start);
    try self.write(line);
    while (true) {
        line = self.getNextLine(start);
        start = self.getNextStart(start);
        try self.write(line);
        if (eql(u8, line, "}")) break;
    }
    return start;
}

fn processExtern(self: *const TextData, idx: usize) !usize {
    var line = self.getPrevLine(idx);
    try self.write(line);
    var start = idx;
    while (true) {
        line = self.getNextLine(start);
        start = self.getNextStart(start);
        try self.write(line);
        if (eql(u8, line, "});")) break;
    }
    return start;
}

fn processExternFnVk(self: *const TextData, idx: usize) !usize {
    var start = idx;
    const line = self.getPrevLine(start);
    start = self.getNextStart(start);
    const fn_name = getFnName(line, &.{"vk"}, &.{});
    const camel_fn_name = try cc.convert(self.allo, fn_name, .camel);
    defer self.allo.free(camel_fn_name);
    const replace_fn_name = try replaceOwned(u8, self.allo, line, fn_name, camel_fn_name);
    defer self.allo.free(replace_fn_name);
    const new_fn_line = try replaceVkStrs(self.allo, replace_fn_name);
    defer self.allo.free(new_fn_line);
    const new_line = try convertArgs2Snake(self.allo, new_fn_line);
    defer self.allo.free(new_line);
    try self.write(new_line);
    return start;
}

fn processExternFn(self: *const TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);
    try self.write(line);
}

fn processExternVar(self: *const TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);
    try self.write(line);
}

fn processExternConst(self: *const TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);
    try self.write(line);
}

fn processExportVar(self: *const TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);
    try self.write(line);
}

fn processFn(self: *const TextData, idx: usize) !usize {
    var line = self.getPrevLine(idx);
    try self.write(line);
    var start: usize = idx;
    while (true) {
        line = self.getNextLine(start);
        start = self.getNextStart(start);
        try self.write(line);
        if (eql(u8, line, "}")) break;
    }
    return start;
}

fn processTypeName(self: *TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);
    const name = getName(line, &.{"VK_"}, &.{});
    const snake_name = try cc.convert(self.allo, name, .snake);
    defer self.allo.free(snake_name);
    const trim_vk_prefix = try replaceVkStrs(self.allo, snake_name);
    defer self.allo.free(trim_vk_prefix);
    const word = try prefixWithAt(self.allo, trim_vk_prefix);
    defer self.allo.free(word);
    const type_name = if (eql(u8, getType(line, &.{}, &.{}).?, "c_uint")) "u32" else "i32";
    const new_field_name = try allocPrint(self.allo, "{s}: {s}", .{ word, type_name });
    const new_field_value = try self.allo.dupe(u8, getValue(line, &.{}, &.{}));
    try self.type_names.append(.{
        .name = new_field_name,
        .value = new_field_value,
    });
}

fn writeTypeNames(self: *const TextData) !void {
    try self.write("pub const TypeNames = struct {");
    for (self.type_names.items) |tn| {
        const newline = try allocPrint(self.allo, "    {s} = {s},", .{ tn.name, tn.value });
        defer self.allo.free(newline);
        try self.write(newline);
    }
    try self.write("};");
}

fn processExtensionName(self: *TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);
    const name = getName(line, &.{ "VK_KHR_", "VK_" }, &.{"_EXTENSION_NAME"});
    const field_name = try cc.convert(self.allo, name, .snake);
    defer self.allo.free(field_name);
    const new_field_name = try prefixWithAt(self.allo, field_name);
    const new_field_value = try self.allo.dupe(u8, getValue(line, &.{}, &.{}));
    try self.extension_names.append(.{
        .name = new_field_name,
        .value = new_field_value,
    });
}

fn writeExtensionNames(self: *const TextData) !void {
    try self.write("pub const ExtensionNames = struct {");
    for (self.extension_names.items) |en| {
        const newline = try allocPrint(self.allo, "    {s}: {s},", .{ en.name, en.value });
        defer self.allo.free(newline);
        try self.write(newline);
    }
    try self.write("};");
}

fn processSpecVersion(self: *TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);
    const name = getName(line, &.{ "VK_KHR_", "VK_" }, &.{"_SPEC_VERSION"});
    const snake_name = try cc.convert(self.allo, name, .snake);
    defer self.allo.free(snake_name);
    const snake_name1 = try prefixWithAt(self.allo, snake_name);
    defer self.allo.free(snake_name1);
    const tname = getType(line, &.{}, &.{}) orelse return;
    const type_name = if (eql(u8, tname, "c_uint")) "u32" else "i32";
    const new_field_name = try allocPrint(
        self.allo,
        "{s}: {s}",
        .{ snake_name1, type_name },
    );
    const new_field_value = try self.allo.dupe(u8, getValue(line, &.{}, &.{}));
    try self.spec_versions.append(.{
        .name = new_field_name,
        .value = new_field_value,
    });
}

fn writeSpecVersions(self: *const TextData) !void {
    for (0..self.spec_versions.items.len -% 1) |i| {
        for (i +% 1..self.spec_versions.items.len) |j| {
            const old_sv = self.spec_versions.items[i];
            const new_sv = self.spec_versions.items[j];
            if (old_sv.value.len > new_sv.value.len) {
                const tmp = self.spec_versions.items[i];
                self.spec_versions.items[i] = self.spec_versions.items[j];
                self.spec_versions.items[j] = tmp;
            } else {
                const ov = try std.fmt.parseInt(i128, old_sv.value, 10);
                const nv = try std.fmt.parseInt(i128, new_sv.value, 10);
                if (ov > nv) {
                    const tmp = self.spec_versions.items[i];
                    self.spec_versions.items[i] = self.spec_versions.items[j];
                    self.spec_versions.items[j] = tmp;
                }
            }
        }
    }

    try self.write("pub const SpecVersions = struct {");
    for (self.spec_versions.items) |sv| {
        const newline = try allocPrint(
            self.allo,
            "    {s} = {s},",
            .{ sv.name, sv.value },
        );
        defer self.allo.free(newline);
        try self.write(newline);
    }
    try self.write("};");
}

fn processPFN(self: *const TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);
    const new_line = try replaceVkStrs(self.allo, line);
    const under_idx = indexOfScalar(u8, new_line, ' ').? +% 1;
    new_line[under_idx] = toLower(new_line[under_idx]);
    defer self.allo.free(new_line);
    try self.write(new_line);
}

fn processImport(self: *const TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);
    try self.write(line);
}

fn processOpaqueVk(self: *const TextData, idx: usize) !usize {
    const line = self.getNextLine(idx);

    const start = self.getNextStart(idx);
    const name = getName(line, &.{"Vk"}, &.{});
    const new_line = try allocPrint(
        self.allo,
        "pub const {s} = enum(u64) {{ null = 0, _ }};",
        .{name},
    );
    defer self.allo.free(new_line);
    try self.write(new_line);
    return start;
}

fn processOpaque(self: *const TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);
    try self.write(line);
}

fn processExternUnionVk(self: *const TextData, idx: usize) !usize {
    var line = self.getPrevLine(idx);
    const name = getName(line, &.{"union_Vk"}, &.{});
    const title = try allocPrint(self.allo, "pub const {s} = extern union {{", .{name});
    defer self.allo.free(title);
    try self.write(title);

    var start: usize = idx;
    while (true) {
        line = self.getNextLine(start);
        start = self.getNextStart(start);
        try self.write(line);
        if (eql(u8, line, "};")) break;
    }

    line = self.getNextLine(start);
    const new_name = getName(line, &.{"Vk"}, &.{});
    if (eql(u8, name, new_name)) start = self.getNextStart(start);

    return start;
}

fn processExternUnion(self: *const TextData, idx: usize) !usize {
    var line = self.getPrevLine(idx);
    try self.write(line);

    var start: usize = idx;
    while (true) {
        line = self.getNextLine(start);
        start = self.getNextStart(start);
        try self.write(line);
        if (eql(u8, line, "};")) break;
    }

    return start;
}

fn processExternStructVk(self: *const TextData, idx: usize) !usize {
    var start = idx;
    var line = self.getPrevLine(start);
    const name = getName(line, &.{"struct_Vk"}, &.{});
    const title = try allocPrint(self.allo, "pub const {s} = extern struct {{", .{name});
    defer self.allo.free(title);
    try self.write(title);

    while (true) {
        line = self.getNextLine(start);
        start = self.getNextStart(start);
        if (eql(u8, line, "};")) break;

        const rline = try convertFieldName2Snake(self.allo, line);
        defer self.allo.free(rline);

        const rline1 = try replaceVkStrs(self.allo, rline);
        defer self.allo.free(rline1);

        const rline2 = try replaceFlags(self.allo, rline1);
        defer self.allo.free(rline2);
        try self.write(rline2);
    }

    try self.write(line);
    return start;
}

fn processExternStruct(self: *const TextData, idx: usize) !usize {
    var start = idx;
    var line = self.getPrevLine(start);
    try self.write(line);
    while (true) {
        line = self.getNextLine(start);
        start = self.getNextStart(start);
        if (eql(u8, line, "};")) break;

        const rline = try convertFieldName2Snake(self.allo, line);
        defer self.allo.free(rline);
        try self.write(rline);
    }
    try self.write(line);
    return start;
}

fn processEnum(self: *const TextData, idx: usize) !usize {
    var line = self.getPrevLine(idx);
    const title_name = getName(line, &.{"enum_Vk"}, &.{});
    const is_result = eql(u8, title_name, "Result");
    const title_value = if (eql(u8, getValue(line, &.{}, &.{}), "c_uint")) "u32" else "i32";

    const newline = try allocPrint(
        self.allo,
        "pub const {s} = enum({s}) {{",
        .{ title_name, title_value },
    );
    defer self.allo.free(newline);
    try self.write(newline);

    const title_words = try cc.split2Words(self.allo, title_name);
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

    var dup_fields = std.ArrayList(NameValue).init(self.allo);
    defer dup_fields.deinit();
    defer {
        for (dup_fields.items) |field| {
            self.allo.free(field.name);
            self.allo.free(field.value);
        }
    }

    var unique_names = std.StringHashMap(void).init(self.allo);
    defer unique_names.deinit();

    var unique_values = std.StringHashMap(usize).init(self.allo);
    defer unique_values.deinit();

    var curr = self.getPrevStart(idx);
    while (curr > 0) {
        line = self.getPrevLine(curr);
        curr = self.getPrevStart(curr);

        const ssn = getScreamingSnakeName(line, &.{"VK_"}, &.{}) orelse break;
        const new_name = try cc.convert(self.allo, ssn, .snake);
        defer self.allo.free(new_name);

        var name_words = try cc.split2Words(self.allo, new_name);
        defer name_words.deinit();
        defer for (name_words.items) |name_word| self.allo.free(name_word);

        const matches = try getMatches(self.allo, &name_words, &title_words);
        defer self.allo.free(matches);
        if (!anyMatches(matches) and !is_result) break;

        for (0..matches.len) |i| {
            const j = matches.len -% i -% 1;
            if (!matches[j]) continue;
            const word = name_words.orderedRemove(j);
            self.allo.free(word);
        }

        const temp_field_name = if (name_words.items.len > 0) try cc.words2Snake(self.allo, name_words) else try self.allo.dupe(u8, "_base");
        defer self.allo.free(temp_field_name);

        const new_field_name = try prefixWithAt(self.allo, temp_field_name);
        const new_field_value = try self.allo.dupe(u8, getValue(line, &.{}, &.{}));

        if (unique_names.get(new_field_name)) |_| {
            self.allo.free(new_field_name);
            self.allo.free(new_field_value);
            continue;
        }

        if (unique_values.get(new_field_value)) |fil| {
            const old_field = fields.items[fil];
            if (old_field.name.len > new_field_name.len) {
                try dup_fields.append(.{
                    .name = old_field.name,
                    .value = try self.allo.dupe(u8, new_field_name),
                });
                fields.items[fil].name = new_field_name;
            } else {
                try dup_fields.append(.{
                    .name = new_field_name,
                    .value = try self.allo.dupe(u8, old_field.name),
                });
            }
            self.allo.free(new_field_value);
            continue;
        }

        try unique_names.put(new_field_name, {});
        try unique_values.put(new_field_value, fields.items.len);
        try fields.append(.{
            .name = new_field_name,
            .value = new_field_value,
        });
    }

    try sort(&fields);

    for (fields.items) |field| {
        const field_line = try allocPrint(
            self.allo,
            "    {s} = {s},",
            .{ field.name, field.value },
        );
        defer self.allo.free(field_line);
        try self.write(field_line);
    }
    try self.write("};");

    for (dup_fields.items) |field| {
        const field_line = try allocPrint(
            self.allo,
            "pub const {s} = {s}.{s};",
            .{ field.name, title_name, field.value },
        );
        defer self.allo.free(field_line);
        try self.write(field_line);
    }

    line = self.getNextLine(idx);
    const start = self.getNextStart(idx);
    return start;
}

fn processFlag1(self: *const TextData, idx: usize) !usize {
    const prev_line = self.getPrevLine(idx);
    var line = prev_line;

    const title_type = if (eql(u8, getValue(line, &.{}, &.{}), "c_uint")) "u32" else "i32";

    line = self.getNextLine(idx);
    var start = self.getNextStart(idx);
    const title_name = getName(line, &.{"Vk"}, &.{ "FlagBitsKHR", "FlagBits" });
    const title_line = try allocPrint(
        self.allo,
        "pub const {s}Flags = enum({s}) {{",
        .{ title_name, title_type },
    );
    defer self.allo.free(title_line);
    try self.write(title_line);

    const name = getName(line, &.{"Vk"}, &.{});
    var title_words = try cc.split2Words(self.allo, name);
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

    var unique_values = std.StringHashMap(usize).init(self.allo);
    defer unique_values.deinit();

    line = prev_line;
    var curr = self.getPrevStart(idx);
    while (curr > 0) {
        line = self.getPrevLine(curr);
        curr = self.getPrevStart(curr);
        const ssn = getScreamingSnakeName(line, &.{"VK_"}, &.{}) orelse break;

        const new_name = try cc.convert(self.allo, ssn, .snake);
        defer self.allo.free(new_name);

        var name_words = try cc.split2Words(self.allo, new_name);
        defer name_words.deinit();
        defer for (name_words.items) |name_word| self.allo.free(name_word);

        const matches = try getMatches(self.allo, &name_words, &title_words);
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

        const new_field_name = try prefixWithAt(self.allo, temp_field_name);
        const new_field_value = try self.allo.dupe(u8, getValue(line, &.{}, &.{}));

        if (unique_names.get(new_field_name)) |_| {
            self.allo.free(new_field_name);
            self.allo.free(new_field_value);
            continue;
        }

        if (unique_values.get(new_field_value)) |fil| {
            const old_field_name = fields.items[fil].name;
            if (old_field_name.len > new_field_name.len) {
                self.allo.free(old_field_name);
                fields.items[fil].name = new_field_name;
            } else {
                self.allo.free(new_field_name);
            }
            self.allo.free(new_field_value);
            continue;
        }

        try unique_names.put(new_field_name, {});
        try unique_values.put(new_field_value, fields.items.len);
        try fields.append(.{
            .name = new_field_name,
            .value = new_field_value,
        });
    }

    try sort(&fields);

    for (fields.items) |field| {
        const newline = try allocPrint(
            self.allo,
            "    {s} = {s},",
            .{ field.name, field.value },
        );
        defer self.allo.free(newline);
        try self.write(newline);
    }
    try self.write("};");

    line = self.getNextLine(start);
    start = self.getNextStart(start);
    return start;
}

fn processFlag2(self: *const TextData, idx: usize) !usize {
    var line = self.getPrevLine(idx);

    const title_name = getName(line, &.{"Vk"}, &.{});
    const title_type = if (eql(u8, getValue(line, &.{}, &.{}), "c_uint")) "u32" else "i32";
    const title_line = try allocPrint(
        self.allo,
        "pub const {s} = enum({s}) {{",
        .{ title_name, title_type },
    );
    defer self.allo.free(title_line);
    try self.write(title_line);

    var title_words = try cc.split2Words(self.allo, title_name);
    defer title_words.deinit();
    for (0..title_words.items.len) |i| {
        const word = title_words.items[i];
        if (isDigit(word[word.len -% 1])) {
            const new_digit = try self.allo.dupe(u8, word[word.len -% 1 .. word.len]);
            try title_words.insert(i +% 1, new_digit);

            const new_word = try self.allo.dupe(u8, word[0 .. word.len -% 1]);
            self.allo.free(word);
            title_words.items[i] = new_word;
        }
    }
    defer for (title_words.items) |title_word| self.allo.free(title_word);

    var start = idx;
    while (true) {
        line = self.getNextLine(start);
        if (indexOfScalar(u8, line, ':') != null) break;
        start = self.getNextStart(idx);
    }

    var fields = std.ArrayList(NameValue).init(self.allo);
    defer fields.deinit();
    defer for (fields.items) |field| {
        self.allo.free(field.name);
        self.allo.free(field.value);
    };

    var unique_names = std.StringHashMap(void).init(self.allo);
    defer unique_names.deinit();

    var unique_values = std.StringHashMap(usize).init(self.allo);
    defer unique_values.deinit();

    while (true) {
        line = self.getNextLine(start);
        start = self.getNextStart(start);
        const ssn = getScreamingSnakeName(line, &.{"VK_"}, &.{}) orelse break;

        var name_words = try cc.split2Words(self.allo, ssn);
        defer name_words.deinit();
        defer for (name_words.items) |name_word| self.allo.free(name_word);

        const matches = try getMatches(self.allo, &name_words, &title_words);
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

        const new_field_name = try prefixWithAt(self.allo, temp_field_name);
        const new_field_value = try self.allo.dupe(u8, getValue(line, &.{}, &.{}));

        if (unique_names.get(new_field_name)) |_| {
            self.allo.free(new_field_name);
            self.allo.free(new_field_value);
            continue;
        }

        if (unique_values.get(new_field_value)) |fil| {
            const old_field_name = fields.items[fil].name;
            if (old_field_name.len > new_field_name.len) {
                self.allo.free(fields.items[fil].name);
                fields.items[fil].name = new_field_name;
            } else {
                self.allo.free(new_field_name);
            }
            self.allo.free(new_field_value);
            continue;
        }

        try unique_names.put(new_field_name, {});
        try unique_values.put(new_field_value, fields.items.len);

        try fields.append(.{
            .name = new_field_name,
            .value = new_field_value,
        });
    }

    try sort(&fields);

    for (fields.items) |field| {
        const newline = try allocPrint(
            self.allo,
            "    {s} = {s},",
            .{ field.name, field.value },
        );
        defer self.allo.free(newline);
        try self.write(newline);
    }
    try self.write("};");

    return start;
}

fn processTypeVk(self: *const TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);
    const name = getName(line, &.{"Vk"}, &.{});
    if (eql(u8, name, "Bool32")) {
        try self.write("pub const Bool32 = enum(u32) {\n    false = 0,\n    true = 1,\n};");
        return;
    }
    const value = getValue(line, &.{"Vk"}, &.{});
    const newline = try std.fmt.allocPrint(self.allo, "pub const {s} = {s};", .{ name, value });
    defer self.allo.free(newline);
    try self.write(newline);
}

fn processType(self: *const TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);
    try self.write(line);
}

fn processBase(self: *const TextData, idx: usize) !void {
    const line = self.getPrevLine(idx);
    try self.write(line);
}

inline fn write(self: *const TextData, line: []const u8) !void {
    _ = try self.wfile.write(line);
    _ = try self.wfile.write("\n");
}

fn getFnName(
    data: []const u8,
    prefixes: []const []const u8,
    suffixes: []const []const u8,
) []const u8 {
    const open_paren_idx = indexOfScalar(u8, data, '(').?;
    const space_idx = lastIndexOfScalar(u8, data[0..open_paren_idx], ' ').? +% 1;
    const fn_name = data[space_idx..open_paren_idx];
    const new_fn_name = removeIxes(fn_name, prefixes, suffixes);
    return new_fn_name;
}

fn getTrimName(data: []const u8) []const u8 {
    return data[0..indexOfScalar(u8, data, ' ').?];
}

fn getName(
    data: []const u8,
    prefixes: []const []const u8,
    suffixes: []const []const u8,
) []const u8 {
    const eql_idx = indexOfScalar(u8, data, '=').? -% 1;
    const space_idx = lastIndexOfScalar(u8, data[0..eql_idx], ' ');
    const start = if (space_idx) |si| si +% 1 else 0;
    const name = data[start..eql_idx];
    const new_name = removeIxes(name, prefixes, suffixes);
    return new_name;
}

fn getScreamingSnakeName(
    data: []const u8,
    prefixes: []const []const u8,
    suffixes: []const []const u8,
) ?[]const u8 {
    const semicolon_idx = indexOfScalar(u8, data, ':') orelse return null;
    const space_idx = lastIndexOfScalar(u8, data[0..semicolon_idx], ' ').? +% 1;
    const name = data[space_idx..semicolon_idx];
    const new_name = removeIxes(name, prefixes, suffixes);
    return if (!cc.isCase(new_name, .screaming_snake)) null else new_name;
}

fn getValue(
    data: []const u8,
    prefixes: []const []const u8,
    suffixes: []const []const u8,
) []const u8 {
    // assumes = ;
    const end = lastIndexOfScalar(u8, data, ')') orelse lastIndexOfScalar(u8, data, ';').?;
    const start = lastIndexOfScalar(u8, data[0..end], ' ').? +% 1;
    const value = data[start..end];
    const new_value = removeIxes(value, prefixes, suffixes);
    return new_value;
}

fn getFullValue(
    data: []const u8,
    prefixes: []const []const u8,
    suffixes: []const []const u8,
) ?[]const u8 {
    const start = (indexOfScalar(u8, data, '=') orelse return null) +% 2;
    const end = (indexOfScalar(u8, data, ';') orelse return null);
    const value = data[start..end];
    const new_value = removeIxes(value, prefixes, suffixes);
    return new_value;
}

fn getType(
    data: []const u8,
    prefixes: []const []const u8,
    suffixes: []const []const u8,
) ?[]const u8 {
    // assumes @as(); on value side, not a fn input
    const comma_idx = lastIndexOfScalar(u8, data, ',') orelse return null;
    const open_paren_idx = lastIndexOfScalar(u8, data[0..comma_idx], '(').? +% 1;
    const vk_type = data[open_paren_idx..comma_idx];
    const new_vk_type = removeIxes(vk_type, prefixes, suffixes);
    return new_vk_type;
}

fn removeIxes(
    word: []const u8,
    prefixes: []const []const u8,
    suffixes: []const []const u8,
) []const u8 {
    var new_word = word;
    if (prefixes.len > 0) {
        outer: for (prefixes) |prefix| {
            if (startsWith(u8, new_word, prefix)) {
                const temp = new_word[prefix.len..];
                new_word = trimLeft(u8, temp, " ");
                break :outer;
            }
        }
    }

    if (suffixes.len > 0) {
        outer: for (suffixes) |suffix| {
            if (endsWith(u8, new_word, suffix)) {
                const temp = new_word[0 .. new_word.len -% suffix.len];
                new_word = temp;
                break :outer;
            }
        }
    }

    return new_word;
}

fn replaceVkStrs(allo: std.mem.Allocator, data: []const u8) ![]u8 {
    var rdata = try allo.dupe(u8, data);
    for ([_][]const u8{ "enum_Vk", "struct_Vk", "union_Vk" }) |prefix| {
        if (indexOf(u8, rdata, prefix) != null) {
            const tmp = try replaceOwned(u8, allo, rdata, prefix, "");
            allo.free(rdata);
            rdata = tmp;
        }
    }

    const vk_strs = [_][]const u8{ "_vk", " vk", "]Vk", ")Vk", " Vk", "VK_" };
    for (vk_strs) |vk_str| {
        if (indexOf(u8, rdata, vk_str) != null) {
            const tmp = try replaceOwned(u8, allo, rdata, vk_str, vk_str[0..1]);
            allo.free(rdata);
            rdata = tmp;
        }
    }

    return rdata;
}

fn replaceFlags(allo: std.mem.Allocator, data: []const u8) ![]u8 {
    var rdata = try allo.dupe(u8, data);
    for (
        [_][]const u8{ "FlagBits2KHR", "FlagBits2", "FlagBitsKHR", "FlagBits" },
        [_][]const u8{ "Flags2", "Flags2", "Flags", "Flags" },
    ) |old_suffix, new_suffix| {
        if (indexOf(u8, rdata, old_suffix) != null) {
            const tmp = try std.mem.replaceOwned(u8, allo, rdata, old_suffix, new_suffix);
            allo.free(rdata);
            rdata = tmp;
        }
    }
    return rdata;
}

fn convertFieldName2Snake(allo: std.mem.Allocator, data: []const u8) ![]u8 {
    const colon_idx = indexOfScalar(u8, data, ':').?;
    const space_idx = lastIndexOfScalar(u8, data[0..colon_idx], ' ').? +% 1;
    const name = data[space_idx..colon_idx];
    const new_name = try cc.convert(allo, name, .snake);

    var new_data = try allo.alloc(u8, data.len +% new_name.len -% name.len);
    @memset(new_data[0..space_idx], ' ');
    @memcpy(new_data[space_idx .. space_idx +% new_name.len], new_name);
    @memcpy(new_data[space_idx +% new_name.len .. new_data.len], data[colon_idx..data.len]);
    return new_data;
}

fn convertArgs2Snake(allo: std.mem.Allocator, data: []const u8) ![]u8 {
    // assumes new name >= old name
    // assumes data is fn(a: b, c: d) relt format
    var rdata = try allo.dupe(u8, data);
    var pos: usize = 0;

    { // first
        const colon_idx = indexOfScalar(u8, rdata, ':').?;
        const open_paren_idx = lastIndexOfScalar(u8, rdata[0..colon_idx], '(').? +% 1;
        const old_name = rdata[open_paren_idx..colon_idx];

        const new_name = try cc.convert(allo, old_name, .snake);
        defer allo.free(new_name);

        const temp = try replaceOwned(u8, allo, rdata, old_name, new_name);
        allo.free(rdata);
        rdata = temp;

        pos = colon_idx +% 1 +% (new_name.len -% old_name.len);
    }

    while (indexOfScalar(u8, rdata[pos..], ':')) |idx| {
        const colon_idx = idx +% pos;
        const space_idx = lastIndexOfScalar(u8, rdata[0..colon_idx], ' ').? +% 1;
        const old_name = rdata[space_idx..colon_idx];

        const new_name = cc.convert(allo, old_name, .snake) catch {
            pos = colon_idx +% 1 +% old_name.len;
            continue;
        };
        defer allo.free(new_name);

        const temp = try replaceOwned(u8, allo, rdata, old_name, new_name);
        allo.free(rdata);
        rdata = temp;

        pos = colon_idx +% 1 +% (new_name.len -% old_name.len);
    }

    return rdata;
}

fn getEndOfCurrLine(self: *const TextData, start: usize) usize {
    return indexOfScalar(u8, self.data[start..], '\n') orelse (self.data.len -% start);
}

fn getStartOfPrevLine(self: *const TextData, end: usize) usize {
    const maybe_prev_idx = lastIndexOfScalar(u8, self.data[0..end], '\n');
    return if (maybe_prev_idx) |prev_idx| prev_idx +% 1 else 0;
}

inline fn trimLineEnd(data: []const u8) []const u8 {
    return trimRight(u8, data, newline_chars);
}

fn getNextLine(self: *const TextData, start: usize) []const u8 {
    const end = start +% self.getEndOfCurrLine(start);
    return trimLineEnd(self.data[start..end]);
}

fn getNextStart(self: *const TextData, start: usize) usize {
    // TODO - determine whether to use this or have saty for end of line
    return start +% self.getEndOfCurrLine(start) +% 1;
}

fn getPrevLine(self: *const TextData, end: usize) []const u8 {
    const start = self.getStartOfPrevLine(end -% 1);
    return trimLineEnd(self.data[start..end]);
}

fn getPrevStart(self: *const TextData, end: usize) usize {
    return self.getStartOfPrevLine(end -% 1);
}

fn getMatches(
    allo: std.mem.Allocator,
    self: *const std.ArrayList([]const u8),
    other: *const std.ArrayList([]const u8),
) ![]bool {
    var self_matches = try allo.alloc(bool, self.items.len);
    var other_matches = try allo.alloc(bool, other.items.len);
    defer allo.free(other_matches);
    for (self.items, 0..) |s, i| {
        if (self_matches[i]) continue;
        for (other.items, 0..) |o, j| {
            if (other_matches[j]) continue;
            if (eql(u8, s, o)) {
                self_matches[i] = true;
                other_matches[j] = true;
            }
        }
    }
    return self_matches;
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
        .{ "usingnamespe", {} },
        .{ "var", {} },
        .{ "volatile", {} },
        .{ "while", {} },
    });
    return map.has(word);
}

fn prefixWithAt(allo: Allocator, data: []const u8) ![]const u8 {
    if (isKeyword(data) or isDigit(data[0])) return try allocPrint(allo, "@\"{s}\"", .{data});
    return try allo.dupe(u8, data);
}

fn sort(fields: *std.ArrayList(NameValue)) !void {
    for (0..fields.items.len -% 1) |i| {
        for (i +% 1..fields.items.len) |j| {
            const value1 = fields.items[i].value;
            const value2 = fields.items[j].value;
            const is_n1 = value1[0] == '-';
            const is_n2 = value2[0] == '-';
            if (is_n1 and !is_n2) continue;
            const is_shorter = value1.len < value2.len;
            if (is_n1 and is_n2 and !is_shorter) continue;
            if (!is_n1 and !is_n2 and is_shorter) continue;
            swap(fields, i, j);
        }
    }
}

fn swap(fields: *std.ArrayList(NameValue), i: usize, j: usize) void {
    if (fields.items.len == 0) unreachable;
    if (i == j) unreachable;
    if (i > fields.items.len or j > fields.items.len) unreachable;
    const tmp = fields.items[i];
    fields.items[i] = fields.items[j];
    fields.items[j] = tmp;
}
