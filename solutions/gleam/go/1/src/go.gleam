import gleam/result

pub type Player {
  Black
  White
}

pub type Game {
  Game(
    white_captured_stones: Int,
    black_captured_stones: Int,
    player: Player,
    error: String,
  )
}

pub fn apply_rules(
  game: Game,
  rule1: fn(Game) -> Result(Game, String),
  rule2: fn(Game) -> Game,
  rule3: fn(Game) -> Result(Game, String),
  rule4: fn(Game) -> Result(Game, String),
) -> Game {
  game
  |> rule1
  |> result.map(rule2)
  |> result.try(rule3)
  |> result.try(rule4)
  |> result.map(fn(game) { Game(..game, player: switch_player(game.player)) })
  |> result.try_recover(fn(error) { Ok(Game(..game, error: error)) })
  |> result.unwrap(game)
}

fn switch_player(player: Player) -> Player {
  case player {
    Black -> White
    White -> Black
  }
}
