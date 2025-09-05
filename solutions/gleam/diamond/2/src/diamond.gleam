import gleam/int
import gleam/list
import gleam/string

const alphabet = [
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
  "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
]

pub fn build(letter: String) -> String {
  let assert [utf_codepoint] = letter |> string.to_utf_codepoints
  let point_in_alphapet =
    utf_codepoint |> string.utf_codepoint_to_int |> int.subtract(64)
  let size = 2 * point_in_alphapet - 1
  let upper_part = alphabet |> list.take(point_in_alphapet) |> list.index_map(build_line(size))
  upper_part
  |> list.append(upper_part |> list.reverse |> list.drop(1))
  |> string.join("\n")
}

fn build_line(size: Int) -> fn(String, Int) -> String {
  fn(letter, position) {
    let first_part_of_line_length = { size + 1 } / 2
    let first_part_of_line =
      string.repeat(" ", first_part_of_line_length - position - 1)
      <> letter
      <> string.repeat(" ", position)
    let second_part_of_line =
      first_part_of_line |> string.reverse |> string.drop_left(1)
    [first_part_of_line, second_part_of_line] |> string.join("")
  }
}
