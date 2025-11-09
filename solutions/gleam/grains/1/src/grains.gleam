import gleam/bool
import gleam/int
import gleam/string

pub type Error {
  InvalidSquare
}

pub fn square(square: Int) -> Result(Int, Error) {
  use <- bool.guard(square > 64 || square <= 0, Error(InvalidSquare))
  1 |> int.bitwise_shift_left(square - 1) |> Ok
}

pub fn total() -> Int {
  let assert Ok(total) =
    string.repeat("1", 64)
    |> int.base_parse(2)
  total
}
