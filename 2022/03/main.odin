package main

import "core:fmt"
import "core:intrinsics"
import "core:strings"
import "core:testing"

import "../../aoc"

main :: proc() {
	input := aoc.must_read_input("2022/03")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> (sum: int) {
	lines := strings.split_lines(input)
	defer delete(lines)

	for line in lines {
		item_type := line[strings.index_any(line[:len(line) / 2], line[len(line) / 2:])]
		sum += priority(item_type)
	}

	return
}

part2 :: proc(input: string) -> (sum: int) {
	lines := strings.split_lines(input)
	defer delete(lines)

	Char_Set :: bit_set['A' ..= 'z';u64]

	for i := 0; i < len(lines); i += 3 {
		s1, s2, s3: Char_Set
		for c in lines[i] do incl(&s1, c)
		for c in lines[i + 1] do incl(&s2, c)
		for c in lines[i + 2] do incl(&s3, c)
		item_type := u8('A' + intrinsics.count_trailing_zeros(transmute(u64)(s1 & s2 & s3)))
		sum += priority(item_type)
	}

	return
}

@(private)
priority :: proc(c: u8) -> int {
	return int(c < 'a' ? c - 'A' + 27 : c - 'a' + 1)
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	testing.expect_value(
		t,
		part1(
			"vJrwpWtwJgWrhcsFMMfFFhFp\njqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL\nPmmdzqPrVvPwwTWBwg\nwMqvLMZHhHMvwLHjbvcjnnSBnvTQFn\nttgJtRGJQctTZtZT\nCrZsJsPPZsGzwwsLwLmpwMDw",
		),
		157,
	)
}


@(test)
test_part2 :: proc(t: ^testing.T) {
	testing.expect_value(
		t,
		part2(
			"vJrwpWtwJgWrhcsFMMfFFhFp\njqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL\nPmmdzqPrVvPwwTWBwg\nwMqvLMZHhHMvwLHjbvcjnnSBnvTQFn\nttgJtRGJQctTZtZT\nCrZsJsPPZsGzwwsLwLmpwMDw",
		),
		70,
	)
}
