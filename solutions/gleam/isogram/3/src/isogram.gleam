import gleam/list
import gleam/regex
import gleam/string

pub fn is_isogram(phrase phrase: String) -> Bool {
  let assert Ok(reg) = regex.from_string("[ -]")
  let letters =
    regex.replace(each: reg, in: phrase, with: "")
    |> string.lowercase()
    |> string.to_graphemes()
  letters == list.unique(letters)
}
