import card/card
import card/data
import clir
import gary/array
import gleam/dict
import gleam/erlang
import gleam/int
import gleam/io
import gleam/list
import gleam/queue
import gleam/string
import gleam_community/ansi
import h_list
import player/player

///Welcome Screen Tesxt
const w_scrn: String = "*** Welcome To Cli Card Game in Gleam ***"

///A Welcome Screen Joke, It Speaks about how long is the name 
const w_helper: String = "---I know, the name is a mouthful---"

///Choose Your Character Text
const cyc: String = "🎮Choose Your Character>"

///Player Constructor List
const c_list: String = "1> Knight 
2> Rabbit 
3> Archer"

///PLayer Enter his name
const e_name = "🕹️Enter Your Player Name>"

///Begin Battle Tag 
const b_battle: String = "⚔️ ^^ Begin Battle ^^⚔️"

type Player =
  player.Player

type Card =
  card.Card

//remeber to make a software that makes a 3d image in the Termianl
fn get_player_type(rd: String) -> String {
  case rd {
    "1" -> "Knight"
    "2" -> "Rabbit"
    "3" -> "Archer"
    _ -> {
      let k =
        clir.read_line(ansi.hex(
          "Wrong Number
>",
          0x007F73,
        ))
      get_player_type(k)
    }
  }
}

fn get_player_name(rd: String) -> String {
  let length = string.length(rd)
  case length > 1 {
    True -> rd
    False ->
      get_player_name(ansi.hex(
        clir.read_line(ansi.hex(
          "The name should be of two or more characters
>",
          0x007F73,
        )),
        0x007F73,
      ))
  }
}

fn first_hand(
  deck: List(card.Card),
  acc: Int,
  hand: List(card.Card),
) -> List(card.Card) {
  case acc >= 4 {
    True -> list.reverse(hand)
    False ->
      case deck {
        [] -> hand
        [first, ..rest] -> first_hand(rest, acc + 1, [first, ..hand])
      }
  }
}

fn get_enemy() -> #(Player, String) {
  let rand: Int = int.random(3) + 1
  let opponent: String = "Opponent"
  let hand: List(card.Card) =
    first_hand(list.shuffle(data.main_card_deck), 0, [])
  case rand {
    1 -> #(player.new_knight(opponent, hand), "Knight")
    2 -> #(player.new_rabbit(opponent, hand), "Rabbit")
    3 -> #(player.new_archer(opponent, hand), "Archer")
    _ -> get_enemy()
  }
}

///The Start_up fucntion is representation for start Screen
///displayed to the user at start up, it is responsible for 
///initializing the player base on the users prefrence and 
///choose an opponent for the player
pub fn start_up() -> #(Player, String, Player) {
  let co1: Int = 0xFFC700
  //Yellow
  let co2: Int = 0xFFF455
  //Yellow_lighter
  let co3: Int = 0x007F73
  //Cyan_darker
  let co4: Int = 0x4CCD99
  //Cyan
  io.print(ansi.hex(w_scrn, co1))
  clir.read_line("")
  io.println("")
  io.print(ansi.hex(w_helper, co2))
  clir.read_line("")
  io.println("")
  io.println(ansi.hex(cyc, co3))
  io.println(ansi.hex(c_list, co4))
  let p_type: String = get_player_type(clir.read_line(ansi.hex(">", 0x007F73)))
  let token: String = case p_type {
    "Knight" -> "🛡️"
    "Rabbit" -> "🐰"
    "Archer" -> "🏹"
    _ -> "🛡️"
  }
  io.println(ansi.hex(e_name, co3))
  let p_name =
    string.capitalise(get_player_name(clir.read_line(ansi.hex(">", 0x007F73))))
  let deck = list.shuffle(data.main_card_deck)
  let p1_hand = first_hand(deck, 0, [])
  let p1: Player = case p_type {
    "Knight" -> {
      io.println(ansi.hex("Welcome Knight 🛡️" <> p_name, co3))
      player.new_knight(p_name, p1_hand)
    }
    "Rabbit" -> {
      io.println(ansi.hex("Welcome Rabbit 🐰" <> p_name, co3))
      player.new_rabbit(p_name, p1_hand)
    }
    "Archer" -> {
      io.println(ansi.hex("Welcome Archer 🏹 " <> p_name, co3))
      player.new_archer(p_name, p1_hand)
    }
    _ -> player.new_knight(p_name, p1_hand)
  }

  let #(opponent, oppo_type) = get_enemy()
  case oppo_type {
    "Knight" -> io.println(ansi.red("Your Opponent is Knight🛡️"))
    "Rabbit" -> io.println(ansi.red("Your Opponent is Rabbit🐰"))
    "Archer" -> io.println(ansi.red("Your Opponent is Archer🏹"))
    _ -> io.println("Shouldn't enter it")
  }
  io.println(ansi.hex("\n------- Ready?! -------\n", co2))
  io.println(ansi.hex("\n" <> b_battle <> "\n", co1))
  #(p1, token, opponent)
}

///Prints All the list given to it, the number(int) required 
///is for indexing the Items, the number given is the initial 
///indexing number.
///Example :-
///(\["Rabbit", "Cow", "Chicken", "bee"\], 1) -> 1.Rabbit 2.Cow 3.Chicken
///______________________________________________________________________
pub fn print_lst(hand: List(Card), acc: Int) -> Nil {
  case hand {
    [] -> Nil
    [first, ..last] -> {
      io.print(ansi.pink(int.to_string(acc) <> "> " <> first.name <> "  "))
      print_lst(last, acc + 1)
    }
  }
}

fn card_categ(crd: Card, acc: Int, categ: String) -> String {
  case acc {
    0 -> categ
    1 ->
      case crd.sta > 0 {
        True -> "Sta"
        False -> card_categ(crd, acc - 1, categ)
      }
    2 ->
      case crd.atk > 0 {
        True -> "atk"
        False -> card_categ(crd, acc - 1, categ)
      }
    3 ->
      case crd.def > 0 {
        True -> "def"
        False -> card_categ(crd, acc - 1, categ)
      }
    _ -> "Error"
  }
}

fn search_cards_loop(hand: List(Card), typ: String) -> Result(Card, String) {
  case hand {
    [] -> Error("Card Not Available")
    [first, ..rest] -> {
      let ctyp: String = card_categ(first, 3, "")
      case ctyp == typ {
        True -> Ok(first)
        False -> search_cards_loop(rest, typ)
      }
    }
  }
}

fn search_for_card_type(
  hand: List(Card),
  typ: List(String),
  err: String,
) -> Result(Card, String) {
  case typ {
    [] -> Error(err)
    [first, ..rest] -> {
      let res = search_cards_loop(hand, first)
      case res {
        Ok(i) -> Ok(i)
        Error(e) -> search_for_card_type(hand, rest, e)
      }
    }
  }
}

fn draw_a_card(deck: List(Card)) -> Card {
  let index_deck = list.index_map(deck, fn(a, b) { #(b, a) })
  let dict_deck = dict.from_list(index_deck)
  case dict.get(dict_deck, 0) {
    Ok(i) -> i
    Error(_) -> card.Card("UnKnown", 0, 0, 0)
  }
}

fn oppo_pir(oppo: Player, pl: Player) -> List(Bool) {
  let #(e_sta, e_def, _e_bn, e_health) = player.get_player_data(oppo)
  let #(_p_sta, _p_def, _p_bn, p_health) = player.get_player_data(pl)

  let hp_p: Bool = case e_health < 50 {
    True -> True
    False -> False
  }

  let def_p: Bool = case e_def <= 0 {
    True -> True
    False -> False
  }

  let atk_p: Bool = case p_health < 50 || p_health > 70 {
    True -> True
    False -> False
  }

  let sta_p: Bool = case e_sta <= 15 {
    True -> True
    False -> False
  }

  let que = queue.new()
  let card_q =
    queue.push_front(que, sta_p)
    |> queue.push_back(hp_p)
    |> queue.push_back(atk_p)
    |> queue.push_back(def_p)
    |> queue.to_list

  card_q
}

fn get_typ_str(acc: Int) -> String {
  case acc {
    0 -> "Sta"
    1 -> "def"
    2 -> "atk"
    _ -> "any"
    //if my math is correct, it shouldn't even approach it 
  }
}

fn fill_typ_queue_helper(
  q: List(Bool),
  res: List(String),
  acc: Int,
) -> List(String) {
  case q {
    [] -> list.reverse(res)
    [first, ..rest] -> {
      case first {
        True -> {
          let typ: String = get_typ_str(acc)
          fill_typ_queue_helper(rest, [typ, ..res], acc + 1)
        }
        False -> fill_typ_queue_helper(rest, res, acc + 1)
      }
    }
  }
}

fn fill_typ_queue(oppo: Player, player: Player) -> List(String) {
  let oppo_q = oppo_pir(oppo, player)
  let op_list = fill_typ_queue_helper(oppo_q, [], 0)
  op_list
}

fn oppo_turn(oppo: Player, pl: Player) -> #(Player, Player) {
  io.println(ansi.red("It's the opponent's Turn!"))
  let full_hand =
    list.append(player.get_hand_list(oppo), [
      draw_a_card(list.shuffle(data.main_card_deck)),
    ])
  let pir_list = fill_typ_queue(oppo, pl)
  let crd = search_for_card_type(full_hand, pir_list, "")
  case crd {
    Error(_) -> {
      io.println(ansi.red("The Opponent ends Turn"))
      #(oppo, pl)
    }
    Ok(i) -> {
      let #(o_sta, o_def, _, o_h) = player.get_player_data(oppo)
      let #(p_sta, p_def, _, p_hp) = player.get_player_data(pl)
      let oppo_new =
        player.new_player(oppo, full_hand, o_h, o_sta + i.sta, o_def + i.def)
      let pl_new =
        player.new_player(
          pl,
          player.get_hand_list(pl),
          p_hp - i.atk,
          p_sta + i.sta,
          p_def + i.def,
        )
      #(oppo_new, pl_new)
    }
  }
}

//this glist func needs to be edited to return a new list, where the hand is
//updated
pub fn pl_choose_a_card(
  hand: List(Card),
  value: String,
  token: String,
) -> #(Card, List(Card)) {
  case value {
    "1" -> {
      let crd = h_list.glist(hand, 0)
      let new_hand = h_list.exclude_elem(hand, crd)
      #(crd, new_hand)
    }
    "2" -> {
      let crd = h_list.glist(hand, 1)
      let new_hand = h_list.exclude_elem(hand, crd)
      #(crd, new_hand)
    }
    "3" -> {
      let crd = h_list.glist(hand, 2)
      let new_hand = h_list.exclude_elem(hand, crd)
      #(crd, new_hand)
    }
    "4" -> {
      let crd = h_list.glist(hand, 3)
      let new_hand = h_list.exclude_elem(hand, crd)
      #(crd, new_hand)
    }
    _ -> {
      io.println("")
      print_lst(hand, 1)
      io.println("")
      let pl_v = clir.read_line(ansi.hex(token <> "Choose a card > ", 0x007F73))
      pl_choose_a_card(hand, pl_v, token)
    }
  }
}

pub fn main() {
  let #(_player, _token, _opponent) =
    start_up()
    |> io.debug
  io.println("_______________________________________________ \n")
  let c_test: List(Card) = list.shuffle(data.main_card_deck)
  let card = pl_choose_a_card(c_test, "", "🛡️")
  let #(c, _) = card
  let name = c.name
  name
  |> string.append(" is an answer!")
  |> ansi.yellow
  |> io.println

  io.println(ansi.pink("Hello, World!"))
}
