package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

import "../../aoc"

main :: proc() {
	input := aoc.must_read_input("2021/09")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> (sum: int) {
	lines := strings.split(input, "\n")

	grid: [dynamic]int
	for line in lines {
		for c in line do append(&grid, int(c - '0'))
	}

	h := len(grid)
	w := len(lines[0])
	for e, i in grid {
		switch {
		case i - w >= 0 && e >= grid[i - w],
		     i + w <= h - 1 && e >= grid[i + w],
			 i - 1 >= 0 && i / w == (i - 1) / w && e >= grid[i - 1],
		     i + 1 <= h - 1 && i / w == (i + 1) / w && e >= grid[i + 1]: continue
		}

		sum += e + 1
	}

	return
}

part2 :: proc(input: string) -> (sum: int) {
	return
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	input := `2199943210
3987894921
9856789892
8767896789
9899965678`

	testing.expect_value(t, part1(input), 15)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
	input := `2199943210
3987894921
9856789892
8767896789
9899965678`

	testing.expect_value(t, part2(input), 0)
}
