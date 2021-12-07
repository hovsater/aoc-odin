package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

import "../../aoc"

MAX_DAYS :: 9

Fish_By_Age :: distinct [MAX_DAYS]int

main :: proc() {
	input := aoc.must_read_input("2021/06")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> int {
	fish_by_age := parse_input(input)
	return simulate(&fish_by_age, 80)
}


part2 :: proc(input: string) -> (count: int) {
	fish_by_age := parse_input(input)
	return simulate(&fish_by_age, 256)
}

simulate :: proc(fish_by_age: ^Fish_By_Age, days: int) -> (count: int) {
	for _day := 0; _day < days; _day += 1 {
		temp := fish_by_age[0]
		for i := 1; i < len(fish_by_age); i += 1 {
			fish_by_age[i - 1] = fish_by_age[i]
		}
		fish_by_age[6] += temp
		fish_by_age[8] = temp
	}

	for f in fish_by_age do count += f

	return
}

parse_input :: proc(input: string) -> (fish_by_age: Fish_By_Age) {
	for age in slice.mapper(strings.split(input, ","), strconv.atoi) {
		fish_by_age[age] += 1
	}

	return
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	input := "3,4,3,1,2"
	testing.expect_value(t, part1(input), 5934)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
	input := "3,4,3,1,2"
	testing.expect_value(t, part2(input), 26984457539)
}
