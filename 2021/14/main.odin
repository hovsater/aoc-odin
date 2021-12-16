package main

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:testing"
import "core:unicode/utf8"

import "../../aoc"

Letters :: distinct map[rune]u64
Pairs :: distinct map[string]u64
Pair_Insertion_Rules :: distinct map[string]rune

Polymer :: struct {
	letters: Letters,
	pairs: Pairs,
}

main :: proc() {
	input := aoc.must_read_input("2021/14")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> u64 {
	polymer, rules := parse_input(input)

	grow_polymer(&polymer, &rules, 10)

	min_letter, max_letter := min_max_polymer_letter(&polymer)

	return max_letter - min_letter
}

part2 :: proc(input: string) -> u64 {
	polymer, rules := parse_input(input)

	grow_polymer(&polymer, &rules, 40)

	min_letter, max_letter := min_max_polymer_letter(&polymer)

	return max_letter - min_letter
}

grow_polymer :: proc(polymer: ^Polymer, rules: ^Pair_Insertion_Rules, step: u8) {
	new_pairs := make(Pairs, len(polymer.pairs))

	for _ in 0..<step {
		for pair, count in polymer.pairs do if count > 0 {
			letter := rules[pair]
			polymer.letters[letter] += count
			new_pairs[utf8.runes_to_string({utf8.rune_at_pos(pair, 0), letter})] += count
			new_pairs[utf8.runes_to_string({letter, utf8.rune_at_pos(pair, 1)})] += count
			new_pairs[pair] -= count
		}

		for pair, count in new_pairs do polymer.pairs[pair] += count
		clear(&new_pairs)
	}
}

min_max_polymer_letter :: proc(polymer: ^Polymer) -> (u64, u64) {
	min_letter := max(u64)
	max_letter := min(u64)

	for _, count in polymer.letters {
		if count < min_letter do min_letter = count
		if count > max_letter do max_letter = count
	}

	return min_letter, max_letter
}

parse_input :: proc(input: string) -> (Polymer, Pair_Insertion_Rules) {
	template_and_rules := strings.split(input, "\n\n")
	string_rules := strings.split(template_and_rules[1], "\n")
	defer delete(template_and_rules)
	defer delete(string_rules)

	polymer := Polymer{make(Letters, int('Z' - 'A') + 1), make(Pairs, len(string_rules))}
	rules := make(Pair_Insertion_Rules, len(string_rules))

	for string_rule in string_rules {
		pair_and_letter := strings.split(string_rule, " -> ")
		defer delete(pair_and_letter)

		polymer.pairs[pair_and_letter[0]] = 0
		rules[pair_and_letter[0]] = utf8.rune_at_pos(pair_and_letter[1], 0)
	}

	template := template_and_rules[0]
	polymer.letters[utf8.rune_at_pos(template, 0)] += 1
	for i := 1; i < len(template); i += 1 {
		polymer.letters[utf8.rune_at_pos(template, i)] += 1
		polymer.pairs[template[i-1:i+1]] += 1
	}

	return polymer, rules
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
