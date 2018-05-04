open Boggle
open Prelude

module Board = struct
  let get, reset =
    let random_board () =
      Board.make dim RandomLetter.(picker Distribution.fr)
    in
    let board = ref (random_board ()) in
    (* get *)
    begin fun () ->
      !board
    end,
    (* reset *)
    begin fun () ->
      board := random_board ()
    end
end

module Words = struct
  let lexicon_fr =
    Msg.display "Chargement du dictionnaire...";
    let req = XmlHttpRequest.create () in
    req##_open (Js.string "GET") (Js.string "dico_fr.txt") Js._false;
    req##send Js.null;
    Sys_js.create_file ~name:"dico_fr.txt" ~content:(Js.to_string req##.responseText);
    match Lexicon.load_file "dico_fr.txt" with
    | None ->
      alert "Erreur : impossible de charger le lexique.";
      assert false
    | Some lexicon ->
      lexicon
      |> Lexicon.filter_min_length 3
      |>- Msg.clear

  let found, check, reset =
    let found_lexicon = ref Lexicon.empty in
    (* found *)
    begin fun () ->
      !found_lexicon
    end,
    (* check *)
    begin fun w ->
      Msg.clear ();
      if not (Lexicon.contains w lexicon_fr)
      then Msg.display "Mot inconnu !"
      else found_lexicon := Lexicon.add w !found_lexicon
    end,
    (* reset *)
    begin fun () ->
      found_lexicon := Lexicon.empty
    end

  let solutions () =
    let board = Board.get () in
    Solver.find_all_paths board lexicon_fr
    |> Path.iter_to_words board
end

module Path = struct
  let get, add_tile, reset, last_tile =
    let path = ref Path.empty in
    let last = ref None in
    (* get *)
    begin fun () ->
      !path
    end,
    (* add_tile *)
    begin fun (i, j) ->
      match Path.add_tile (Board.get ()) !path (i, j) with
      | None -> ()
      | Some new_path ->
        path := new_path;
        last := Some (i, j)
    end,
    (* reset *)
    begin fun () ->
      path := Path.empty;
      last := None
    end,
    (* last_tile *)
    begin fun () ->
      !last
    end
end
