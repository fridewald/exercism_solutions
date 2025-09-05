import gleam/bool
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result

pub opaque type Frame {
  Strike(first: Int, next_roll: Option(Int), after_next_roll: Option(Int))
  Spare(first: Int, second: Int, next_roll: Option(Int))
  OpenFrame(first: Int, second: Int)
  OngoingFrame(first: Int)
}

pub type Game {
  Game(frames: List(Frame))
}

pub type Error {
  InvalidPinCount
  GameComplete
  GameNotComplete
}

// const empty_frame = Frame
pub fn roll(game: Game, knocked_pins: Int) -> Result(Game, Error) {
  let #(frame_before_roll, prev_frames) = case game.frames {
    [prev_frame, ..rest] -> #(prev_frame, rest)
    // maybe there is a better way
    [] -> #(OngoingFrame(0), [])
  }
  use <- bool.guard(
    knocked_pins > 10 && knocked_pins < 0,
    Error(InvalidPinCount),
  )
  let n_frames = game.frames |> list.length()
  case n_frames {
    0 ->
      case knocked_pins {
        10 -> Ok(Game([Strike(10, None, None)]))
        _ -> Ok(Game([OngoingFrame(knocked_pins)]))
      }
    10 -> roll_tenth_frame(frame_before_roll, prev_frames, knocked_pins)
    _ -> roll_before_tenth_frame(frame_before_roll, prev_frames, knocked_pins)
  }
}

fn roll_before_tenth_frame(
  frame_before_roll: Frame,
  prev_frames: List(Frame),
  knocked_pins: Int,
) -> Result(Game, Error) {
  use updated_frames <- result.try(case knocked_pins, frame_before_roll {
    // strike after strike
    10, Strike(_, _, _)
    | // strike after spare or open frame
      10,
      Spare(_, _, _)
    | 10, OpenFrame(_, _)
    -> Ok([Strike(10, None, None), frame_before_roll, ..prev_frames])
    // new ongoing frame after spare or open frame or strike
    pins, Spare(_, _, _) | pins, OpenFrame(_, _) | pins, Strike(10, _, _)
      if pins < 10
    -> Ok([OngoingFrame(pins), frame_before_roll, ..prev_frames])
    // spare or open frame
    pins, OngoingFrame(first) ->
      handle_ongoing_frame(pins, first)
      |> result.map(list.prepend(prev_frames, _))
    _, _ -> Error(InvalidPinCount)
  })
  Ok(Game(frames: updated_frames))
}

fn handle_ongoing_frame(pins, prev_roll) {
  case prev_roll + pins {
    10 -> Ok(Spare(prev_roll, pins, None))
    sum_pins if sum_pins < 10 -> Ok(OpenFrame(prev_roll, pins))
    _ -> Error(InvalidPinCount)
  }
}

fn roll_tenth_frame(
  tenth_frame: Frame,
  prev_frames: List(Frame),
  knocked_pins: Int,
) -> Result(Game, Error) {
  use updated_frame <- result.try(case tenth_frame {
    // strike
    Strike(10, None, None) ->
      Ok(Strike(10, next_roll: Some(knocked_pins), after_next_roll: None))
    Strike(10, Some(a), None) if a + knocked_pins > 10 && a != 10 ->
      Error(InvalidPinCount)
    Strike(10, Some(_) as first, None) ->
      // io.debug()
      Ok(Strike(10, first, after_next_roll: Some(knocked_pins)))
    // spare
    Spare(a, b, None) -> Ok(Spare(a, b, Some(knocked_pins)))
    OngoingFrame(prev_roll) -> handle_ongoing_frame(knocked_pins, prev_roll)
    _ -> Error(GameComplete)
  })

  Ok(Game(frames: [updated_frame, ..prev_frames]))
}

pub fn score(game: Game) -> Result(Int, Error) {
  use #(tenth_frame, rest) <- result.try(case game.frames {
    [ten, ..rest] -> Ok(#(ten, rest))
    [] -> Error(GameNotComplete)
  })
  use <- bool.guard(
    when: list.length(game.frames) < 10,
    return: Error(GameNotComplete),
  )
  let games_with_bonus = [
    tenth_frame,
    ..rest
    |> list.scan(
      from: tenth_frame,
      with: fn(following_frame: Frame, current_frame: Frame) {
        case current_frame {
          Spare(a, b, _) -> Spare(a, b, Some(following_frame.first))
          Strike(10, _, _) -> {
            case following_frame {
              Strike(_, b, _) -> Strike(10, Some(10), b)
              // should not happen
              OngoingFrame(_) -> panic
              Spare(first:, second:, next_roll: _) | OpenFrame(first:, second:) ->
                Strike(10, Some(first), Some(second))
            }
          }
          rest -> rest
        }
      },
    )
  ]
  games_with_bonus
  |> list.try_fold(0, fn(acc, frame: Frame) {
    case frame {
      Spare(a, b, Some(c)) -> Ok(acc + a + b + c)
      Strike(_, Some(a), Some(b)) -> Ok(acc + 10 + a + b)
      OpenFrame(a, b) -> Ok(acc + a + b)
      _ -> Error(GameNotComplete)
    }
  })
}
