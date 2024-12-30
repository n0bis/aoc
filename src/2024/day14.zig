const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day14.txt");

const width = 101;
const height = 103;
const seconds = 100;
const Pos = @Vector(2, isize);
const Robot = struct { pos: Pos, vel: Pos };

fn extract(robot: []const u8) !Pos {
    var it = std.mem.splitSequence(u8, robot, ",");
    const x = try std.fmt.parseInt(isize, it.next().?, 10);
    const y = try std.fmt.parseInt(isize, it.next().?, 10);
    return Pos{ x, y };
}

fn move(pos: Pos, vel: Pos, splat: isize) Pos {
    return Pos{ @mod(pos[0] + vel[0] * splat, width), @mod(pos[1] + vel[1] * splat, height) };
}

fn part1() !void {
    var quadrants = [2][2]u64{ [_]u64{ 0, 0 }, [_]u64{ 0, 0 } };
    var it = std.mem.splitSequence(u8, input, "\n");
    while (it.next()) |line| {
        var robot = std.mem.splitSequence(u8, line, " ");
        var robot_pos = try extract(robot.next().?[2..]);
        const robot_vel = try extract(robot.next().?[2..]);
        robot_pos = move(robot_pos, robot_vel, seconds);
        if (robot_pos[0] == width / 2 or robot_pos[1] == height / 2) continue;
        quadrants[@intFromBool(robot_pos[0] > width / 2)][@intFromBool(robot_pos[1] > height / 2)] += 1;
    }
    const sum = quadrants[0][0] * quadrants[0][1] * quadrants[1][0] * quadrants[1][1];
    print("Safety factor: {}\n", .{sum});
}

fn checkConsecutive(map: std.AutoHashMap(Pos, void), len: usize) bool {
    for (0..height) |y| {
        var count: usize = 0;
        for (0..width) |x| {
            const pos = Pos{ @intCast(x), @intCast(y) };
            if (map.contains(pos)) {
                count += 1;
                if (count == len) return true;
            } else {
                count = 0;
            }
        }
    }
    for (0..width) |x| {
        var count: usize = 0;
        for (0..height) |y| {
            const pos = Pos{ @intCast(x), @intCast(y) };
            if (map.contains(pos)) {
                count += 1;
                if (count == len) return true;
            } else {
                count = 0;
            }
        }
    }
    return false;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var robots = std.ArrayList(Robot).init(allocator);
    defer robots.deinit();

    var it = std.mem.splitSequence(u8, input, "\n");
    while (it.next()) |line| {
        var robot = std.mem.splitSequence(u8, line, " ");
        const robot_pos = try extract(robot.next().?[2..]);
        const robot_vel = try extract(robot.next().?[2..]);
        try robots.append(Robot{ .pos = robot_pos, .vel = robot_vel });
    }

    var map = std.AutoHashMap(Pos, void).init(allocator);
    defer map.deinit();

    const max = width * height;
    for (1..max) |i| {
        map.clearRetainingCapacity();
        for (robots.items) |*r| {
            r.pos = move(r.pos, r.vel, 1);
            try map.put(r.pos, {});
        }
        if (checkConsecutive(map, 10)) {
            print("10 consecutive robots at {}\n", .{i});
            break;
        }
    }
}
