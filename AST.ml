type ast = 
  spec * clause list

(* Number of variables / Number of clauses *)
(* TODO: is it really useful after parsing? *)
type spec = int * int

and clause = eq_litteral list

and eq_litteral = 
| Equality of couple_var
| Difference of couple_var

(* Values of type couple_var must be in increasing order *)
and couple_var = var * var

and var = int
