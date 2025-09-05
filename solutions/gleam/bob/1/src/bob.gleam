import gleam/list
import gleam/string

pub fn hey(remark: String) -> String {
  let trimmed_remark = string.trim(remark)
  let any_capital_letters =
    remark
    |> string.to_utf_codepoints
    |> list.map(string.utf_codepoint_to_int)
    |> list.any(fn(code_point) { code_point >= 0x41 && code_point <= 0x5a })
  case
    string.ends_with(trimmed_remark, "?"),
    any_capital_letters && string.uppercase(remark) == remark,
    trimmed_remark == ""
  {
    _, _, True -> "Fine. Be that way!"
    True, False, False -> "Sure."
    False, True, False -> "Whoa, chill out!"
    True, True, False -> "Calm down, I know what I'm doing!"
    False, False, False -> "Whatever."
  }
}
