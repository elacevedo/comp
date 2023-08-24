all: prog

prog: scanner.l parser.y
	bison -d parser.y
	flex scanner.l
	gcc lex.yy.c parser.tab.c -o a.out

clean:
	rm parser.tab.c
	rm parser.tab.h
	rm lex.yy.c
	rm a.out
