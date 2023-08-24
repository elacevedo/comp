//To do
//String const
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

%token <astN> T_Identifier T_BoolConstant T_IntConstant T_DoubleConstant T_StringConstant

%token <astN> T_Semicolon
%type <astN> program fnDecl variableDecl variable type params stmtBlock stmt expr constant

%left '+' '-'
%left '*' '/' '%'
%left '(' ')'
%left '{' '}'

%% /*** define the language rules ***/

/* decl+ */
program: fnDecl {
                        $$ = newASTnode("program", $1, emptyN, emptyN, emptyN, emptyN, Zero);
                        printTree($$);
                 };

fnDecl: type T_Identifier '(' params ')' {
                        $$ = newASTnode("fnDecl", $1, $2, $4, emptyN, emptyN, Zero);
                     }
      | type T_Identifier '(' params ')' stmtBlock {
                        $$ = newASTnode("fnDecl", $1, $2, $4, $6, emptyN, Zero);
      };
params: variableDecl {
      $$ = newASTnode("param", $1, emptyN, emptyN, emptyN, emptyN, Zero);
   };
stmtBlock: '{' stmt '}' {
                $$ = newASTnode("stmtBlock", $2, emptyN, emptyN, emptyN, emptyN, Zero);
         };
stmt: variableDecl {
        $$ = newASTnode("stmt", $1, emptyN, emptyN, emptyN, emptyN, Zero);
    }
    | T_Print '(' expr ')' {
         $$ = newASTnode("printStmt", $1,  $3, emptyN, emptyN, emptyN, Zero);
    };

variableDecl: variable T_Semicolon 
            {
                // printf("start constructing node: variableDecl\n");
                $$ = newASTnode("varDecl", $1, $2, emptyN, emptyN, emptyN, Zero);
                //printTree($$);
            }
            | variableDecl ',' variable {
               $$ = newASTnode("params", $1, $3, emptyN, emptyN, emptyN, Zero);
            }
            | variable {
              $$ = newASTnode("params", $1, emptyN, emptyN, emptyN, emptyN, Zero);
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
    | T_Void
    {
       $$ = newASTnode("fnType", $1, emptyN, emptyN, emptyN, emptyN, Zero);
    };

expr: constant {
      $$ = newASTnode("expr", $1, emptyN, emptyN, emptyN, emptyN, Zero);
   }
;
constant: T_StringConstant {
       $$ = newASTnode("type", $1, emptyN, emptyN, emptyN, emptyN, Zero);
    };


%% /*** c code section ***/
