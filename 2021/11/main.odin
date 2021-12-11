package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

import "../../aoc"

Octopus :: [2]int

Grid :: distinct map[Octopus]int

main :: proc() {
	input := aoc.must_read_input("2021/11")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> (flashes: int) {
	width, height, grid := parse_input(input)

	for _ in 0..<100 {
		flashed: map[Octopus]bool

		for octopus in grid {
			grid[octopus] += 1

			if grid[octopus] > 9 {
				flashes += count_flashes(&grid, octopus, &flashed)
			}
		}

		for octopus in flashed {
			grid[octopus] = 0
		}

	}

	return
}

part2 :: proc(input: string) -> int {
	width, height, grid := parse_input(input)

	for step := 1 ;; step += 1 {
		flashed: map[Octopus]bool

		for octopus in grid {
			grid[octopus] += 1

			if grid[octopus] > 9 {
				count_flashes(&grid, octopus, &flashed)
			}
		}

		for octopus in flashed {
			grid[octopus] = 0
		}

		if len(flashed) == width * height do return step

	}
}

count_flashes :: proc(grid: ^Grid, octopus: Octopus, flashed: ^map[Octopus]bool) -> (flashes: int) {
	if ok := octopus in flashed; ok do return

	flashed[octopus] = true
	queue := [dynamic]Octopus{octopus}

	flashes += 1
	for len(queue) != 0 {
		c := pop_front(&queue)
		for n in neighbours(grid, c) {
			if ok := n in flashed; ok do continue

			grid[n] += 1
			if grid[n] > 9 {
				flashed[n] = true
				append(&queue, n)
				flashes += 1
			}
		}
	}

	return
}

parse_input :: proc(input: string) -> (width, height: int, grid: Grid) {
	lines := strings.split(input, "\n")
	width = len(lines[0])
	height = len(lines)

	for line, y in lines {
		for c, x in line do grid[{x, y}] = int(c - '0')
	}

	return
}

neighbours :: proc(grid: ^Grid, octopus: Octopus) -> (neighbours: [dynamic]Octopus) {
	directions := [8]Octopus{{0, -1}, {0, 1}, {-1, 0}, {1, 0}, {-1, -1}, {1, -1}, {-1, 1}, {1, 1}}

	for direction in directions {
		neighbour := octopus + direction
		if ok := neighbour in grid; ok do append(&neighbours, neighbour)
	}

	return
}

print_grid :: proc(width, height: int, grid: ^Grid) {
	for y in 0..<height {
		for x in 0..<width {
			fmt.printf("{}", grid[{x, y}])
		}
		fmt.printf("\n")
	}
	fmt.printf("\n")
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	input := `5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526`

	testing.expect_value(t, part1(input), 1656)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
	input := `5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526`


	testing.expect_value(t, part2(input), 195)
}
