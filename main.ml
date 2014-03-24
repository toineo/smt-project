(* Entry point of the solver *)
open Operators


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

(* This function is not optimized, but for a printing function, that is not such a problem *)
let print_part eq nvars =
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
            Printf.printf "%d, " h1;
            print t
          | [h] ->
            vars_done.(h) <-  true;
            Printf.printf "%d}" h
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
    match
      Solver.solve $ Parser.main Lexer.token lexbuf
    with
    | None -> Printf.printf "Unsat\n"
    | Some (eq, nvars) ->
      (* print_tree eq nvars *)
      print_part eq (nvars + 1)

  with
  | e ->
    Printf.eprintf "Unexpected exception : %s\n" (Printexc.to_string e)
