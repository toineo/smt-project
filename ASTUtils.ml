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



(* Normalize variables to have them in [0; nvars - 1] *)
(* Here, we make the assumption that they are in [1, nvars]
   We could make it more robust, but this is not the purpose of this projet
*)
let remap = function
  | spec, clauses ->
    let translate_lit = function
      | Equality (x, y) -> Equality (x - 1, y - 1)
      | Difference (x, y) -> Difference (x - 1, y - 1)
    in
    let translate_clause = List.map translate_lit
    in
    (spec, List.map translate_clause clauses)
      ,
    () (* Allows to make the inverse transformation (for now, we don't need it) *)


let remap_inverse_var map var = var + 1
