(* Entry point of the solver *)
open Operators


(* TODO: better display *)
let print_equalities eq nvars tr =
  for i = 0 to nvars - 1 do
    Printf.printf "%d = %d\n" (tr i) (tr $ Puf.find eq i)
  done

let print_tree eq nvars tr =
  for i = 0 to nvars - 1do
    let k = ref 0 in
    for j = 0 to nvars do
      if (((Puf.find eq j) == i) && (i != j))
      then
	    begin
	      k := !k+1;
	      if (!k == 1)
	      then
	        Printf.printf "%d\n" $ tr i;
	      Printf.printf "|= %d\n" $ tr j
	    end
    done;
    if (!k == 1) then Printf.printf "\n"
  done

(* This function is not optimized, but for a printing function, that is not such a problem *)
let print_part eq nvars tr =
  let vars_done = Array.make nvars false
  in

  let get_all repr =
    let rec f cur =
      if cur >= nvars then []
      else
        if Puf.find eq cur = repr then
          cur :: f (cur + 1)
        else
          f (cur + 1)
    in
    f 0
  in

  let rec process n =
    if n >= nvars then ()
    else
      if vars_done.(n) = false
      then
        let part = get_all (Puf.find eq n)
        in

        let rec print = function
          | h1 :: ((h2 :: _ ) as t) ->
            vars_done.(h1) <- true;
            Printf.printf "%d, " $ tr h1;
            print t
          | [h] ->
            vars_done.(h) <-  true;
            Printf.printf "%d}" $ tr h
          | _ -> assert false
        in

        Printf.printf "{";
        print part;
        Printf.printf "\n";
        process (n + 1)
      else
        process (n + 1)
  in

  process 0



let _ =
  if Array.length Sys.argv < 2 then
    begin
      Printf.printf "Error: no input file given\n";
      exit 1
    end;

  let filename = Sys.argv.(1)
  in
  try
    let input_file = open_in filename
    in
    let lexbuf = Lexing.from_channel input_file
    in
    let ast = Parser.main Lexer.token lexbuf
    in
    let norm_ast, inv = ASTUtils.remap ast
    in
    match
      Solver.solve norm_ast
    with
    | None, _ -> Printf.printf "Unsat\n"
    | Some eq, nvars ->
      (* print_equalities eq nvars (ASTUtils.remap_inverse_var inv) *)
      (* print_tree eq nvars (ASTUtils.remap_inverse_var inv) *)
      print_part eq nvars (ASTUtils.remap_inverse_var inv)

  with
  | e ->
    Printf.eprintf "Unexpected exception : %s\n" (Printexc.to_string e)
