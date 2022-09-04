package aoc

import "core:fmt"
import "core:os"
import "core:path/filepath"

must_read_input :: proc(name: string) -> string {
	file_dir := filepath.dir(#file)
	defer delete(file_dir)

	path_parts := [?]string{file_dir, "..", name, "input.txt"}
	puzzle_path := filepath.join(path_parts[:])
	defer delete(puzzle_path)

	data, ok := os.read_entire_file(puzzle_path)
	if !ok {
		fmt.eprintf("failed to read puzzle input: %s\n", puzzle_path)
		os.exit(1)
	}

	return string(data)
}
