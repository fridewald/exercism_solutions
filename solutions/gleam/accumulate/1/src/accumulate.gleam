pub fn accumulate(list: List(a), fun: fn(a) -> b) -> List(b) {
  case list {
    [] -> []
    [a] -> [fun(a)]
    [a, ..rest] -> [fun(a), ..accumulate(rest, fun)]
  }
}
