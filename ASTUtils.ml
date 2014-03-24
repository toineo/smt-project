open AST

(* Constructors as functions *)
let couple_var v1 v2 =
  if v1 <= v2 then v1, v2
  else v2, v1

let equality x = Equality x
let difference x = Difference x


(* FIXME: this function should be a Printf formatter *)
let print_lit = function
  | Equality (x, y) ->
    Printf.printf "%d = %d\n" x y
  | Difference (x, y) ->
    Printf.printf "%d <> %d\n" x y
