#include "parser.tab.h"
extern int num_lines; // used in .l file
extern int num_cols; // used in .l file
extern int flage_print; // used in tree.c
extern char *yytext;
void yyerror(char *s);
extern int yylex(void);
extern FILE *fileIn;

// the struct of ast node
typedef struct ASTnode {
    int lineNum;
    char *name;
    struct ASTnode *child1;
    struct ASTnode *child2;
    struct ASTnode *child3;
    struct ASTnode *child4;
    struct ASTnode *child5; // at most a node has 5 children
    char *content;
}ASTnode;

// prototypes
struct ASTnode *newASTnode(char* nodeType, ASTnode *c1, ASTnode *c2, ASTnode *c3, ASTnode *c4, ASTnode *c5, int line);
void printTree(ASTnode *currNode);

