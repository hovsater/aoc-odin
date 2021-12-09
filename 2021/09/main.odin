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

Point :: struct {
	x, y: int,
}

Grid :: struct {
	width, height: int,
	points: map[Point]int,
}

part1 :: proc(input: string) -> (sum: int) {
	grid := parse_input(input)

	for p, v in grid.points {
		if u, ok := grid.points[{p.x, p.y - 1}]; ok && v >= u do continue
		if d, ok := grid.points[{p.x, p.y + 1}]; ok && v >= d do continue
		if l, ok := grid.points[{p.x - 1, p.y}]; ok && v >= l do continue
		if r, ok := grid.points[{p.x + 1, p.y}]; ok && v >= r do continue
		sum += v + 1
	}

	return
}

part2 :: proc(input: string) -> (sum: int) {
	return
}

parse_input :: proc (input: string) -> (grid: Grid) {
	lines := strings.split(input, "\n")
	grid.width = len(lines[0])
	grid.height = len(lines)

	for line, i in lines {
		for c, j in line do grid.points[Point{j, i}] = int(c - '0')
	}

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
