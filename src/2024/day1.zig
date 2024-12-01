const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day1.txt");

pub fn part1(left: []i32, right: []i32) void {
    std.mem.sort(i32, left, {}, std.sort.asc(i32));
    std.mem.sort(i32, right, {}, std.sort.asc(i32));

    var sum: u32 = 0;
    for (0..left.len) |i| {
        sum += @abs(left[i] - right[i]);
    }

    print("part1: {d}\n", .{sum});
}

pub fn part2(left: []i32, h: *std.AutoHashMap(i32, i32)) void {
    var sum: i32 = 0;
    for (left) |i| {
        const count = h.get(i) orelse 0;
        sum += i * count;
    }
    print("part2: {d}\n", .{sum});
}

pub fn part2Mem(left: []i32, right: []i32) void {
    var sum: i32 = 0;
    for (left) |i| {
        const count: i32 = @intCast(std.mem.count(i32, right, &[_]i32{i}));
        sum += count * i;
    }
    print("part2 mem: {d}\n", .{sum});
}

pub fn solve() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var h = std.AutoHashMap(i32, i32).init(allocator);
    defer h.deinit();

    var it = std.mem.tokenizeScalar(u8, input, '\n');

    var a: std.ArrayList(i32) = std.ArrayList(i32).init(allocator);
    var b: std.ArrayList(i32) = std.ArrayList(i32).init(allocator);

    while (it.next()) |token| {
        var line = std.mem.split(u8, token, "   ");
        const left_value = try std.fmt.parseInt(i32, line.next().?, 10);
        const right_value = try std.fmt.parseInt(i32, line.next().?, 10);
        try a.append(left_value);
        try b.append(right_value);
        if (h.get(right_value)) |v| try h.put(right_value, v + 1) else try h.put(right_value, 1);
    }

    const left = try a.toOwnedSlice();
    const right = try b.toOwnedSlice();

    part1(left, right);
    part2(left, &h);
    part2Mem(left, right);
}
