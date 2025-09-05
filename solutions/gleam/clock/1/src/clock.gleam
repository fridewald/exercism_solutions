import gleam/int

pub type Clock {
  Clock(minutes: Int)
}

fn mod(dividend: Int, divisor: Int){
    let remainder = dividend % divisor
    case remainder < 0 {
        True -> remainder + divisor
        False -> remainder
    }
}

fn normalize(clock: Clock){
  let minutes = mod(clock.minutes, 24 * 60)
  Clock(minutes)
}


pub fn create(hour hour: Int, minute minute: Int) -> Clock {
  Clock(hour * 60 + minute)
  |> normalize
}

pub fn add(clock: Clock, minutes minutes: Int) -> Clock {
  Clock(clock.minutes + minutes)
  |> normalize
}

pub fn subtract(clock: Clock, minutes minutes: Int) -> Clock {
  add(clock, -minutes)
}

pub fn display(clock: Clock) -> String {
  let hour_n = clock.minutes / 60
  let minute_n = clock.minutes % 60

  let hour = case hour_n < 10 {
    True -> "0" 
    False -> ""
  } <> int.to_string(hour_n)
  let minute = case minute_n < 10 {
    True -> "0" 
    False -> ""
  } <> int.to_string(minute_n)

  hour <> ":" <> minute
}
