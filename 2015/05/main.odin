package main

import "core:fmt"
import "core:strings"
import "core:testing"

import "../../aoc"

main :: proc() {
	input := aoc.must_read_input("2015/05")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> (n: int) {
	for line in strings.split(input, "\n") {
		if is_nice(line) do n += 1
	}

	return
}

part2 :: proc(input: string) -> (n: int) {
	panic("part2 not implemented")
}

is_vowel :: proc(r: u8) -> bool {
	switch r {
	case 'a', 'e', 'i', 'o', 'u':
		return true
	}

	return false
}

is_nice :: proc(input: string) -> bool {
	vowels: int
	repeating_letter: bool
	contains_bad_substrings: bool

	for _, i in input[:len(input)] {
		r := input[i]

		if is_vowel(r) do vowels += 1

		if i < len(input) - 1 {
			rr := input[i + 1]
			str := string([]byte{r, rr})

			if r == rr do repeating_letter = true
			if str == "ab" || str == "cd" || str == "pq" || str == "xy" do contains_bad_substrings = true
		}
	}

	return vowels >= 3 && repeating_letter && !contains_bad_substrings
}

@(test)
test_is_nice :: proc(t: ^testing.T) {
	testing.expect_value(t, is_nice("aaa"), true)
	testing.expect_value(t, is_nice("ugknbfddgicrmopn"), true)

	testing.expect_value(t, is_nice("jchzalrnumimnmhp"), false)
	testing.expect_value(t, is_nice("haegwjzuvuyypxyu"), false)
	testing.expect_value(t, is_nice("dvszwmarrgswjxmb"), false)
}
