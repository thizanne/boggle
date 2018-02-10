type 'a t = ('a -> unit) -> unit

val empty: 'a t
val singleton : 'a -> 'a t
val cons : 'a -> 'a t -> 'a t
val append : 'a t -> 'a t -> 'a t

val length : 'a t -> int

val range : int -> int -> int t

val flatten : 'a t t -> 'a t
val map : ('a -> 'b) -> 'a t -> 'b t
val flat_map : ('a -> 'b t) -> 'a t -> 'b t
val filter : ('a -> bool) -> 'a t -> 'a t
val fold : ('acc -> 'a -> 'acc) -> 'acc -> 'a t -> 'acc
val exists : ('a -> bool) -> 'a t -> bool (* lazy *)
val iter : ('a -> unit) -> 'a t -> unit

val product : 'a t -> 'b t -> ('a * 'b) t

val to_rev_list : 'a t -> 'a list
