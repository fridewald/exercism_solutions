import gleam/int
import gleam/list
import gleam/set

pub fn sum(factors factors: List(Int), limit limit: Int) -> Int {
  factors
  |> list.map(multiplies(_, limit))
  |> list.fold(set.new(), with: fn(multi, factors) {
    set.union(multi, set.from_list(factors))
  })
  |> set.to_list
  |> int.sum
}

fn multiplies(factor: Int, limit: Int) -> List(Int) {
  let times = limit / factor + 1
  list.range(1, times)
  |> list.map(int.multiply(_, factor))
  |> list.filter(fn(x) { x < limit })
}
