///A Card Type that initializes a constructor
///each card has an atk value, or a def value or both
///where some cards would have both allow you to attack
///and gain defense points simultinuosly and others do
///others wouldn't allow but to either attack or defend
///every card with either an attack or defense would 
///consume stamina except cards that increase the player's
///stamina 
pub type Card {
  Card(name: String, atk: Int, def: Int, sta: Int)
}
