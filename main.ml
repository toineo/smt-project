(* Entry point of the solver *)
open Operators


let filename = Sys.argv.(1)


let main () =
  let input_file = open_in filename 
  in
  let lexbuf = Lexing.from_channel input_file
  in

  Solver.solve $ Parser.main Lexer.token lexbuf
    (* TODO: catch exceptions *)
