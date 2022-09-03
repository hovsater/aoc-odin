package main

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

import "../../aoc"

main :: proc() {
	input := aoc.must_read_input("2021/01")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> (increases: int) {
	measurements := slice.mapper(strings.split(input, "\n"), strconv.atoi)
	current_depth := measurements[0]

	for depth in measurements[1:] {
		if depth > current_depth do increases += 1
		current_depth = depth
	}

	return
}

part2 :: proc(input: string) -> (increases: int) {
	measurements := slice.mapper(strings.split(input, "\n"), strconv.atoi)

	for i := 3; i < len(measurements); i += 1 {
		if measurements[i] > measurements[i - 3] do increases += 1
	}

	return
}

@(test)
test_part2 :: proc(t: ^testing.T) {
	testing.expect_value(t, part2("199\n200\n208\n210\n200\n207\n240\n269\n260\n263"), 5)
}
