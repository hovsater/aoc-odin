package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

import "../../aoc"

main :: proc() {
	input := aoc.must_read_input("2022/01")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> int {
	totals := slice.mapper(strings.split(input, "\n\n"), sum_calories)

	return slice.max(totals)
}

part2 :: proc(input: string) -> int {
	totals := slice.mapper(strings.split(input, "\n\n"), sum_calories)
	slice.reverse_sort(totals)

	return slice.reduce(totals[0:3], 0, sum)
}

sum :: proc(a: int, b: int) -> int {return a + b}

sum_calories :: proc(calories: string) -> int {
	return slice.reduce(slice.mapper(strings.split(calories, "\n"), strconv.atoi), 0, sum)
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	testing.expect_value(
		t,
		part1("1000\n2000\n3000\n\n4000\n\n5000\n6000\n\n7000\n8000\n9000\n\n10000"),
		24000,
	)
}


@(test)
test_part2 :: proc(t: ^testing.T) {
	testing.expect_value(
		t,
		part2("1000\n2000\n3000\n\n4000\n\n5000\n6000\n\n7000\n8000\n9000\n\n10000"),
		45000,
	)
}
