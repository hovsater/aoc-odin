package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

import "../../aoc"

Vector2 :: distinct [2]int

LineSegment :: struct {
	a, b: Vector2,
}

main :: proc() {
	input := aoc.must_read_input("2021/05")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> int {
	line_segments := parse_input(input)
	return count_overlaps(line_segments[:])
}

part2 :: proc(input: string) -> int {
	line_segments := parse_input(input)
	return count_overlaps(line_segments[:], true)
}

@(private)
count_overlaps :: proc(line_segments: []LineSegment, count_diagonals := false) -> (overlaps: int) {
	counts: map[Vector2]int
	for segment in line_segments {
		delta := segment.b - segment.a
		if !count_diagonals && delta.x != 0 && delta.y != 0 do continue

		s := slope(delta)
		for p := segment.a; p != segment.b; p += s {
			counts[p] += 1
		}

		counts[segment.b] += 1
	}

	for _, v in counts {
		if v > 1 do overlaps += 1
	}

	return
}

@(private)
slope :: proc(v: Vector2) -> Vector2 {
	return Vector2{max(min(v.x, 1), -1), max(min(v.y, 1), -1)}
}

@(private)
parse_input :: proc(input: string) -> (line_segments: [dynamic]LineSegment) {
	for line in strings.split(input, "\n") {
		parts := strings.split(line, " -> ")
		p1 := slice.mapper(strings.split(parts[0], ","), strconv.atoi)
		p2 := slice.mapper(strings.split(parts[1], ","), strconv.atoi)
		append(&line_segments, LineSegment{{p1[0], p1[1]}, {p2[0], p2[1]}})
	}

	return
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	input := `0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2`

	testing.expect_value(t, part1(input), 5)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
	input := `0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2`

	testing.expect_value(t, part2(input), 12)
}
