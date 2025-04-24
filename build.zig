const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // dependencies:
    const BitTricks = b.dependency("BitTricks", .{});
    const CodingCase = b.dependency("CodingCase", .{});
    const PackedEnumSet = b.dependency("PackedEnumSet", .{});

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const exe = b.addExecutable(.{
        .name = "TranslateVulkan",
        .root_module = exe_mod,
        .link_libc = true,
    });
    exe.root_module.addLibraryPath(b.path("Vulkan/Lib"));
    exe.root_module.linkSystemLibrary("vulkan-1", .{});
    exe.addIncludePath(b.path("Vulkan/Include"));
    exe.root_module.addImport("BitTricks", BitTricks.module("BitTricks"));
    exe.root_module.addImport("CodingCase", CodingCase.module("CodingCase"));
    exe.root_module.addImport("PackedEnumSet", PackedEnumSet.module("PackedEnumSet"));
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .target = target,
        .optimize = optimize,
        .root_module = exe_mod,
        .link_libc = true,
    });
    exe_unit_tests.root_module.addLibraryPath(b.path("Vulkan/Lib"));
    exe_unit_tests.root_module.linkSystemLibrary("vulkan-1", .{});
    exe_unit_tests.addIncludePath(b.path("Vulkan/Include"));
    exe_unit_tests.root_module.addImport("BitTricks", BitTricks.module("BitTricks"));
    exe_unit_tests.root_module.addImport("CodingCase", CodingCase.module("CodingCase"));
    exe_unit_tests.root_module.addImport("PackedEnumSet", PackedEnumSet.module("PackedEnumSet"));
    b.installArtifact(exe_unit_tests);

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
