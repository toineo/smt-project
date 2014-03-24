{
  open Parser
}


rule token = parse
| [' ' '\t']
    { token lexbuf }
| '\n'+
    { TNewLine }
| eof
    { TEOF }


(* We don't need a real management of words *)
| 'p'
    { TP }
| "cnf"
    { TCNF }
| 'c'
    { comment_line lexbuf }



(* Numbas *)
| ['0' - '9']+ as n
    { TInt (int_of_string n) }



(* Equality operators *)
| '='
    { TEqual }
| "<>"
    { TDifferent }



and comment_line = parse
| '\n'
    { token lexbuf }
| _
    { comment_line lexbuf }


{

}
