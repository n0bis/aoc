const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day4.txt");

const Move = struct {
    x: isize,
    y: isize,
};

const moves = [_]Move{
    Move{ .x = 1, .y = 0 },
    Move{ .x = 0, .y = 1 },
    Move{ .x = -1, .y = 0 },
    Move{ .x = 0, .y = -1 },
    Move{ .x = 1, .y = 1 },
    Move{ .x = 1, .y = -1 },
    Move{ .x = -1, .y = 1 },
    Move{ .x = -1, .y = -1 },
};

fn check(map: [][]const u8, row: usize, col: usize) u32 {
    var total: u32 = 0;
    for (moves) |move| {
        const max_row = @as(isize, @intCast(row)) + 3 * move.x;
        const max_col = @as(isize, @intCast(col)) + 3 * move.y;
        if (max_row >= 0 and max_row < map.len and max_col >= 0 and max_col < map[0].len) {
            const new_row = @as(isize, @intCast(row));
            const new_col = @as(isize, @intCast(col));
            if (map[@as(usize, @intCast(new_row + move.x))][@as(usize, @intCast(new_col + move.y))] == 'M' and
                map[@as(usize, @intCast(new_row + 2 * move.x))][@as(usize, @intCast(new_col + 2 * move.y))] == 'A' and
                map[@as(usize, @intCast(new_row + 3 * move.x))][@as(usize, @intCast(new_col + 3 * move.y))] == 'S')
            {
                total += 1;
            }
        }
    }
    return total;
}

fn check_x(map: [][]const u8, row: usize, col: usize) u32 {
    var total: u32 = 0;

    const new_row = @as(isize, @intCast(row));
    const new_col = @as(isize, @intCast(col));

    if (new_row - 1 >= 0 and new_row - 1 < map.len and
        new_row + 1 >= 0 and new_row + 1 < map.len and
        new_col - 1 >= 0 and new_col - 1 < map[0].len and
        new_col + 1 >= 0 and new_col + 1 < map[0].len)
    {
        const up_left = map[row - 1][col - 1];
        const up_right = map[row - 1][col + 1];
        const down_left = map[row + 1][col - 1];
        const down_right = map[row + 1][col + 1];
        const cross = .{ up_left, up_right, down_left, down_right };
        if (std.mem.eql(u8, &cross, "MMSS") or
            std.mem.eql(u8, &cross, "SSMM") or
            std.mem.eql(u8, &cross, "MSMS") or
            std.mem.eql(u8, &cross, "SMSM"))
        {
            total += 1;
        }
    }

    return total;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var lines = std.ArrayList([]const u8).init(allocator);

    var it = std.mem.tokenizeScalar(u8, input, '\n');
    while (it.next()) |line| {
        try lines.append(line);
    }
    var total: u32 = 0;
    var x_total: u32 = 0;
    for (0..lines.items.len) |row| {
        for (0..lines.items[0].len) |col| {
            if (lines.items[row][col] == 'X') {
                total += check(lines.items, row, col);
            }
            if (lines.items[row][col] == 'A') {
                x_total += check_x(lines.items, row, col);
            }
        }
    }
    print("Total: {}\n", .{total});
    print("Total MAS X patterns: {}\n", .{x_total});
}
