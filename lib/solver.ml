let rec backtrack board lexicon path (i, j) =
  match Path.add_tile board path (i, j) with
  | None -> Iter.empty
  | Some path' ->
    let letter = Board.get_letter board i j in
    let lexicon' = Lexicon.letter_suffixes lexicon letter in
    if Lexicon.is_empty lexicon'
    then Iter.empty
    else
      let solutions_through_neighbours =
        Board.neighbours board (i, j)
        |> Iter.flat_map (backtrack board lexicon' path')
      in
      if Lexicon.has_empty_word lexicon'
      then Iter.cons path' solutions_through_neighbours
      else solutions_through_neighbours

let find_all_paths board lexicon =
  Board.all_positions board
  |> Iter.flat_map (backtrack board lexicon Path.empty)
