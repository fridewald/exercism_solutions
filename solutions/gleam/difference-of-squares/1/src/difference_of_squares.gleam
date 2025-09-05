pub fn square_of_sum(n: Int) -> Int {
  let sum =  {{ n + 1 } * n / 2 }
  sum * sum
}

pub fn sum_of_squares(n: Int) -> Int {
  case n {
    1 -> 1
    n -> sum_of_squares(n - 1) + n * n
  }
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) - sum_of_squares(n)
}
