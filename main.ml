(* Entry point of the solver *)
open Operators
(* open Puf *)

(* TODO: better display *)
let print_uf eq nvars =
  for i = 0 to nvars do
    Printf.printf "%d = %d\n" i (Puf.find eq i)
  done

let print_tree eq nvars =
  for i = 0 to nvars do 
    let k = ref 0 in
    for j = 0 to nvars do 
      if (((Puf.find eq j) == i) && (i != j)) 
      then
	begin
	  k := !k+1;
	  if (!k == 1)
	  then
	    Printf.printf "%d\n" i;
	  Printf.printf "|= %d\n" j
	end
    done;
    if (!k == 1) then Printf.printf "\n"
  done

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
    match
      Solver.solve $ Parser.main Lexer.token lexbuf
    with
    | None -> Printf.printf "Unsat\n"
    | Some (eq, nvars) ->
      print_tree eq nvars

  with
  | e ->
    Printf.eprintf "Unexpected exception : %s\n" (Printexc.to_string e) 
