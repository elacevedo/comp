/*** definition section ***/
%{
    #include <stdio.h>
    #include <unistd.h>
    #include "tree.h"
    #include "parser_3.tab.h"
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
%type <astN> variableDecl variable type program fnDecl multiDecl decl 
%type <astN> stmtBlock //stmt //multiStmts //printStmt expr //formals

%left '(' ')'

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%% /*** define the language rules ***/

/* decl+ */
program: multiDecl {
           $$ = newASTnode("program", $1, emptyN, emptyN, emptyN, emptyN, Zero);
           printTree($$);
       };
multiDecl: multiDecl decl {
             $$ = newASTnode("multiDecl", $1, $2, emptyN, emptyN, emptyN, Zero);
         }
         | decl {
             $$ = newASTnode("multiDecl", $1, emptyN, emptyN, emptyN, emptyN, Zero);
         };
decl: variableDecl {
        $$ = newASTnode("decl", $1, emptyN, emptyN, emptyN, emptyN, Zero);
    }
    | fnDecl {
        $$ = newASTnode("decl", $1, emptyN, emptyN, emptyN, emptyN, Zero);
    };
variableDecl: variable
            {
                // printf("start constructing node: variableDecl\n");
                $$ = newASTnode("multiVars", $1, emptyN, emptyN, emptyN, emptyN, Zero);
                //printTree($$);
            }
            | variableDecl ',' variable {
                $$ = newASTnode("multiVars", $1, $3, emptyN, emptyN, emptyN, Zero);
            }
            | variable T_Semicolon {
                $$ = newASTnode("varDecl", $1, $2, emptyN, emptyN, emptyN, Zero);
            };
/*multiVars: multiVars variable {
             $$ = newASTnode("multiVars", $1, $2, emptyN, emptyN, emptyN, Zero);
         }
         | variable {
             $$ = newASTnode("multiVars", $1, emptyN, emptyN, emptyN, emptyN, Zero);
         };*/
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
    | T_Void
    {
       $$ = newASTnode("fnType", $1, emptyN, emptyN, emptyN, emptyN, Zero);
    };
fnDecl: type T_Identifier '(' ')' stmtBlock{
          $$ = newASTnode("fnDecl", $1, $2, $5, emptyN, emptyN, Zero);
      }
      | type T_Identifier '(' ')' T_Semicolon{
          $$ = newASTnode("fnDecl", $1, $2, $5, emptyN, emptyN, Zero);
      }
      ;
/*formals: variableDecl {
          $$ = newASTnode("formals", $1, emptyN, emptyN, emptyN, emptyN, Zero);
       };*/
stmtBlock: variableDecl {
            $$ = newASTnode("stmtBlock", $1, emptyN, emptyN, emptyN, emptyN, Zero);
         };
%% /*** c code section ***/
