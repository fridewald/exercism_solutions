import gleam/dict
import gleam/float
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/set
import gleam/string
import gleam/string_tree
import pocket_watch

const digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

fn apply_possible_solution(
  letter_cardi_map: dict.Dict(String, Int),
  sol: dict.Dict(String, Int),
) -> Int {
  // use <- pocket_watch.simple("apply_possible_solution")

  letter_cardi_map
  // |> echo
  |> dict.map_values(fn(key, values) {
    let sol_value =
      sol
      |> dict.get(key)
      |> result.unwrap(0)

    sol_value * values
  })
  // |> echo
  |> dict.values
  |> int.sum
  // let letter_string_tree = string_tree.from_string(letter_string)
  // let res_string =
  //   list.fold(
  //     dict.to_list(sol),
  //     letter_string_tree,
  //     fn(letter_string_tree, char_to_int_map) {
  //       string_tree.replace(
  //         letter_string_tree,
  //         each: char_to_int_map.0,
  //         with: char_to_int_map.1 |> int.to_string,
  //       )
  //     },
  //   )
  //   |> string_tree.to_string
  // int.parse(res_string) |> echo
  // int.parse("0001") |> echo
}

pub fn solve(puzzle: String) -> Result(dict.Dict(String, Int), Nil) {
  // echo puzzle
  use <- pocket_watch.simple("solve")
  use #(summands, sum) <- result.try(parse(puzzle) |> echo)
  // use #(summands, sum) <- result.try(parse(puzzle))
  // let summands_graphemes = list.map(summands, string.to_graphemes)
  // let sum_graphemes = string.to_graphemes(sum)
  let validate_base = validate(sum, summands)
  let used_letter_list =
    { summands |> dict.keys |> set.from_list }
    |> set.union(set.from_list(sum |> dict.keys))
    |> set.drop(["+"])
    |> set.to_list
    |> echo
  {
    let possible_subsets_of_digits =
      list.combinations(digits, used_letter_list |> list.length)
    use subset_of_digits <- list.find_map(possible_subsets_of_digits)
    use <- pocket_watch.simple("test_subset")
    // This seems slow. Do manual permutations
    find_permutation_of_digit_set(
      subset_of_digits |> set.from_list,
      validate_base,
      used_letter_list,
      [],
    )
  }
  // |> echo
}

fn find_permutation_of_digit_set(
  open_subset_of_digits: set.Set(Int),
  validate: fn(dict.Dict(String, Int)) -> Bool,
  used_letter_list: List(String),
  assigned_digits: List(Int),
) -> Result(dict.Dict(String, Int), Nil) {
  case open_subset_of_digits |> set.size {
    0 -> {
      let base = list.zip(used_letter_list, assigned_digits) |> dict.from_list
      case validate(base) {
        True -> Ok(base)
        False -> Error(Nil)
      }
    }
    _ -> {
      use digit <- list.find_map(open_subset_of_digits |> set.to_list)
      // drop current digit from subset
      let open_subset_of_digits =
        open_subset_of_digits
        |> set.drop([digit])
      find_permutation_of_digit_set(
        open_subset_of_digits,
        validate,
        used_letter_list,
        [digit, ..assigned_digits],
      )
    }
  }
}

fn validate(
  sum: dict.Dict(String, Int),
  summands: dict.Dict(String, Int),
) -> fn(dict.Dict(String, Int)) -> Bool {
  fn(sol) {
    // use <- pocket_watch.simple("validate")
    let sum_int = apply_possible_solution(sum, sol)
    // |> int.parse
    // |> result.unwrap(0)
    // let summands_string = apply_possible_solution(summands, sol)
    // |> string.split(on: "+")
    // case
    //
    let no_leading_zeros = True
    // list.all(summands_string, fn(x) {
    //   case x {
    //     "0" <> _ -> False
    //     _ -> True
    //   }
    // })
    // let summands_int =
    //   summands_string
    //   |> list.filter_map(int.parse)
    // |> result.unwrap(0)
    // |> int.sum
    let summands_int = apply_possible_solution(summands, sol)
    no_leading_zeros && sum_int == summands_int
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

fn parse(
  puzzle: String,
) -> Result(#(dict.Dict(String, Int), dict.Dict(String, Int)), Nil) {
  use <- pocket_watch.simple("parse")
  let split = case
    string.replace(puzzle, " ", "")
    |> string.split("==")
  {
    [summands, result] -> Ok(#(summands, result))
    _ -> Error(Nil)
  }

  use x <- result.map(split)
  let #(summands_string, res) = x
  let summands = string.split(summands_string, "+")
  let res_dict = count_char_card(res)

  let summands_dict =
    summands
    |> list.map(count_char_card)
    |> list.fold(dict.new(), fn(acc, x) {
      dict.combine(acc, x, fn(a, b) { a + b })
    })

  #(summands_dict, res_dict)
}

fn count_char_card(res: String) -> dict.Dict(String, Int) {
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
