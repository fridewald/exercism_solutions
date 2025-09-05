import gleam/dict
import gleam/list
import gleam/option.{None, Some}
import gleam/string

pub fn find_anagrams(word: String, candidates: List(String)) -> List(String) {
  let word_count_dict: dict.Dict(Int, Int) = character_dict(word)
  candidates
  |> list.filter(fn(can) {
    can |> string.lowercase() != word |> string.lowercase
  })
  |> list.filter(fn(can) {
    let can_dict = character_dict(can)
    can_dict == word_count_dict
  })
}

fn character_dict(word: String) {
  let increment = fn(x) {
    case x {
      Some(i) -> i + 1
      None -> 0
    }
  }
  word
  |> string.lowercase
  |> string.to_utf_codepoints
  |> list.map(string.utf_codepoint_to_int)
  |> list.fold(dict.new(), fn(word_dict, code_point) {
    dict.upsert(word_dict, code_point, increment)
  })
}
