package main

import "core:fmt"
import "core:testing"

import "../../aoc"

Point :: struct {
	x, y: int,
}

main :: proc () {
	input := aoc.must_read_input("2015/03")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> int {
	points := make(map[Point]int)
	defer delete(points)

	x, y := 0, 0
	points[Point{x, y}] += 1
	for r in input {
		switch r {
		case '^':
			y += 1
		case '>':
			x += 1
		case 'v':
			y -= 1
		case '<':
			x -= 1
		}

		points[Point{x, y}] += 1
	}

	return len(points);
}

part2 :: proc(input: string) -> (res: int) {
	points := make(map[Point]int)
	defer delete(points)

	sx, sy := 0, 0
	rx, ry := 0, 0
	points[Point{0, 0}] += 2
	for r, i in input {
		santa_moving := i % 2 == 0

		switch r {
		case '^':
			if (santa_moving) {
				sy += 1
			} else {
				ry += 1
			}
		case '>':
			if (santa_moving) {
				sx += 1
			} else {
				rx += 1
			}
		case 'v':
			if (santa_moving) {
				sy -= 1
			} else {
				ry -= 1
			}
		case '<':
			if (santa_moving) {
				sx -= 1
			} else {
				rx -= 1
			}
		}

		if (santa_moving) {
			points[Point{sx, sy}] += 1
		} else {
			points[Point{rx, ry}] += 1
		}
	}

	return len(points);
}


@(test)
test_part1 :: proc(t: ^testing.T) {
	testing.expect_value(t, part1(">"), 2)
	testing.expect_value(t, part1("^>v<"), 4)
	testing.expect_value(t, part1("^v^v^v^v^v"), 2)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
	testing.expect_value(t, part2("^v"), 3)
	testing.expect_value(t, part2("^>v<"), 3)
	testing.expect_value(t, part2("^v^v^v^v^v"), 11)
}
