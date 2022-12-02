package main

import "core:fmt"
import "core:strings"
import "core:testing"

import "../../aoc"

main :: proc() {
	input := aoc.must_read_input("2022/02")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> (score: int) {
	lines := strings.split_lines(input)
	defer delete(lines)

	for line in lines {
		a := int(line[0] - 'A')
		b := int(line[2] - 'X')
		score += (b - a + 1) %% 3 * 3 + b + 1
	}

	return
}

part2 :: proc(input: string) -> (score: int) {
	lines := strings.split_lines(input)
	defer delete(lines)

	for line in lines {
		a := int(line[0] - 'A')
		b := int(line[2] - 'X')
		score += b * 3 + (a + b - 1) %% 3 + 1
	}

	return

}

@(test)
test_part1 :: proc(t: ^testing.T) {
	testing.expect_value(t, part1("A Y\nB X\nC Z"), 15)
}


@(test)
test_part2 :: proc(t: ^testing.T) {
	testing.expect_value(t, part2("A Y\nB X\nC Z"), 12)
}
