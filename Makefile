run:
	lex mini_l.lex
	gcc -o lexer lex.yy.c -lfl
	./lexer test_input.txt
bison:
	flex mini_l.lex
	bison -v -d --file-prefix=y bison.y
	gcc -o parser lex.yy.c y.tab.c -lfl
	./parser testInput/factorial.ppf

bison.tab.c bison.tab.h: bison.y
	bison -t -v -d bison.y

lex.yy.c: mini_l.lex bison.tab.h
	flex mini_l.lex

add: lex.yy.c bison.tab.c bison.tab.h
	g++ -o parser bison.tab.c lex.yy.c  -lfl
	./parser testInput/minFiles/add.min
	
test: lex.yy.c bison.tab.c bison.tab.h
	g++ -o parser bison.tab.c lex.yy.c  -lfl
	./parser testInput/testfile.ppf
clean:
	rm parser bison.tab.c lex.yy.c bison.tab.h bison.output
