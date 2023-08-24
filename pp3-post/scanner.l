/*** definition sec ***/
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #include "tree.h"
    #include "parser.tab.h"
    ASTnode *epN = NULL;
    int num_lines = 1;
    int num_cols = 1;
%}

/* an identifier has letters, digits, and underscores and start with letters*/
IDENTIFIER  [a-zA-Z][_a-zA-Z0-9]*

INT_DEX     [0-9]+
INT_HEX     [0][xX][0-9a-fA-F]+
DOUBLE_CONS {INT_DEX}[.][0-9]*
DOUBLE_CONS_E {INT_DEX}[.][0-9]*[eE][+][0-9]*[1-9]+[0-9]*
OPERATOR      ([+\-*/%=<>\\,.!()\[\]])

/* a string has any character except for \n and "*/
STRING      ["][^\n\"]*["]
WRONGSTR    ["][^\n\"]*


/* single comment contains ^\n - any character except for \n*/
COMMENT1    [/][/][^\n]*
%x COMMENT

%% /* generate an ast node if a terminal is matched, and send it to parser */
";" {
    // printf("%s \t\t line %d cols %d", yytext, num_lines, num_cols);
    // printf("-%d is \'%s\'\n", num_cols, yytext);
    
    num_cols++;
    yylval.astN = newASTnode("T_Semicolon", epN, epN, epN, epN, epN, num_lines);
    return T_Semicolon;
}

"void" {

    // printf("%s \t\t line %d cols %d", yytext, num_lines, num_cols);
    num_cols += (yyleng-1);
    // printf("-%d is T_Void\n", num_cols);
    num_cols++;
    yylval.astN = newASTnode("void", epN, epN, epN, epN, epN, num_lines);
    return T_Void;
}

"Print("{STRING}");" {

    // printf("%s \t\t line %d cols %d", yytext, num_lines, num_cols);
    num_cols += (yyleng-1);
    // printf("-%d is T_Void\n", num_cols);
    num_cols++;
    yylval.astN = newASTnode("T_Print", epN, epN, epN, epN, epN, num_lines);
    return T_Print;
}

"return" {

    // printf("%s \t\t line %d cols %d", yytext, num_lines, num_cols);
    num_cols += (yyleng-1);
    // printf("-%d is T_Void\n", num_cols);
    num_cols++;
    yylval.astN = newASTnode("return", epN, epN, epN, epN, epN, num_lines);
    return T_Return;
}

"int" {
    
    // printf("%s \t\t line %d cols %d", yytext, num_lines, num_cols);
    num_cols += (yyleng-1);
    // printf("-%d is T_Int\n", num_cols);
    num_cols++;
    yylval.astN = newASTnode("int", epN, epN, epN, epN, epN, num_lines);
    return T_Int;
}
"double" {
    
    // printf("%s \t\t line %d cols %d", yytext, num_lines, num_cols);
    num_cols += (yyleng-1);
    // printf("-%d is T_Double\n", num_cols);
    num_cols++;
    yylval.astN = newASTnode("double", epN, epN, epN, epN, epN, num_lines);
    return T_Double;
}
"bool" {
    
    // printf("%s \t\t line %d cols %d", yytext, num_lines, num_cols);
    num_cols += (yyleng-1);
    // printf("-%d is T_Bool\n", num_cols);
    num_cols++;
    yylval.astN = newASTnode("bool", epN, epN, epN, epN, epN, num_lines);
    return T_Bool;
}
"string" {
    
    // printf("%s \t\t line %d cols %d", yytext, num_lines, num_cols);
    num_cols += (yyleng-1);
    // printf("-%d is T_String\n", num_cols);
    num_cols++;
    yylval.astN = newASTnode("string", epN, epN, epN, epN, epN, num_lines);
    return T_String;
}

{OPERATOR} {
    num_cols += (yyleng-1);
    num_cols++;
}

{IDENTIFIER} {
    if (yyleng < 32){
        
        // printf("%s \t\t line %d cols %d", yytext, num_lines, num_cols);
        num_cols += (yyleng-1);
        // printf("-%d is T_Identifier\n", num_cols);
        num_cols++;
    }
    else {
        
        // printf("\n*** Error line %d.\n", num_lines);
        // printf("*** Identifier too long: \"%s\"\n\n", yytext);
        // printf("%s line %d cols %d", yytext, num_lines, num_cols);
        num_cols += (yyleng-1);
        // printf("-%d is T_Identifier", num_cols);
        num_cols++;
        // printf("(truncated to %.*s)\n", 31, yytext);
    }
    yylval.astN = newASTnode("T_Identifier", epN, epN, epN, epN, epN, num_lines);
    return T_Identifier;
}
{INT_DEX}+ {
    num_cols += (yyleng-1);
    num_cols++;
    yylval.astN = newASTnode("T_Identifier", epN, epN, epN, epN, epN, num_lines);
    return atoi(yytext);
}
{WRONGSTR} {
    
    // printf("\n*** Error line %d.\n", num_lines);
    // printf("*** Unterminated string constant: %s\n\n", yytext);
}
{COMMENT1} {
    
}
" "|\t {
    
    num_cols++;
}
\n {
    
    num_lines++;
    num_cols=1;
}
.  {
    
    num_cols++;
}
<<EOF>> return 0;



%%
int yywrap(){

}
