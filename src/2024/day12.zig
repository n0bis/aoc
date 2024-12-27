const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day12.test");

const directions = [4][2]i8{ .{ -1, 0 }, .{ 1, 0 }, .{ 0, -1 }, .{ 0, 1 } };
const Allocator = std.mem.Allocator;

const UnionFind = struct {
    const Node = union(enum) { parent: usize, rank: usize };

    const Self = @This();

    allocator: Allocator,
    uf: []Node,

    fn init(allocator: Allocator, len: usize) !Self {
        const uf = try allocator.alloc(Node, len);
        @memset(uf, .{ .rank = 1 });
        return Self{ .allocator = allocator, .uf = uf };
    }

    fn deinit(self: *Self) void {
        self.allocator.free(self.uf);
    }

    fn find(self: *Self, x: usize) usize {
        switch (self.uf[x]) {
            .rank => return x,
            .parent => |*p| {
                p.* = self.find(p.*);
                return p.*;
            },
        }
    }

    fn sizeOf(self: *Self, x: usize) usize {
        return self.uf[self.find(x)].rank;
    }

    fn merge(self: *Self, x: usize, y: usize) void {
        var a = self.find(x);
        var b = self.find(y);
        if (a == b) return;
        if (self.uf[b].rank > self.uf[a].rank) {
            std.mem.swap(usize, &a, &b);
        }
        self.uf[b].rank += self.uf[a].rank;
        self.uf[a] = .{ .parent = b };
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var grid = std.ArrayList([]const u8).init(allocator);
    defer grid.deinit();

    var it = std.mem.tokenizeSequence(u8, input, "\n");
    while (it.next()) |line| {
        try grid.append(line);
    }

    const height = grid.items.len;
    const width = grid.items[0].len;
    const size = height * width;

    var union_find = try UnionFind.init(allocator, size);
    defer union_find.deinit();

    for (grid.items, 0..) |line, row| {
        for (line, 0..) |plant, col| {
            const idx = row * width + col;
            if (col > 0 and plant == grid.items[row][col - 1]) union_find.merge(idx, idx - 1);
            if (row > 0 and plant == grid.items[row - 1][col]) union_find.merge(idx, idx - width);
        }
    }

    var total_price: u64 = 0;

    for (grid.items, 0..) |line, row| {
        for (line, 0..) |plant, col| {
            const idx = row * width + col;
            for (directions) |dir| {
                const new_row = @as(isize, @intCast(row)) + dir[0];
                const new_col = @as(isize, @intCast(col)) + dir[1];
                if (new_row < 0 or new_row >= grid.items.len or new_col < 0 or new_col >= width or grid.items[@as(usize, @intCast(new_row))][@as(usize, @intCast(new_col))] != plant) {
                    total_price += @intCast(union_find.sizeOf(idx));
                }
            }
        }
    }

    print("Total price of {}\n", .{total_price});
}
