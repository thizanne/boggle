type t

val empty : t
val is_empty : t -> bool
val add : string -> t -> t

val to_iter : t -> string Iter.t

val letter_suffixes : t -> char -> t
val has_empty_word : t -> bool

val filter_min_length : int -> t -> t
val load_file : string -> t option
