package main

import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:testing"

import "../../aoc"

main :: proc() {
	input := aoc.must_read_input("2021/02")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> int {
	position, depth : int
	for line in strings.split(input, "\n") {
		parts := strings.split(line, " ")
		value := strconv.atoi(parts[1])

		switch parts[0] {
			case "up":
				depth -= value
			case "down":
				depth += value
			case "forward":
				position += value
		}
	}

	return position * depth
}

part2 :: proc(input: string) -> int {
	position, depth, aim : int
	for line in strings.split(input, "\n") {
		parts := strings.split(line, " ")
		value := strconv.atoi(parts[1])

		switch parts[0] {
			case "up":
				aim -= value
			case "down":
				aim += value
			case "forward":
				position += value
				depth += aim * value
		}
	}

	return position * depth
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	input := "forward 5\ndown 5\nforward 8\nup 3\ndown 8\nforward 2"
	testing.expect_value(t, part1(input), 150)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
	input := "forward 5\ndown 5\nforward 8\nup 3\ndown 8\nforward 2"
	testing.expect_value(t, part2(input), 900)
}
