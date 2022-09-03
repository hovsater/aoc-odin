package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

import "../../aoc"

main :: proc() {
	input := aoc.must_read_input("2021/07")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> int {
	numbers := parse_input(input)
	fuel_calculator :: proc(position, number: int) -> int {
		return abs(position - number)
	}

	return minimum_fuel(numbers, fuel_calculator)
}

part2 :: proc(input: string) -> int {
	numbers := parse_input(input)
	fuel_calculator :: proc(position, number: int) -> int {
		moves := abs(position - number)
		return moves * (1 + moves) / 2
	}

	return minimum_fuel(numbers, fuel_calculator)
}

minimum_fuel :: proc(numbers: []int, f: proc(_: int, _: int) -> int) -> int {
	moves: map[int]int

	for p := numbers[0]; p <= numbers[len(numbers) - 1]; p += 1 {
		for n in numbers {
			if p == n do continue
			moves[p] += f(p, n)
		}
	}

	return slice.min(slice.map_values(moves))
}

parse_input :: proc(input: string) -> []int {
	numbers := slice.mapper(strings.split(input, ","), strconv.atoi)
	slice.sort(numbers)

	return numbers
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	input := "16,1,2,0,4,2,7,1,2,14"
	testing.expect_value(t, part1(input), 37)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
	input := "16,1,2,0,4,2,7,1,2,14"
	testing.expect_value(t, part2(input), 168)
}
