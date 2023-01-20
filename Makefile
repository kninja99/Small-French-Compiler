run:
	lex mini_l.lex
	gcc -o lexer lex.yy.c -lfl
	./lexer test_input.txt
clean:
	rm lex.yy.c
	rm lexer