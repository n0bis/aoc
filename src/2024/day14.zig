const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day14.txt");

const width = 101;
const height = 103;
const seconds = 100;
const Pos = @Vector(2, isize);

fn extract(robot: []const u8) !Pos {
    var it = std.mem.splitSequence(u8, robot, ",");
    const x = try std.fmt.parseInt(isize, it.next().?, 10);
    const y = try std.fmt.parseInt(isize, it.next().?, 10);
    return Pos{ x, y };
}

fn move(pos: Pos, vel: Pos, splat: isize) Pos {
    return Pos{ @mod(pos[0] + vel[0] * splat, width), @mod(pos[1] + vel[1] * splat, height) };
}

pub fn main() !void {
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
