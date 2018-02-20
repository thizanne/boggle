open Boggle

let compare w1 w2 =
  if String.length w1 = String.length w2
  then String.compare w1 w2
  else String.length w2 - String.length w1

let get_lexicon_filename () =
  (* Will only work when the executable is launched from the root
     source project directory. *)
  Filename.concat "dict" "dico_fr.txt"

let get_lexicon filename = match Lexicon.load_file filename with
  | Some lexicon -> Lexicon.filter_min_length 3 lexicon
  | None ->
    Printf.printf
      "Fichier de dictionnaire %s introuvable !\n\
       Assurez-vous de lancer ce programme à la racine des sources du \
       projet."
      filename;
    exit 1

let make_board arg = match Board.from_string arg with
  | Some board -> board
  | None ->
    print_endline
      "Mauvais format pour la grille ! Rentrez un nombre carré de lettres.";
    exit 1

let print_solution lexicon board =
  Solver.find_all_paths board lexicon
  |> Path.iter_to_words board
  |> Iter.to_rev_list
  |> List.sort compare
  |> List.iter print_endline

let print_board_then_solution lexicon board =
  Board.print board;
  print_endline "\nAppuyez sur entrée pour afficher les solutions...";
  ignore @@ read_line ();
  print_solution lexicon board

let make_random_board () =
  Board.make 4 @@ RandomLetter.(picker Distribution.fr)

let main () =
  let lexicon_filename = get_lexicon_filename () in
  let lexicon = get_lexicon lexicon_filename in
  if Array.length Sys.argv >= 2
  then print_solution lexicon @@ make_board Sys.argv.(1)
  else print_board_then_solution lexicon @@ make_random_board ()

let () = main ()
