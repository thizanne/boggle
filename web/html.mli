(** Display and manage the html rendering the state of the game. The
    [display] functions are meant to be explicitely called when this
    state changes. *)

module Board : sig
  val cell_tag : int * int -> Dom_html.element Js.t
  (** Get the element corresponding to a cell of the board. *)

  val display : unit -> unit
  (** Display the current board on the pagex. *)
end

module Words : sig
  val display_solutions : unit -> unit
  (** Display the solutions of the current board. The solutions that
      were not found by the player are typesetted differently. *)

  val display_found : unit -> unit
  (** Display the words found by the player. *)
end

module Path : sig
  val display : unit -> unit
  (** Display the word corresponding to the current path and display
      the current path. The path is displayed by colouring its tiles,
      and colouring differently the last tile. *)
end
