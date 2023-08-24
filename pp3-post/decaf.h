#include "parser.tab.h"

extern int num_lines;
extern int num_cols;
extern char *yytext;
void yyerror(char *s);
extern int yylex(void);

typedef struct Instruction {
   int lineNum;
   char *op;
   char *dest;
   char *reg1;
   char *reg2;
   int offset;
   int base;
   struct Instruction *next;
}Instruction;

struct Instruction *newInstruction(char* opcode, char* destination, char* r1, char* r2, int offsetNum, int baseNum, Instruction *nextInstruction, int line);
void printInstruction(Instruction *currInstruction);
