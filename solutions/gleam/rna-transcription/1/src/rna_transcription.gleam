import gleam/list
import gleam/result
import gleam/string

pub fn to_rna(dna: String) -> Result(String, Nil) {
  string.to_graphemes(dna)
  |> list.try_map(fn(x) {
    case x {
      "G" -> Ok("C")
      "C" -> Ok("G")
      "T" -> Ok("A")
      "A" -> Ok("U")
      _ -> Error(Nil)
    }
  })
  |> result.map(string.join(_, ""))
}
