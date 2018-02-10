type t

val get_letter : t -> int -> int -> char

val dim : t -> int
val is_valid_pos : t -> int * int -> bool
val all_positions : t -> (int * int) Iter.t

val are_neighbours : t -> int * int -> int * int -> bool
val neighbours : t -> int * int -> (int * int) Iter.t

val make : int -> (unit -> char) -> t
val from_string : string -> t option
val print : t -> unit
