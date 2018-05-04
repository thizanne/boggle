open Boggle
open Prelude

let () =
  Html.Board.display ();
  Action.(
    "new_grid" => reset_board;
    "solve_grid" => display_solutions;
    "check_word" => check_word;
  );

  for i = 0 to dim - 1 do
    for j = 0 to dim - 1 do
      let cell_tag = Html.Board.cell_tag (i, j) in
      Action.(cell_tag ==> path_add_tile (i, j))
    done
  done
