const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day5.txt");

const Rule = struct { left: i32, right: i32 };
const PageComparer = struct {
    rules: []const Rule,
    fn compare(self: PageComparer, x: i32, y: i32) std.math.Order {
        for (self.rules) |rule| {
            if (rule.left == x and rule.right == y) return .lt;
            if (rule.left == y and rule.right == x) return .gt;
        }
        return .eq;
    }
};

fn lessThan(comparer: PageComparer, lhs: i32, rhs: i32) bool {
    return comparer.compare(lhs, rhs) == .lt;
}

fn is_ordered(update: []i32, comparer: PageComparer) bool {
    for (0..update.len) |i| {
        for (i + 1..update.len) |j| {
            if (comparer.compare(update[i], update[j]) == .gt) {
                return false;
            }
        }
    }
    return true;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var rules = std.ArrayList(Rule).init(allocator);
    defer rules.deinit();
    var pages = std.ArrayList([]i32).init(allocator);
    defer pages.deinit();

    var it = std.mem.tokenizeScalar(u8, input, '\n');
    while (it.next()) |line| {
        if (std.mem.indexOfScalar(u8, line, '|') != null) {
            var seperator = std.mem.splitScalar(u8, line, '|');
            const left_value = try std.fmt.parseInt(i32, seperator.next().?, 10);
            const right_value = try std.fmt.parseInt(i32, seperator.next().?, 10);
            try rules.append(Rule{ .left = left_value, .right = right_value });
        }
        if (std.mem.indexOfScalar(u8, line, ',') != null) {
            var numbers = std.ArrayList(i32).init(allocator);
            defer numbers.deinit();
            var seperator = std.mem.splitScalar(u8, line, ',');
            while (seperator.next()) |number| {
                try numbers.append(try std.fmt.parseInt(i32, number, 10));
            }
            try pages.append(try numbers.toOwnedSlice());
        }
    }

    const comparer = PageComparer{ .rules = rules.items };
    var total_middle_pages: i32 = 0;
    for (pages.items) |update| {
        if (!is_ordered(update, comparer)) {
            std.mem.sort(i32, update, comparer, lessThan);
            const middle_index = update.len / 2;
            total_middle_pages += update[middle_index];
        }
    }

    print("Total middle pages sum: {}\n", .{total_middle_pages});
}
