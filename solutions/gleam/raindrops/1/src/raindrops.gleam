import gleam/int

pub fn convert(number: Int) -> String {
  let pling = case number % 3 {
    0 -> "Pling"
    _ -> ""
  }
  let plang = case number % 5 {
    0 -> "Plang"
    _ -> ""
  }
  let plong = case number % 7 {
    0 -> "Plong"
    _ -> ""
  }
  let message = pling <> plang <> plong
  case message == "" {
    True -> int.to_string(number)
    False -> message
  }
}
