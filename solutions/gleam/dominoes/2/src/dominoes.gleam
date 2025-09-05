import gleam/list
import gleam/option.{None, Some}

pub fn can_chain(chain: List(#(Int, Int))) -> Bool {
  case chain {
    [] -> True
    [item, ..rest] -> do_can_chain(item.0, item.1, rest)
  }
}

fn do_can_chain(start: Int, end: Int, rest_chain: List(#(Int, Int))) -> Bool {
  case rest_chain {
    [] -> start == end
    _ -> {
      use #(o_item, rest) <- list.any(find_ends(rest_chain, start))
      case o_item {
        None -> False
        Some(item) -> do_can_chain(item.1, end, rest)
      }
    }
  }
}

fn find_ends(
  chain: List(#(a, a)),
  number: a,
) -> List(#(option.Option(#(a, a)), List(#(a, a)))) {
  do_find_end(chain, number, [], [])
}

fn do_find_end(uncheck_dominos, number, checked_dominios, list_of_matches) {
  case uncheck_dominos {
    [] -> list_of_matches
    [#(a, b) as item, ..rest] -> {
      let list_of_matches = case a, b {
        a, _ if a == number -> [
          #(Some(#(a, b)), list.flatten([checked_dominios, rest])),
          ..list_of_matches
        ]
        _, b if b == number -> [
          #(Some(#(b, a)), list.flatten([checked_dominios, rest])),
          ..list_of_matches
        ]
        _, _ -> list_of_matches
      }
      do_find_end(rest, number, [item, ..checked_dominios], list_of_matches)
    }
  }
}
