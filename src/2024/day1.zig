const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day1.txt");

pub fn solve() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var h = std.AutoHashMap(i32, i32).init(allocator);
    defer h.deinit();

    var a: [1000]i32 = undefined;
    var b: [1000]i32 = undefined;

    var it = std.mem.tokenizeScalar(u8, input, '\n');
    var idx: usize = 0;

    while (it.next()) |token| {
        var line = std.mem.split(u8, token, "   ");
        const left = line.next().?;
        const right = line.next().?;
        const left_value = try std.fmt.parseInt(i32, left, 10);
        const right_value = try std.fmt.parseInt(i32, right, 10);
        a[idx] = (left_value);
        b[idx] = (right_value);
        if (h.get(right_value)) |v| try h.put(right_value, v + 1) else try h.put(right_value, 1);
        idx += 1;
    }

    std.mem.sort(i32, &a, {}, std.sort.asc(i32));
    std.mem.sort(i32, &b, {}, std.sort.asc(i32));

    const va: @Vector(1000, i32) = a;
    const vb: @Vector(1000, i32) = b;
    const c = @abs(va - vb);
    var d: i32 = 0;
    print("hello advent of code {any}\n", .{@reduce(.Add, c)});
    for (a) |i| {
        const count = h.get(i) orelse 0;
        d += i * count;
    }
    print("{any}", .{d});
}
