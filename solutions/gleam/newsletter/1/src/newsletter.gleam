import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn read_emails(path: String) -> Result(List(String), Nil) {
  simplifile.read(path)
  |> result.map(fn(x) { string.trim(x) |> string.split("\n") })
  |> result.nil_error()
}

pub fn create_log_file(path: String) -> Result(Nil, Nil) {
  case simplifile.verify_is_file(path) {
    Ok(True) -> Ok(Nil)
    Ok(False) ->
      simplifile.create_file(at: path)
      |> result.nil_error()
    _ -> Error(Nil)
  }
}

pub fn log_sent_email(path: String, email: String) -> Result(Nil, Nil) {
  create_log_file(path)
  |> result.map(fn(_x) {
    simplifile.append(path, email <> "\n") |> result.nil_error()
  })
  |> result.flatten()
}

pub fn send_newsletter(
  emails_path: String,
  log_path: String,
  send_email: fn(String) -> Result(Nil, Nil),
) -> Result(Nil, Nil) {
  let assert Ok(_) = create_log_file(log_path)
  read_emails(emails_path)
  |> result.map(fn(emails) {
    emails
    |> list.map(fn(email) {
      send_email(email)
      |> result.map(fn(_) { log_sent_email(log_path, email) })
      |> result.unwrap(Ok(Nil))
    })
    |> result.all
  })
  |> result.flatten()
  |> result.map(fn(_) { Nil })
}
