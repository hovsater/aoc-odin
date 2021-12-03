package main

import "core:crypto/md5"
import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:testing"

import "../../aoc"

main :: proc () {
	input := aoc.must_read_input("2015/04")
	fmt.println("part1", part1(input))
	fmt.println("part2", part2(input))
}

part1 :: proc(input: string) -> (n: int) {
	buf : [10]byte
	for {
		n += 1
		str := strings.concatenate([]string{input, strconv.itoa(buf[:], n)})
		defer delete(str)

		hash := md5.hash_string(str)
		hash_string := fmt.aprintf("%02x", string(hash[:]))
		defer delete(hash_string)

		if strings.has_prefix(hash_string, "00000") {
			break
		}
	}

	return
}

part2 :: proc(input: string) -> (n: int) {
	buf : [10]byte
	for {
		n += 1
		str := strings.concatenate([]string{input, strconv.itoa(buf[:], n)})
		defer delete(str)

		hash := md5.hash_string(str)
		hash_string := fmt.aprintf("%02x", string(hash[:]))
		defer delete(hash_string)

		if strings.has_prefix(hash_string, "000000") {
			break
		}
	}

	return
}

@(private)
find_md5_hash_with_prefix :: proc(secret, prefix: string) -> (n: int) {
	buf : [10]byte
	for {
		n += 1
		str := strings.concatenate([]string{secret, strconv.itoa(buf[:], n)})
		defer delete(str)

		hash := md5.hash_string(str)
		hash_string := fmt.aprintf("%02x", string(hash[:]))
		defer delete(hash_string)

		if strings.has_prefix(hash_string, prefix) {
			break
		}
	}

	return
}

@(test)
test_part1 :: proc(t: ^testing.T) {
	testing.expect_value(t, part1("abcdef"), 609043)
	testing.expect_value(t, part1("pqrstuv"), 1048970)
}
