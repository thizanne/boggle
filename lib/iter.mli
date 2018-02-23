(** Itérateurs sur des séquences de valeurs d'un certain
   type. Certaines fonctions {e forcent} l'itérateur : elles
   consomment tous ses éléments pour produire le résultat. Ces
   fonctions ne terminent pas si l'itérateur est infini. Les autres
   fonctions sont paresseuses : elle produisent un itérateur mais
   n'évaluent pas ses éléments lorsqu'on les appelle. Elles terminent
   même sur des itérateurs infinis. *)

type 'a t = ('a -> unit) -> unit
(** Un itérateur de valeurs de type ['a].

    Ce type n'est pas abstrait. Vous pourrez donc l'utiliser
    directement dans les autres modules, bien que ce ne soit ni
    nécessaire ni conseillé dans le cadre de ce projet, les fonctions
    exportées par ce module étant suffisantes.
*)

val empty: 'a t
(** L'itérateur sur 0 élément. *)

val singleton : 'a -> 'a t
(** Un itérateur sur une séquence d'un élément. *)

val cons : 'a -> 'a t -> 'a t
(** [cons x s] itère sur [x] puis sur les éléments de [s]. *)

val append : 'a t -> 'a t -> 'a t
(** [append s1 s2] itère sur les éléments de [s1] puis ceux de [s2] *)

val length : 'a t -> int
(** [length s] est le nombre d'éléments de [s]. Force l'itérateur. *)

val range : int -> int -> int t
(** [range from to_] est itère sur les entiers de [from] (inclus)
   à [to_] (inclus). Si [from > to_], [range from to_] est l'itérateur
   vide. *)

val flatten : 'a t t -> 'a t
(** Un itérateur sur les éléments concaténés de plusieurs
   itérateurs. *)

val map : ('a -> 'b) -> 'a t -> 'b t
(** [map f s] est un itérateur sur [f x1, f x2, ...], où [x1, x2, ...]
   sont les éléments de [s]. *)

val flat_map : ('a -> 'b t) -> 'a t -> 'b t
(** [flat_map f s] applique paresseusement [f] à tous les éléments de
   [s], puis itère successivement sur les éléments des itérateurs
   ainsi obtenus. Fonctionnellement, [flat_map f s = flatten (map
   f s)]. *)

val filter : ('a -> bool) -> 'a t -> 'a t
(** [filter predicate s] itère sur les éléments [x] de [s] pour
   lesquels [predicate x] vaut [true]. *)

val fold : ('acc -> 'a -> 'acc) -> 'acc -> 'a t -> 'acc
(** Si [s] est l'itérateur sur [x1, x2, ..., xn], [fold f init s] est
   [f (... (f (f acc x1) x2) ... ) xn]. Force l'itérateur. *)

val exists : ('a -> bool) -> 'a t -> bool
(** Renvoie [true] si et seulement si il existe un élément d'un
    itérateur satisfaisant un prédicat donné. Si aucun élément ne
    satisfait le prédicat, renvoie [false] si l'itérateur est fini, et
    ne termine pas sinon.

    {b Note :} cette fonction force « partiellement » l'itérateur,
    c'est-à-dire jusqu'à trouver un élément satisfaisant le prédicat. *)

val iter : ('a -> unit) -> 'a t -> unit
(** Applique une fonction successivement à tous les éléments d'un
   itérateur. Force l'itérateur. *)

val product : 'a t -> 'b t -> ('a * 'b) t
(** [product a b] itère sur tous les couples formés d'un élément de
   [a] et d'un élément de [b]. *)

val to_rev_list : 'a t -> 'a list
(** Renvoie la liste composée de tous les éléments d'un itérateur, en
   ordre inverse. Force l'itérateur. *)
