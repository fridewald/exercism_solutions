import gleam/list

pub type Tree(a) {
  Leaf
  Node(value: a, left: Tree(a), right: Tree(a))
}

pub opaque type Zipper(a) {
  Zipper(tree: Tree(a), focus: List(Step), sub_tree: Tree(a))
}

pub opaque type Step {
  Left
  Right
}

pub fn to_zipper(tree: Tree(a)) -> Zipper(a) {
  Zipper(tree:, focus: [], sub_tree: tree)
}

pub fn to_tree(zipper: Zipper(a)) -> Tree(a) {
  insert_sub_tree(zipper).tree
}

pub fn value(zipper: Zipper(a)) -> Result(a, Nil) {
  case zipper.sub_tree {
    Leaf -> Error(Nil)
    Node(value:, ..) -> Ok(value)
  }
}

fn insert_sub_tree(zipper: Zipper(a)) -> Zipper(a) {
  Zipper(
    ..zipper,
    tree: do_insert_sub_tree(
      zipper.tree,
      zipper.focus |> list.reverse,
      zipper.sub_tree,
    ),
  )
}

fn do_insert_sub_tree(tree: Tree(a), focus: List(Step), sub_tree: Tree(a)) {
  case focus, tree {
    [], _ -> sub_tree
    [Left, ..rest], Node(left:, ..) ->
      Node(..tree, left: do_insert_sub_tree(left, rest, sub_tree))
    [Right, ..rest], Node(right:, ..) ->
      Node(..tree, right: do_insert_sub_tree(right, rest, sub_tree))
    [_, ..], Leaf -> panic as "Focus list points to non existing node"
  }
}

fn get_node(zipper: Zipper(a)) -> Tree(a) {
  do_get_node(zipper.tree, list.reverse(zipper.focus))
}

fn do_get_node(tree: Tree(a), focus: List(Step)) -> Tree(a) {
  case tree, focus {
    _, [] -> tree
    Leaf, _ -> panic as "Focus list points to non existing node"
    Node(left:, ..), [Left, ..rest_focus] -> do_get_node(left, rest_focus)
    Node(right:, ..), [Right, ..rest_focus] -> do_get_node(right, rest_focus)
  }
}

pub fn up(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  let zipper = insert_sub_tree(zipper)
  case zipper.focus {
    [] -> Error(Nil)
    [_, ..focus] -> {
      let sub_tree = get_node(Zipper(..zipper, focus:))
      Ok(Zipper(..zipper, focus:, sub_tree:))
    }
  }
}

pub fn left(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  let zipper = insert_sub_tree(zipper)
  case zipper.sub_tree {
    Leaf -> Error(Nil)
    Node(left:, ..) ->
      Ok(Zipper(..zipper, focus: [Left, ..zipper.focus], sub_tree: left))
  }
}

pub fn right(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  let zipper = insert_sub_tree(zipper)
  case zipper.sub_tree {
    Leaf -> Error(Nil)
    Node(right:, ..) ->
      Ok(Zipper(..zipper, focus: [Right, ..zipper.focus], sub_tree: right))
  }
}

pub fn set_value(zipper: Zipper(a), value: a) -> Zipper(a) {
  case zipper.sub_tree {
    Leaf -> Zipper(..zipper, sub_tree: Node(value:, left: Leaf, right: Leaf))
    Node(..) as sub_tree -> Zipper(..zipper, sub_tree: Node(..sub_tree, value:))
  }
}

pub fn set_left(zipper: Zipper(a), tree: Tree(a)) -> Result(Zipper(a), Nil) {
  case zipper.sub_tree {
    Leaf -> Error(Nil)
    Node(..) as sub_tree ->
      Ok(Zipper(..zipper, sub_tree: Node(..sub_tree, left: tree)))
  }
}

pub fn set_right(zipper: Zipper(a), tree: Tree(a)) -> Result(Zipper(a), Nil) {
  case zipper.sub_tree {
    Leaf -> Error(Nil)
    Node(..) as sub_tree ->
      Ok(Zipper(..zipper, sub_tree: Node(..sub_tree, right: tree)))
  }
}
