pub type GbTree(key, value)

@external(erlang, "gb_trees", "empty")
fn empty() -> GbTree(k, v)

@external(erlang, "gb_trees", "insert")
fn do_insert(key: k, value: v, tree: GbTree(k, v)) -> GbTree(k, v)

@external(erlang, "gb_trees", "delete_any")
fn do_delete(key: k, tree: GbTree(k, v)) -> GbTree(k, v)

pub fn new_gb_tree() -> GbTree(k, v) {
  empty()
}

pub fn insert(tree: GbTree(k, v), key: k, value: v) -> GbTree(k, v) {
  do_insert(key, value, tree)
}

pub fn delete(tree: GbTree(k, v), key: k) -> GbTree(k, v) {
  do_delete(key, tree)
}
