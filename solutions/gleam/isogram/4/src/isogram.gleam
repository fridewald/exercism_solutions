import gleam/list
import gleam/regexp
import gleam/string

pub fn is_isogram(phrase phrase: String) -> Bool {
  let assert Ok(reg) = regexp.from_string("[ -]")
  let letters =
    regexp.replace(each: reg, in: phrase, with: "")
    |> string.lowercase()
    |> string.to_graphemes()
  letters == list.unique(letters)
}
