import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn is_armstrong_number(number: Int) -> Bool {
  {
    use digit_strings <- result.map(
      number
      |> int.to_string
      |> string.to_graphemes
      |> list.map(int.parse)
      |> result.all,
    )
    let size = digit_strings |> list.length

    digit_strings
    |> list.map(fn(x) { power(x, size) })
    |> int.sum
  }
  == Ok(number)
}

fn power(x: Int, exponent: Int) -> Int {
  do_power(1, x, exponent)
}

fn do_power(res: Int, x: Int, expo: Int) {
  case expo {
    0 -> res
    _ if expo > 0 -> do_power(res * x, x, { expo - 1 })
    _ -> do_power(res * 1 / x, 1 / x, { -1 * expo } - 1)
  }
}
