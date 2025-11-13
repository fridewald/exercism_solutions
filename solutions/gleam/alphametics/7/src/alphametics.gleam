import gleam/bool
import gleam/dict
import gleam/float
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/set
import gleam/string

const digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

pub fn solve(puzzle: String) -> Result(dict.Dict(String, Int), Nil) {
  use #(summands, sum, first_letters) <- result.try(parse(puzzle))
  let validate_callback = get_validate_callback(sum, summands)
  let used_letters: List(String) =
    { summands |> dict.keys |> set.from_list }
    |> set.union(set.from_list(sum |> dict.keys))
    |> set.drop(["+"])
    |> set.to_list
  let possible_subsets_of_digits =
    list.combinations(digits, used_letters |> list.length)
  use subset_of_digits <- list.find_map(possible_subsets_of_digits)
  // Do manual permutations
  find_permutation_of_digit_set(
    subset_of_digits |> set.from_list,
    validate_callback,
    used_letters,
    first_letters,
    [],
  )
}

fn parse(
  puzzle: String,
) -> Result(
  #(dict.Dict(String, Int), dict.Dict(String, Int), set.Set(String)),
  Nil,
) {
  let split = case
    string.replace(puzzle, " ", "")
    |> string.split("==")
  {
    [summands, result] -> Ok(#(summands, result))
    _ -> Error(Nil)
  }

  use #(summands_string, result_string) <- result.map(split)
  let summands = string.split(summands_string, "+")
  let result_dict = get_letter_multiplier_dict(result_string)

  let summands_dict =
    summands
    |> list.map(get_letter_multiplier_dict)
    |> list.fold(dict.new(), fn(acc, x) {
      dict.combine(acc, x, fn(a, b) { a + b })
    })
  // first letter set
  let assert Ok(res_first) = string.first(result_string)
  let assert Ok(summands_firsts) =
    list.map(summands, string.first) |> result.all
  let first_letter_set = set.from_list(summands_firsts) |> set.insert(res_first)
  #(summands_dict, result_dict, first_letter_set)
}

fn get_letter_multiplier_dict(res: String) -> dict.Dict(String, Int) {
  let res_graphems = string.to_graphemes(res) |> list.reverse

  list.index_map(res_graphems, fn(char, index) { #(char, index) })
  |> list.fold(dict.new(), fn(acc, char_index_tuple) {
    dict.upsert(acc, char_index_tuple.0, fn(cardinality) {
      {
        cardinality
        |> option.unwrap(0)
      }
      + {
        int.power(10, int.to_float(char_index_tuple.1))
        |> result.unwrap(0.0)
        |> float.truncate
      }
    })
  })
}

fn get_validate_callback(
  sum: dict.Dict(String, Int),
  summands: dict.Dict(String, Int),
) -> fn(dict.Dict(String, Int)) -> Bool {
  fn(possible_solution) {
    let sum_int = apply_possible_solution(sum, possible_solution)
    let summands_int = apply_possible_solution(summands, possible_solution)
    sum_int == summands_int
  }
}

fn apply_possible_solution(
  letter_cardi_map: dict.Dict(String, Int),
  sol: dict.Dict(String, Int),
) -> Int {
  letter_cardi_map
  |> dict.map_values(fn(key, values) {
    let sol_value =
      sol
      |> dict.get(key)
      |> result.unwrap(0)

    sol_value * values
  })
  |> dict.values
  |> int.sum
}

fn find_permutation_of_digit_set(
  open_subset_of_digits: set.Set(Int),
  validate: fn(dict.Dict(String, Int)) -> Bool,
  letters_in_equation: List(String),
  first_letters: set.Set(String),
  assigned_digits: List(Int),
) -> Result(dict.Dict(String, Int), Nil) {
  case open_subset_of_digits |> set.size {
    // base case
    0 -> {
      let possible_solution =
        list.zip(letters_in_equation, assigned_digits) |> dict.from_list
      case validate(possible_solution) {
        True -> Ok(possible_solution)
        False -> Error(Nil)
      }
    }
    // iterative case
    _ -> {
      use digit <- list.find_map(open_subset_of_digits |> set.to_list)
      let is_leading_zero =
        digit == 0
        && {
          let assert Ok(curr_letter) =
            list_get(
              letters_in_equation,
              { open_subset_of_digits |> set.size } - 1,
            )
          first_letters |> set.contains(curr_letter)
        }
      // early return when we have a leading zero
      use <- bool.guard(is_leading_zero, Error(Nil))
      // drop current digit from open subset
      let open_subset_of_digits =
        open_subset_of_digits
        |> set.drop([digit])
      let assigned_digits = [digit, ..assigned_digits]
      find_permutation_of_digit_set(
        open_subset_of_digits,
        validate,
        letters_in_equation,
        first_letters,
        assigned_digits,
      )
    }
  }
}

fn list_get(used_letter_list: List(a), int: Int) -> Result(a, Nil) {
  case used_letter_list, int {
    [value, ..], 0 -> Ok(value)
    [_, ..rest], a if a > 0 -> list_get(rest, int - 1)
    [], _ -> Error(Nil)
    [_, ..], _ -> Error(Nil)
  }
}
