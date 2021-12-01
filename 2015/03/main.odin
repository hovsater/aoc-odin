package main

import "core:container"
import "core:fmt"
import "core:os"
import "core:path"
import "core:slice"
import "core:testing"

/*

--- Day 3: Perfectly Spherical Houses in a Vacuum ---

Santa is delivering presents to an infinite two-dimensional grid of houses.

He begins by delivering a present to the house at his starting location, and
then an elf at the North Pole calls him via radio and tells him where to move
next. Moves are always exactly one house to the north (^), south (v), east (>),
or west (<). After each move, he delivers another present to the house at his
new location.

However, the elf back at the north pole has had a little too much eggnog, and
so his directions are a little off, and Santa ends up visiting some houses more
than once. How many houses receive at least one present?

For example:

- > delivers presents to 2 houses: one at the starting location, and one to the
  east.

- ^>v< delivers presents to 4 houses in a square, including twice to the house
  at his starting/ending location.

- ^v^v^v^v^v delivers a bunch of presents to some very lucky children at only 2
  houses.

--- Part Two ---

The next year, to speed up the process, Santa creates a robot version of
himself, Robo-Santa, to deliver presents with him.

Santa and Robo-Santa start at the same location (delivering two presents to the
same starting house), then take turns moving based on instructions from the
elf, who is eggnoggedly reading from the same script as the previous year.

This year, how many houses receive at least one present?

For example:

- ^v delivers presents to 3 houses, because Santa goes north, and then
  Robo-Santa goes south.

- ^>v< now delivers presents to 3 houses, and Santa and Robo-Santa end up back
  where they started.

- ^v^v^v^v^v now delivers presents to 11 houses, with Santa going one direction
  and Robo-Santa going the other.

*/

Point :: struct {
	x, y: int,
}

main :: proc () {
	data, ok := os.read_entire_file(path.join(path.dir(#file), "./input.txt"))
	if !ok {
		fmt.println("Failed to read puzzle input.")
		os.exit(1)
	}

	fmt.println("part1 answer is", solve_part1(string(data)))
	fmt.println("part2 answer is", solve_part2(string(data)))
}

solve_part1 :: proc(input: string) -> int {
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

solve_part2 :: proc(input: string) -> (res: int) {
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
test_solve_part1 :: proc(t: ^testing.T) {
	testing.expect_value(t, solve_part1(">"), 2)
	testing.expect_value(t, solve_part1("^>v<"), 4)
	testing.expect_value(t, solve_part1("^v^v^v^v^v"), 2)
}

@(test)
test_solve_part2 :: proc(t: ^testing.T) {
	testing.expect_value(t, solve_part2("^v"), 3)
	testing.expect_value(t, solve_part2("^>v<"), 3)
	testing.expect_value(t, solve_part2("^v^v^v^v^v"), 11)
}
