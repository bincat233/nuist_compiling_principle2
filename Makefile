all: clean doyacc dolex asciidoc.out

doyacc:
	bison -d parser.y -o y.tab.c

dolex:
	flex lexical.l

testlex:
	flex -D DEBUG -olexical.l.c lexical.l
	gcc lexical.l.c -ll -olexical.out

asciidoc.out: y.tab.c lex.yy.c
	gcc y.tab.c lex.yy.c -ly -ll -o ascii.out

..c.o:
	gcc -c $< -g

clean:
	rm -rf *.o
	rm -f *.y.c *.y.output *.l.c *.out
