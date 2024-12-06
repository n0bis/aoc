const std = @import("std");
const print = std.debug.print;
const input = @embedFile("day3.txt");

const State = enum { start, m, mu, mul, mul_start, mul_num1, mul_seperator, mul_num2 };

const StateMachine = struct {
    state: State,
    num1: u64,
    num2: u64,
    sum: u64,

    pub fn init() StateMachine {
        return StateMachine{ .state = State.start, .num1 = 0, .num2 = 0, .sum = 0 };
    }

    pub fn scan(self: *StateMachine, c: u8) void {
        switch (c) {
            'm' => self.state = State.m,
            'u' => self.state = if (self.state == State.m) State.mu else State.start,
            'l' => self.state = if (self.state == State.mu) State.mul else State.start,
            '(' => self.state = if (self.state == State.mul) State.mul_start else State.start,
            '0'...'9' => {
                const digit = @as(u64, @intCast(c - '0'));
                switch (self.state) {
                    State.mul_start, State.mul_num1 => {
                        self.num1 = self.num1 * 10 + digit;
                        self.state = State.mul_num1;
                    },
                    State.mul_seperator, State.mul_num2 => {
                        self.num2 = self.num2 * 10 + digit;
                        self.state = State.mul_num2;
                    },
                    else => self.state = State.start,
                }
            },
            ',' => self.state = if (self.state == State.mul_num1) State.mul_seperator else State.start,
            ')' => {
                if (self.state == State.mul_num2) {
                    self.sum += self.num1 * self.num2;
                }
                self.reset();
            },
            else => self.reset(),
        }
    }

    fn reset(self: *StateMachine) void {
        self.state = State.start;
        self.num1 = 0;
        self.num2 = 0;
    }
};

pub fn main() !void {
    var sm = StateMachine.init();
    var it = std.mem.tokenizeScalar(u8, input, '\n');
    while (it.next()) |line| {
        for (line) |c| {
            sm.scan(c);
        }
    }
    print("Sum: {}\n", .{sm.sum});
}
