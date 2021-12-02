package aoc

import "core:fmt"
import "core:os"
import "core:path"

must_read_input :: proc(name: string) -> string {
	puzzle_path := path.join(path.dir(#file), "..", name, "input.txt")

	data, ok := os.read_entire_file(puzzle_path)
	if !ok {
		fmt.eprintf("failed to read puzzle input: %s\n", puzzle_path)
		os.exit(1)
	}

	return string(data)
}
