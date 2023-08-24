all: prog

prog: scanner.l parser.y tree.h
	lex scanner.l
	bison -d parser.y
	gcc parser.tab.c lex.yy.c tree.c -o a.out

clean:
	rm parser.tab.c
	rm parser.tab.h
	rm lex.yy.c
	rm a.out

