

int main(int argc, char** argv) {
   if ( argc > 1 ) {
      stdin = fopen( argv[1], "r");
      fileIn = fopen( argv[1], "r" );
   }
   else {
      printf("please type in file name\n");
   }
   yyparse();
   return 0;
}
