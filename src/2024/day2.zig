const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day2.txt");

pub fn validLevels(levels: std.ArrayList(std.ArrayList(i32))) void {
    var safe: u32 = 0;
    for (levels.items) |item| {
        if (validLevel(item.items)) safe += 1;
    }
    print("safe count: {d}\n", .{safe});
}

pub fn validLevel(level: []const i32) bool {
    const is_inc = level[1] > level[0];
    for (0..level.len - 1) |i| {
        const diff = @abs(level[i + 1] - level[i]);
        if (diff < 1 or diff > 3) return false;
        if (is_inc and level[i + 1] <= level[i]) return false;
        if (!is_inc and level[i + 1] >= level[i]) return false;
    }
    return true;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var levels: std.ArrayList(std.ArrayList(i32)) = std.ArrayList(std.ArrayList(i32)).init(allocator);

    var it = std.mem.tokenizeScalar(u8, input, '\n');
    while (it.next()) |token| {
        var level: std.ArrayList(i32) = std.ArrayList(i32).init(allocator);
        var line = std.mem.split(u8, token, " ");
        while (line.next()) |current| {
            const current_int = try std.fmt.parseInt(i32, current, 10);
            try level.append(current_int);
        }
        try levels.append(level);
    }
    validLevels(levels);
}
