import gleam/list
import gleam/string

pub fn slices(input: String, size: Int) -> Result(List(String), Error) {
  case input, size {
    _, 0 -> Error(SliceLengthZero)
    _, size if size < 0 -> Error(SliceLengthNegative)
    "", _ -> Error(EmptySeries)
    input, size -> {
      let value =
        input
        |> string.to_graphemes()
        |> list.window(size)
        |> list.map(string.join(_, ""))
      case value {
        [] -> Error(SliceLengthTooLarge)
        ok -> Ok(ok)
      }
    }
  }
}

pub type Error {
  SliceLengthTooLarge
  SliceLengthZero
  SliceLengthNegative
  EmptySeries
}
