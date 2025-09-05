import gleam/list
import gleam/result

pub fn rows(n: Int) -> List(List(Int)) {
  let first_row = list.repeat(0, times: n)
  let res = do_rows(n, [[1, ..first_row]])
  result.unwrap(res, [])
}

fn do_rows(n: Int, rows: List(List(Int))) -> Result(List(List(Int)), Nil) {
  case n {
    0 -> Ok([])
    1 -> {
      rows
      |> list.map(list.filter(_, fn(x) { x != 0 }))
      |> list.reverse()
      |> Ok
    }
    _ -> {
      use last_row <- result.try(list.first(rows))
      let adding = [0, ..last_row]

      do_rows(n - 1, [
        list.zip(last_row, adding)
          |> list.map(fn(x) { x.0 + x.1 }),
        ..rows
      ])
    }
  }
}
