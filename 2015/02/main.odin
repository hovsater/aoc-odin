package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

import "../../aoc"

main :: proc () {
	input := aoc.must_read_input("2015/02")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> (sum: int) {
	for line in strings.split(input, "\n") {
		a, b, c := dimensions(line)
		ab, bc, ca := a*b, b*c, c*a

		sum += 2*ab + 2*bc + 2*ca + min(ab, min(bc, ca))
	}

	return;
}

part2 :: proc(input: string) -> (sum: int) {
	for line in strings.split(input, "\n") {
		a, b, c := dimensions(line)
		if (a < b) {
			sum += 2*a+2*min(b, c)+a*b*c
		} else {
			sum += 2*b+2*min(a, c)+a*b*c
		}
	}

	return;
}

@(private)
dimensions :: proc(line: string) -> (int, int, int) {
	d := slice.mapper(strings.split(line, "x"), strconv.atoi)
	return d[0], d[1], d[2]
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	testing.expect_value(t, part1("2x3x4"), 58)
	testing.expect_value(t, part1("4x3x2"), 58)
	testing.expect_value(t, part1("2x3x4\n1x1x10"), 101)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
	testing.expect_value(t, part2("2x3x4"), 34)
	testing.expect_value(t, part2("2x3x4\n1x1x10"), 48)
}
