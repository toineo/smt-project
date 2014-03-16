%{
  open Operators
  open ASTUtils

(* TODO: 
   For now, we accept whitespaces in source file; is it ok?
   For instance, the following clause is accepted:
   1 = 2 3<>  4

   Also, we do accept comments about anywhere in the file; is it a problem?
*)
%}

%token TComment
%token TP TCNF
%token <int> TInt
%token TEqual TDifferent
%token TNewLine
%token TEOF


%start <AST.ast> main


%%

main:
| s = spec   cls = clauses TEOF
    { s, cls }

spec:
| TP TCNF  nbvars = TInt  nbclauses = TInt
    { nbvars, nbclauses }


clauses:
| l = separated_list(TNewLine, clause)
    { l }


clause:
| l = list(eq_literal)
    { l }


eq_literal:
| v1 = TInt  op = eq_operator  v2 = TInt
    { op $ couple_var v1 v2 }


eq_operator:
| TEqual     { equality   }
| TDifferent { difference }
