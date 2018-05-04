open Boggle
open Prelude

type t = unit -> unit

let ( ==> ) elt (action : unit -> unit) =
  elt##.onclick :=
    Dom_html.handler begin
      fun _evt ->
        action ();
        Js._true
    end

let ( => ) id action =
  Dom_html.getElementById id ==> action

let reset_board () =
  State.Board.reset ();
  State.Path.reset ();
  State.Words.reset ();
  Html.Words.display_found ();
  Html.Path.display ();
  Html.Board.display ();
  ("check_word" @> Dom_html.CoerceTo.button)##.disabled := Js._false

let display_solutions () =
  Html.Words.display_solutions ();
  ("check_word" @> Dom_html.CoerceTo.button)##.disabled := Js._true

let path_add_tile (i, j) () =
  State.Path.add_tile (i, j);
  Html.Path.display ()

let check_word () =
  State.Words.check @@ Path.to_string (State.Board.get ()) (State.Path.get ());
  Html.Words.display_found ();
  State.Path.reset ();
  Html.Path.display ()
