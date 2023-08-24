%{
# include "parser.tab.h"
%}

%%
[0-9]+  {yylval = atoi(yytext);return T_NUM;}
[-/+*()^\n]     {return yytext[0];}
[ \t\r\a]+      {/*ignore all space*/}
.       {return 0;}
%%
int yywrap(void){
    return 1;
}

