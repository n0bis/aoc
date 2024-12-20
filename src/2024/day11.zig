const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day11.txt");

const Map = std.AutoArrayHashMap(u64, u64);

fn count_stones(stones: *Map, blinks: usize) !u64 {
    for (0..blinks) |_| {
        var new_stones: Map = try stones.clone();
        defer new_stones.deinit();
        stones.clearRetainingCapacity();
        var it = new_stones.iterator();
        while (it.next()) |entry| {
            const stone = entry.key_ptr.*;
            const count = entry.value_ptr.*;
            if (stone == 0) {
                const new_count = try stones.getOrPutValue(1, 0);
                new_count.value_ptr.* += count;
            } else {
                const digits = std.math.log10_int(stone) + 1;
                if (digits % 2 == 0) {
                    const shift = std.math.pow(u64, 10, digits / 2);
                    const left = try stones.getOrPutValue(stone / shift, 0);
                    left.value_ptr.* += count;
                    const right = try stones.getOrPutValue(stone % shift, 0);
                    right.value_ptr.* += count;
                } else {
                    const new_count = try stones.getOrPutValue(stone * 2024, 0);
                    new_count.value_ptr.* += count;
                }
            }
        }
    }
    var sum: u64 = 0;
    var it = stones.iterator();
    while (it.next()) |stone| {
        sum += stone.value_ptr.*;
    }
    return sum;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var it = std.mem.tokenizeSequence(u8, input, " ");
    var stones: Map = Map.init(allocator);
    defer stones.deinit();

    while (it.next()) |line| {
        const stone = try std.fmt.parseInt(u64, line, 10);
        const count = try stones.getOrPutValue(stone, 0);
        count.value_ptr.* += 1;
    }

    const count = try count_stones(&stones, 25);
    print("Stones: {}\n", .{count});
}
