import gleam/int
import gleam/list

pub fn scores(high_scores: List(Int)) -> List(Int) {
  high_scores
}

pub fn latest(high_scores: List(Int)) -> Result(Int, Nil) {
  list.last(high_scores)
}

pub fn personal_best(high_scores: List(Int)) -> Result(Int, Nil) {
  list.max(high_scores, int.compare)
}

pub fn personal_top_three(high_scores: List(Int)) -> List(Int) {
  list.sort(high_scores, int.compare)
  |> list.reverse
  |> list.take(3)
}
