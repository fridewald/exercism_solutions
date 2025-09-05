import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{None, Some}
import gleam/regex
import gleam/string

pub fn count_words(input: String) -> Dict(String, Int) {
  let assert Ok(reg) = regex.from_string("(\\w|\\w[\\w']*\\w)\\W")
  regex.scan(reg, input <> "$")
  |> list.map(fn(match) {
    let assert [Some(word), ..] = match.submatches
    word
  })
  |> list.map(string.lowercase)
  |> list.fold(dict.new(), fn(acc, x) {
    dict.upsert(acc, x, fn(t) {
      case t {
        None -> 1
        Some(count) -> count + 1
      }
    })
  })
}
