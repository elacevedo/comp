# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include "tree.h"
#include "decaf.h"

int flage_print = 1; // use to tell where to print line number in printTree

struct ASTnode *newASTnode(char *nodeType, ASTnode *c1, ASTnode *c2, ASTnode *c3, ASTnode *c4, ASTnode *c5, int line) 
{
    ASTnode *node=( ASTnode * ) malloc ( sizeof ( ASTnode )); // store current new node
    if(node == NULL) {
        printf("unable to allocate memory for AST node\n");
        exit(0);
    }
    // printf("**** creating a node for %s\n", nodeType);

    node->name = nodeType;
    node->child1 = c1;
    node->child2 = c2;
    node->child3 = c3;
    node->child4 = c4;
    node->child5 = c5;
    
    if (c1 == NULL && c2 == NULL && c3 == NULL && c4 ==NULL && c5 == NULL){ 
        // when it is a ternimal, initialize its content
        char *temp;
        temp = (char * ) malloc ( sizeof ( char *) * 40);
        strcpy(temp, yytext);
        node->content = temp;
    }
    else
    {// if there is no content, initilize it to NULL
        node->content = NULL;
    }
    
    // initialize the line number of each AST node

    if (line == 0){
        node->lineNum = node->child1->lineNum;
    }
    else
    {
        node->lineNum = line;
    }
    
    return node;
}

void printTree(ASTnode *currNode)
{
    if(currNode != NULL)
    {
        // print content for certain AST node
        if (strcmp(currNode->name, "program") == 0){
            printf("\n   Program:\n");
        }
        if (strcmp(currNode->name, "fnDecl") == 0){
            printf("  %d   ", currNode->lineNum);
            printf("FnDecl: \n");
        }
        if (strcmp(currNode->name, "varDecl") == 0){
            printf("  %d   ", currNode->lineNum);
            printf("VarDecl: \n");
        }
        if (strcmp(currNode->name, "multiVars") == 0){
            printf("  %d   ", currNode->lineNum);
            printf("(formals) VarDecl: \n");
        }
        if (strcmp(currNode->name, "stmtBlock") == 0){
            printf("  %d   ", currNode->lineNum);
            printf("(body) StmtBlock: \n");
        }
        if (strcmp(currNode->name, "fnType") == 0){
            printf("         (return type) Type: %s\n", currNode->child1->name);
            if (currNode->child1->content != NULL){
                free(currNode->child1->content);
            }
            free(currNode->child1);
            currNode->child1 = NULL;
        }
        if (strcmp(currNode->name, "return") == 0){
            printf("         ReturnStmt:\n");
            if (currNode->child1->content != NULL){
                free(currNode->child1->content);
            }
            free(currNode->child1);
            currNode->child1 = NULL;
        }
        if (strcmp(currNode->name, "print") == 0){
            printf("         PrintStmt:\n");
            if (currNode->child1->content != NULL){
                free(currNode->child1->content);
            }
            free(currNode->child1);
            currNode->child1 = NULL;
        }
        if (strcmp(currNode->name, "type") == 0){
            printf("         Type: %s\n", currNode->child1->name);

            // delete the type node and free memory in case it run again
            if (currNode->child1->content != NULL){
                free(currNode->child1->content);
            }
            free(currNode->child1);
            currNode->child1 = NULL; // in case it run again
        }
        if (strcmp(currNode->name, "T_Identifier") == 0){
            printf("  %d", currNode->lineNum);
            printf("      Identifier: %s\n", currNode->content);
        }
        if (strcmp(currNode->name, "T_Print") == 0){
            printf("  %d", currNode->lineNum);
            printf("      (args) StringConstant: %s\n", currNode->content);
        }

        // recursive call to print
        if (currNode->child1 != NULL)
            printTree(currNode->child1);

        if (currNode->child2 != NULL)
            printTree(currNode->child2);

        if (currNode->child3 != NULL)
            printTree(currNode->child3);

        if (currNode->child4 != NULL)
            printTree(currNode->child4);

        if (currNode->child5 != NULL)
            printTree(currNode->child5);

        // free dynamic memory
        if (currNode->content != NULL){
            free(currNode->content);
        }
        free(currNode);
        currNode = NULL;
    }
    else 
        return;
}
