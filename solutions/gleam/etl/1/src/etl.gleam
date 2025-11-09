import gleam/dict.{type Dict}
import gleam/list
import gleam/string

pub fn transform(legacy: Dict(Int, List(String))) -> Dict(String, Int) {
  legacy
  |> dict.to_list
  |> list.flat_map(fn(entry) {
    list.map(entry.1, fn(letter) { #(letter |> string.lowercase, entry.0) })
  })
  |> dict.from_list
}
