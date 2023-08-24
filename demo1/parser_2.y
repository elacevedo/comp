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
%token <astN> T_Int T_Double T_Bool T_String T_Void T_Print
%token <astN> T_LessEqual T_GreaterEqual T_Equal T_NotEqual
%token <astN> T_While T_For T_If T_Else T_Return T_Break
%token <astN> T_And T_Or

%token <astN> T_Identifier

%token <astN> T_Semicolon
%type <astN> variableDecl variable type program fnDecl


%% /*** define the language rules ***/

/* decl+ */
program: variableDecl {
           $$ = newASTnode("program", $1, emptyN, emptyN, emptyN, emptyN, Zero);
           printTree($$);
       }
       | fnDecl {
           $$ = newASTnode("program", $1, emptyN, emptyN, emptyN, emptyN, Zero);
           printTree($$);
       };
fnDecl: type T_Identifier {
          $$ = newASTnode("fnDecl", $1, $2, emptyN, emptyN, emptyN, Zero);
      };

variableDecl: variable T_Semicolon 
            {
                // printf("start constructing node: variableDecl\n");
                $$ = newASTnode("varDecl", $1, $2, emptyN, emptyN, emptyN, Zero);
                //printTree($$);
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
