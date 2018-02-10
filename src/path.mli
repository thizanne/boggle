type t

val empty : t
val add_tile : Board.t -> t -> (int * int) -> t option
val to_string : Board.t -> t -> string

val iter_to_words : Board.t -> t Iter.t -> string Iter.t
