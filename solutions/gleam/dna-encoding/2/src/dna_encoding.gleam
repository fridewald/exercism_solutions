import gleam/list
import gleam/result

pub type Nucleotide {
  Adenine
  Cytosine
  Guanine
  Thymine
}

pub fn encode_nucleotide(nucleotide: Nucleotide) -> Int {
  case nucleotide {
    Adenine -> 0
    Cytosine -> 1
    Guanine -> 2
    Thymine -> 3
  }
}

pub fn decode_nucleotide(nucleotide: Int) -> Result(Nucleotide, Nil) {
  case nucleotide {
    0 -> Ok(Adenine)
    1 -> Ok(Cytosine)
    2 -> Ok(Guanine)
    3 -> Ok(Thymine)
    _ -> Error(Nil)
  }
}

pub fn encode(dna: List(Nucleotide)) -> BitArray {
  list.fold(over: dna, from: <<>>, with: fn(barray, nucleotide) {
    <<barray:bits, encode_nucleotide(nucleotide):2>>
  })
}

pub fn decode(dna: BitArray) -> Result(List(Nucleotide), Nil) {
  use int_list <- result.try(bit_array_to_list(dna, Ok([])))
  use element <- list.try_map(int_list)
  decode_nucleotide(element)
}

fn bit_array_to_list(
  dna: BitArray,
  res_list: Result(List(Int), Nil),
) -> Result(List(Int), Nil) {
  use int_list <- result.try(res_list)
  case dna {
    <<value:2, rest:bits>> -> bit_array_to_list(rest, Ok([value, ..int_list]))
    <<value:2>> -> Ok([value, ..int_list])
    <<>> -> res_list
    _ -> Error(Nil)
  }
  |> result.map(list.reverse)
}
