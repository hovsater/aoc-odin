package main

import "core:fmt"
import "core:testing"

import "../../aoc"

main :: proc() {
	input := aoc.must_read_input("2015/01")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> (sum: int) {
	for r in input {
		if r == '(' {
			sum += 1
		} else if r == ')' {
			sum -= 1
		}
	}

	return
}

part2 :: proc(input: string) -> int {
	sum := 0
	for r, i in input {
		if r == '(' {
			sum += 1
		} else if r == ')' {
			sum -= 1
		}

		if sum == -1 {
			return i + 1
		}
	}

	return -1
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	testing.expect_value(t, part1("(())"), 0)
	testing.expect_value(t, part1("))((((("), 3)
	testing.expect_value(t, part1(")())())"), -3)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
	testing.expect_value(t, part2("((("), -1)
	testing.expect_value(t, part2("())"), 3)
	testing.expect_value(t, part2("))("), 1)
}
