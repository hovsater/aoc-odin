package main

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:testing"

import "../../aoc"

main :: proc() {
	input := aoc.must_read_input("2015/05")
	defer delete(input)

	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> (n: int) {
	lines := strings.split(input, "\n")
	defer delete(lines)

	for line in lines do if part1_is_str_nice(line) {
			n += 1
		}

	return
}

part2 :: proc(input: string) -> (n: int) {
	lines := strings.split(input, "\n")
	defer delete(lines)

	for line in lines do if part2_is_str_nice(line) {
			n += 1
		}

	return
}

part1_is_str_nice :: proc(input: string) -> bool {
	vowels: int
	repeating_letter: bool
	contains_bad_substrings: bool

	for _, i in input {
		if is_vowel(input[i]) {
			vowels += 1
		}

		if i < len(input) - 1 {
			str := input[i:i + 2]

			if str[0] == str[1] {
				repeating_letter = true
			}

			if str == "ab" || str == "cd" || str == "pq" || str == "xy" {
				contains_bad_substrings = true
			}
		}
	}

	return vowels >= 3 && repeating_letter && !contains_bad_substrings
}

part2_is_str_nice :: proc(input: string) -> bool {
	str_map: strings.Intern
	strings.intern_init(&str_map)
	defer strings.intern_destroy(&str_map)

	pair_counts := make(map[string]int)
	defer delete(pair_counts)

	repeating_letters_with_gap: int

	maybe_prev_i: Maybe(int)
	for _, i in input[:len(input) - 1] {
		pair := strings.intern_get(&str_map, input[i:i + 2]) or_else panic("")

		if prev_i, ok := maybe_prev_i.?; ok {
			prev_pair := strings.intern_get(&str_map, input[prev_i:prev_i + 2]) or_else panic("")

			if prev_pair != pair || prev_i + 1 < i {
				maybe_prev_i = i
				pair_counts[pair] += 1
			}

			if prev_pair[0] == pair[1] {
				repeating_letters_with_gap += 1
			}
		} else {
			maybe_prev_i = i
			pair_counts[pair] += 1
		}
	}

	counts := slice.map_values(pair_counts)
	defer delete(counts)

	return repeating_letters_with_gap > 0 && slice.max(counts) > 1
}

is_vowel :: proc(r: u8) -> bool {
	switch r {
	case 'a', 'e', 'i', 'o', 'u':
		return true
	case:
		return false
	}
}

@(test)
test_part1_is_str_nice :: proc(t: ^testing.T) {
	testing.expect_value(t, part1_is_str_nice("aaa"), true)
	testing.expect_value(t, part1_is_str_nice("ugknbfddgicrmopn"), true)

	testing.expect_value(t, part1_is_str_nice("jchzalrnumimnmhp"), false)
	testing.expect_value(t, part1_is_str_nice("haegwjzuvuyypxyu"), false)
	testing.expect_value(t, part1_is_str_nice("dvszwmarrgswjxmb"), false)
}

@(test)
test_is_nice_new :: proc(t: ^testing.T) {
	testing.expect_value(t, part2_is_str_nice("qjhvhtzxzqqjkmpb"), true)
	testing.expect_value(t, part2_is_str_nice("xxyxx"), true)
	testing.expect_value(t, part2_is_str_nice("xyxyaba"), true)

	testing.expect_value(t, part2_is_str_nice("uurcxstgmygtbstg"), false)
	testing.expect_value(t, part2_is_str_nice("ieodomkazucvgmuy"), false)
}
