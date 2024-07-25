import card/card
import player/player

type Card =
  card.Card

type Player =
  player.Player

pub type GameField {
  GameField(p1: Player, p2: Player, vcard: Card)
}
