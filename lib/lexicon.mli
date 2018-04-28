(** Un module pour gérer des Lexiques, c'est-à-dire des ensembles de
   mots. *)

type t
(** Le type des lexiques. *)

val empty : t
(** Le lexique vide, qui ne contient aucun mot *)

val is_empty : t -> bool
(** Est-ce qu'un lexique est vide ? *)

val add : string -> t -> t
(** [add word lexicon] ajoute le mot [word] au lexique [lexicon]. *)

val contains : string -> t -> bool
(** Est-ce qu'un lexique contient un mot donné ? *)

val to_iter : t -> string Iter.t
(** Un itérateur sur les mots d'un lexique. *)

val letter_suffixes : t -> char -> t
(** [letter_suffixes lexicon alpha] est le lexique contenant tous les
    mots présents dans [lexicon] et commençant par la lettre [alpha],
    desquels on a retiré cette première lettre [alpha].

    Par exemple, si [lexicon] contient les mots ["abstraction"],
    ["a",] et ["chameau"], [letter_suffixes lexicon 'a'] contiendra les
    mots ["bstraction"] et [""] (le mot vide).
*)

val has_empty_word : t -> bool
(** Renvoie [true] si le lexique contient le mot vide, [false]
    sinon.
*)

val filter_min_length : int -> t -> t
(** [filter_min_length len lexicon] renvoie le lexique composés des
    mots de [lexicon] qui ont [len] caractères ou plus.
*)

val load_file : string -> t option
(** Charge un fichier de mots dans un dictionnaire. [load_file
    filename] ouvrira le fichier [filename] et ajoutera chaque ligne de
    ce fichier comme un mot du lexique [lexicon], puis renverra [Some
    lexicon]. Si l'ouverture du fichier échoue, renvoie [None].

    Aucune vérification n'est faite sur le contenu du fichier : chaque
    ligne est considérée comme un mot valide. Les caractères "saut de
    ligne" ne sont pas considérés comme faisant partie des mots.
*)
