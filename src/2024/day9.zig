const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day9.txt");

fn file_sum(x: u64, n: u64, block_id: u64) u64 {
    return ((((2 * x) + n - 1) * n) / 2) * block_id;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const n: u64 = input.len;
    var line: []u8 = try allocator.alloc(u8, n);
    defer allocator.free(line);
    @memcpy(line, input);
    var last_block_idx: u64 = if (n % 2 == 0) n - 2 else n - 1;
    var idx: usize = 0;
    var block_idx: usize = 0;
    var check_sum: u64 = 0;
    while (idx <= last_block_idx) {
        if (idx % 2 == 0) {
            check_sum += file_sum(block_idx, line[idx] - '0', idx / 2);
            block_idx += line[idx] - '0';
            idx += 1;
        } else {
            const new_n = @min(line[idx] - '0', line[last_block_idx] - '0');
            check_sum += file_sum(block_idx, new_n, last_block_idx / 2);
            line[idx] -= new_n;
            line[last_block_idx] -= new_n;
            block_idx += new_n;
            if (line[idx] == '0') {
                idx += 1;
            }
            if (line[last_block_idx] == '0') {
                last_block_idx -= 2;
            }
        }
    }
    print("Checksum: {}\n", .{check_sum});
}
