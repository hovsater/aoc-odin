package main

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:testing"

import "../../aoc"

pair_map := map[rune]rune {
	'(' = ')',
	')' = '(',
	'[' = ']',
	']' = '[',
	'{' = '}',
	'}' = '{',
	'<' = '>',
	'>' = '<',
}

main :: proc() {
	input := aoc.must_read_input("2021/10")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> (sum: int) {
	rune_points := map[rune]int {
		')' = 3,
		']' = 57,
		'}' = 1197,
		'>' = 25137,
	}

	for line in strings.split(input, "\n") {
		open_chunks: [dynamic]rune

		for c in line {
			switch c {
			case '(', '[', '{', '<':
				append(&open_chunks, c)
			case ')', ']', '}', '>':
				if pop(&open_chunks) != pair_map[c] do sum += rune_points[c]
			}
		}
	}

	return
}

part2 :: proc(input: string) -> int {
	rune_points := map[rune]int {
		')' = 1,
		']' = 2,
		'}' = 3,
		'>' = 4,
	}
	line_scores: [dynamic]int

	loop: for line in strings.split(input, "\n") {
		open_chunks: [dynamic]rune

		for c in line {
			switch c {
			case '(', '[', '{', '<':
				append(&open_chunks, c)
			case ')', ']', '}', '>':
				if pop(&open_chunks) != pair_map[c] do continue loop
			}
		}

		score: int
		for i := len(open_chunks) - 1; i >= 0; i -= 1 {
			score = (score * 5) + rune_points[pair_map[open_chunks[i]]]
		}

		append(&line_scores, score)
	}

	slice.sort(line_scores[:])

	return line_scores[len(line_scores) / 2]
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	input := `[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]`


	testing.expect_value(t, part1(input), 26397)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
	input := `[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]`


	testing.expect_value(t, part2(input), 288957)
}
