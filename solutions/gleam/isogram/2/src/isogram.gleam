import gleam/list
import gleam/regex
import gleam/result
import gleam/set
import gleam/string

pub fn is_isogram_1(phrase phrase: String) -> Bool {
  let assert Ok(reg) = regex.from_string("[ -]")
  let cleaned =
    regex.replace(each: reg, in: phrase, with: "") |> string.lowercase()
  let letters = string.split(cleaned, on: "")
  list.try_fold(over: letters, from: set.new(), with: fn(acc, x) {
    case set.contains(acc, x) {
      True -> Error(Nil)
      False -> Ok(set.insert(acc, x))
    }
  })
  |> result.is_ok()
}

pub fn is_isogram(phrase phrase: String) -> Bool {
  let assert Ok(reg) = regex.from_string("[ -]")
  let cleaned =
    regex.replace(each: reg, in: phrase, with: "") |> string.lowercase()
  let letters = string.split(cleaned, on: "")
  letters == list.unique(letters)
}
