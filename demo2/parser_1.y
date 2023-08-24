%{
/* the part between %{ and %} contains the declarations of C  */
#include <stdio.h>
/* need to have these two declarations, otherwise it will get error */
int yylex();
void yyerror(const char* msg){}
%}

/*
the part between %} and %% is the definitions of bison
*/

/* %token is used to define any token you need: T_Int, T_Identifier, and so on, the scanner.l will include the parset.tab.h header file to use those tokens */

%token T_NUM

/* %left and %right are used to define the operator precedence */
%left '+' '-'
%left '*' '/'


%%

/* this part is used to match the grammar, and take actions.
 * : means can go to, | means or
 * for S : S E '\' rule:
 * means, S can go to S E '\n'
 * $$ means the value of S
 * $1 means the S
 * $2 means the E
 * $3 means '\n'
 */

S   :   S E '\n'    {printf("ans=%d\n",$2);}
    |   /*enpty*/   {/*enpty*/} 
    ;
E   :   E '+' E     {$$ = $1+$3;}
    |   E '-' E     {$$ = $1-$3;}
    |   E '*' E     {$$ = $1*$3;}
    |   E '/' E     {$$ = $1/$3;}
    |   T_NUM       {$$ = $1;}
    |   '(' E ')'   {$$ = $2;}
    ;
%%
/* C part functions*/
int main(){
    // use parser
    return yyparse();
}
