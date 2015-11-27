type dict =
  | Eow
  | Node of char * dict list

let add t w =
  let rec add t w i =
    if String.length w = i then Eow :: t
    else match t with
      | [] ->  [Node(w.[i], add [] w (succ i))]
      | Eow :: xs -> Eow :: add xs w i
      | Node (c, cs) :: xs ->
        if c = w.[i] then Node (c, add cs w (succ i)) :: xs
        else Node (c, cs) :: add xs w i
  in add t w 0

let rec can_follow dicts c = match dicts with
  | [] -> []
  | Eow :: xs -> can_follow xs c
  | Node(c', cs) :: xs ->
    if c = c' then cs else can_follow xs c

type box = {
  letter : char;
  mutable visited : bool;
}

let rec print_word = function
  | [] -> print_newline ()
  | x :: xs -> let () = print_word xs in print_char x

let rec backtrack found board follows w i j =
  board.(i).(j).visited <- true;
  if List.mem Eow follows then found := w :: !found;
  for i' = i - 1 to i + 1 do
    for j' = j - 1 to j + 1 do
      if not board.(i').(j').visited then
        let follow' = can_follow follows board.(i').(j').letter in
        if follow' <> []
        then backtrack found board follow' (board.(i').(j').letter :: w) i' j'
    done
  done;
  board.(i).(j).visited <- false

let load_dict f =
  let f = open_in f in
  let d = ref [] in
  let rec read () =
    d := add !d (input_line f);
    read ()
  in let () = try read () with End_of_file -> () in !d

let load_board () =
  let b = read_line () in
  let x = ref 0 in
  let m = Array.make_matrix 6 6 {letter = '\000'; visited = true} in
  for i = 1 to 4 do
    for j = 1 to 4 do
      m.(i).(j) <- {letter = b.[!x]; visited = false}; incr x
    done
  done;
  m

let compare x y =
  - (Pervasives.compare (List.length x) (List.length y))

let rec remove_doubles = function
  | [] -> []
  | [x] -> [x]
  | x :: y :: s ->
    if x = y then remove_doubles (x :: s)
    else x :: remove_doubles (y :: s)

let () =
  let dicts = load_dict "dico_fr.txt" in
  let board = load_board () in
  let words = ref [] in
  for i = 1 to 4 do
    for j = 1 to 4 do
      backtrack words board dicts [] i j
    done
  done;
  List.iter print_word (List.sort compare (remove_doubles (List.sort Pervasives.compare !words)))
