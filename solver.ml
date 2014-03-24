exception Unsat

module ISet = Set.Make (struct type t = int let compare = compare end)

let rec solve ast =
  let nvars, processed_ast = process ast
  in

  let rec one_step_solve eq diff = function
    | [] ->  (* No remaning clause, we have a model *)
      eq
    | h :: t ->

      (* The following function will be used to iterate over the literals of the current clause,
         trying to make the current literal true and continuing resolution *)
      let rec add_literal = function
        | [] -> raise Unsat (* Backtrack to the previous level *)
        | lit :: tail ->
          try
            match lit with
            | _ -> eq (* TODO *)
          with
            Unsat -> add_literal tail
      in

      add_literal h
  in

  (* FIXME: variable name normalization (remove the +1 in the following line) *)
  one_step_solve (Puf.create nvars) (Parray.create nvars ISet.empty)


(* Transform the ast into a form usable during solving phases *)
and process = function
  | (nbvar, _), cllist -> nbvar, cllist
(* For now, we don't need any transformation *)
