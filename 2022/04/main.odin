package main

import "core:fmt"
import "core:intrinsics"
import "core:strings"
import "core:testing"
import "core:strconv"
import "core:slice"

import "../../aoc"

main :: proc() {
	input := aoc.must_read_input("2022/04")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> (count: int) {
	splits := [3]string{"\n", "-", ","}
	values := slice.mapper(strings.split_multi(input, splits[:]), strconv.atoi)


	for i := 0; i + 3 < len(values); i += 4 {
		a1, a2 := values[i], values[i + 1]
		b1, b2 := values[i + 2], values[i + 3]
		if a1 >= b1 && a2 <= b2 || b1 >= a1 && b2 <= a2 do count += 1
	}

	return
}

part2 :: proc(input: string) -> (count: int) {
	splits := [3]string{"\n", "-", ","}
	values := slice.mapper(strings.split_multi(input, splits[:]), strconv.atoi)


	for i := 0; i + 3 < len(values); i += 4 {
		a1, a2 := values[i], values[i + 1]
		b1, b2 := values[i + 2], values[i + 3]
		if a1 >= b1 && a1 <= b2 || b1 >= a1 && b1 <= a2 do count += 1
	}

	return

}

@(test)
test_part1 :: proc(t: ^testing.T) {
	testing.expect_value(t, part1("2-4,6-8\n2-3,4-5\n5-7,7-9\n2-8,3-7\n6-6,4-6\n2-6,4-8"), 2)
}


@(test)
test_part2 :: proc(t: ^testing.T) {
	testing.expect_value(t, part2("2-4,6-8\n2-3,4-5\n5-7,7-9\n2-8,3-7\n6-6,4-6\n2-6,4-8"), 4)
}
