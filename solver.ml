open AST

exception Unsat

module ISet = Set.Make (struct type t = int let compare = compare end)

let rec solve ast =
  let nvars, processed_clauses = process ast
  in

  (* In the following function :
     - eq is the union find structure, that represents the current partition of variables
     - diff is an array containing, for each variable, a set of variables that have
     to be different

     WARNING: to know if a <> b is enforced, one must check if b is in a's set AND if a is in b's set
     (this is due to the fact that a unique representative partition structure cannot be order preserving)
  *)
  let rec one_step_solve eq diff = function
    | [] ->  (* No remaning clause, we have a model *)
      Some (eq, nvars)                  (* FIXME: putting nvars here is ugly *)
    | cur_clause :: rem_clauses ->
      (* The following function will be used to iterate over the literals of the current clause,
         trying to make the current literal true and continuing resolution *)
      let rec add_literal = function
        | [] -> raise Unsat (* Backtrack to the previous level *)
        | lit :: tail ->
          try
            match lit with
            | Difference (x, y) ->
              let rx, ry = Puf.find eq x, Puf.find eq y
              in

              if rx = ry then raise Unsat
              else
                (* As the union-find cannot preserve (representative) order (w.r.t. element order),
                   we do not take order into account *)
                one_step_solve
                  eq
                  (Parray.set diff rx (ISet.add ry (Parray.get diff rx)))
                  rem_clauses
            | Equality (x, y) ->
              let rx, ry = Puf.find eq x, Puf.find eq y
              in

              (* Simple check to accelerate this trivial case (x = y already) *)
              if rx = ry
              then
                one_step_solve
                  eq
                  diff
                  rem_clauses

              else
                (* We have to iterate the set of "difference" of both representative to make sure
                   that the other representative is not element of this set *)
                (* This is probably the most inefficent part of this naive solver *)
                let setx, sety = Parray.get diff rx, Parray.get diff ry
                in

                if ISet.exists (fun e -> ry = Puf.find eq e) setx
                  || ISet.exists (fun e -> rx = Puf.find eq e) sety

                then (* Difference is already enforced, so this literal is necessarily false *)
                  add_literal tail

                else (* This equality can be enforced *)
                  let neweq = Puf.union eq rx ry
                  in

                  let rrx = Puf.find neweq rx
                  in

                  (* We have to move the "non representative"'s set into the representative's set *)
                  if rrx = rx (* Rx is still the representative in the new structure *)
                  then
                    one_step_solve
                      neweq
                      (Parray.set diff rx (ISet.union setx sety))
                      rem_clauses
                  else  (* This time, ry is the new representative *)
                    one_step_solve
                      neweq
                      (Parray.set diff ry (ISet.union setx sety))
                      rem_clauses
          with
            Unsat -> add_literal tail
      in

      add_literal cur_clause
  in

  (* FIXME: variable name normalization (remove the +1 in the following line) *)
  try
    one_step_solve (Puf.create (nvars + 1)) (Parray.create (nvars + 1) ISet.empty) processed_clauses
  with
  | Unsat -> None


(* Transform the ast into a form usable during solving phases *)
and process = function
  | (nbvar, _), cllist -> nbvar, cllist
(* For now, we don't need any transformation *)
