const std = @import("std");

// Zig 0.14.0-dev.1860+2e2927735 (works with zig 0.13.0 too)
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module = b.addModule("z80", .{
        .root_source_file = b.path("src/zig80.zig"),
    });

    const lib = b.addStaticLibrary(.{
        .name = "z80",
        .root_source_file = b.path("src/zig80.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .target = target,
        .name = "cpu",
        .root_source_file = b.path("examples/main.zig"),
        .optimize = optimize,
    });

    exe.root_module.addImport("z80", module);

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the example app");
    run_step.dependOn(&run_cmd.step);

    const main_tests = b.addTest(.{
        .root_source_file = b.path("src/tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    // test files are GPL licensed, so they are excluded from the distribution
    // const download_tests = b.addSystemCommand(&.{ "python", "tools/download_tests.py", "src/tests" });
    const download_tests = b.addSystemCommand(&.{ "bash", "tools/download_tests.sh", "src/tests" });
    main_tests.step.dependOn(&download_tests.step);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
