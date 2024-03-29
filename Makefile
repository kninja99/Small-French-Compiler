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
	g++ -std=c++11 -o parser bison.tab.c lex.yy.c  -lfl
	./parser testInput/minFiles/add.ppf > output.txt

math: lex.yy.c bison.tab.c bison.tab.h
	g++ -std=c++11 -o parser bison.tab.c lex.yy.c  -lfl
	./parser testInput/minFiles/math.ppf > output.txt

function: lex.yy.c bison.tab.c bison.tab.h
	g++ -std=c++11 -o parser bison.tab.c lex.yy.c  -lfl
	./parser testInput/minFiles/function.ppf > output.txt

array: lex.yy.c bison.tab.c bison.tab.h
	g++ -std=c++11 -o parser bison.tab.c lex.yy.c  -lfl
	./parser testInput/minFiles/array.ppf > output.txt

loop: lex.yy.c bison.tab.c bison.tab.h
	g++ -std=c++11 -o parser bison.tab.c lex.yy.c  -lfl
	./parser testInput/minFiles/loop.ppf > output.txt

embeddedLoop: lex.yy.c bison.tab.c bison.tab.h
	g++ -std=c++11 -o parser bison.tab.c lex.yy.c  -lfl
	./parser testInput/minFiles/nestedLoop.ppf > output.txt

break: lex.yy.c bison.tab.c bison.tab.h
	g++ -std=c++11 -o parser bison.tab.c lex.yy.c  -lfl
	./parser testInput/minFiles/break.ppf > output.txt

ifelse: lex.yy.c bison.tab.c bison.tab.h
	g++ -std=c++11 -o parser bison.tab.c lex.yy.c  -lfl
	./parser testInput/minFiles/ifelse.ppf > output.txt
	
test: lex.yy.c bison.tab.c bison.tab.h
	g++ -std=c++11 -o parser bison.tab.c lex.yy.c  -lfl
	./parser testInput/testfile.ppf > output.txt
clean: 
	rm parser bison.tab.c lex.yy.c bison.tab.h bison.output
