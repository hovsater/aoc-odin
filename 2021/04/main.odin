package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

import "../../aoc"

main :: proc() {
	input := aoc.must_read_input("2021/04")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

Board :: struct {
	numbers:                map[int]BoardNumber,
	row_counts, col_counts: map[int]int,
	is_solved:              bool,
}

board_sum_unmarked :: proc(b: ^Board) -> (sum: int) {
	for _, n in b.numbers {
		if !n.is_marked do sum += n.value
	}

	return
}

board_mark_number :: proc(b: ^Board, n: ^BoardNumber) -> (int, int) {
	n.is_marked = true
	b.row_counts[n.row] += 1
	b.col_counts[n.col] += 1

	return b.row_counts[n.row], b.col_counts[n.col]
}

BoardNumber :: struct {
	value, row, col: int,
	is_marked:       bool,
}

part1 :: proc(input: string) -> (sum: int) {
	lines := strings.split(input, "\n")
	numbers := slice.mapper(strings.split(lines[0], ","), strconv.atoi)
	boards := parse_boards(lines[2:])

	loop: for v in numbers {
		for board in &boards {
			if number, ok := &board.numbers[v]; ok {
				row_count, col_count := board_mark_number(&board, number)
				if row_count == 5 || col_count == 5 {
					board.is_solved = true

					sum = board_sum_unmarked(&board) * number.value
					break loop
				}
			}
		}
	}

	return
}

part2 :: proc(input: string) -> (sum: int) {
	lines := strings.split(input, "\n")
	numbers := slice.mapper(strings.split(lines[0], ","), strconv.atoi)
	boards := parse_boards(lines[2:])

	boards_unsolved := len(boards)
	loop: for v in numbers {
		for board in &boards {
			if board.is_solved do continue

			if number, ok := &board.numbers[v]; ok {
				row_count, col_count := board_mark_number(&board, number)
				if row_count == 5 || col_count == 5 {
					board.is_solved = true
					boards_unsolved -= 1

					if boards_unsolved == 0 {
						sum = board_sum_unmarked(&board) * number.value
						break loop
					}
				}
			}
		}
	}

	return
}

@(private)
parse_boards :: proc(lines: []string) -> (boards: [dynamic]Board) {
	i, row: int

	append(&boards, Board{})
	for line in lines {
		if line == "" {
			append(&boards, Board{})
			i += 1
			row = 0
			continue
		}

		is_not_empty :: proc(s: string) -> bool {
			return len(s) != 0
		}

		for n, col in slice.mapper(
			slice.filter(strings.split(line, " "), is_not_empty),
			strconv.atoi,
		) {
			boards[i].numbers[n] = BoardNumber{n, row, col, false}
		}

		row += 1
	}

	return
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	input := `7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7`


	testing.expect_value(t, part1(input), 4512)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
	input := `7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7`


	testing.expect_value(t, part2(input), 1924)
}
