open Boggle

(** A module for managing the global state of the game *)

module Board : sig
  val get : unit -> Board.t
  (** Get the current board (initialised to a random one). *)

  val reset : unit -> unit
  (** Create a new random board*)
end

module Words : sig
  val found : unit -> Lexicon.t
  (**  The set of valid words found by the player *)

  val check : string -> unit
  (** If the word is valid, add it to the found words *)

  val reset : unit -> unit
  (** Sets the found words to an empty set *)

  val solutions : unit -> string Iter.t
  (** The set of all valid words on the grid *)
end

module Path : sig
  val get : unit -> Path.t
  (** Get the current path *)

  val add_tile : int * int -> unit
  (** Try to add a given tile to the current path. If this is not
     allowed, do nothing. *)

  val reset : unit -> unit
  (** Sets the current path to the empty path. *)

  val last_tile : unit -> (int * int) option
  (** Gets the coordinates of the last tile of the path, if it
     exists. *)
end
