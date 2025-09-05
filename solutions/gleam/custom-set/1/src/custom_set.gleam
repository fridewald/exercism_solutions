import gleam/dict
import gleam/list
import gleam/result

pub opaque type Set(t) {
  Set(set: dict.Dict(t, Nil))
}

pub fn new(members: List(t)) -> Set(t) {
  Set(
    set: list.unique(members)
    |> list.map(fn(x) { #(x, Nil) })
    |> dict.from_list(),
  )
}

pub fn is_empty(set: Set(t)) -> Bool {
  is_equal(set, new([]))
}

pub fn contains(in set: Set(t), this member: t) -> Bool {
  dict.get(set.set, member) |> result.is_ok
}

pub fn is_subset(first: Set(t), of second: Set(t)) -> Bool {
  first.set
  |> dict.to_list()
  |> list.all(fn(x) { contains(second, x.0) })
}

pub fn disjoint(first: Set(t), second: Set(t)) -> Bool {
  intersection(first, second) |> is_empty
}

pub fn is_equal(first: Set(t), to second: Set(t)) -> Bool {
  first == second
}

pub fn add(to set: Set(t), this member: t) -> Set(t) {
  dict.insert(set.set, member, Nil)
  |> Set
}

pub fn intersection(of first: Set(t), and second: Set(t)) -> Set(t) {
  first.set
  |> dict.filter(fn(key, _) { dict.has_key(second.set, key) })
  |> Set
}

pub fn difference(between first: Set(t), and second: Set(t)) -> Set(t) {
  first.set
  |> dict.drop(second.set |> dict.keys())
  |> Set
}

pub fn union(of first: Set(t), and second: Set(t)) -> Set(t) {
  dict.combine(first.set, second.set, fn(_, _) { Nil })
  |> Set
}
