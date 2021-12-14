package main

import "core:fmt"
import "core:strings"
import "core:testing"
import "core:slice"

import "../../aoc"

CAVE_START :: "start"
CAVE_END :: "end"

Cave :: struct {
	name: string,
	passages: [dynamic]^Cave,
}

main :: proc() {
	input := aoc.must_read_input("2021/12")
	fmt.println("part1_recursive", part1_recursive(input))
	fmt.println("part2_recursive", part2_recursive(input))
	fmt.println("part1_iterative", part1_iterative(input))
	fmt.println("part2_iterative", part2_iterative(input))
}

part1_recursive :: proc(input: string) -> int {
	caves_visited: map[^Cave]u8
	caves := parse_input(input)

	return find_paths_recursive(caves[CAVE_START], &caves_visited, false)
}

part2_recursive :: proc(input: string) -> int {
	caves_visited: map[^Cave]u8
	caves := parse_input(input)

	return find_paths_recursive(caves[CAVE_START], &caves_visited, true)
}

part1_iterative :: proc(input: string) -> int {
	caves := parse_input(input)

	return find_paths_iterative(caves[CAVE_START], false)
}

part2_iterative :: proc(input: string) -> int {
	caves := parse_input(input)

	return find_paths_iterative(caves[CAVE_START], true)
}

parse_input :: proc(input: string) -> (caves: map[string]^Cave) {
	lines := strings.split(input, "\n")
	defer delete(lines)

	for line in lines {
		names := strings.split(line, "-")
		defer delete(names)

		for name in names {
			if name not_in caves do caves[name] = new_clone(Cave{name=name})
		}

		append(&caves[names[0]].passages, caves[names[1]])
		append(&caves[names[1]].passages, caves[names[0]])
	}

	return
}

find_paths_recursive :: proc(cave: ^Cave, caves_visited: ^map[^Cave]u8, revisit_once: bool) -> (count: int) {
	revisit_once := revisit_once

	if is_end(cave) do return 1

	if caves_visited[cave] > 0 {
		if !revisit_once do return 0
		revisit_once = false
	}

	if is_small(cave) do caves_visited[cave] +=1

	for neighbouring_cave in cave.passages {
		if is_start(neighbouring_cave) do continue
		count += find_paths_recursive(neighbouring_cave, caves_visited, revisit_once)
	}

	if cave in caves_visited do caves_visited[cave] -= 1

	return
}

CavePath :: struct {
	current: ^Cave,
	visited: map[^Cave]bool,
	revisit_once: bool,
}


find_paths_iterative :: proc(cave: ^Cave, revisit_once: bool) -> (count: int) {
	stack : [dynamic]CavePath
	initial_path := CavePath{cave, {cave = true}, revisit_once}
	append(&stack, initial_path)

	for len(stack) != 0  {
		path := pop(&stack)

		if is_end(path.current) {
			count += 1
			continue
		}

		for neighbouring_cave in path.current.passages {
			if is_start(neighbouring_cave) do continue

			if !is_small(neighbouring_cave) {
				append(&stack, CavePath{neighbouring_cave, path.visited, path.revisit_once})
			} else if !path.visited[neighbouring_cave] {
				new_visited := make(map[^Cave]bool, len(path.visited) + 1)
				new_visited[neighbouring_cave] = true
				for k, v in path.visited do new_visited[k] = v
				append(&stack, CavePath{neighbouring_cave, new_visited, path.revisit_once})
			} else if path.revisit_once {
				append(&stack, CavePath{neighbouring_cave, path.visited, false})
			}
		}
	}

	return
}

is_small :: proc(cave: ^Cave) -> bool {
	return cave.name[0] >= 'a' && cave.name[0] <= 'z'
}

is_start :: proc(cave: ^Cave) -> bool {
	return cave.name == CAVE_START
}

is_end :: proc(cave: ^Cave) -> bool {
	return cave.name == CAVE_END
}

@(test)
test_part1_recursive :: proc(t: ^testing.T) {
	input := `start-A
start-b
A-c
A-b
b-d
A-end
b-end`

	testing.expect_value(t, part1_recursive(input), 10)
}

@(test)
test_part1_iterative :: proc(t: ^testing.T) {
	input := `start-A
start-b
A-c
A-b
b-d
A-end
b-end`

	testing.expect_value(t, part1_iterative(input), 10)
}

@(test)
test_part2_recursive :: proc(t: ^testing.T) {
	input := `start-A
start-b
A-c
A-b
b-d
A-end
b-end`

	testing.expect_value(t, part2_recursive(input), 36)
}

@(test)
test_part2_iterative :: proc(t: ^testing.T) {
	input := `start-A
start-b
A-c
A-b
b-d
A-end
b-end`

	testing.expect_value(t, part2_iterative(input), 36)
}
