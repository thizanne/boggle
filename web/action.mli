type t

val reset_board : t
val display_solutions : t
val check_word : t
val path_add_tile : int * int -> t

val ( => ) : string -> t -> unit
(** Attach an action to an element given by its id *)

val ( ==> ) : Dom_html.element Js.t -> t -> unit
(** Attach an action to an element *)
