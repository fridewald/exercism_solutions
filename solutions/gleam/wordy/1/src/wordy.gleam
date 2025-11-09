import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type Error {
  SyntaxError
  UnknownOperation
  ImpossibleOperation
}

type EquationParts {
  Number(Int)
  Plus
  Minus
  Multiply
  Divide
}

pub fn main() {
  answer("What is?")
}

pub fn answer(question: String) -> Result(Int, Error) {
  use trimmed <- result.try(trim_what(question))
  use equation <- result.try(split_to_equation(trimmed))
  perform_calculation(equation)
}

fn trim_what(question: String) -> Result(String, Error) {
  case question {
    "What is" <> equation ->
      Ok(equation |> string.replace(each: "?", with: "") |> string.trim)
    _ -> Error(UnknownOperation)
  }
}

fn split_to_equation(trimmed: String) -> Result(List(EquationParts), Error) {
  string.split(trimmed, on: " ")
  |> list.filter(fn(x) { x != "" })
  |> convert_to_equation
}

fn convert_to_equation(
  strings: List(String),
) -> Result(List(EquationParts), Error) {
  case strings {
    [] -> Error(SyntaxError)
    [number] -> parse_equation_part(number) |> result.map(fn(x) { [x] })
    [number, op, "by", ..rest] -> {
      use number <- result.try(parse_equation_part(number))
      use operation <- result.try(parse_equation_part(op))
      use next <- result.try(convert_to_equation(rest))
      Ok([number, operation, ..next])
    }
    [number, op, ..rest] -> {
      use number <- result.try(parse_equation_part(number))
      use operation <- result.try(parse_equation_part(op))
      use next <- result.try(convert_to_equation(rest))
      Ok([number, operation, ..next])
    }
  }
}

fn parse_equation_part(equation_part: String) {
  case equation_part {
    "plus" -> Ok(Plus)
    "minus" -> Ok(Minus)
    "multiplied" -> Ok(Multiply)
    "divided" -> Ok(Divide)
    number ->
      int.parse(number)
      |> result.map(Number)
      |> result.replace_error(UnknownOperation)
  }
}

fn perform_calculation(equation: List(EquationParts)) -> Result(Int, Error) {
  case equation {
    [] -> Error(SyntaxError)
    _ -> do_perform_calculation(equation, 0)
  }
}

fn do_perform_calculation(equation, result) {
  case equation {
    // base case
    // issue when starting equation is empty is handle in calling function
    [] -> Ok(result)
    // start, ugly but fine for exercism
    [Number(number), ..rest] if result == 0 ->
      do_perform_calculation(rest, number)
    // interativ step
    [Plus, Number(end), ..rest] -> do_perform_calculation(rest, result + end)
    [Minus, Number(end), ..rest] -> do_perform_calculation(rest, result - end)
    [Multiply, Number(end), ..rest] ->
      do_perform_calculation(rest, result * end)
    [Divide, Number(end), ..rest] if end != 0 ->
      do_perform_calculation(rest, result / end)
    [Divide, Number(end), ..] if end == 0 -> Error(ImpossibleOperation)
    _ -> Error(SyntaxError)
  }
}
