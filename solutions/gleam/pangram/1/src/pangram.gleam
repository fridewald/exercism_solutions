import gleam/list
import gleam/set
import gleam/string

pub fn is_pangram(sentence: String) -> Bool {
  sentence
  |> string.lowercase
  |> string.to_utf_codepoints
  |> list.map(string.utf_codepoint_to_int)
  |> list.filter(fn(utf) { utf >= 0x61 && utf <= 0x7a })
  |> set.from_list
  |> set.size
  == 26
}
