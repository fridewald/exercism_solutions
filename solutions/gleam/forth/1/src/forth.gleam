import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type Forth {
  Forth(stack: Stack, function_stack: FunctionStack)
}

type FunctionStack =
  Dict(String, List(String))

pub type ForthError {
  DivisionByZero
  StackUnderflow
  InvalidWord
  UnknownWord
}

pub opaque type Stack {
  Stack(stack: Stack, value: Int)
  Bottom
}

pub fn new() -> Forth {
  Forth(Bottom, dict.new())
}

pub fn format_stack(f: Forth) -> String {
  do_format_stack(f.stack)
}

fn do_format_stack(s: Stack) -> String {
  case s {
    Bottom -> ""
    Stack(Bottom, i) -> int.to_string(i)
    Stack(s, i) -> do_format_stack(s) <> " " <> int.to_string(i)
  }
}

pub fn eval(f: Forth, prog: String) -> Result(Forth, ForthError) {
  case string.trim(prog) {
    "" -> Ok(f)
    ": " <> func_definition -> eval_function_definition(f, func_definition)
    command_string ->
      command_string
      |> string.split(on: " ")
      |> apply_functions(f.function_stack)
      |> execute_commands(f.stack)
      |> result.map(Forth(stack: _, function_stack: f.function_stack))
  }
}

fn eval_function_definition(f: Forth, prog: String) -> Result(Forth, ForthError) {
  case string.split(prog, " ") {
    [] | [_] | [_, ";"] -> Error(UnknownWord)
    [first_string, ..rest] -> {
      use word <- result.try(parse_word(first_string))

      let function_stack =
        dict.insert(
          f.function_stack,
          string.uppercase(word),
          apply_functions(rest, f.function_stack),
        )
      Ok(Forth(stack: f.stack, function_stack:))
    }
  }
}

fn parse_word(word: String) -> Result(String, ForthError) {
  case int.parse(word) {
    Ok(_) -> Error(InvalidWord)
    _ -> Ok(word)
  }
}

fn apply_functions(
  commands: List(String),
  f_stack: FunctionStack,
) -> List(String) {
  commands
  |> list.map(fn(command) {
    let upper_command = string.uppercase(command)
    case command, dict.get(f_stack, upper_command) {
      // we can safely drop the end semicolon
      ";", _ -> []
      // replace command with function body
      _, Ok(body) -> body
      _, Error(_) -> [upper_command]
    }
  })
  |> list.flatten()
}

fn execute_commands(
  commands: List(String),
  f: Stack,
) -> Result(Stack, ForthError) {
  case commands {
    [] -> Ok(f)
    [command, ..rest] ->
      execute_command(f, command)
      |> result.then(execute_commands(rest, _))
  }
}

fn execute_command(f: Stack, command: String) -> Result(Stack, ForthError) {
  let num_result = int.parse(command)
  case num_result, string.uppercase(command) {
    Ok(num), _ -> Ok(Stack(f, num))
    _, "+" -> {
      case f {
        Stack(Stack(rest, i2), i1) -> Ok(Stack(rest, i2 + i1))
        _ -> Error(StackUnderflow)
      }
    }
    _, "-" ->
      case f {
        Stack(Stack(rest, i2), i1) -> Ok(Stack(rest, i2 - i1))
        _ -> Error(StackUnderflow)
      }
    _, "*" ->
      case f {
        Stack(Stack(rest, i2), i1) -> Ok(Stack(rest, i2 * i1))
        _ -> Error(StackUnderflow)
      }
    _, "/" ->
      case f {
        Stack(Stack(rest, i2), i1) if i1 != 0 -> Ok(Stack(rest, i2 / i1))
        Stack(Stack(_, _), i1) if i1 == 0 -> Error(DivisionByZero)
        _ -> Error(StackUnderflow)
      }
    _, "DUP" ->
      case f {
        Stack(rest, i1) -> Ok(Stack(Stack(rest, i1), i1))
        _ -> Error(StackUnderflow)
      }
    _, "DROP" ->
      case f {
        Stack(rest, _) -> Ok(rest)
        _ -> Error(StackUnderflow)
      }
    _, "SWAP" ->
      case f {
        Stack(Stack(rest, i2), i1) -> Ok(Stack(Stack(rest, i1), i2))
        _ -> Error(StackUnderflow)
      }
    _, "OVER" ->
      case f {
        Stack(Stack(_, i2), _) -> Ok(Stack(f, i2))
        _ -> Error(StackUnderflow)
      }
    _, _ -> Error(UnknownWord)
  }
}
