import gleam/int
import gleam/list
import gleam/result

// Please define the Usd type
pub type Usd

// Please define the Eur type
pub type Eur

// Please define the Jpy type
pub type Jpy

// Please define the Money type
pub opaque type Money(currency) {
  Money(value: Int)
}

pub fn dollar(amount: Int) -> Money(Usd) {
  Money(amount)
}

pub fn euro(amount: Int) -> Money(Eur) {
  Money(amount)
}

pub fn yen(amount: Int) -> Money(Jpy) {
  Money(amount)
}

pub fn total(prices: List(Money(currency))) -> Money(currency) {
  list.reduce(prices, fn(a, b) { Money(a.value + b.value) })
  |> result.unwrap(Money(0))
}
