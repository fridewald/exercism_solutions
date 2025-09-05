// TODO: please define the Pizza custom type
pub type Pizza {
  Margherita
  Caprese
  Formaggio
  ExtraSauce(Pizza)
  ExtraToppings(Pizza)
}

pub fn pizza_price(pizza: Pizza) -> Int {
  pizza_price_acc(pizza, 0)
}

fn pizza_price_acc(pizza: Pizza, acc: Int) -> Int {
  case pizza {
    Margherita -> 7 + acc
    Caprese -> 9 + acc
    Formaggio -> 10 + acc
    ExtraSauce(pizza_inside) -> pizza_price_acc(pizza_inside, acc + 1)
    ExtraToppings(pizza_inside) -> pizza_price_acc(pizza_inside, acc + 2)
  }
}

pub fn order_price(order: List(Pizza)) -> Int {
  case order {
    [] -> 0
    [pizza] -> pizza_price(pizza) + 3
    [pizza, pizza2] -> pizza_price(pizza) + pizza_price(pizza2) + 2
    [pizza, ..rest] -> order_price_acc(rest, pizza_price(pizza))
  }
}

fn order_price_acc(order: List(Pizza), acc: Int) -> Int {
  case order {
    [] -> acc
    [pizza, ..rest] -> order_price_acc(rest, acc + pizza_price(pizza))
  }
}
