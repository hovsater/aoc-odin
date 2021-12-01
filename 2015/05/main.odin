package main

import "core:fmt"
import "core:os"
import "core:path"
import "core:strings"
import "core:testing"
import "core:unicode/utf8"

/*

--- Day 5: Doesn't He Have Intern-Elves For This? ---

Santa needs help figuring out which strings in his text file are naughty or
nice.

A nice string is one with all of the following properties:

- It contains at least three vowels (aeiou only), like aei, xazegov, or
  aeiouaeiouaeiou.

- It contains at least one letter that appears twice in a row, like xx, abcdde
  (dd), or aabbccdd (aa, bb, cc, or dd).

- It does not contain the strings ab, cd, pq, or xy, even if they are part of
  one of the other requirements.

For example:

- ugknbfddgicrmopn is nice because it has at least three vowels (u...i...o...),
  a double letter (...dd...), and none of the disallowed substrings.

- aaa is nice because it has at least three vowels and a double letter, even
  though the letters used by different rules overlap.

- jchzalrnumimnmhp is naughty because it has no double letter.

- haegwjzuvuyypxyu is naughty because it contains the string xy.

- dvszwmarrgswjxmb is naughty because it contains only one vowel.

How many strings are nice?

--- Part Two ---

Realizing the error of his ways, Santa has switched to a better model of
determining whether a string is naughty or nice. None of the old rules apply,
as they are all clearly ridiculous.

Now, a nice string is one with all of the following properties:

- It contains a pair of any two letters that appears at least twice in the
  string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like
  aaa (aa, but it overlaps).

- It contains at least one letter which repeats with exactly one letter between
  them, like xyx, abcdefeghi (efe), or even aaa.

For example:

- qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice (qj) and a
  letter that repeats with exactly one letter between them (zxz).

- xxyxx is nice because it has a pair that appears twice and a letter that
  repeats with one between, even though the letters used by each rule overlap.

- uurcxstgmygtbstg is naughty because it has a pair (tg) but no repeat with a
  single letter between them.

- ieodomkazucvgmuy is naughty because it has a repeating letter with one
  between (odo), but no pair that appears twice.

How many strings are nice under these new rules?

*/

main :: proc () {
	data, ok := os.read_entire_file(path.join(path.dir(#file), "./input.txt"))
	if !ok {
		fmt.println("Failed to read puzzle input.")
		os.exit(1)
	}

	fmt.println("part1 answer is", solve_part1(string(data)))
	fmt.println("part2 answer is", solve_part2(string(data)))
}

solve_part1 :: proc(input: string) -> (n: int) {
	for line in strings.split(input, "\n") {
		if is_nice(line) do n += 1
	}

	return
}

solve_part2 :: proc(input: string) -> (n: int) {
	return
}

is_vowel :: proc(r: u8) -> bool {
	switch r {
	case 'a', 'e', 'i', 'o', 'u':
		return true
	}

	return false
}

is_nice :: proc(input: string) -> bool {
	vowels : int
	repeating_letter : bool
	contains_bad_substrings : bool

	for _, i in input[:len(input)] {
		r := input[i]

		if is_vowel(r) do vowels += 1

		if i < len(input) - 1 {
			rr := input[i+1]
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
