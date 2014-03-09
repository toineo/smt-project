open AST

(* Constructors as functions *)
let couple_var v1 v2 = 
  if v1 <= v2 then v1, v2
  else v2, v1

let equality x = Equality x
let difference x = Difference x
