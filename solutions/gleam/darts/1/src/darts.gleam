pub fn score(x: Float, y: Float) -> Int {
  case x *. x +. y *. y {
    r if r <=. 100.0 && r >. 25.0 -> 1
    r if r <=. 25.0 && r >. 1.0 -> 5
    r if r <=. 1.0 -> 10
    _ -> 0
  }
}
