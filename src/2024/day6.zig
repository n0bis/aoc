const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day6.txt");

const Point = struct { x: i32, y: i32 };

const directions = &[4]Point{
    .{ .x = 0, .y = -1 },
    .{ .x = 1, .y = 0 },
    .{ .x = 0, .y = 1 },
    .{ .x = -1, .y = 0 },
};

inline fn valid(x: i32, y: i32, xlen: i32, ylen: i32) bool {
    return x >= 0 and y >= 0 and x < xlen and y < ylen;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var lines = std.ArrayList([]const u8).init(allocator);
    defer lines.deinit();

    var pos: Point = .{ .x = 0, .y = 0 };

    var row: i32 = 0;
    var it = std.mem.tokenizeScalar(u8, input, '\n');
    while (it.next()) |line| : (row += 1) {
        try lines.append(line);
        if (std.mem.indexOf(u8, line, "^") != null) {
            pos = .{ .x = @as(i32, @intCast(std.mem.indexOf(u8, line, "^").?)), .y = row };
        }
    }

    var visited_count: u32 = 1;
    var visisted = std.AutoArrayHashMap([2]i32, bool).init(allocator);
    defer visisted.deinit();
    try visisted.put([2]i32{ pos.x, pos.y }, true);

    var direction: usize = 0;
    while (true) {
        const add = directions[direction];
        const next: Point = .{ .x = pos.x + add.x, .y = pos.y + add.y };
        if (!valid(next.x, next.y, @intCast(lines.items[0].len), @intCast(lines.items.len))) {
            break;
        }
        const item = lines.items[@as(usize, @intCast(next.y))][@as(usize, @intCast(next.x))];
        switch (item) {
            '.' => {
                if (visisted.get([2]i32{ next.x, next.y }) == null) {
                    visited_count += 1;
                    try visisted.put([2]i32{ next.x, next.y }, true);
                }
                pos = next;
            },
            '^' => pos = next,
            '#' => direction = (direction + 1) % directions.len,
            else => unreachable,
        }
    }

    print("Visited {}\n", .{visited_count});
}
