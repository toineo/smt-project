type ast =
  spec * clause list

(* Number of variables / Number of clauses *)
and spec = int * int

and clause = eq_literal list

and eq_literal =
| Equality of couple_var
| Difference of couple_var

(* Values of type couple_var must be in increasing order *)
and couple_var = var * var

and var = int
