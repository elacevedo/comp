/*** definition section ***/
%{
    #include <stdio.h>
    #include <unistd.h>
    #include "tree.h"
    #include "parser.tab.h"
    int yylex();
    ASTnode *emptyN = NULL;
    int Zero = 0;
%}

%union{
  struct ASTnode *astN;
  double d;
}
/*** define the type of terminals and nonterminals ***/
%token <astN> T_Int T_Double T_Bool
%token <astN> T_String
%token <astN> T_Identifier
%token <astN> T_Semicolon
%type <astN> variableDecl variable type


%% /*** define the language rules ***/

/* decl+ */
variableDecl: variable T_Semicolon 
            {
                // printf("start constructing node: variableDecl\n");
                $$ = newASTnode("varDecl", $1, $2, emptyN, emptyN, emptyN, Zero);
                printTree($$);
            }
;
variable: type T_Identifier 
        {
            // printf("start constructing node: variable\n");
            $$ = newASTnode("variable", $1, $2, emptyN, emptyN, emptyN, Zero);
        }
;
type: T_Int 
    {
        // printf("start constructing node: type - int\n");
        $$ = newASTnode("type", $1, emptyN, emptyN, emptyN, emptyN, Zero);
    }
    | T_Double 
    {
        // printf("start constructing node: type - double\n");
        $$ = newASTnode("type",  $1, emptyN, emptyN, emptyN, emptyN, Zero);
    }
    | T_Bool 
    {
        // printf("start constructing node: type - bool\n");
        $$ = newASTnode("type",  $1, emptyN, emptyN, emptyN, emptyN, Zero);
    }
    | T_String 
    {
        // printf("start constructing node: type - string\n");
        $$ = newASTnode("type",  $1, emptyN, emptyN, emptyN, emptyN,Zero);
    }
;
%% /*** c code section ***/
