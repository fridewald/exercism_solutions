import gleam/list
import gleam/option

pub fn can_chain(chain: List(#(Int, Int))) -> Bool {
  case chain {
    [] -> True
    [item, ..rest] -> do_can_chain(item.0, item.1, rest)
  }
}

fn do_can_chain(start: Int, end: Int, rest_chain: List(#(Int, Int))) {
  case rest_chain {
    [] -> start == end
    _ -> {
      use #(o_item, rest) <- list.any(find_end(rest_chain, start))
      case o_item {
        option.None -> False
        option.Some(item) -> do_can_chain(item.1, end, rest)
      }
    }
  }
}

fn find_end(chain, number) {
  do_find_end(chain, number, [], [])
}

fn do_find_end(chain, number, rest_count, res) {
  case chain {
    [] -> res
    [#(a, _) as item, ..rest] if a == number -> {
      do_find_end(rest, number, [item, ..rest_count], [
        #(option.Some(item), list.flatten([rest_count, rest])),
        ..res
      ])
    }
    [#(a, b) as item, ..rest] if b == number -> {
      do_find_end(rest, number, [item, ..rest_count], [
        #(option.Some(#(b, a)), list.flatten([rest_count, rest])),
        ..res
      ])
    }
    [item, ..rest] -> do_find_end(rest, number, [item, ..rest_count], res)
  }
}
