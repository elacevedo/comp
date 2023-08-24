all: prog

prog: scanner.l parser_3.y tree.h
	lex scanner.l
	bison -d parser_3.y
	gcc parser_3.tab.c lex.yy.c tree.c -o a.out

clean:
	rm parser_3.tab.c
	rm parser_3.tab.h
	rm lex.yy.c
	rm a.out

