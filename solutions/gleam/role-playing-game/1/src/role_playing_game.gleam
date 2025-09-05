import gleam/option.{type Option, Some, None}
import gleam/int

pub type Player {
  Player(name: Option(String), level: Int, health: Int, mana: Option(Int))
}

pub fn introduce(player: Player) -> String {
  option.unwrap(player.name, "Mighty Magician")
}

pub fn revive(player: Player) -> Option(Player) {
  case player {
    Player(_, level, 0, _) if level >= 10 -> Some(Player(..player, health: 100, mana: Some(100)))
    Player(_, _, 0, _)  -> Some(Player(..player, health: 100))
    _ -> None
  }
}

pub fn cast_spell(player: Player, cost: Int) -> #(Player, Int) {
  let demage = 2 * cost
  case player {
    Player(mana: None, ..) -> #(Player(..player, health: int.max(0, player.health - cost)), 0)
    Player(mana: Some(mana), ..) if mana < cost-> #(player, 0)
    Player(mana: Some(mana), ..) -> #(Player(..player, mana: Some(mana - cost)), demage)
  }
}
