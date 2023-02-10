%{
#include <stdio.h>
extern FILE* yyin;
extern int lineNum;
extern int charPos;
%}

%start prog_start
%token NUMBER STARTBRACKET CLOSEBRACKET STARTPAREN CLOSEPAREN INTEGER ADD SUBTRACT DIVIDE MULTIPLICATION ASSIGNMENT LESSTHAN GREATERTHAN EQUAL NOTEQUAL LESSTHANEQUAL GREATERTHANEQUAL OUTPUT INPUT DO WHILE RETURN FUNCTION ELSE IF ENDLINE TRUE FALSE IDENTIFIER

%%
prog_start: %empty /* epsilon */ {printf("prog_start-> epsilon");}
    | functions {printf("prog_start-> FUNCTIONS\n");}

functions: function {printf("functions -> function\n");}
    | function functions {printf("functions -> function functions");}

function: FUNCTION {printf("functions -> FUNCTION\n");}
%%
main(int argc, char *argv[]){
    FILE *fp = fopen(argv[1],"r");
    yyin = fp;
    yyparse();
}
int yyerror(){}