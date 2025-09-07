import gleam/bool
import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/set

pub type Classification {
  Perfect
  Abundant
  Deficient
}

pub type Error {
  NonPositiveInt
}

pub fn classify(number: Int) -> Result(Classification, Error) {
  use factors <- result.map(factors(number))
  let aliquot_sum =
    factors
    |> set.to_list
    |> int.sum

  case aliquot_sum {
    x if x == number -> Perfect
    x if x > number -> Abundant
    _ -> Deficient
  }
}

fn factors(number: Int) -> Result(set.Set(Int), Error) {
  let sqr = int.square_root(number) |> result.unwrap(0.0) |> float.truncate
  use <- bool.guard(number <= 0, Error(NonPositiveInt))
  use <- bool.guard(number == 1, Ok(set.new()))
  use <- bool.guard(number == 2, Ok(set.from_list([1])))
  list.range(2, sqr)
  |> list.fold(set.from_list([1]), fn(se, n) {
    case int.modulo(number, n) {
      Ok(0) -> set.insert(se, n) |> set.insert(number / n)
      Error(_) | Ok(_) -> se
    }
  })
  |> Ok
}
