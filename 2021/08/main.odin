package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"
import "core:container"

import "../../aoc"

main :: proc() {
	input := aoc.must_read_input("2021/08")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> (count: int) {
	for line in strings.split(input, "\n") {
		parts := strings.split(line, " | ")
		for o in strings.split(parts[1], " ") {
			if len(o) == 2 || len(o) == 3 || len(o) == 4 || len(o) == 7 {
				count += 1
			}
		}
	}

	return
}

part2 :: proc(input: string) -> (sum: int) {
	for line in strings.split(input, "\n") {
		numbers: [10]string
		parts := strings.split(line, " | ")
		patterns := strings.split(parts[0], " ")
		outputs := strings.split(parts[1], " ")

		for p in patterns {slice.sort(transmute([]u8)p)}
		for o in outputs {slice.sort(transmute([]u8)o)}

		// Find 1, 4, 7 and 8
		for pattern in patterns {
			switch len(pattern) {
			case 2:
				numbers[1] = pattern
			case 4:
				numbers[4] = pattern
			case 3:
				numbers[7] = pattern
			case 7:
				numbers[8] = pattern
			}
		}

		// Find the rest
		for pattern in patterns {
			if slice.contains(numbers[:], pattern) do continue

			s1 := count_equal_segments(numbers[1], pattern)
			s4 := count_equal_segments(numbers[4], pattern)
			s8 := count_equal_segments(numbers[8], pattern)

			switch len(pattern) + s1 + s4 + s8 {
			case 13:
				numbers[2] = pattern
			case 14:
				numbers[5] = pattern
			case 15:
				numbers[3] = pattern
			case 16:
				numbers[6] = pattern
			case 17:
				numbers[0] = pattern
			case 18:
				numbers[9] = pattern
			}
		}

		multiplier := 1000
		for o in outputs {
			for p, n in numbers {
				if o == p {
					sum += n * multiplier
					multiplier /= 10
				}
			}
		}
	}

	return
}

count_equal_segments :: proc(s1, s2: string) -> (count: int) {
	for c in s1 {
		if strings.contains_rune(s2, c) != -1 do count += 1
	}

	return
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	input := `be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce`

	testing.expect_value(t, part1(input), 26)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
	input := `be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce`

	testing.expect_value(t, part2(input), 61229)
}
