pub fn append(first first: List(a), second second: List(a)) -> List(a) {
  case first {
    [] -> second
    [head] -> [head, ..second]
    tail -> do_append(second, reverse(tail))
  }
}

fn do_append(appended, reversed_rest) {
  case reversed_rest {
    [] -> appended
    [last_element, ..rest] -> do_append([last_element, ..appended], rest)
  }
}

// TODO: tail recursive
pub fn concat(lists: List(List(a))) -> List(a) {
  case lists {
    [] -> []
    [head, ..tail] -> append(head, concat(tail))
  }
}

pub fn filter(list: List(a), function: fn(a) -> Bool) -> List(a) {
  case list {
    [] -> []
    [head, ..tail] ->
      case function(head) {
        True -> [head, ..filter(tail, function)]
        False -> filter(tail, function)
      }
  }
}

pub fn length(list: List(a)) -> Int {
  case list {
    [] -> 0
    [_, ..tail] -> 1 + length(tail)
  }
}

// TODO: tail recursive
pub fn map(list: List(a), function: fn(a) -> b) -> List(b) {
  case list {
    [] -> []
    [head, ..tail] -> [function(head), ..map(tail, function)]
  }
}

pub fn foldl(
  over list: List(a),
  from initial: b,
  with function: fn(b, a) -> b,
) -> b {
  case list {
    [] -> initial
    [a, ..tail] -> foldl(tail, function(initial, a), function)
  }
}

pub fn foldr(
  over list: List(a),
  from initial: b,
  with function: fn(b, a) -> b,
) -> b {
  case reverse(list) {
    [] -> initial
    [a, ..tail] -> foldl(tail, function(initial, a), function)
  }
}

pub fn reverse(list: List(a)) -> List(a) {
  case list {
    [] -> []
    [a, ..tail] -> do_reverse([a], tail)
  }
}

fn do_reverse(reversed: List(a), tail: List(a)) -> List(a) {
  case tail {
    [] -> reversed
    [a] -> [a, ..reversed]
    [a, ..this_tail] -> do_reverse([a, ..reversed], this_tail)
  }
}
