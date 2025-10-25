import gleam/bool
import gleam/dict
import gleam/float
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/result

type Books {
  Books(one: Int, two: Int, three: Int, four: Int, five: Int)
}

pub fn lowest_price(books: List(Int)) -> Float {
  let books = fill_book_type_count(books)
  let book_reduction_groups =
    greedy_fill_book_reduction_groups(books)
    |> rearrange_greedy_filled_reduction_groups
  get_reduced_price_in_cents(book_reduction_groups)
}

/// First we can just try to make the biggest possible groups.
/// Then we can rearrange 53 -> 44. That should be the only possible impromvement, bc the step 2 -> 3 is 5% and 4 -> 5 is 5% but 3 -> 4 is 10%.
/// So it is better to have two 4s (20 + 20 = 40 reduction) instead of 53 (10 + 25 = 35)
fn rearrange_greedy_filled_reduction_groups(
  reduction_group: dict.Dict(Int, Int),
) -> dict.Dict(Int, Int) {
  case dict.get(reduction_group, 5), dict.get(reduction_group, 3) {
    Ok(fives), Ok(threes) if fives > 0 && threes > 0 -> {
      let n_rearrangements = int.min(fives, threes)
      let new_four =
        dict.get(reduction_group, 4)
        |> result.unwrap(0)
        |> int.add(2 * n_rearrangements)
      dict.insert(reduction_group, 4, new_four)
      |> dict.insert(5, fives - n_rearrangements)
      |> dict.insert(3, threes - n_rearrangements)
    }
    _, _ -> reduction_group
  }
  // }
}

fn get_reduced_price_in_cents(
  book_reduction_groups: dict.Dict(Int, Int),
) -> Float {
  dict.map_values(book_reduction_groups, fn(group_size, n_groups) {
    int.to_float(n_groups) *. get_group_price_in_cents(group_size)
  })
  |> dict.values
  |> list.fold(0.0, float.add)
}

fn get_group_price_in_cents(group_size: Int) -> Float {
  case group_size {
    5 -> 0.75
    4 -> 0.8
    3 -> 0.9
    2 -> 0.95
    _ -> 1.0
  }
  *. int.to_float(group_size)
  *. 8.0
  *. 100.0
}

fn increment(x) {
  case x {
    Some(i) -> i + 1
    None -> 0
  }
}

fn greedy_fill_book_reduction_groups(books: Books) {
  let book_groups =
    dict.from_list([#(0, 0), #(1, 0), #(2, 0), #(3, 0), #(4, 0), #(5, 0)])
  do_greedy_fill_result(books, book_groups)
}

fn do_greedy_fill_result(
  books: Books,
  book_reduction_groups: dict.Dict(Int, Int),
) {
  use <- bool.guard(books == Books(0, 0, 0, 0, 0), book_reduction_groups)
  let n_diff_books = get_number_different_book_types(books)
  let book_reduction_groups =
    dict.upsert(book_reduction_groups, n_diff_books, increment)
  let books = reduce_books(books)
  do_greedy_fill_result(books, book_reduction_groups)
}

fn reduce_books(books: Books) -> Books {
  let Books(one:, two:, three:, four:, five:) = books
  Books(
    one: one - one / one,
    two: two - two / two,
    three: three - three / three,
    four: four - four / four,
    five: five - five / five,
  )
}

fn get_number_different_book_types(books: Books) -> Int {
  let Books(one:, two:, three:, four:, five:) = books
  one / one + two / two + three / three + four / four + five / five
}

fn fill_book_type_count(books: List(Int)) {
  list.fold(
    over: books,
    from: Books(one: 0, two: 0, three: 0, four: 0, five: 0),
    with: reduce_book_to_type_count,
  )
}

fn reduce_book_to_type_count(books_type_count: Books, book_input: Int) {
  case book_input {
    1 -> Books(..books_type_count, one: books_type_count.one + 1)
    2 -> Books(..books_type_count, two: books_type_count.two + 1)
    3 -> Books(..books_type_count, three: books_type_count.three + 1)
    4 -> Books(..books_type_count, four: books_type_count.four + 1)
    5 -> Books(..books_type_count, five: books_type_count.five + 1)
    _ -> books_type_count
  }
}
