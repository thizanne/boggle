open Boggle
open Prelude

module Board = struct
  let cell_tag (i, j) =
    let board_tag = Dom_html.getElementById "board" in
    let row =
      (board_tag##getElementsByTagName (Js.string "tr"))##item i
      |> flip Js.Opt.get (fun () -> assert false)
    in
    (row##getElementsByTagName (Js.string "td"))##item j
    |> flip Js.Opt.bind Dom.CoerceTo.element
    |> flip Js.Opt.map Dom_html.element
    |> flip Js.Opt.get (fun () -> assert false)

  let display () =
    let board = State.Board.get () in
    for i = 0 to dim - 1 do
      for j = 0 to dim - 1 do
        let letter = Js.string @@ String.make 1 @@ Board.get_letter board i j in
        (cell_tag (i, j))##.innerHTML := letter
      done
    done
end

module Words = struct

  let sort words =
    let compare w1 w2 =
      if String.length w1 = String.length w2
      then String.compare w1 w2
      else String.length w2 - String.length w1
    in
    words
    |> Iter.to_rev_list
    |> List.sort compare
    |> flip List.iter

  let display words =
    let all_words_tag = Dom_html.getElementById "all_words" in
    let words_html =
      words
      |> Iter.map @@ ( ^ ) "<br />"
      |> Iter.fold ( ^ ) ""
    in
    all_words_tag##.innerHTML := Js.string words_html

  let display_solutions () =
    Msg.display "Recherche des solutions...";
    let colourise w =
      if Lexicon.contains w (State.Words.found ())
      then w
      else Printf.sprintf {|<span class="not_found"> %s </span>|} w
    in
    State.Words.solutions ()
    |> sort
    |> Iter.map colourise
    |> display;
    Msg.clear ()

  let display_found () =
    State.Words.found ()
    |> Lexicon.to_iter
    |> sort
    |> display
end

module Path = struct
  let display_word () =
    let current_word_tag = Dom_html.getElementById "current_word" in
    let word = Path.to_string (State.Board.get ()) (State.Path.get ()) in
    current_word_tag##.innerHTML := Js.string (word ^ "_")

  let display_path () =
    let cell_class i j =
      (Board.cell_tag (i, j))##.classList
    in
    Boggle.Board.all_positions
      (State.Board.get ())
      (fun (i, j) ->
         (cell_class i j)##remove (Js.string "onpath");
         (cell_class i j)##remove (Js.string "last")
      );
    Path.iter
      (State.Path.get ())
      (fun (i, j) -> (cell_class i j)##add (Js.string "onpath"));
    match State.Path.last_tile () with
    | None -> ()
    | Some (i, j) -> (cell_class i j)##add (Js.string "last")

  let display () =
    display_word ();
    display_path ()
end
