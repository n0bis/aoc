const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day15.txt");

const width = 51;
const height = 50;

const Direction = enum { Up, Down, Left, Right };

fn parseDirection(c: u8) Direction {
    switch (c) {
        '^' => return .Up,
        'v' => return .Down,
        '<' => return .Left,
        '>' => return .Right,
        else => unreachable,
    }
}

fn calculateNewPosition(pos: usize, dir: Direction) usize {
    switch (dir) {
        .Up => return pos - width,
        .Down => return pos + width,
        .Left => return pos - 1,
        .Right => return pos + 1,
    }
}

fn isWall(map: []const u8, pos: usize) bool {
    return map[pos] == '#';
}

fn isBox(map: []const u8, pos: usize) bool {
    return map[pos] == 'O';
}

fn isFree(map: []const u8, pos: usize) bool {
    return map[pos] == '.';
}

fn simulate(map: *[width * height]u8, moves: []const u8) !void {
    var robot_pos: usize = std.mem.indexOf(u8, map, "@").?;

    for (moves) |move| {
        if (move == '\n') continue;
        const dir = parseDirection(move);

        var next_pos = robot_pos;
        while (!isFree(map, next_pos) and !isWall(map, next_pos)) next_pos = calculateNewPosition(next_pos, dir);
        if (isWall(map, next_pos)) continue;

        map[next_pos] = 'O';
        map[robot_pos] = '.';
        robot_pos = calculateNewPosition(robot_pos, dir);
        map[robot_pos] = '@';
    }
}

fn calculateGPS(map: []const u8) usize {
    var sum: usize = 0;
    for (map, 0..) |element, i| {
        if (element == 'O') {
            sum += 100 * (i / width) + (i % width);
        }
    }
    return sum;
}

pub fn main() !void {
    const map_input = input[0..(width * height)];
    const moves_input = std.mem.trim(u8, input[(width * height)..], "\n");

    print("width: {}\n", .{std.mem.indexOf(u8, map_input, "\n").? + 1});

    var map: [(width * height)]u8 = undefined;
    @memcpy(&map, map_input);

    try simulate(&map, moves_input);
    const gps_sum = calculateGPS(&map);
    print("Final map:\n{s}\n", .{map});
    print("Sum of all boxes' GPS coordinates: {}\n", .{gps_sum});
}
