package main

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:testing"
import "core:unicode/utf8"

import "../../aoc"

main :: proc() {
	input := aoc.must_read_input("2021/14")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> int {
	pair_counts: map[string]int
	letter_counts: map[rune]int

	parts := strings.split(input, "\n\n")
	defer delete(parts)

	for i := 0; i < len(parts[0]) - 1; i += 1 {
		letter_counts[utf8.rune_at_pos(parts[0], i)] += 1
		pair_counts[parts[0][i:i + 2]] += 1
	}

	letter_counts[utf8.rune_at_pos(parts[0], len(parts[0]) - 1)] += 1

	string_rules := strings.split(parts[1], "\n")
	defer delete(string_rules)
	rules := make(map[string]rune, len(string_rules))
	for string_rule in string_rules {
		rule_parts := strings.split(string_rule, " -> ")
		defer delete(rule_parts)
		rules[rule_parts[0]] = utf8.rune_at_pos(rule_parts[1], 0)
	}

	for _ in 0 ..< 10 {
		new_counts: map[string]int
		for p, v in pair_counts {
			if p in rules && pair_counts[p] > 0 {
				letter := rules[p]
				letter_counts[letter] += v
				pair_l := utf8.runes_to_string([]rune{utf8.rune_at_pos(p, 0), letter})
				pair_r := utf8.runes_to_string([]rune{letter, utf8.rune_at_pos(p, 1)})
				new_counts[pair_l] += v
				new_counts[pair_r] += v
				new_counts[p] -= v
			}
		}

		for p, v in new_counts {
			pair_counts[p] += v
		}
	}


	min := -1
	max := -1
	for _, c in letter_counts {
		if c < min || min == -1 do min = c
		if c > max || max == -1 do max = c
	}


	return max - min
}

part2 :: proc(input: string) -> int {
		pair_counts: map[string]int
	letter_counts: map[rune]int

	parts := strings.split(input, "\n\n")
	defer delete(parts)

	for i := 0; i < len(parts[0]) - 1; i += 1 {
		letter_counts[utf8.rune_at_pos(parts[0], i)] += 1
		pair_counts[parts[0][i:i + 2]] += 1
	}

	letter_counts[utf8.rune_at_pos(parts[0], len(parts[0]) - 1)] += 1

	string_rules := strings.split(parts[1], "\n")
	defer delete(string_rules)
	rules := make(map[string]rune, len(string_rules))
	for string_rule in string_rules {
		rule_parts := strings.split(string_rule, " -> ")
		defer delete(rule_parts)
		rules[rule_parts[0]] = utf8.rune_at_pos(rule_parts[1], 0)
	}

	for _ in 0 ..< 40 {
		new_counts: map[string]int
		for p, v in pair_counts {
			if p in rules && pair_counts[p] > 0 {
				letter := rules[p]
				letter_counts[letter] += v
				pair_l := utf8.runes_to_string([]rune{utf8.rune_at_pos(p, 0), letter})
				pair_r := utf8.runes_to_string([]rune{letter, utf8.rune_at_pos(p, 1)})
				new_counts[pair_l] += v
				new_counts[pair_r] += v
				new_counts[p] -= v
			}
		}

		for p, v in new_counts {
			pair_counts[p] += v
		}
	}


	min := -1
	max := -1
	for _, c in letter_counts {
		if c < min || min == -1 do min = c
		if c > max || max == -1 do max = c
	}


	return max - min
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	input := `NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C`


	testing.expect_value(t, part1(input), 1588)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
	input := `NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C`


	testing.expect_value(t, part2(input), 2188189693529)
}
