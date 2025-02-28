const std = @import("std");
const zigimg = @import("zigimg");

const characters: [10]u8 = .{ ' ', '.', ':', '-', '=', '+', '*', '#', '%', '@' };

pub fn main() !void {
    std.debug.print("AZCII - Zig ASCII Art Generator\n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var file = try std.fs.cwd().openFile("assets/turtwig.png", .{});
    defer file.close();

    var image = try zigimg.Image.fromFile(allocator, &file);
    defer image.deinit();

    const stdout = std.io.getStdOut().writer();

    for (image.pixels.rgba32, 0..) |pixel, index| {
        if (index % image.width == 0) {
            std.debug.print("\n", .{});
        }
        try writeCharacter(stdout, pixel);
    }
}

fn writeCharacter(writer: anytype, pixel: zigimg.color.Rgba32) !void {
    const sum: u32 = @as(u32, pixel.r) + @as(u32, pixel.g) + @as(u32, pixel.b);
    const sum_as_float: f32 = @floatFromInt(sum);
    const normalized_avg: f32 = sum_as_float / 3 / 256.0;
    const character_index: usize = @intFromFloat(std.math.round(normalized_avg * 9));

    try writer.print("\x1b[38;2;{};{};{}m{c} \x1b[0m", .{ pixel.r, pixel.g, pixel.b, characters[character_index] });
}
