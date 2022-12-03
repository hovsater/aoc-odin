package main

import "core:fmt"
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
		item_type := int(line[strings.index_any(line[:len(line) / 2], line[len(line) / 2:])])
		sum += item_type < 'a' ? item_type - 'A' + 27 : item_type - 'a' + 1
	}

	return
}

part2 :: proc(input: string) -> (sum: int) {
	lines := strings.split_lines(input)
	defer delete(lines)

	Char_Set :: bit_set['A' ..= 'z']

	for i := 0; i < len(lines); i += 3 {
		sa, sb, sc, sd: Char_Set
		for c in lines[i] do incl(&sa, c)
		for c in lines[i + 1] do incl(&sb, c)
		for c in lines[i + 2] do incl(&sc, c)
		sd = sa & sb & sc

		for c in 'A' ..= 'z' {
			if c in sd {
				sum += int(c < 'a' ? c - 'A' + 27 : c - 'a' + 1)
				break
			}
		}
	}

	return
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
