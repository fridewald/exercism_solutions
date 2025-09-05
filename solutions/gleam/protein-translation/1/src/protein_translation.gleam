import gleam/list
import gleam/result
import gleam/string

pub fn proteins(rna: String) -> Result(List(String), Nil) {
  let result_rna =
    string.to_graphemes(rna)
    |> list.sized_chunk(3)
    |> list.map(string.join(_, ""))
    |> list.take_while(fn(x) { !stop_condo(x) })
    |> list.try_map(protein_to_acid)

  use acid <- result.map(result_rna)
  list.take_while(acid, fn(x) { x != "STOP" })
}

fn protein_to_acid(rna: String) {
  case rna {
    "AUG" -> Ok("Methionine")
    "UUU" | "UUC" -> Ok("Phenylalanine")
    "UUA" | "UUG" -> Ok("Leucine")
    "UCU" | "UCC" | "UCA" | "UCG" -> Ok("Serine")
    "UAU" | "UAC" -> Ok("Tyrosine")
    "UGU" | "UGC" -> Ok("Cysteine")
    "UGG" -> Ok("Tryptophan")
    "UAA" | "UAG" | "UGA" -> Ok("STOP")
    _ -> Error(Nil)
  }
}

fn stop_condo(x) {
  case x {
    "UAA" | "UAG" | "UGA" -> True
    _ -> False
  }
}
