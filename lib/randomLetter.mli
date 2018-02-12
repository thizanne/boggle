(** Un module pour sélectionner des lettres aléatoirement selon une
    certaine distribution. *)

module Distribution : sig
  (** Un module regroupant des distributions de lettres. *)

  type t
  (** Le type des distributions de lettres. *)

  val uniform : t
  (** La distribution uniforme des 26 lettres de l'alphabet (en
      minuscule). Chaque lettre a la même fréquence. *)

  val fr : t
  (** La distribution des 26 lettres minuscules correspondant à la
      langue française. Les accents et autres signes diacritiques ont
      été retirés.
  *)
end

val picker : Distribution.t -> (unit -> char)
(** [picker distribution] renvoie une fonction [random_letter] qui
    permet de tirer aléatoirement une lettre selon la distribution
    donnée.

    Voici un exemple d'utilisation de {!picker} dans le terminal (une
    fois le module {!RandomLetter} ouvert) :

   {[
# let random_letter_fr = picker Distribution.fr;;
val random_letter_fr : unit -> char = <fun>
# random_letter_fr ();;
- : char = 's'
# random_letter_fr ();;
- : char = 'a'
# random_letter_fr ();;
- : char = 'e'
   ]}

    [random_letter_fr] renverra une lettre avec une probabilité égale
    à sa fréquence dans la langue française. On notera par exemple
    qu'ici, cette fonction a renvoyé 3 lettres parmi les 4 plus
    fréquentes (c'est un hasard, mais c'était un résultat plus probable
    que ['k'], ['w'] et ['z']).
*)
