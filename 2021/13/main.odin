package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

import "../../aoc"

Point :: distinct [2]int

Grid :: struct {
	width, height: int,
	points: map[Point]bool,
}

Fold_X :: distinct int
Fold_Y :: distinct int
Fold :: union{Fold_X, Fold_Y}

main :: proc() {
	input := aoc.must_read_input("2021/13")
	fmt.println("part1", part1(input))
	fmt.println("part2")
	part2(input)
}

part1 :: proc(input: string) -> int {
	grid, folds := parse_input(input)
	fold_grid(&grid, folds[:1])

	return len(grid.points)
}

part2 :: proc(input: string) {
	grid, folds := parse_input(input)
	fold_grid(&grid, folds[:])
	print_grid(&grid)
}

fold_grid :: proc(grid: ^Grid, folds: []Fold) {
	for fold in folds {
		switch f in fold {
		case Fold_X:
			x := int(f)
			for p in slice.map_keys(grid.points) {
				if p.x <= x do continue
				grid.points[{x - (p.x - x), p.y}] = true
				delete_key(&grid.points, p)
			}
			grid.width -= x + 1
		case Fold_Y:
			y := int(f)
			for p in slice.map_keys(grid.points) {
				if p.y <= y do continue
				grid.points[{p.x, y - (p.y - y)}] = true
				delete_key(&grid.points, p)
			}
			grid.height -= y + 1
		}
	}
}

print_grid :: proc(grid: ^Grid) {
	for y := 0; y < grid.height; y += 1 {
		for x := 0; x < grid.width; x += 1 {
			point := Point{x, y}
			if point in grid.points {
				fmt.printf("#")
			} else {
				fmt.printf(".")
			}
		}

		fmt.printf("\n")
	}

	fmt.printf("\n")
}

parse_input :: proc(input: string) -> (grid: Grid, folds: [dynamic]Fold) {
	parts := strings.split(input, "\n\n")
	defer delete(parts)

	max_x, max_y: int
	coordinate_lines := strings.split(parts[0], "\n")
	defer delete(coordinate_lines)

	for coordinate_line in coordinate_lines {
		coordinate := strings.split(coordinate_line, ",")
		defer delete(coordinate)

		x := strconv.atoi(coordinate[0])
		y := strconv.atoi(coordinate[1])
		if x > max_x do max_x = x
		if y > max_y do max_y = y

		grid.points[{x, y}] = true
	}

	grid.width = max_x + 1
	grid.height = max_y + 1

	fold_lines := strings.split(parts[1], "\n")
	defer delete(fold_lines)

	for fold_line in fold_lines {
		fold := strings.split(fold_line, "=")
		defer delete(fold)

		if strings.has_suffix(fold[0], "x") {
			append(&folds, Fold_X(strconv.atoi(fold[1])))
		} else {
			append(&folds, Fold_Y(strconv.atoi(fold[1])))
		}
	}

	return
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	input := `6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5`

	testing.expect_value(t, part1(input), 17)
}
