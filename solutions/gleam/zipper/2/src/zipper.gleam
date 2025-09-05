import gleam/list

pub type Tree(a) {
  Leaf
  Node(value: a, left: Tree(a), right: Tree(a))
}

pub opaque type Zipper(a) {
  Zipper(sub_tree: Tree(a), focus: List(Step(a)))
}

pub opaque type Step(a) {
  Left(value: a, right: Tree(a))
  Right(value: a, left: Tree(a))
}

pub fn to_zipper(tree: Tree(a)) -> Zipper(a) {
  Zipper(sub_tree: tree, focus: [])
}

pub fn to_tree(zipper: Zipper(a)) -> Tree(a) {
  case up(zipper) {
    Error(_) -> zipper.sub_tree
    Ok(zipper) -> to_tree(zipper)
  }
}

pub fn value(zipper: Zipper(a)) -> Result(a, Nil) {
  case zipper.sub_tree {
    Leaf -> Error(Nil)
    Node(value:, ..) -> Ok(value)
  }
}

pub fn up(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper.focus {
    [] -> Error(Nil)
    [Left(value:, right:), ..focus] ->
      Ok(Zipper(sub_tree: Node(value:, right:, left: zipper.sub_tree), focus:))

    [Right(value:, left:), ..focus] ->
      Ok(Zipper(sub_tree: Node(value:, left:, right: zipper.sub_tree), focus:))
  }
}

pub fn left(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper.sub_tree {
    Leaf -> Error(Nil)
    Node(left:, value:, right:) ->
      Ok(Zipper(focus: [Left(value:, right:), ..zipper.focus], sub_tree: left))
  }
}

pub fn right(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper.sub_tree {
    Leaf -> Error(Nil)
    Node(left:, value:, right:) ->
      Ok(Zipper(focus: [Right(left:, value:), ..zipper.focus], sub_tree: right))
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
