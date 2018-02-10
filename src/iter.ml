type +'a t = ('a -> unit) -> unit

let empty =
  fun k ->
    ()

let cons x s =
  fun k ->
    k x;
    s k

let singleton x =
  fun k ->
    k x

let append s1 s2 =
  fun k ->
    s1 k;
    s2 k

let rec range from to_ =
  fun k ->
    if from > to_
    then ()
    else begin
      k from;
      range (from + 1) to_ k
    end

let length s =
  let r = ref 0 in
  s (fun _ -> incr r);
  !r

let flatten s =
  fun k ->
    s (fun sub -> sub k)

let map f s =
  fun k ->
    s (fun x -> k @@ f x)

let flat_map f s =
  fun k ->
    s (fun x -> f x @@ k)

let filter f s =
  fun k ->
    s (fun x -> if f x then k x else ())

let fold f acc s =
  let acc_ref = ref acc in
  s (fun x -> acc_ref := f !acc_ref x);
  !acc_ref

let exists f s =
  fold (fun acc x -> acc || f x) false s

let iter f s =
  s f

let product s1 s2 =
  fun k ->
    s1 (fun x -> s2 (fun y -> k (x, y)))

let to_rev_list s =
  fold (fun acc x -> x :: acc) [] s
