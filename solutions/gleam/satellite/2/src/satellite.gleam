import gleam/bool
import gleam/list
import gleam/set

pub type Tree(a) {
  Nil
  Node(value: a, left: Tree(a), right: Tree(a))
}

pub type Error {
  DifferentLengths
  DifferentItems
  NonUniqueItems
}

pub fn tree_from_traversals(
  inorder inorder: List(a),
  preorder preorder: List(a),
) -> Result(Tree(a), Error) {
  use <- bool.guard(
    list.length(inorder) != list.length(preorder),
    Error(DifferentLengths),
  )
  use <- bool.guard(list.unique(inorder) != inorder, Error(NonUniqueItems))
  use <- bool.guard(
    set.from_list(inorder) != set.from_list(preorder),
    Error(DifferentItems),
  )
  do_tree_from_traversals(inorder, preorder)
  |> Ok
}

pub fn do_tree_from_traversals(
  inorder inorder: List(a),
  preorder preorder: List(a),
) -> Tree(a) {
  case preorder {
    [] -> Nil
    [root, ..rest_pre_order] -> {
      let left_in_order = list.take_while(inorder, fn(x) { x != root })
      let right_in_order =
        list.drop_while(inorder, fn(x) { x != root }) |> list.drop(1)
      let #(left_pre_order, right_pre_order) =
        list.split(rest_pre_order, list.length(left_in_order))
      let left_tree = do_tree_from_traversals(left_in_order, left_pre_order)
      let right_tree = do_tree_from_traversals(right_in_order, right_pre_order)
      Node(value: root, left: left_tree, right: right_tree)
    }
  }
}
