import gleam/list
import gleam/result
import gleam/string

pub fn distance(strand1: String, strand2: String) -> Result(Int, Nil) {
  use combi_list <- result.map(list.strict_zip(
    strand1 |> string.to_graphemes,
    strand2 |> string.to_graphemes,
  ))

  list.count(combi_list, fn(two_letters) { two_letters.0 != two_letters.1 })
}
