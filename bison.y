%{
#include <stdio.h>
extern FILE* yyin;
extern int lineNum;
extern int charPos;
%}

%start prog_start
%token NUMBER STARTBRACKET CLOSEBRACKET STARTPAREN CLOSEPAREN INTEGER ADD SUBTRACT DIVIDE MULTIPLICATION ASSIGNMENT LESSTHAN GREATERTHAN EQUAL NOTEQUAL LESSTHANEQUAL GREATERTHANEQUAL OUTPUT INPUT DO WHILE RETURN FUNCTION ELSE IF ENDLINE TRUE FALSE IDENTIFIER COMMA

%%
prog_start: %empty /* epsilon */ {printf("prog_start-> epsilon");}
    | functions {printf("prog_start-> functions\n");}

functions: function {printf("functions -> function\n");}
    | function functions {printf("functions -> function functions");}

function: FUNCTION IDENTIFIER STARTPAREN CLOSEPAREN {printf("function -> FUNCTION IDENTIFIER STARTPAREN CLOSEPAREN\n");}
    | FUNCTION IDENTIFIER STARTPAREN args CLOSEPAREN {printf("function -> FUNCTION IDENTIFIER STARTPAREN args CLOSEPAREN\n");}

args: arg {printf("args -> arg\n");}
    | arg COMMA args {printf("args -> arg COMMA args\n");}

arg: INTEGER IDENTIFIER {printf("arg -> INTEGER IDENTIFIER\n");}
%%
main(int argc, char *argv[]){
    FILE *fp = fopen(argv[1],"r");
    yyin = fp;
    yyparse();
}
int yyerror(){}