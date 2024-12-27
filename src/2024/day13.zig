const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day13.txt");

const ClawMachine = struct {
    xa: f64,
    ya: f64,
    xb: f64,
    yb: f64,
    xp: f64,
    yp: f64,

    fn extractCoords(line: []const u8, x_prefix: []const u8, y_prefix: []const u8) ![2]f64 {
        const x_start = std.mem.indexOf(u8, line, x_prefix).? + x_prefix.len;
        const x_end = std.mem.indexOf(u8, line[x_start..], ",") orelse line.len - x_start;
        const x = try std.fmt.parseFloat(f64, line[x_start .. x_start + x_end]);

        const y_start = std.mem.indexOf(u8, line, y_prefix).? + y_prefix.len;
        const y_end = line.len;
        const y = try std.fmt.parseFloat(f64, line[y_start..y_end]);

        return .{ x, y };
    }

    fn parse(block: []const u8) !ClawMachine {
        var lines = std.mem.splitSequence(u8, block, "\n");
        const line_a = lines.next().?;
        const line_b = lines.next().?;
        const line_p = lines.next().?;

        const a = try ClawMachine.extractCoords(line_a, "X+", "Y+");
        const b = try ClawMachine.extractCoords(line_b, "X+", "Y+");
        const p = try ClawMachine.extractCoords(line_p, "X=", "Y=");

        return ClawMachine{ .xa = a[0], .ya = a[1], .xb = b[0], .yb = b[1], .xp = p[0] + 10000000000000, .yp = p[1] + 10000000000000 };
    }
};

pub fn main() !void {
    var tokens: u64 = 0;
    var it = std.mem.splitSequence(u8, std.mem.trim(u8, input, " \n"), "\n\n");
    while (it.next()) |machine| {
        const cm = try ClawMachine.parse(machine);
        const a = (cm.xp * cm.yb - cm.yp * cm.xb) / (cm.xa * cm.yb - cm.ya * cm.xb);
        const b = (cm.xp - a * cm.xa) / cm.xb;
        if (a == @round(a) and b == @round(b)) {
            tokens += @intFromFloat(3.0 * a + b);
        }
    }
    print("Tokens: {}\n", .{tokens});
}
