import gleam/list
import gleam/string

pub fn proteins(rna: String) -> Result(List(String), Nil) {
  string.to_graphemes(rna)
  |> list.sized_chunk(3)
  |> list.map(string.join(_, ""))
  |> list.take_while(fn(x) { !stop_codon(x) })
  |> list.try_map(protein_to_acid)
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
    _ -> Error(Nil)
  }
}

fn stop_codon(x) {
  case x {
    "UAA" | "UAG" | "UGA" -> True
    _ -> False
  }
}
