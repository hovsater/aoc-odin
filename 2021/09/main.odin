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

Point :: [2]int

Grid :: struct {
	width, height: int,
	points:        map[Point]int,
}

part1 :: proc(input: string) -> (sum: int) {
	grid := parse_input(input)

	loop: for p, v in grid.points {
		for n in point_neighbours(&grid, p) {
			if v >= grid.points[n] do continue loop
		}

		sum += v + 1
	}

	return
}

part2 :: proc(input: string) -> int {
	grid := parse_input(input)
	basins: [dynamic]int

	loop: for p, v in grid.points {
		for n in point_neighbours(&grid, p) {
			if v >= grid.points[n] do continue loop
		}

		append(&basins, basin_of_point(&grid, p))
	}

	slice.sort(basins[:])

	sum := 1;for b in basins[len(basins) - 3:] do sum *= b

	return sum
}

basin_of_point :: proc(grid: ^Grid, p: Point) -> (count: int) {
	queue := [dynamic]Point{p}
	visited := map[Point]bool {
		p = true,
	}

	count += 1
	for len(queue) != 0 {
		c := pop_front(&queue)
		for n in point_neighbours(grid, c) {
			if ok := n in visited; ok do continue
			visited[n] = true

			if grid.points[n] != 9 {
				append(&queue, n)
				count += 1
			}
		}
	}

	return
}

point_neighbours :: proc(grid: ^Grid, p: Point) -> (neighbours: [dynamic]Point) {
	n := Point{p.x, p.y - 1}
	s := Point{p.x, p.y + 1}
	w := Point{p.x - 1, p.y}
	e := Point{p.x + 1, p.y}

	if ok := n in grid.points; ok do append(&neighbours, n)
	if ok := s in grid.points; ok do append(&neighbours, s)
	if ok := w in grid.points; ok do append(&neighbours, w)
	if ok := e in grid.points; ok do append(&neighbours, e)

	return
}

parse_input :: proc(input: string) -> (grid: Grid) {
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

	testing.expect_value(t, part2(input), 1134)
}
