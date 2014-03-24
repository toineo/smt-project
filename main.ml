(* Entry point of the solver *)
open Operators
(* open Puf *)



(* tests Union Find*)

(* let t = create 10 *)
(* let () = Printf.printf "%b\n" (find t 0 <> find t 1) *)
(* let t = union t 0 1 *)
(* let () = Printf.printf "%b\n" (find t 0 = find t 1) *)
(* let () = Printf.printf "%b\n" (find t 0 <> find t 2) *)
(* let t = union t 2 3 *)
(* let t = union t 0 3 *)
(* let () = Printf.printf "%b\n" (find t 1 = find t 2) *)
(* let t = union t 4 4 *)
(* let () = Printf.printf "%b\n" (find t 4 <> find t 3) *)
(* let () = Printf.printf "%b\n" (find t 4 = find t 3) *)




(* TODO: better display *)
let print_uf eq nvars =
  for i = 0 to nvars do
    Printf.printf "%d = %d\n" i (Puf.find eq i)
  done





let _ =
  if Array.length Sys.argv < 2 then
    begin
      Printf.printf "Error: no input file given\n";
      exit 1
    end;

  let filename = Sys.argv.(1)
  in


  let input_file = open_in filename
  in
  let lexbuf = Lexing.from_channel input_file
  in

  match
    Solver.solve $ Parser.main Lexer.token lexbuf
  with
  | None -> Printf.printf "Unsat\n"
  | Some (eq, nvars) ->
    print_uf eq nvars

(* TODO: catch exceptions (file opening, etc) *)
