import gleam/bool
import gleam/list
import gleam/result

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
  do_tree_from_traversals(inorder, preorder)
}

pub fn do_tree_from_traversals(
  inorder inorder: List(a),
  preorder preorder: List(a),
) -> Result(Tree(a), Error) {
  case preorder {
    [] -> Ok(Nil)
    [root, ..rest_pre_order] -> {
      let left_in_order = list.take_while(inorder, fn(x) { x != root })
      use <- bool.guard(left_in_order == inorder, Error(DifferentItems))
      let right_in_order =
        list.drop_while(inorder, fn(x) { x != root }) |> list.drop(1)
      let #(left_pre_order, right_pre_order) =
        list.split(rest_pre_order, list.length(left_in_order))
      use left_tree <- result.try(tree_from_traversals(
        left_in_order,
        left_pre_order,
      ))
      use right_tree <- result.try(tree_from_traversals(
        right_in_order,
        right_pre_order,
      ))
      Node(value: root, left: left_tree, right: right_tree)
      |> Ok
    }
  }
}
