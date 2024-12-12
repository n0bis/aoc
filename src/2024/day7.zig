const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day7.txt");

const Equation = struct {
    test_result: u64,
    numbers: []u64,
    fn evaluate_part1(self: *Equation) u64 {
        const limit = self.numbers.len;
        if (limit == 0) return 0;
        const combinations: u64 = (@as(u64, @intCast(1))) << @as(u6, @intCast(limit - 1));
        for (0..combinations) |combination| {
            var result = self.numbers[0];
            var ops = combination;
            for (1..limit) |idx| {
                if (ops & 1 == 0) {
                    result += self.numbers[idx];
                } else {
                    result *= self.numbers[idx];
                }
                ops >>= 1;
            }
            if (result == self.test_result) {
                return result;
            }
        }
        return 0;
    }

    fn evaluate_part2(self: *Equation) u64 {
        const limit = self.numbers.len;
        if (limit == 0) return 0;
        const combinations: u64 = std.math.pow(u64, 3, limit - 1);
        var count: u64 = 0;
        while (count < combinations) : (count += 1) {
            var result = self.numbers[0];
            var ops = count;
            for (1..limit) |idx| {
                const cur_op = ops % 3;
                ops /= 3;
                switch (cur_op) {
                    0 => result *= self.numbers[idx],
                    1 => result += self.numbers[idx],
                    2 => result = concatInt(result, self.numbers[idx]),
                    else => unreachable,
                }
                if (result > self.test_result) {
                    break;
                }
            }
            if (result == self.test_result) {
                return result;
            }
        }
        return 0;
    }
};

fn concatInt(x: u64, y: u64) u64 {
    var factor: u64 = 10;
    while (y >= factor) {
        factor *= 10;
    }
    return x * factor + y;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var lines = std.ArrayList([]const u8).init(allocator);
    defer lines.deinit();
    var result_part1: u64 = 0;
    var result_part2: u64 = 0;

    var it = std.mem.tokenizeScalar(u8, input, '\n');
    while (it.next()) |line| {
        var split = std.mem.splitAny(u8, line, ": ");
        const test_result = try std.fmt.parseInt(u64, split.first(), 10);
        var numbers = std.ArrayList(u64).init(allocator);
        defer numbers.deinit();

        while (split.next()) |num| {
            if (num.len < 1) {
                continue;
            }
            const number = try std.fmt.parseInt(u64, num, 10);
            try numbers.append(number);
        }
        var equation = Equation{ .test_result = test_result, .numbers = numbers.items };
        result_part1 += equation.evaluate_part1();
        result_part2 += equation.evaluate_part2();
    }
    print("Result part1: {d}\n", .{result_part1});
    print("Result part2: {d}\n", .{result_part2});
}
