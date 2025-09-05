import gleam/bool
import gleam/list
import gleam/option.{Some}
import gleam/regex
import gleam/result
import gleam/string

pub fn clean(input: String) -> Result(String, String) {
  let assert Ok(remove) = regex.from_string("[\\(\\). \\-+]")
  let cleaned_number = regex.replace(each: remove, in: input, with: "")

  let assert Ok(has_letter) = regex.from_string("[a-zA-Z]")
  use <- bool.guard(
    regex.check(with: has_letter, content: cleaned_number),
    Error("letters not permitted"),
  )

  let assert Ok(has_punctuation) = regex.from_string("\\W")
  use <- bool.guard(
    regex.check(with: has_punctuation, content: cleaned_number),
    Error("punctuations not permitted"),
  )
  use <- bool.guard(
    cleaned_number |> string.length() < 10,
    Error("must not be fewer than 10 digits"),
  )
  use <- bool.guard(
    cleaned_number |> string.length() > 11,
    Error("must not be greater than 11 digits"),
  )
  let assert Ok(reg) =
    regex.from_string("^(\\d{0,1})(\\d)(\\d{2})(\\d)(\\d{2})(\\d{4})$")
  let scan_res = regex.scan(with: reg, content: cleaned_number)
  use scan_res <- result.try(list.first(scan_res) |> result.replace_error(""))
  let assert regex.Match(
    _,
    [
      country_code,
      Some(area_code_start),
      Some(area_code),
      Some(exchange_code_start),
      Some(exchange_code),
      Some(subscriber_number),
    ],
  ) = scan_res

  use <- bool.guard(
    option.is_some(country_code) && country_code != Some("1"),
    Error("11 digits must start with 1"),
  )

  use <- bool.guard(
    area_code_start == "0",
    Error("area code cannot start with zero"),
  )
  use <- bool.guard(
    area_code_start == "1",
    Error("area code cannot start with one"),
  )
  use <- bool.guard(
    exchange_code_start == "0",
    Error("exchange code cannot start with zero"),
  )
  use <- bool.guard(
    exchange_code_start == "1",
    Error("exchange code cannot start with one"),
  )

  Ok(
    area_code_start
    <> area_code
    <> exchange_code_start
    <> exchange_code
    <> subscriber_number,
  )
}
