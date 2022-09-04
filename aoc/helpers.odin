package aoc

import "core:fmt"
import "core:os"
import "core:path/filepath"

must_read_input :: proc(name: string) -> string {
  path_parts := [?]string{filepath.dir(#file), "..", name, "input.txt"}
	puzzle_path := filepath.join(path_parts[:])

	data, ok := os.read_entire_file(puzzle_path)
	if !ok {
		fmt.eprintf("failed to read puzzle input: %s\n", puzzle_path)
		os.exit(1)
	}

	return string(data)
}
