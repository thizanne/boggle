module Distribution = struct
  type t = int array
  (** Distributions are represented as an array of (relative)
      occurrences of each letter (diacritic removed), given in
      alphabetic order.
  *)

  let uniform =
    Array.make 26 1

  let fr = [|
    70924245; (* a *)
    10817171; (* b *)
    30764083; (* c *)
    34914685; (* d *)
    137301681; (* e *)
    10579192; (* f *)
    11684140; (* g *)
    10583562; (* h *)
    63139805; (* i *)
    3276064; (* j *)
    2747547; (* k *)
    47171247; (* l *)
    24894034; (* m *)
    60728196; (* n *)
    48132617; (* o *)
    23647179; (* p *)
    6140307; (* q *)
    57656209; (* r *)
    61882785; (* s *)
    56267109; (* t *)
    43069799; (* u *)
    10590858; (* v *)
    1653435; (* w *)
    3588990; (* x *)
    4351953; (* y *)
    1433913; (* z *)
  |]
end

let cumulative occurrences =
  (* Build the cumulative occurrences array *)
  let cumul = Array.make (Array.length occurrences) 0 in
  cumul.(0) <- occurrences.(0);
  for i = 1 to Array.length occurrences - 1 do
    cumul.(i) <- cumul.(i - 1) + occurrences.(i)
  done;
  cumul

let find_index n cumul =
  (* From an integer (between 0 included and the max of cumul
     excluded) and a cumulative occurrences array, find the smallest
     index in the array such as the array value at this index is
     greater than the integer. *)
  let rec aux i_min i_max =
    if i_min = i_max then i_min
    else
      let i = i_min + (i_max - i_min) / 2 in
      if cumul.(i) <= n
      then aux (i + 1) i_max
      else aux i_min i
  in aux 0 (Array.length cumul - 1)

let letter_of_index index =
  (* Given an index between 0 and 25, returns the corresponding
     letter from 'a' to 'z' *)
  Char.chr (index + Char.code 'a')

let picker occurrences =
  let () = Random.self_init () in
  let cumul = cumulative occurrences in
  let cumul_max = cumul.(Array.length cumul - 1) in
  fun () ->
    find_index (Random.int cumul_max) cumul
    |> letter_of_index
