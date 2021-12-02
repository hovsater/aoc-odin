package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:path"
import "core:slice"
import "core:testing"

import "../../aoc"

/*

--- Day 1: Not Quite Lisp ---

Santa was hoping for a white Christmas, but his weather machine's "snow"
function is powered by stars, and he's fresh out! To save Christmas, he needs
you to collect fifty stars by December 25th.

Collect stars by helping Santa solve puzzles. Two puzzles will be made
available on each day in the Advent calendar; the second puzzle is unlocked
when you complete the first. Each puzzle grants one star. Good luck!

Here's an easy puzzle to warm you up.

Santa is trying to deliver presents in a large apartment building, but he can't
find the right floor - the directions he got are a little confusing. He starts
on the ground floor (floor 0) and then follows the instructions one character
at a time.

An opening parenthesis, (, means he should go up one floor, and a closing
parenthesis, ), means he should go down one floor.

The apartment building is very tall, and the basement is very deep; he will
never find the top or bottom floors.

For example:

- (()) and ()() both result in floor 0.

- ((( and (()(()( both result in floor 3.

- ))((((( also results in floor 3.

- ()) and ))( both result in floor -1 (the first basement level).

- ))) and )())()) both result in floor -3.

To what floor do the instructions take Santa?

--- Part Two ---

Now, given the same instructions, find the position of the first character that
causes him to enter the basement (floor -1). The first character in the
instructions has position 1, the second character has position 2, and so on.

For example:

- ) causes him to enter the basement at character position 1.

- ()()) causes him to enter the basement at character position 5.

What is the position of the character that causes Santa to first enter the
basement?

*/

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