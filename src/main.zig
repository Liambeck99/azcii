const std = @import("std");
const zigimg = @import("zigimg");

pub fn main() !void {
    std.debug.print("AZCII - Zig ASCII Art Generator\n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var file = try std.fs.cwd().openFile("assets/smile.png", .{});
    defer file.close();

    var image = try zigimg.Image.fromFile(allocator, &file);
    defer image.deinit();

    std.debug.print("height ->{}\nwidth -> {}\n", .{ image.height, image.width });

    for (image.pixels.rgba32, 0..) |pixel, index| {
        if (index % image.width == 0) {
            std.debug.print("\n", .{});
        }
        if (pixel.r > 0) {
            std.debug.print("$", .{});
        } else {
            std.debug.print(" ", .{});
        }
    }
}
