import gleam/string

pub fn message(log_line: String) -> String {
  let return_msg = case log_line {
    "[ERROR]: " <> msg -> msg
    "[WARNING]: " <> msg -> msg
    "[INFO]: " <> msg -> msg
    _ -> "invalid format"
  }
  string.trim(return_msg)
}

pub fn log_level(log_line: String) -> String {
  case log_line {
    "[ERROR]:" <> _ -> "error"
    "[WARNING]: " <> _ -> "warning"
    "[INFO]: " <> _ -> "info"
    _ -> "invalid format"
  }
}

pub fn reformat(log_line: String) -> String {
  message(log_line) <> " (" <> log_level(log_line) <> ")" 
}
