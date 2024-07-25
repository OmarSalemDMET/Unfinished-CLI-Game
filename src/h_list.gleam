import card/card
import gleam/list

fn g_list_elem_helper(
  lst: List(card.Card),
  index: Int,
  acc: Int,
  elem: card.Card,
) -> card.Card {
  case acc == index + 1 {
    True -> elem
    False ->
      case lst {
        [] -> elem
        [first, ..last] -> g_list_elem_helper(last, index, acc + 1, first)
      }
  }
}

///This Function returns a specific element in a List!
///__________________________________________________
pub fn glist(lst: List(card.Card), index) -> card.Card {
  let o: card.Card = card.Card("name", 12, 13, 10)
  g_list_elem_helper(lst, index, 0, o)
}

fn trim_index_h(
  lst: List(card.Card),
  card: card.Card,
  n_list: List(card.Card),
) -> List(card.Card) {
  case lst {
    [] -> list.reverse(n_list)
    [first, ..rest] ->
      case card == first {
        True -> trim_index_h(rest, card, n_list)
        False -> trim_index_h(rest, card, [first, ..n_list])
      }
  }
}

///It returns a new List of cards excluding a desired element
///
///Example :- 
///   ( \[ card1, card2, card3 \], card2 ) ------> \[card1, card3\]
///__________________________________________________________
pub fn exclude_elem(lst: List(card.Card), card: card.Card) -> List(card.Card) {
  trim_index_h(lst, card, [])
}
