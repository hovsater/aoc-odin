package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

import "../../aoc"

main :: proc() {
	input := aoc.must_read_input("2021/03")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> int {
	numbers := strings.split(input, "\n")
	num_bits := len(numbers[0])
	bits_set := make([]int, num_bits)

	for number in numbers {
		for c, i in number do bits_set[i] += c == '1' ? 1 : 0
	}

	gamma, epsilon: int
	for c, i in bits_set {
		if c >= len(numbers) - c {
			gamma |= (1 << uint(num_bits - i - 1))
		} else {
			epsilon |= (1 << uint(num_bits - i - 1))
		}
	}

	return gamma * epsilon
}

part2 :: proc(input: string) -> int {
	numbers := strings.split(input, "\n")
	slice.sort(numbers)

	oxygen := find_number(numbers[:], false)
	co2 := find_number(numbers[:], true)

	return oxygen * co2
}

find_number :: proc(nums: []string, flip: bool) -> int {
	i: int
	temp := nums
	for len(temp) > 1 {
		zeroes: int
		for n in temp do zeroes += n[i] == '0' ? 1 : 0

		if len(temp) - zeroes >= zeroes {
			temp = flip ? temp[:zeroes] : temp[zeroes:]
		} else {
			temp = flip ? temp[zeroes:] : temp[:zeroes]
		}

		i += 1
	}

	n, _ := strconv.parse_int(temp[0], 2)
	return n
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	input := "00100\n11110\n10110\n10111\n10101\n01111\n00111\n11100\n10000\n11001\n00010\n01010"
	testing.expect_value(t, part1(input), 198)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
	input := "00100\n11110\n10110\n10111\n10101\n01111\n00111\n11100\n10000\n11001\n00010\n01010"
	testing.expect_value(t, part2(input), 230)
}
