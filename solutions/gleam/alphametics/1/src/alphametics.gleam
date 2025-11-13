import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/set
import gleam/string

const digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

fn apply(
  grapheme: List(String),
  sol: dict.Dict(String, Int),
) -> Result(Int, Nil) {
  case
    grapheme
    |> list.filter_map(dict.get(sol, _))
  {
    [0, ..] -> Error(Nil)
    no_leading_zero -> int.undigits(no_leading_zero, 10)
  }
}

pub fn solve(puzzle: String) -> Result(dict.Dict(String, Int), Nil) {
  echo puzzle
  use #(summands, res) <- result.try(parse(puzzle) |> echo)
  let summands = list.map(summands, string.to_graphemes)
  let res = string.to_graphemes(res)
  let validate: fn(dict.Dict(String, Int)) -> Bool = fn(sol) {
    let res1 =
      apply(res, sol)
      |> result.unwrap(0)
    let sum = {
      list.filter_map(summands, apply(_, sol))
      |> int.sum
    }
    case res1 == sum {
      False -> False
      True -> {
        echo list.filter_map(summands, apply(_, sol))
        echo apply(res, sol)
        True
      }
    }
  }
  let letter_list =
    list.fold(summands, set.new() |> set.union(set.from_list(res)), fn(acc, x) {
      acc
      |> set.union(set.from_list(x))
    })
    |> set.to_list
  {
    let combis = list.combinations(digits, letter_list |> list.length)
    use combi <- list.find_map(combis)
    let perms = list.permutations(combi)

    use perm <- list.find_map(perms)
    let base = list.zip(letter_list, perm) |> dict.from_list
    case validate(base) {
      True -> Ok(base)
      False -> Error(Nil)
    }
  }
  |> echo
}

fn parse(puzzle: String) -> Result(#(List(String), String), Nil) {
  case
    string.replace(puzzle, " ", "")
    |> string.split("==")
  {
    [summands, result] -> Ok(#(summands, result))
    _ -> Error(Nil)
  }
  |> result.map(with: fn(x) {
    let #(summands, res) = x
    #(string.split(summands, "+"), res)
  })
}
