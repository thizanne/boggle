module M = struct

  include Map.Make (Char)

  let to_iter s =
    fun k ->
      iter (fun key item -> k (key, item)) s
end

type t = {
  eow : bool;
  words : t M.t;
}

let empty = {
  eow = false;
  words = M.empty;
}

let has_empty_word { eow; words = _ } =
  eow

let rec is_empty { eow; words } =
  (* Module abstraction ensures that there is no way to build an
     empty lexicon with a non-empty `words` map. Thus we could
     simply test for `words` being the empty map instead of the
     `for_all`. However the proposed solution will do the same
     operations (for_all will immediately return true on the empty
     map), and is more robust against possible future changes that
     might break this property. *)
  not eow &&
  M.for_all (fun _letter sublexicon -> is_empty sublexicon) words

let add word lexicon =
  let rec add_chars_from_n lexicon n =
    if n = String.length word
    then
      { lexicon with eow = true }
    else
      let current_sublexicon = match M.find_opt word.[n] lexicon.words with
        | None -> empty
        | Some sublexicon -> sublexicon in
      let new_sublexicon = add_chars_from_n current_sublexicon (n + 1) in
      { lexicon with words = M.add word.[n] new_sublexicon lexicon.words }
  in add_chars_from_n lexicon 0

let contains word lexicon =
  let rec contains_from_n lexicon n =
    if n = String.length word
    then has_empty_word lexicon
    else
      match M.find_opt word.[n] lexicon.words with
      | None -> false
      | Some sublexicon -> contains_from_n sublexicon (n + 1)
  in contains_from_n lexicon 0

let string_cons char word =
  (* Add a char to the beginning of a string *)
  Printf.sprintf "%c%s" char word

let rec to_iter { eow; words } =
  M.to_iter words
  |> Iter.map (fun (letter, sublexicon) -> letter, to_iter sublexicon)
  |> Iter.flat_map
    (fun (letter, suffixes) -> Iter.map (string_cons letter) suffixes)
  |> Iter.append (if eow then Iter.singleton "" else Iter.empty)

let letter_suffixes { eow = _; words } letter =
  match M.find_opt letter words with
  | Some suffixes -> suffixes
  | None -> empty

let rec filter_min_length len ({ eow; words } as lexicon) =
  if len = 0
  then lexicon
  else
    let words =
      words
      |> M.map @@ filter_min_length (len - 1)
      |> M.filter @@ fun _letter sublexicon -> not (is_empty sublexicon) in
    { eow = false; words }

let load_file f =
  let rec load_channel channel acc =
    match input_line channel with
    | word -> load_channel channel (add word acc)
    | exception End_of_file -> acc
  in
  match open_in f with
  | channel -> Some (load_channel channel empty)
  | exception Sys_error _ -> None
