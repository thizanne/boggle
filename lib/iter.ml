(**

   Ce module implémente des itérateurs sur des valeurs d'un certain
   type. Ces itérateurs correspondent à des séquences d'éléments de
   ce type, c'est à dire d'un certain nombre, éventuellement infini,
   d'éléments qui se suivent. Les itérateurs seront utilisés dans
   plusieurs modules du projet.

   Vous connaissez déjà une structure pour représenter des séquences
   d'éléments : la liste. Elle consiste à garder tous les éléments de
   la séquence en mémoire, en utilisant le constructeur `::` pour lier
   un élément aux éléments suivants.

   Cette technique fonctionne bien pour des petites listes d'éléments,
   mais elle présente plusieurs inconvénients :

   - Elle nécessite de représenter tous les éléments en mémoire, ce qui
   peut être problématique pour des séquences comprenant un nombre
   très important d'éléments, et empêche de représenter des séquences
   infinies comme « la séquence de tous les entiers : 0, 1, ... »

   - Une opération comme `append : 'a list -> 'a list -> 'a list`, qui
   concatène deux listes, nécessite de parcourir intégralement le
   premier paramètre afin de pouvoir construire explicitement la liste
   résultat en mémoire.

   Le module `Iter` résoudra ces problèmes en représentant une séquence
   d'éléments de type `'a` par une valeur de type `('a -> unit) ->
   unit`. Concrètement, la séquence `x_1, x_2, ...` est représentée
   par la fonction d'ordre supérieur qui prend une fonction `k` en
   paramètre et qui applique successivement `k` à `x1`, `x2`, et ainsi
   de suite.

   On peut alors représenter une séquence même infinie efficacement : par
   exemple, la séquence des nombres entiers à partir de `n` est une
   fonction `nat_from` qui prend en paramètre une fonction `k : int ->
   unit` et qui appelle récursivement `k` sur `n`, puis sur `n + 1`,
   puis sur `n + 2`, et ainsi de suite. Voici un exemple
   d'implémentation d'une telle fonction :

   {[
     # let rec nat_from n = fun k -> k n; nat_from (n + 1) k ;;
     val nat_from : int -> (int -> 'a) -> 'b = <fun>
     # let all_nat = nat_from 0;;
     val all_nat : (int -> '_a) -> 'b = <fun>
   ]}

   On remarquera qu'on a pu définir sans problème la séquence de tous les
   entiers à partir de `0`. On notera également que le type de
   `nat_from` inféré par le compilateur contient les variables `'a` et
   `'b` au lieu de `unit` : c'est ici un détail technique qui n'a pas
   d'importance (de même pour `all_nat`).

   Cette représentation résout également le problème de la concaténation
   de deux séquences `s1` et `s2` : en effet, il n'y a plus besoin
   d'énumérer explicitement les éléments de `s1`. Il suffit de dire
   que l'itérateur sur la concaténation de `s1` et `s2` prend en
   paramètre une fonction `k`, l'applique sur tous les éléments de
   `s1`, puis sur tous les éléments de `s2`. On dit que cette
   construction est paresseuse : elle n'évalue pas totalement ses
   paramètres avant de retourner.

   Bien sûr, lorsqu'on essayera d'appliquer un itérateur comme `all_nat`
   à une fonction comme `print_int`, cet appel ne terminera pas : on
   ne peut évidemment pas énumérer une séquence infinie d'éléments
   dans un programme. Cependant, il est possible d'écrire une fonction
   qui garde par exemple uniquement les `n` premiers éléments d'une
   séquence, ce qui permet ainsi de travailler avec des séquences
   infinies au cours d'un programme avant de les tronquer lorsqu'on
   a besoin d'énumérer explicitement leurs éléments. Ce projet ne fera
   toutefois pas intervenir de séquences infinies, vous n'aurez donc
   pas ce genre de problème à résoudre (il est malgré tout important
   de comprendre comment elles fonctionnent afin d'être à l'aise avec
   le principe des itérateurs).

   Les plus attentifs d'entre vous auront remarqué que vous avez déjà
   utilisé des objets ressemblant à ces itérateurs : il s'agit des
   fonction `iter` proposées par différents modules, comme `List`. En
   effet, si vous disposez d'une liste `li`, la fonction `fun k ->
   List.iter k li` est exactement un itérateur sur les éléments de la
   liste !

   Bien sûr, se contenter de définir de tels itérateurs ne suffit pas
   dans un programme réel : il faut bien finir par faire quelque chose
   des éléments de ces séquences. Pour cela, on dit que certaines
   fonctions « forcent » l'itérateur : elles construisent explicitement
   les éléments de la séquence sous-jacente. La documentation du
   module vous indique quelles sont les fonctions qui doivent forcer
   leurs paramètres.

*)

type +'a t = ('a -> unit) -> unit

let empty =
  (* Un itérateur sur une séquence vide n'applique `k` sur aucun
     élément : il renvoie simplement `()` *)
  fun k ->
    ()

let cons x s =
  (* Pour itérer sur cons x s, on applique k à x, puis on itère sur
     s *)
  fun k ->
    k x;
    s k

let singleton x =
  (* Un itérateur qui n'applique k qu'à un élément *)
  fun k ->
    k x

let append s1 s2 =
  (* On itère sur s1, puis on itère sur s2 *)
  fun k ->
    s1 k;
    s2 k

let rec range from to_ =
  (* Tant que from n'a pas atteint to_, on applique k à from_, puis on
     recommence en incrémentant from_ *)
  fun k ->
    if from > to_
    then ()
    else begin
      k from;
      range (from + 1) to_ k
    end

let length s =
  (* Une première fonction qui itère vraiment sur un itérateur s :
     pour chaque élément, on incrémente un compteur à l'aide d'une
     référence. On retourne ensuite la valeur de ce compteur. *)
  let r = ref 0 in
  s (fun _ -> incr r);
  !r

let flatten s =
  (* On itère sur chaque élément sub de s la fonction « itérer sur
     sub ». On itère ainsi successivement sur tous les éléments de
     s. *)
  fun k ->
    s (fun sub -> sub k)

let map f s =
  (* Itérer sur s, c'est appliquer k à chaque élément x de s.
     Itérer sur map f s, c'est appliquer k à f x pour chaque élément x de s.
  *)
  fun k ->
    s (fun x -> k @@ f x)

let flat_map f s =
  (* On combine flatten et map : pour chaque élément x de s, on itère
     l'application de k sur le résultat de f x. *)
  fun k ->
    s (fun x -> f x @@ k)

let filter f s =
  (* On n'itère que sur les éléments vérifiant le prédicat *)
  fun k ->
    s (fun x -> if f x then k x else ())

let fold f acc s =
  (* On généralise count : pour chaque élément, on met à jour une
     référence qui sert d'accumulateur, puis on renvoie cet
     accumulateur. *)
  let acc_ref = ref acc in
  s (fun x -> acc_ref := f !acc_ref x);
  !acc_ref

let exists f s =
  (* || est paresseux : dès que l'accumulateur sera mis à true une
     fois, l'itération s'arrêtera. *)
  fold (fun acc x -> acc || f x) false s

let iter f s =
  (* Trivial : on itère f sur s *)
  s f

let product s1 s2 =
  (* Pour chaque élément x de s1, on itère sur tous les éléments de
     s2. *)
  fun k ->
    s1 (fun x -> s2 (fun y -> k (x, y)))

let to_rev_list s =
  (* Une utilisation classique de fold. La liste est retournée parce
     qu'on commence par ajouter (en tête de l'accumulateur) les
     premiers éléments de la séquence, et on finit par les derniers
     qui se retrouvent donc en tête de la valeur finale. *)
  fold (fun acc x -> x :: acc) [] s
