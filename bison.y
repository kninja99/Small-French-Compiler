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
    ;

functions: function {printf("functions -> function\n");}
    | function functions {printf("functions -> function functions");}
    ;

function: FUNCTION IDENTIFIER STARTPAREN args CLOSEPAREN STARTBRACKET statements CLOSEBRACKET {printf("function -> FUNCTION IDENTIFIER STARTPAREN args CLOSEPAREN STARTBRACKET statement CLOSEBRACKET\n");}
    ;

args: arg {printf("args -> arg\n");}
    | arg COMMA args {printf("args -> arg COMMA args\n");}
    | %empty /* epsilon */ {printf("args -> epsilon\n");}
    ;

arg: INTEGER IDENTIFIER {printf("arg -> INTEGER IDENTIFIER\n");}
    | IDENTIFIER {printf("arg -> IDENTIFIER\n");}
    ;

statements: %empty /* epsilon */ {printf("statements -> epsilon\n");}
    | statement ENDLINE statements {printf("statements -> statement ENDLINE statements\n");}
    ;

statement: declaration {printf("statement -> declaration\n");}
    | function_call {printf("statement -> function_call\n");}
    | assignment {printf("statement -> assignment\n");}
    | io {printf("statement -> io\n");}
    ;

declaration: INTEGER IDENTIFIER {printf("declaration -> INTEGER IDENTIFIER\n");}
    ;

function_call: IDENTIFIER STARTPAREN args CLOSEPAREN {printf("function_call -> IDENTIFIER STARTPAREN args CLOSEPAREN\n");}
    ;

assignment: IDENTIFIER ASSIGNMENT NUMBER {printf("assignment -> IDENTIFIER ASSIGNMENT NUMBER\n");}
    | declaration ASSIGNMENT NUMBER {printf("assignment -> declaration ASSIGNMENT NUMBER\n");}
    | IDENTIFIER ASSIGNMENT function_call {printf("assignment -> IDENTIFIER ASSIGNMENT function_call\n");}
    | declaration ASSIGNMENT function_call {printf("assignment -> declaration ASSIGNMENT function_call\n");}
    ;

io: OUTPUT IDENTIFIER {printf("io -> OUTPUT IDENTIFIER\n");}
    | INPUT IDENTIFIER {printf("io -> INPUT IDENTIFIER\n");}
    ;
%%
main(int argc, char *argv[]){
    FILE *fp = fopen(argv[1],"r");
    yyin = fp;
    yyparse();
}
int yyerror(){}