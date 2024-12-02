const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day2.txt");

pub fn validLevels(levels: std.ArrayList(std.ArrayList(i32))) !void {
    var safe: u32 = 0;
    for (levels.items) |item| {
        if (validLevel(item.items)) {
            safe += 1;
            continue;
        }
        if (try canBecomeSafe(item)) safe += 1;
    }
    print("safe count: {d}\n", .{safe});
}

pub fn canBecomeSafe(level: std.ArrayList(i32)) !bool {
    for (0..level.items.len) |i| {
        var copy = try level.clone();
        _ = copy.orderedRemove(i);
        const modified_level = copy;
        if (validLevel(modified_level.items)) {
            return true;
        }
    }
    return false;
}

pub fn validLevel(level: []const i32) bool {
    const is_inc = level[1] > level[0];
    var window_iter = std.mem.window(i32, level, 2, 1);
    while (window_iter.next()) |pair| {
        const current = pair[0];
        const next = pair[1];
        const diff = @abs(next - current);
        if (diff < 1 or diff > 3) return false;
        if (is_inc and next <= current) return false;
        if (!is_inc and next >= current) return false;
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
    try validLevels(levels);
}
