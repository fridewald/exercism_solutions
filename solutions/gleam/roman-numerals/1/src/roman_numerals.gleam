pub fn convert(number: Int) -> String {
  case number {
    0 -> ""
    x if x < 4 -> "I" <> convert(x - 1)
    x if x == 4 -> "IV"
    x if x < 9 -> "V" <> convert(x - 5)
    x if x == 9 -> "IX"
    x if x < 40 -> "X" <> convert(x - 10)
    x if x < 50 -> "XL" <> convert(x - 40)
    x if x < 90 -> "L" <> convert(x - 50)
    x if x < 100 -> "XC" <> convert(x - 90)
    x if x < 400 -> "C" <> convert(x - 100)
    x if x < 500 -> "CD" <> convert(x - 400)
    x if x < 900 -> "D" <> convert(x - 500)
    x if x < 1000 -> "CM" <> convert(x - 900)
    x if x >= 1000 -> "M" <> convert(x - 1000)
    _ -> ""
  }
}
