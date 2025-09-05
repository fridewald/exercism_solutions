import gleam/list

pub fn accumulate(list: List(a), fun: fn(a) -> b) -> List(b) {
  do_accumulate([], list.reverse(list), fun)
}

fn do_accumulate(done: List(b), list: List(a), fun: fn(a) -> b) -> List(b) {
  case list {
    [] -> done
    [a] -> [fun(a), ..done]
    [a, ..rest] -> do_accumulate([fun(a), ..done], rest, fun)
  }
}
