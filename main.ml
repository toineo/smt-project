(* Entry point of the solver *)
open Operators
open Puf

let filename = Sys.argv.(1)


let main () =
  let input_file = open_in filename 
  in
  let lexbuf = Lexing.from_channel input_file
  in
  Solver.solve $ Parser.main Lexer.token lexbuf
    (* TODO: catch exceptions *)


(* tests Union Find*)
let t = create 10
let () = Printf.printf "%b\n" (find t 0 <> find t 1)
let t = union t 0 1
let () = Printf.printf "%b\n" (find t 0 = find t 1)
let () = Printf.printf "%b\n" (find t 0 <> find t 2)
let t = union t 2 3
let t = union t 0 3
let () = Printf.printf "%b\n" (find t 1 = find t 2)
let t = union t 4 4
let () = Printf.printf "%b\n" (find t 4 <> find t 3)
let () = Printf.printf "%b\n" (find t 4 = find t 3)
