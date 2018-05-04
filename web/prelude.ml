let flip f x y = f y x

let ( |>- ) x f =
  let () = f () in
  x

let win = Dom_html.window
let alert s = win##alert (Js.string s)

let ( @> ) id coercion =
  try
    Dom_html.getElementById id
    |> coercion
    |> flip Js.Opt.get (fun () -> alert "Coercion impossible"; assert false)
  with Not_found ->
    Printf.ksprintf alert {|Élément "%s" introuvable|} id;
    raise Not_found

module Msg = struct
  let msg_tag =
    Dom_html.getElementById "message"

  let display s =
    msg_tag##.innerHTML := Js.string s

  let clear () =
    msg_tag##.innerHTML := Js.string ""
end

let dim = 4
