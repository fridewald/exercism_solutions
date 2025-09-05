pub type Robot {
  Robot(direction: Direction, position: Position)
}

pub type Direction {
  North
  East
  South
  West
}

pub type Position {
  Position(x: Int, y: Int)
}

pub fn create(direction: Direction, position: Position) -> Robot {
  Robot(direction, position)
}

pub fn move(
  direction: Direction,
  position: Position,
  instructions: String,
) -> Robot {
  case instructions {
    "R" <> rest -> move(turn_right(direction), position, rest)
    "L" <> rest -> move(turn_left(direction), position, rest)
    "A" <> rest -> move(direction, advance(direction, position), rest)
    _ -> Robot(direction, position)
  }
}

fn advance(direction: Direction, position: Position) -> Position {
  case direction {
    North -> Position(x: position.x, y: position.y + 1)
    East -> Position(x: position.x + 1, y: position.y)
    South -> Position(x: position.x, y: position.y - 1)
    West -> Position(x: position.x - 1, y: position.y)
  }
}

fn turn_right(direction: Direction) -> Direction {
  case direction {
    North -> East
    East -> South
    South -> West
    West -> North
  }
}

fn turn_left(direction: Direction) -> Direction {
  case direction {
    North -> West
    East -> North
    South -> East
    West -> South
  }
}
