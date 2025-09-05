import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/order
import gleam/string

pub type Result {
  Win
  Loss
  Draw
}

pub type GameResults {
  GameResults(n_games: Int, win: Int, draw: Int, loss: Int, points: Int)
}

pub fn tally(input: String) -> String {
  parse(input)
  |> list.fold(dict.new(), fn(acc, game) {
    let #(team1, team2, result) = game
    let #(team1_res, team2_res) = case result {
      Win -> #(Win, Loss)
      Draw -> #(Draw, Draw)
      Loss -> #(Loss, Win)
    }
    acc
    |> dict.upsert(team1, upsert_game_results(team1_res))
    |> dict.upsert(team2, upsert_game_results(team2_res))
  })
  |> format
}

fn parse(input: String) {
  input
  |> string.split("\n")
  |> list.filter_map(fn(x) {
    case string.split(x, ";") {
      [team1, team2, "win"] -> #(team1, team2, Win) |> Ok
      [team1, team2, "draw"] -> #(team1, team2, Draw) |> Ok
      [team1, team2, "loss"] -> #(team1, team2, Loss) |> Ok
      _ -> Error(Nil)
    }
  })
}

fn upsert_game_results(team_res) {
  fn(x) {
    case x {
      None -> {
        init_game_result(team_res)
      }
      Some(cur_game_result) -> {
        update_game_result(cur_game_result, team_res)
      }
    }
  }
}

fn update_game_result(game_results: GameResults, result: Result) -> GameResults {
  case result {
    Win ->
      GameResults(
        ..game_results,
        n_games: game_results.n_games + 1,
        win: game_results.win + 1,
        points: game_results.points + 3,
      )
    Draw ->
      GameResults(
        ..game_results,
        n_games: game_results.n_games + 1,
        draw: game_results.draw + 1,
        points: game_results.points + 1,
      )
    Loss ->
      GameResults(
        ..game_results,
        n_games: game_results.n_games + 1,
        loss: game_results.loss + 1,
      )
  }
}

fn init_game_result(result: Result) -> GameResults {
  GameResults(n_games: 0, win: 0, loss: 0, draw: 0, points: 0)
  |> update_game_result(result)
}

fn format(team_results: Dict(String, GameResults)) -> String {
  let formatted_team_results =
    dict.to_list(team_results)
    |> list.sort(game_order)
    |> list.map(format_team_result)

  [
    "Team                           | MP |  W |  D |  L |  P",
    ..formatted_team_results
  ]
  |> string.join("\n")
}

fn format_team_result(value: #(String, GameResults)) -> String {
  let GameResults(win:, loss:, draw:, points:, n_games:) = value.1
  let win = int.to_string(win)
  let loss = int.to_string(loss)
  let draw = int.to_string(draw)
  let points = int.to_string(points)
  let n_games = int.to_string(n_games)
  string.pad_right(value.0, 31, " ")
  <> "| "
  <> string.pad_left(n_games, 2, " ")
  <> " | "
  <> string.pad_left(win, 2, " ")
  <> " | "
  <> string.pad_left(draw, 2, " ")
  <> " | "
  <> string.pad_left(loss, 2, " ")
  <> " | "
  <> string.pad_left(points, 2, " ")
}

fn game_order(
  team_1_result: #(String, GameResults),
  team_2_result: #(String, GameResults),
) -> order.Order {
  case int.compare({ team_2_result.1 }.points, { team_1_result.1 }.points) {
    order.Eq -> string.compare(team_1_result.0, team_2_result.0)
    _ as ordered -> ordered
  }
}
