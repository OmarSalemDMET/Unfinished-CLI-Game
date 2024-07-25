import card/card
import card/data
import gleam/list

//import gleam/float
//A type Annotation for easier readability
type Card =
  card.Card

///The Player Opaque type consists of three constructors 
///a Knight, a Rabbit, and an Archer
///each type has a perameters of its own
pub opaque type Player {
  Knight(
    name: String,
    stamina: Int,
    defense: Int,
    bonus: String,
    health: Int,
    hand: List(Card),
    my_turn: Bool,
  )
  Rabbit(
    name: String,
    stamina: Int,
    defense: Int,
    bonus: String,
    health: Int,
    hand: List(Card),
    my_turn: Bool,
  )
  Archer(
    name: String,
    stamina: Int,
    defense: Int,
    bonus: String,
    health: Int,
    hand: List(Card),
    my_turn: Bool,
  )
}

///This functions initializes a new Knight player,
///the user enters name, unless tha name has a value
///the function would return a knight player of name "Unknown"
pub fn new_knight(name: String, hand) -> Player {
  case name == "" {
    True -> Knight("Unknown", 100, 12, "def", 100, hand, False)
    False -> Knight(name, 100, 12, "def", 100, hand, False)
  }
}

///This functions initializes a new Rabbit player,
///the user enters name, unless tha name has a value
///the function would return a Rabbit player of name "Unknown"
pub fn new_rabbit(name: String, hand) -> Player {
  case name == "" {
    True -> Rabbit("Unknown", 120, 7, "sta", 100, hand, False)
    False -> Rabbit(name, 120, 7, "sta", 100, hand, False)
  }
}

///This functions initializes a new Archer player,
///the user enters name, unless tha name has a value
///the function would return a Archer player of name "Unknown"
pub fn new_archer(name: String, hand) -> Player {
  case name == "" {
    True -> Archer("Unknown", 90, 3, "def", 100, hand, False)
    False -> Archer(name, 90, 3, "def", 100, hand, False)
  }
}

///A recursive function that takes a list of a "mapped" tuple
///and an empty list "yield" to fill for the result, the yield 
///is filled from the topmost of the list.
pub fn get_hand(
  deck_data: List(card.Card),
  yield: List(card.Card),
  c: Int,
) -> List(card.Card) {
  case deck_data {
    [] -> []
    [h, ..t] ->
      case c {
        0 -> yield
        c -> {
          let crd = h
          let temp: List(card.Card) = [crd]
          get_hand(t, list.append(yield, temp), c - 1)
        }
      }
  }
}

///It adds "n" number of cards to the player,
///it returns the suitable plater constructor
///according to the player input paramter using
///pattern matching.
pub fn draw_a_card(p1: Player) -> Player {
  let deck = list.shuffle(data.main_card_deck)
  let new_hand = get_hand(deck, [], 4)
  let player = case p1 {
    Knight(name, stamina, defense, bonus, health, _, my_turn) ->
      Knight(
        name: name,
        stamina: stamina,
        defense: defense,
        bonus: bonus,
        health: health,
        hand: new_hand,
        my_turn: my_turn,
      )
    Rabbit(name, stamina, defense, bonus, health, _, my_turn) ->
      Rabbit(
        name: name,
        stamina: stamina,
        defense: defense,
        bonus: bonus,
        health: health,
        hand: new_hand,
        my_turn: my_turn,
      )
    Archer(name, stamina, defense, bonus, health, _, my_turn) ->
      Archer(
        name: name,
        stamina: stamina,
        defense: defense,
        bonus: bonus,
        health: health,
        hand: new_hand,
        my_turn: my_turn,
      )
  }

  player
}

///Get the list in the players Hand
///________________________________
pub fn get_hand_list(pl: Player) -> List(card.Card) {
  pl.hand
}

///{Stamina, Defence , bonus, health}
///__________________________________
pub fn get_player_data(pl: Player) -> #(Int, Int, String, Int) {
  #(pl.stamina, pl.defense, pl.bonus, pl.health)
}

///Checks if it is the player's turn
///_________________________________
pub fn get_player_turn(pl: Player) -> Bool {
  pl.my_turn
}

pub fn new_player(pl: Player, new_hand, n_health, n_sta, n_def) -> Player {
  let player = case pl {
    Knight(name, _, _, bonus, _, _, my_turn) ->
      Knight(
        name: name,
        stamina: n_sta,
        defense: n_def,
        bonus: bonus,
        health: n_health,
        hand: new_hand,
        my_turn: my_turn,
      )
    Rabbit(name, _, _, bonus, _, _, my_turn) ->
      Rabbit(
        name: name,
        stamina: n_sta,
        defense: n_def,
        bonus: bonus,
        health: n_health,
        hand: new_hand,
        my_turn: my_turn,
      )
    Archer(name, _, _, bonus, _, _, my_turn) ->
      Archer(
        name: name,
        stamina: n_sta,
        defense: n_def,
        bonus: bonus,
        health: n_health,
        hand: new_hand,
        my_turn: my_turn,
      )
  }

  player
}
