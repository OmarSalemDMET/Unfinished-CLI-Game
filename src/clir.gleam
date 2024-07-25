import card/card
import gleam/dynamic
import gleam/result
import gleam/string

@external(erlang, "io", "get_line")
fn erl_read_line(prompt: String) -> dynamic.Dynamic

fn read_line_signal(prompt: String) -> Result(String, Nil) {
  erl_read_line(prompt)
  |> dynamic.from()
  |> dynamic.string()
  |> result.nil_error
}

///The "read_line" function utilizes the erlang get_function
///it takes a prompt and returns a reply to this prompt
///Example :
///Prompt = "Enter Your Name" --
///the command line will ask the user to enter their name
pub fn read_line(prompt: String) -> String {
  let inp: String = case read_line_signal(prompt) {
    Ok(i) -> i
    Error(_) -> "Couldn't read the command line argument!"
  }
  let len: Int = string.length(inp)
  let yld: String = string.slice(from: inp, at_index: 0, length: len - 1)
  yld
}
