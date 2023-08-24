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
%type <astN> variableDecl variable type program fnDecl multiDecl decl 
%type <astN> stmtBlock stmt multiStmts formals multiVars expr lValue //printStmt expr formals returnStmt //multiVars

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
variableDecl: variable T_Semicolon {
                $$ = newASTnode("varDecl", $1, $2, emptyN, emptyN, emptyN, Zero);
            }
;/*         | variable {
             $$ = newASTnode("multiVars", $1, emptyN, emptyN, emptyN, emptyN, Zero);
         }
         | variableDecl ',' variable {
             $$ = newASTnode("multiVars", $1, $3, emptyN, emptyN, emptyN, Zero);
         };*/
multiVars: variable {
             $$ = newASTnode("multiVars", $1, emptyN, emptyN, emptyN, emptyN, Zero);
         }
         | multiVars ',' variable {
             $$ = newASTnode("multiVars", $1, $3, emptyN, emptyN, emptyN, Zero);
         }
         | multiVars variable T_Semicolon {
             $$ = newASTnode("multiVars", $1, $2, emptyN, emptyN, emptyN, Zero);
         };
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
    }
    | T_Return {
       $$ = newASTnode("return", $1, emptyN, emptyN, emptyN, emptyN, Zero);
    }
/*    | T_Print {
       $$ = newASTnode("print", $1, emptyN, emptyN, emptyN, emptyN, Zero);
    }*/;
fnDecl: type T_Identifier formals stmtBlock{
          $$ = newASTnode("fnDecl", $1, $2, $3, $4, emptyN, Zero);
      }
      | type T_Identifier T_Semicolon{
          $$ = newASTnode("fnDecl", $1, $2, $3, emptyN, emptyN, Zero);
      }
      | type T_Identifier stmtBlock{
          $$ = newASTnode("fnDecl", $1, $2, $3, emptyN, emptyN, Zero);
      }
      | type T_Identifier formals T_Semicolon{
          $$ = newASTnode("fnDecl", $1, $2, $3, $4, emptyN, Zero);
      }
      ;
formals: '(' multiVars ')' {
          $$ = newASTnode("formals", $2, emptyN, emptyN, emptyN, emptyN, Zero);
       };
stmtBlock: multiStmts {
            $$ = newASTnode("stmtBlock", $1, emptyN, emptyN, emptyN, emptyN, Zero);
         };
multiStmts: stmt {
             $$ = newASTnode("stmt", $1, emptyN, emptyN, emptyN, emptyN, Zero);
          } 
          | multiStmts stmt {
            $$ = newASTnode("stmt", $1, $2, emptyN, emptyN, emptyN, Zero);
          };
stmt: variableDecl {
        $$ = newASTnode("stmt", $1, emptyN, emptyN, emptyN, emptyN, Zero);
     }
     | expr {
        $$ = newASTnode("stmt", $1, emptyN, emptyN, emptyN, emptyN, Zero);
     };
/*printStmt: T_Print expr {
            $$ = newASTnode("printStmt", $1, $2, emptyN, emptyN, emptyN, Zero);
         };
returnStmt: T_Return {
            $$ = newASTnode("returnStmt",  $1, emptyN, emptyN, emptyN, emptyN,Zero);
          };*/
expr: T_Identifier '=' expr T_Semicolon {
       $$ = newASTnode("expr", $1, $3, $4, emptyN, emptyN, Zero);
    };
%% /*** c code section ***/
