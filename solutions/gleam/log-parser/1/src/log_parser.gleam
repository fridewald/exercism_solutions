import gleam/io
import gleam/option.{Some}
import gleam/regex

pub fn is_valid_line(line: String) -> Bool {
  let assert Ok(re) = regex.from_string("^\\[(DEBUG|INFO|WARNING|ERROR)\\]")
  regex.check(with: re, content: line)
}

pub fn split_line(line: String) -> List(String) {
  let assert Ok(re) = regex.from_string("<[~*=-]*>")
  regex.split(with: re, content: line)
}

pub fn tag_with_user_name(line: String) -> String {
  let assert Ok(re) = regex.from_string("User\\s+(\\S+)")

  let scan = regex.scan(with: re, content: line)
  case scan {
    [regex.Match(_, [Some(user_name)]), ..] ->
      "[USER] " <> user_name <> " " <> line
    _ -> line
  }
}
