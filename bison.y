%{
#include <stdio.h>
extern FILE* yyin;
extern int lineNum;
extern int charPos;
%}

%start prog_start
%token NUMBER STARTBRACKET CLOSEBRACKET STARTPAREN CLOSEPAREN INTEGER ADD SUBTRACT DIVIDE MULTIPLICATION ASSIGNMENT LESSTHAN GREATERTHAN EQUAL NOTEQUAL LESSTHANEQUAL GREATERTHANEQUAL OUTPUT INPUT DO WHILE RETURN FUNCTION ELSE IF ENDLINE TRUE FALSE IDENTIFIER COMMA

%%
prog_start: %empty /* epsilon */ {printf("prog_start-> epsilon \n");}
    | functions {printf("prog_start-> functions\n");}
    ;

functions: function {printf("functions -> function\n");}
    | function functions {printf("functions -> function functions\n");}
    ;

function: FUNCTION IDENTIFIER STARTPAREN args CLOSEPAREN STARTBRACKET statements CLOSEBRACKET {printf("function -> FUNCTION IDENTIFIER STARTPAREN args CLOSEPAREN STARTBRACKET statement CLOSEBRACKET\n");}
    ;

args: arg {printf("args -> arg\n");}
    | arg COMMA args {printf("args -> arg COMMA args\n");}
    | %empty /* epsilon */ {printf("args -> epsilon\n");}
    ;

arg: INTEGER IDENTIFIER {printf("arg -> INTEGER IDENTIFIER\n");}
    | IDENTIFIER {printf("arg -> IDENTIFIER\n");}
    | NUMBER {printf("arg -> NUMBER\n");}
    | expression {printf("arg -> expression\n");}
    ;

statements: %empty /* epsilon */ {printf("statements -> epsilon\n");}
    | statement ENDLINE statements {printf("statements -> statement ENDLINE statements\n");}
    | conditionals statements {printf("statements -> conditionals\n");}
    | whileloop statements {printf("statements -> whileloop\n");}
    | dowhile statements {printf("statements -> dowhile\n");}
    ;

statement: declaration {printf("statement -> declaration\n");}
    | assignment {printf("statement -> assignment\n");}
    | expression {printf("statement -> expression\n");}
    | io {printf("statement -> io\n");}
    | return {printf("statement -> return\n");}
    ;

declaration: INTEGER IDENTIFIER {printf("declaration -> INTEGER IDENTIFIER\n");}
    ;

function_call: IDENTIFIER STARTPAREN args CLOSEPAREN {printf("function_call -> IDENTIFIER STARTPAREN args CLOSEPAREN\n");}
    ;

assignment: IDENTIFIER ASSIGNMENT expression {printf("assignment -> IDENTIFIER ASSIGNMENT expersion\n");}
    | declaration ASSIGNMENT expression {printf("assignment -> declaration ASSIGNMENT expression\n");}
    ;

io: OUTPUT IDENTIFIER {printf("io -> OUTPUT IDENTIFIER\n");}
    | INPUT IDENTIFIER {printf("io -> INPUT IDENTIFIER\n");}
    ;

expression: expression addop term {printf("exp ->exp addop term\n");}
    | term {printf("exp ->term\n");}
    ;

addop: ADD {printf("addop ->ADD\n");}
    | SUBTRACT {printf("addop ->SUBTRACT\n");}
    ;

term: term multop factor {printf("term -> term multop factor\n");}
    | factor {printf("term -> factor\n");}
    ;

multop: MULTIPLICATION {printf("multop -> MULTIPLICATION\n");}
    | DIVIDE {printf("multop -> DIVIDE\n");}

factor: STARTPAREN expression CLOSEPAREN {printf("factor -> STARTPAREN expression CLOSEPAREN\n");} 
    | NUMBER {printf("factor -> NUMBER\n");}
    | IDENTIFIER {printf("factor -> IDENTIFIER\n");}
    | function_call {printf("factor -> function_call\n");}
    ;

conditionals: IF STARTPAREN boolean CLOSEPAREN STARTBRACKET statements CLOSEBRACKET condition {printf("conditionals -> IF STARTPAREN boolean CLOSEPAREN STARTBRACKET statements CLOSEBRACKET condition\n");}
    ;

condition: %empty /* epsilon */ {printf("condition -> epsilon\n");}
    | ELSE STARTBRACKET statements CLOSEBRACKET {printf("condition -> ELSE STARTBRACKET statements CLOSEBRACKET\n");}
    ;

boolean: TRUE  {printf("boolean -> TRUE\n");}
    | FALSE {printf("boolean -> FALSE\n");}
    | expression boolop expression {printf("boolean -> expression boolop expression\n");}
    ;

boolop: EQUAL {printf("boolop-> EQUAL\n");}
    | LESSTHAN  {printf("boolop-> LESSTHAN\n");}
    | LESSTHANEQUAL {printf("boolop-> LESSTHANEQUAL\n");}
    | GREATERTHAN   {printf("boolop-> GREATERTHAN\n");}
    | GREATERTHANEQUAL  {printf("boolop-> GREATERTHANEQUAL\n");}
    | NOTEQUAL  {printf("boolop-> NOTEQUAL\n");}
    ;

whileloop: WHILE STARTPAREN boolean CLOSEPAREN STARTBRACKET statements CLOSEBRACKET {printf("whileloop -> WHILE STARTPAREN boolean CLOSEPAREN STARTBRACKET statements CLOSEBRACKET\n");}

dowhile: DO STARTBRACKET statements CLOSEBRACKET WHILE STARTPAREN boolean CLOSEPAREN ENDLINE {printf("dowhile -> DO STARTBRACKET statements CLOSEBRACKET WHILE STARTPAREN boolean CLOSEPAREN ENDLINE\n");}
    ;

return: RETURN expression {printf("return -> RETURN expression\n");}  
    ; 
 %%
main(int argc, char *argv[]){
    FILE *fp = fopen(argv[1],"r");
    yyin = fp;
    yyparse();
}
int yyerror(){}