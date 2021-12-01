package main

import "core:crypto/md5"
import "core:fmt"
import "core:os"
import "core:path"
import "core:strconv"
import "core:strings"
import "core:testing"

/*

--- Day 4: The Ideal Stocking Stuffer ---

Santa needs help mining some AdventCoins (very similar to bitcoins) to use as
gifts for all the economically forward-thinking little girls and boys.

To do this, he needs to find MD5 hashes which, in hexadecimal, start with at
least five zeroes. The input to the MD5 hash is some secret key (your puzzle
input, given below) followed by a number in decimal. To mine AdventCoins, you
must find Santa the lowest positive number (no leading zeroes: 1, 2, 3, ...)
that produces such a hash.

For example:

- If your secret key is abcdef, the answer is 609043, because the MD5 hash of
  abcdef609043 starts with five zeroes (000001dbbfa...), and it is the lowest
  such number to do so.

- If your secret key is pqrstuv, the lowest number it combines with to make an
  MD5 hash starting with five zeroes is 1048970; that is, the MD5 hash of
  pqrstuv1048970 looks like 000006136ef....

--- Part Two ---

Now find one that starts with six zeroes.

*/

main :: proc () {
	data, ok := os.read_entire_file(path.join(path.dir(#file), "./input.txt"))
	if !ok {
		fmt.println("Failed to read puzzle input.")
		os.exit(1)
	}

	fmt.println("part1 answer is", solve_part1(string(data)))
	fmt.println("part2 answer is", solve_part2(string(data)))
}

solve_part1 :: proc(input: string) -> (n: int) {
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

solve_part2 :: proc(input: string) -> (n: int) {
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
test_solve_part1 :: proc(t: ^testing.T) {
	testing.expect_value(t, solve_part1("abcdef"), 609043)
	testing.expect_value(t, solve_part1("pqrstuv"), 1048970)
}
