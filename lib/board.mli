(** Module pour définir et travailler sur des grilles de Boggle. On ne
   considère que des grilles carrées. *)

type t
(** Le type d'une grille. *)

val get_letter : t -> int -> int -> char
(** [get_letter board i j] renvoie le caractère présent à la ligne [i]
   et à la colonne [j] sur la grille [board]. *)

val dim : t -> int
(** La dimension d'une grille, c'est à dire le nombre de lignes (qui
    est égal au nombre de colonnes). *)

val all_positions : t -> (int * int) Iter.t
(** Un itérateur sur toutes les positions (ligne, colonne) d'une
   grille. *)

val are_neighbours : t -> int * int -> int * int -> bool
(** Est-ce que deux cases données par leurs positions sont voisines ?
   Deux cases sont voisines si elles se "touchent" par un côté ou en
   diagonale. On considèrera que les cases données sont des cases
   valides sur la grille. *)

val neighbours : t -> int * int -> (int * int) Iter.t
(** Un itérateur sur les cases voisines d'une case donnée. *)

val make : int -> (unit -> char) -> t
(** [make dim make_char] crée une grille de dimension [dim] et appelle
   [make_char ()] pour remplir chaque case. [make_char] est une
   fonction renvoyant un caractère à chaque appel. Voir le module
   {!RandomLetter}. *)

val from_string : string -> t option
(** [from_string s] crée une grille [grid] à partir d'une chaîne de
    caractères [s] comprenant tous les caractères de la grille dans
    l'ordre usuel de lecture (de gauche à droite, puis de haut en
    bas). [s] doit avoir un nombre carré de caractères, c'est-à-dire
    que la longueur de [s] doit être le carré d'un entier [n] qui sera
    donc la dimension de la grille. Si [s] n'a pas un nombre carré de
    caractères, [from_string s] renvoie [None]. *)

val print : t -> unit
(** Affiche une grille. Deux caractères consécutifs sur une même ligne
    sont séparés par une espace. Deux lignes consécutives sont
    affichées consécutivement. On affichera un caractère saut de ligne
    après la dernière ligne. On pourra, pour simplifier le code,
    afficher une espace après le caractère de chaque ligne.

    Voici un exemple d'affichage d'une grille :
{[a t r s
e u l c
n m t e
h t s c]}
*)
