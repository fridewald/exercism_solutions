import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result

pub type Tree(a) {
  Tree(label: a, children: List(Tree(a)))
}

type Stepper(a) {
  Stepper(
    label: a,
    focus: Option(Tree(a)),
    left: List(Tree(a)),
    right: List(Tree(a)),
    parent: Option(Stepper(a)),
  )
}

fn init_stepper_from_tree(tree: Tree(a)) {
  case tree.children {
    [] ->
      Stepper(label: tree.label, focus: None, left: [], right: [], parent: None)
    right ->
      Stepper(label: tree.label, focus: None, left: [], right:, parent: None)
  }
}

fn build_stepper_from_tree(tree: Tree(a), parent: Stepper(a)) {
  Stepper(..init_stepper_from_tree(tree), parent: Some(parent))
}

/// Build a tree starting from the current stepper
/// the current focus tree will be ignored when building the tree
fn build_tree_from_stepper(stepper: Stepper(a)) {
  case stepper {
    Stepper(label:, left:, right:, parent: None, ..) ->
      Tree(label:, children: list.flatten([left, right]))
    Stepper(label:, left:, right:, parent: Some(parent), ..) ->
      Tree(
        label:,
        children: list.flatten([
          [build_tree_from_stepper(parent)],
          left,
          right,
        ]),
      )
  }
}

pub fn from_pov(tree: Tree(a), from: a) -> Result(Tree(a), Nil) {
  tree
  |> init_stepper_from_tree
  |> find_node(from)
  |> result.map(build_tree_from_stepper)
}

fn find_node(stepper: Stepper(a), node: a) -> Result(Stepper(a), Nil) {
  case stepper {
    // base case 0
    Stepper(label:, ..) if label == node -> Ok(stepper)
    // base case 1
    Stepper(focus: Some(focus), ..) if focus.label == node ->
      Ok(build_stepper_from_tree(focus, stepper))
    // focus stepper on first right child
    Stepper(focus: None, right: [next_child, ..right], ..) ->
      find_node(Stepper(..stepper, focus: Some(next_child), right:), node)
    // stepping down and right
    Stepper(focus: Some(focus), left:, right: [next_child, ..right], ..) -> {
      let step_down = build_stepper_from_tree(focus, stepper)
      // going on step down
      find_node(step_down, node)
      |> result.lazy_or(fn() {
        // going on step right
        find_node(
          Stepper(
            ..stepper,
            focus: Some(next_child),
            left: [focus, ..left],
            right:,
          ),
          node,
        )
      })
    }
    // stepping down
    Stepper(focus: Some(focus), right: [], ..) -> {
      let step_down = build_stepper_from_tree(focus, stepper)
      // going on step down
      find_node(step_down, node)
    }
    // bad case
    Stepper(right: [], ..) -> Error(Nil)
  }
}

pub fn path_to(
  tree tree: Tree(a),
  from from: a,
  to to: a,
) -> Result(List(a), Nil) {
  from_pov(tree, from)
  |> result.then(find_down_path(_, to))
}

fn find_down_path(tree: Tree(a), to: a) {
  case tree {
    Tree(label:, ..) if label == to -> Ok([label])
    Tree(children: [], ..) -> Error(Nil)
    Tree(label:, children: [child, ..rest]) ->
      find_down_path(child, to)
      // found child
      |> result.map(fn(path) { [label, ..path] })
      // try next child
      |> result.lazy_or(fn() {
        find_down_path(Tree(..tree, children: rest), to)
      })
  }
}
