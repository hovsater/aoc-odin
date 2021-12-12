package main

import "core:fmt"
import "core:strings"
import "core:testing"

import "../../aoc"

CAVE_START_ID :: "start"
CAVE_END_ID :: "end"

Cave :: struct {
	id: string,
	connections: [dynamic]^Cave,
}

Caves :: distinct map[string]^Cave

main :: proc() {
	input := aoc.must_read_input("2021/12")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> int {
	small_caves_visited: map[^Cave]u8
	caves := parse_input(input)

	return find_distinct_paths(caves[CAVE_START_ID], &small_caves_visited, false)
}

part2 :: proc(input: string) -> int {
	small_caves_visited: map[^Cave]u8
	caves := parse_input(input)

	return find_distinct_paths(caves[CAVE_START_ID], &small_caves_visited, true)
}

parse_input :: proc(input: string) -> (caves: Caves) {
	lines := strings.split(input, "\n")
	defer delete(lines)

	for line in lines {
		ids := strings.split(line, "-")
		defer delete(ids)

		for id in ids {
			if id not_in caves {
				caves[id] = new_clone(Cave{id = id})
			}
		}

		append(&caves[ids[0]].connections, caves[ids[1]])
		append(&caves[ids[1]].connections, caves[ids[0]])
	}

	return
}


find_distinct_paths :: proc(cave: ^Cave, small_caves_visited: ^map[^Cave]u8, revisit_small_cave_once: bool) -> (count: int) {
	revisit_small_cave_once := revisit_small_cave_once

	if is_end(cave) do return 1

	if small_caves_visited[cave] > 0 {
		if !revisit_small_cave_once do return 0
		revisit_small_cave_once = false
	}

	if is_small(cave) do small_caves_visited[cave] +=1

	for neighbouring_cave in cave.connections {
		if is_start(neighbouring_cave) do continue
		count += find_distinct_paths(neighbouring_cave, small_caves_visited, revisit_small_cave_once)
	}

	if cave in small_caves_visited do small_caves_visited[cave] -= 1

	return
}

is_small :: proc(cave: ^Cave) -> bool {
	for c in cave.id {
		if ! (c >= 'a' && c <= 'z') do return false
	}

	return true
}

is_start :: proc(cave: ^Cave) -> bool {
	return cave.id == CAVE_START_ID
}

is_end :: proc(cave: ^Cave) -> bool {
	return cave.id == CAVE_END_ID
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	input := `start-A
start-b
A-c
A-b
b-d
A-end
b-end`

	testing.expect_value(t, part1(input), 10)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
	input := `start-A
start-b
A-c
A-b
b-d
A-end
b-end`

	testing.expect_value(t, part2(input), 36)
}
