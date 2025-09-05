import gleam/list

pub type Tree {
  Nil
  Node(data: Int, left: Tree, right: Tree)
}

pub fn to_tree(data: List(Int)) -> Tree {
  use tree, item <- list.fold(data, Nil)
  insert(tree, item)
}

fn new(data: Int) -> Tree {
  Node(data:, left: Nil, right: Nil)
}

fn insert(tree tree: Tree, data in_data: Int) -> Tree {
  case tree {
    Nil -> new(in_data)
    Node(data:, right:, ..) if in_data > data ->
      Node(..tree, right: insert(right, in_data))
    Node(left:, ..) -> Node(..tree, left: insert(left, in_data))
  }
}

pub fn sorted_data(data: List(Int)) -> List(Int) {
  let tree = to_tree(data)
  to_sorted_data(tree)
}

fn to_sorted_data(tree: Tree) -> List(Int) {
  case tree {
    Nil -> []
    Node(data:, left:, right:) -> {
      list.append(to_sorted_data(left), [data, ..to_sorted_data(right)])
    }
  }
}
