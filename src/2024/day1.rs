use std::collections::HashMap;
use std::fs;

fn part1(left: &mut [i32], right: &mut [i32]) {
    left.sort_unstable();
    right.sort_unstable();

    let sum: i32 = left
        .iter()
        .zip(right.iter())
        .map(|(l, r)| (l - r).abs())
        .sum();

    println!("part1: {}", sum);
}

fn part2(left: &[i32], counts: &HashMap<i32, i32>) {
    let sum: i32 = left
        .iter()
        .map(|&i| i * counts.get(&i).copied().unwrap_or(0))
        .sum();

    println!("part2: {}", sum);
}

fn solve() -> Result<(), Box<dyn std::error::Error>> {
    let input = fs::read_to_string("day1.txt")?;

    let mut counts: HashMap<i32, i32> = HashMap::new();
    let mut left = Vec::new();
    let mut right = Vec::new();

    for line in input.lines() {
        let parts: Vec<&str> = line.split("   ").collect();
        if parts.len() == 2 {
            let left_value: i32 = parts[0].trim().parse()?;
            let right_value: i32 = parts[1].trim().parse()?;

            left.push(left_value);
            right.push(right_value);

            *counts.entry(right_value).or_insert(0) += 1;
        }
    }

    part1(&mut left, &mut right);
    part2(&left, &counts);

    Ok(())
}

fn main() {
    if let Err(e) = solve() {
        eprintln!("Error: {}", e);
    }
}
