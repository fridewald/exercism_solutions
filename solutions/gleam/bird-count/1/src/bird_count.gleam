pub fn today(days: List(Int)) -> Int {
  case days {
    [] -> 0
    [today, ..] -> today
  }
}

pub fn increment_day_count(days: List(Int)) -> List(Int) {
  case days {
    [] -> [1]
    [today, ..rest] -> [today + 1, ..rest]
  }
}

pub fn has_day_without_birds(days: List(Int)) -> Bool {
  case days {
    [today, ..rest] -> today == 0 || has_day_without_birds(rest)
    _ -> False
  }
}

pub fn total(days: List(Int)) -> Int {
  case days {
    [today, ..rest] -> today + total(rest)
    [] -> 0
  }
}

pub fn busy_days(days: List(Int)) -> Int {
  let int_busy_day = fn(count) {
    case count {
      x if x >= 5 -> 1
      _ -> 0
    }
  }
  case days {
    [today, ..rest] -> busy_days(rest) + int_busy_day(today)
    [] -> 0
  }
}
