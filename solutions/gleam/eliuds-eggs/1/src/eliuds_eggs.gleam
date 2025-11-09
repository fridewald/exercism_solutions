import gleam/int
import gleam/list
import gleam/string

pub fn egg_count(number: Int) -> Int {
  number
  |> int.to_base2
  |> string.to_graphemes
  |> list.count(fn(x) { x == "1" })
}
