type t = (int * int) list

let empty = []

let add_tile board path (i, j) = match path with
  | [] -> Some [i, j]
  | (i', j') :: ps ->
    if
      Board.are_neighbours board (i, j) (i', j') &&
      not (List.exists (( = ) (i, j)) path)
    then Some ((i, j) :: path)
    else None

let rec to_string board path = match path with
  | [] -> ""
  | (i, j) :: ps ->
    to_string board ps ^
    String.make 1 (Board.get_letter board i j)

let rec iter path f = match path with
  | [] -> ()
  | last :: previous ->
    iter previous f;
    f last

let iter_to_words board all_paths =
  Iter.fold
    (fun acc path -> Lexicon.add (to_string board path) acc)
    Lexicon.empty
    all_paths
  |> Lexicon.to_iter
