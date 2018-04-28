(** Chemins sur une grille. Un chemin est une séquence de cases
    valides de la grille qui respecte les deux invariants suivants :

    - Deux cases consécutives dans le chemin sont voisines sur la grille.
    - Toute case de la grille est présente au plus une fois dans le chemin.

    Tout chemin construit à l'aide des fonctions fournit dans ce
    module garantit de respecter ces deux invariants.
*)

type t
(** Le type des chemins. *)

val empty : t
(** Le chemin vide (qui ne contient aucune case). *)

val add_tile : Board.t -> t -> (int * int) -> t option
(** Ajoute une case de la grille, donnée par ses coordonnées (numéro
    de ligne, numéro de colonne), à un chemin. Renvoie [None] si le
    chemin ainsi constitué ne serait pas valide (c'est-à-dire si un des
    invariants des chemins n'était pas respecté).
*)

val to_string : Board.t -> t -> string
(** Renvoie le mot décrit lorsqu'on parcourt un chemin sur une grille,
    c'est-à-dire le mot constitué des lettres correspondant à chaque
    case du chemin dans l'ordre.
*)

val iter : t -> (int * int) Iter.t
(** Renvoie un itérateur sur les positions de t *)

val iter_to_words : Board.t -> t Iter.t -> string Iter.t
(** Étant donnés une grille et un itérateur sur des chemins, renvoie
    un itérateur sur les mots décrits par ces chemins. Si deux chemins
    décrivent le même mot, ce mot n'est présent qu'une fois dans
    l'itérateur renvoyé. Aucun ordre n'est spécifié sur les mots de
    l'itérateur.
*)
