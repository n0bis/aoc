const std = @import("std");
const print = std.debug.print;

const puzzle = @import("2024/day1.zig");

pub fn main() !void {
    try puzzle.solve();
}
