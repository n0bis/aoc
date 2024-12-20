const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day10.txt");

const directions = [4][2]i8{ .{ -1, 0 }, .{ 1, 0 }, .{ 0, -1 }, .{ 0, 1 } };

var mapBox: [2]usize = .{ 0, 0 };

fn valid(pos: [2]i64) bool {
    return pos[0] >= 0 and pos[1] >= 0 and pos[0] < mapBox[0] and pos[1] < mapBox[1];
}

const Set = std.AutoHashMap([2]usize, bool);
const Map = std.AutoArrayHashMap([2]usize, u64);

fn count_trails(map: *Map, x: usize, y: usize, height: u8, visited: *Set) !u64 {
    if (height == 9 and !visited.contains(.{ x, y })) {
        try visited.put(.{ x, y }, true);
        return 1;
    }

    var score: u64 = 0;
    for (directions) |dir| {
        const newX = @as(i8, @intCast(x)) + dir[0];
        const newY = @as(i8, @intCast(y)) + dir[1];
        if (valid([2]i64{ newX, newY })) {
            const newPos: [2]usize = .{ @as(usize, @intCast(newX)), @as(usize, @intCast(newY)) };
            if (map.get(newPos) == height + 1) {
                score += try count_trails(map, @as(usize, @intCast(newX)), @as(usize, @intCast(newY)), height + 1, visited);
            }
        }
    }

    return score;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var it = std.mem.tokenizeScalar(u8, input, '\n');
    var map: Map = std.AutoArrayHashMap([2]usize, u64).init(allocator);
    defer map.deinit();

    var row: usize = 0;
    var ylen: usize = 0;
    while (it.next()) |line| : (row += 1) {
        if (ylen == 0) {
            ylen = line.len;
        }
        for (line, 0..) |ch, col| {
            try map.put(.{ row, col }, ch - '0');
        }
    }

    mapBox = .{ row, ylen };

    var trailHeads: u64 = 0;
    var iterator = map.iterator();
    while (iterator.next()) |entry| {
        if (entry.value_ptr.* == 0) {
            var visited: Set = std.AutoHashMap([2]usize, bool).init(allocator);
            defer visited.deinit();
            trailHeads += try count_trails(&map, entry.key_ptr.*[0], entry.key_ptr.*[1], 0, &visited);
        }
    }
    print("Trail heads: {}\n", .{trailHeads});
}
