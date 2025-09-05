pub fn keep(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  do_keep(list, predicate, [])
}

fn do_keep(list, predicate, result) {
  case list {
    [] -> reverse(result)
    [element, ..rest] -> {
      let result = case predicate(element) {
        True -> [element, ..result]
        False -> result
      }
      do_keep(rest, predicate, result)
    }
  }
}

fn reverse(list) {
  do_reverse(list, [])
}

fn do_reverse(list, result) {
  case list {
    [] -> result
    [element, ..rest] -> {
      let result = [element, ..result]
      do_reverse(rest, result)
    }
  }
}

pub fn discard(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  keep(list, fn(x) { !predicate(x) })
}
