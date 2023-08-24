# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include "decaf.h"

FILE *fileIn = NULL;

struct Instruction *newInstruction(char* opcode, char* destination, char* r1, char* r2, int offsetNum, int baseNum, Instruction *nextInstruction, int line) {
   Instruction *node = (Instruction *) malloc (sizeof(Instruction));
   if(node == NULL) {
      printf("unable to allocate memory for AST node\n");
      exit(0);
   }

   node->op = opcode;
   node->dest = destination;
   node->reg1 = r1;
   node->reg2 = r2;
   node->offset = offsetNum;
   node->base = baseNum;
   node->next = nextInstruction;
   node->lineNum = line;

   return node;
}

void printInstruction(Instruction *currInstruction) {
   if(currInstruction != NULL) {
   
      if(currInstruction->next != NULL)
         printInstruction(currInstruction->next);
   
      free(currInstruction);
      currInstruction = NULL;
   }
   else
      return;
}

void yyerror(char *s) {
}

int main(int argc, char** argv)
{
    // start parsing
    if ( argc > 1 ) {
            stdin = fopen( argv[1], "r" );
            fileIn = fopen( argv[1], "r" );
            // printf("open file sucessed\n");
    }
    else{
        printf("please type in file name\n");
    }
    yyparse();
    return 0;
}
