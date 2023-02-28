run:
	lex mini_l.lex
	gcc -o lexer lex.yy.c -lfl
	./lexer test_input.txt
bison:
	flex mini_l.lex
	bison -v -d --file-prefix=y bison.y
	gcc -o parser lex.yy.c y.tab.c -lfl
	./parser testInput/factorial.ppf
clean:
	rm parser
