import gleam/string

pub opaque type TreasureChest(treasure) {
  TreasureChest(password: String, treasuer: treasure)
}

pub fn create(
  password: String,
  contents: treasure,
) -> Result(TreasureChest(treasure), String) {
  case string.length(password) {
    x if x < 8 -> Error("Password must be at least 8 characters long")
    _ -> Ok(TreasureChest(password, contents))
  }
}

pub fn open(
  chest: TreasureChest(treasure),
  password: String,
) -> Result(treasure, String) {
  case chest {
    TreasureChest(pass, treasure) if pass == password -> Ok(treasure)
    _ -> Error("Incorrect password")
  }
}
