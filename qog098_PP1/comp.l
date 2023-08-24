%{
#include <math.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int num_lines = 1, col_end = 0, col_start = 1;
int numDigits(int num);

%}

DIGIT   [0-9]
ID      "_"*[a-zA-Z]"_"*[a-zA-Z0-9]*"_"*
DOUBLE  {DIGIT}+"."{DIGIT}*
STRING  " "*.*" "*

%%

\n   ++num_lines; col_start = 1;

("//")+{STRING}*
"/*"([^*]|(\*+[^*/]))*\*+\/

true|false   { col_end = col_start + strlen(yytext) - 1;
              fprintf(yyout, "%s line %d cols %d-%d is %s (value = %s)\n", yytext, num_lines, col_start, col_end, "T_BoolConstant", yytext);
              col_start += strlen(yytext); }
void         { col_end = col_start + strlen(yytext) - 1;
               fprintf(yyout, "%s line %d cols %d-%d is %s\n", yytext, num_lines, col_start, col_end, "T_Void");
               col_start += strlen(yytext); }
int          { col_end = col_start + strlen(yytext) - 1;
               fprintf(yyout, "%s line %d cols %d-%d is %s\n", yytext, num_lines, col_start, col_end, "T_Int");
               col_start += strlen(yytext); }
double       { col_end = col_start + strlen(yytext) - 1;
               fprintf(yyout, "%s line %d cols %d-%d is %s\n", yytext, num_lines, col_start, col_end, "T_Double");
               col_start += strlen(yytext); }
string       { col_end = col_start + strlen(yytext) - 1;
               fprintf(yyout, "%s line %d cols %d-%d is %s\n", yytext, num_lines, col_start, col_end, "T_String");
               col_start += strlen(yytext); }
while        { col_end = col_start + strlen(yytext) - 1;
               fprintf(yyout, "%s line %d cols %d-%d is %s\n", yytext, num_lines, col_start, col_end, "T_While");
               col_start += strlen(yytext); }
if           { col_end = col_start + strlen(yytext) - 1;
               fprintf(yyout, "%s line %d cols %d-%d is %s\n", yytext, num_lines, col_start, col_end, "T_If");
               col_start += strlen(yytext); }
else         { col_end = col_start + strlen(yytext) - 1;
               fprintf(yyout, "%s line %d cols %d-%d is %s\n", yytext, num_lines, col_start, col_end, "T_Else");
               col_start += strlen(yytext); }
return       { col_end = col_start + strlen(yytext) - 1;
               fprintf(yyout, "%s line %d cols %d-%d is %s\n", yytext, num_lines, col_start, col_end, "T_Return");
               col_start += strlen(yytext); }
break        { col_end = col_start + strlen(yytext) - 1;
               fprintf(yyout, "%s line %d cols %d-%d is %s\n", yytext, num_lines, col_start, col_end, "T_Break");
               col_start += strlen(yytext); }
"+"|"-"|"*"|"/"|"<"|">"|"="|";"|","|"!"|"{"|"}"|"("|")" { col_end = col_start + strlen(yytext) - 1;
                         fprintf(yyout, "%s line %d cols %d-%d is '%s'\n", yytext, num_lines, col_start, col_end, yytext);
                         col_start += strlen(yytext); }
"||"         { col_end = col_start + strlen(yytext) - 1;
               fprintf(yyout, "%s line %d cols %d-%d is %s\n", yytext, num_lines, col_start, col_end, "T_Or");
               col_start += strlen(yytext); }
"<="         { col_end = col_start + strlen(yytext) - 1;
               fprintf(yyout, "%s line %d cols %d-%d is %s\n", yytext, num_lines, col_start, col_end, "T_LessEqual");
               col_start += strlen(yytext); }
">="         { col_end = col_start + strlen(yytext) - 1;
               fprintf(yyout, "%s line %d cols %d-%d is %s\n", yytext, num_lines, col_start, col_end, "T_GreaterEqual");
               col_start += strlen(yytext); }
"=="         { col_end = col_start + strlen(yytext) - 1;
               fprintf(yyout, "%s line %d cols %d-%d is %s\n", yytext, num_lines, col_start, col_end, "T_Equal");
               col_start += strlen(yytext); }

["]([^"\n]|\\.)*["]{0,1} { col_end = col_start + strlen(yytext) - 1;
                       char *error;
                       error = strrchr(yytext, '\"');
                       if( error-yytext == 0 ) {
                          fprintf(yyout, "\n*** Error line %d.\n", num_lines);
                          fprintf(yyout, "*** Unterminated string constant: %s\n\n", yytext);
                       }
                       else {
                          fprintf(yyout, "%s line %d cols %d-%d is %s (value = %s)\n", yytext, num_lines, col_start, col_end, "T_StringConstant", yytext); }
                       col_start += strlen(yytext); }

{ID}+        { col_end = col_start + strlen(yytext) - 1;
               if( strlen(yytext) > 32 ) {
                  int len = strlen(yytext);
                  char *ptr;
                  ptr = yytext;
                  fprintf(yyout, "\n*** Error line %d.\n*** Indentifier too long: \"%s\"\n\n", num_lines, yytext);
                  ptr[31] = '\0';
                  fprintf(yyout, "%s line %d cols %d-%d is %s (truncated to %s)\n", yytext, num_lines, col_start, col_end, "T_Identifier", ptr);
                  col_start += len; }
               else {
                  fprintf(yyout, "%s line %d cols %d-%d is %s\n", yytext, num_lines, col_start, col_end, "T_Identifier");
                  col_start += strlen(yytext); }
               }

{DIGIT}+     { int digits = numDigits( atoi(yytext) );
               col_end = digits + col_start - 1;
               fprintf(yyout, "%s line %d cols %d-%d is %s (value = %d)\n", yytext, num_lines, col_start, col_end, "T_IntConstant", atoi(yytext));
               col_start += digits; }
{DOUBLE}     { col_end = col_start + strlen(yytext) - 1;
               char *eptr;
               double value = strtod(yytext, &eptr);
               fprintf(yyout, "%s line %d cols %d-%d is %s (value = %0.2f)\n", yytext, num_lines, col_start, col_end, "T_DoubleConstant", value);
               col_start += strlen(yytext); }
{DOUBLE}(E|e)("+"|"-"){DIGIT}* { col_end = col_start + strlen(yytext) - 1;
                                 char *eptr;
                                 int value = strtod(yytext, &eptr);
                                 fprintf(yyout, "%s line %d cols %d-%d is %s (value = %d)\n", yytext, num_lines, col_start, col_end, "T_DoubleConstant", value);
                                 col_start += strlen(yytext); }
[ \t]+
.   { fprintf(yyout, "\n*** Error line %d.\n", num_lines);
      fprintf(yyout, "*** Unrecognized char: '%s'\n", yytext); }

<<EOF>> return 0;
%%

//User Code
int yywrap(){}
int numDigits(int num) {
   int remainder = 1;
   if (num < 0) num = (num == INT_MIN) ? INT_MAX: -num;
   while (num > 9) {
      num /= 10;
      remainder++;
   }
   return remainder;
}

int main(int argc, char *argv[]){
   yyin = fopen(argv[1], "r");
   yyout = fopen(argv[2], "w");
   yylex();
   fclose(yyin);
   return 0;
}
