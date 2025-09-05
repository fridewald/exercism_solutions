import gleam/list
import gleam/set.{type Set}
import gleam/string

pub fn new_collection(card: String) -> Set(String) {
  set.from_list([card])
}

pub fn add_card(collection: Set(String), card: String) -> #(Bool, Set(String)) {
  #(set.contains(collection, card), set.insert(collection, card))
}

pub fn trade_card(
  my_card: String,
  their_card: String,
  collection: Set(String),
) -> #(Bool, Set(String)) {
  #(
    set.contains(collection, my_card) && !set.contains(collection, their_card),
    collection |> set.delete(my_card) |> set.insert(their_card),
  )
}

pub fn boring_cards(collections: List(Set(String))) -> List(String) {
  case collections {
    [] -> []
    [_] -> []
    [collection, ..] -> boring_cards_(collections, collection) |> set.to_list
  }
}

fn boring_cards_(
  collections: List(Set(String)),
  boring: Set(String),
) -> Set(String) {
  case collections {
    [] -> boring
    [collection] -> set.intersection(boring, collection)
    [collection, ..rest] ->
      boring_cards_(rest, set.intersection(collection, boring))
  }
}

pub fn total_cards(collections: List(Set(String))) -> Int {
  case collections {
    [] -> 0
    [collection] -> set.size(collection)
    [collection, ..rest] -> total_cards_set(rest, collection) |> set.size
  }
}

fn total_cards_set(
  collections: List(Set(String)),
  total: Set(String),
) -> Set(String) {
  case collections {
    [] -> set.new()
    [collection] -> set.union(collection, total)
    [collection, ..rest] -> total_cards_set(rest, set.union(collection, total))
  }
}

pub fn shiny_cards(collection: Set(String)) -> Set(String) {
  set.filter(collection, fn(card) { string.starts_with(card, "Shiny ") })
}
