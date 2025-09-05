import gleam/list

pub fn keep(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  do_keep(list, predicate, [])
}

fn do_keep(list, predicate, result) {
  case list {
    [] -> list.reverse(result)
    [element, ..rest] -> {
      let result = case predicate(element) {
        True -> [element, ..result]
        False -> result
      }
      do_keep(rest, predicate, result)
    }
  }
}

pub fn discard(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  keep(list, fn(x) { !predicate(x) })
}
