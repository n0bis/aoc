const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day8.txt");

fn check_bounds(vec: @Vector(2, i64), width: i64, height: i64) bool {
    return vec[0] >= 0 and vec[1] >= 0 and vec[0] < width and vec[1] < height;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var antennas = std.AutoHashMap(u8, std.ArrayList(@Vector(2, i64))).init(allocator);
    defer antennas.deinit();

    var it = std.mem.tokenizeScalar(u8, input, '\n');
    var row: i64 = 0;
    var width: i64 = 0;
    while (it.next()) |line| : (row += 1) {
        for (line, 0..) |c, i| {
            if (c == '.') {
                continue;
            }
            if (width == 0) {
                width = @as(i64, @intCast(line.len));
            }
            const antenna = try antennas.getOrPut(c);
            if (!antenna.found_existing) {
                antenna.value_ptr.* = std.ArrayList(@Vector(2, i64)).init(allocator);
            }
            try antenna.value_ptr.*.append(.{ row, @as(i64, @intCast(i)) });
        }
    }

    var antinodes = std.AutoHashMap(@Vector(2, i64), bool).init(allocator);
    defer antinodes.deinit();

    var iter = antennas.iterator();
    while (iter.next()) |antenna| {
        const positions = antenna.value_ptr.*.items;
        for (positions, 0..) |antenna1, i| {
            for (positions[(i + 1)..]) |antenna2| {
                const diff = antenna2 - antenna1;
                const antinode1 = antenna2 + diff;
                const antinode2 = antenna1 - diff;
                if (check_bounds(antinode1, width, row)) {
                    try antinodes.put(antinode1, true);
                }
                if (check_bounds(antinode2, width, row)) {
                    try antinodes.put(antinode2, true);
                }
            }
        }
    }
    print("Unique locations: {d}\n", .{antinodes.count()});
}
