import gleam/int
import gleam/list
import gleam/string

const alphabet = [
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
  "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
]

pub fn build(letter: String) -> String {
  let upper = string.uppercase(letter)
  let assert [utf_codepoint_1, ..] = upper |> string.to_utf_codepoints
  let point_in_alphapet =
    utf_codepoint_1 |> string.utf_codepoint_to_int |> int.subtract(64)
  let length = 2 * point_in_alphapet - 1
  let upper_base = alphabet |> list.take(point_in_alphapet)
  let upper_part = upper_base |> list.index_map(build_line(length))

  upper_part
  |> list.append(upper_part |> list.reverse |> list.drop(1))
  |> string.join("\n")
}

fn build_line(length: Int) -> fn(String, Int) -> String {
  fn(letter, position) {
    let first_part_of_line_length = { length + 1 } / 2
    let first_part_of_line =
      string.repeat(" ", first_part_of_line_length - position - 1)
      <> letter
      <> string.repeat(" ", position)

    let second_part_of_line =
      first_part_of_line |> string.reverse |> string.drop_left(1)

    [first_part_of_line, second_part_of_line] |> string.join("")
  }
}
