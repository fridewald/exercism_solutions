import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/set
import gleam/string

const digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

fn apply_possible_solution(
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
  // echo puzzle
  // use #(summands, sum) <- result.try(parse(puzzle) |> echo)
  use #(summands, sum) <- result.try(parse(puzzle))
  let summands_graphemes = list.map(summands, string.to_graphemes)
  let sum_graphemes = string.to_graphemes(sum)
  let validate_base = validate(sum_graphemes, summands_graphemes)
  let used_letter_list =
    list.fold(
      summands_graphemes,
      set.new() |> set.union(set.from_list(sum_graphemes)),
      fn(acc, x) {
        acc
        |> set.union(set.from_list(x))
      },
    )
    |> set.to_list
  {
    let possible_subsets_of_digits =
      list.combinations(digits, used_letter_list |> list.length)
    use subset_of_digits <- list.find_map(possible_subsets_of_digits)
    // This seems slow. Do manual permutations
    find_permutation_of_digit_set(
      subset_of_digits,
      validate_base,
      used_letter_list,
      [],
    )
  }
  // |> echo
}

fn find_permutation_of_digit_set(
  open_subset_of_digits: List(Int),
  validate: fn(dict.Dict(String, Int)) -> Bool,
  used_letter_list: List(String),
  assigned_digits: List(Int),
) -> Result(dict.Dict(String, Int), Nil) {
  case open_subset_of_digits {
    [] -> {
      let base = list.zip(used_letter_list, assigned_digits) |> dict.from_list
      case validate(base) {
        True -> Ok(base)
        False -> Error(Nil)
      }
    }
    _ -> {
      use digit <- list.find_map(open_subset_of_digits)
      // drop current digit from subset
      let open_subset_of_digits =
        open_subset_of_digits
        |> set.from_list
        |> set.drop([digit])
        |> set.to_list
      find_permutation_of_digit_set(
        open_subset_of_digits,
        validate,
        used_letter_list,
        [digit, ..assigned_digits],
      )
    }
  }
  // let perms = list.permutations(subset_of_digits)

  // use perm <- list.find_map(perms)
  // let base = list.zip(used_letter_list, perm) |> dict.from_list
  // // Ok(base)
  // case validate_base(base) {
  //   True -> Ok(base)
  //   False -> Error(Nil)
  // }
}

fn validate(
  sum: List(String),
  summands: List(List(String)),
) -> fn(dict.Dict(String, Int)) -> Bool {
  fn(sol) {
    let sum_int =
      apply_possible_solution(sum, sol)
      |> result.unwrap(0)
    let summands_sum_int = {
      list.filter_map(summands, apply_possible_solution(_, sol))
      |> int.sum
    }
    sum_int == summands_sum_int
    // case sum_int == summands_sum_int {
    //   False -> False
    //   True -> {
    //     echo list.filter_map(summands, apply_possible_solution(_, sol))
    //     echo apply_possible_solution(summands_sum_int, sol)
    //     True
    //   }
    // }
  }
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
