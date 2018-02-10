type t = char array array

let get_letter board i j =
  board.(i).(j)

let dim board =
  Array.length board

let is_valid_pos board (i, j) =
  i >= 0 && i < dim board && j >= 0 && j < dim board

let all_positions board =
  Iter.product
    (Iter.range 0 @@ dim board - 1)
    (Iter.range 0 @@ dim board - 1)

let are_neighbours board (i, j) (i', j') =
  is_valid_pos board (i, j) &&
  is_valid_pos board (i', j') &&
  (i, j) <> (i', j') &&
  i' >= i - 1 && i' <= i + 1 &&
  j' >= j - 1 && j' <= j + 1

let neighbours board (i, j) =
  Iter.product
    (Iter.range (i - 1) (i + 1))
    (Iter.range (j - 1) (j + 1))
  |> Iter.filter (( <> ) (i, j))
  |> Iter.filter @@ is_valid_pos board

let make dim make_char =
  let board = Array.make_matrix dim dim '\000' in
  for i = 0 to dim - 1 do
    for j = 0 to dim - 1 do
      board.(i).(j) <- make_char ();
    done
  done;
  board

let from_string s =
  let x = ref 0 in
  let dim = int_of_float @@ sqrt @@ float @@ String.length s in
  if dim * dim <> String.length s
  then None
  else begin
    let m = Array.make_matrix dim dim '\000' in
    for i = 0 to dim - 1 do
      for j = 0 to dim - 1 do
        m.(i).(j) <- s.[!x];
        incr x;
      done
    done;
    Some m
  end

let print board =
  for i = 0 to dim board - 1 do
    for j = 0 to dim board - 1 do
      print_char board.(i).(j);
      print_char ' ';
    done;
    print_newline ();
  done
