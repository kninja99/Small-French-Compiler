%{
#include <stdio.h>
#include <string>
#include <string.h>
extern FILE* yyin;
extern int lineNum;
extern int charPos;

extern int yylex(void);
void yyerror(const char *msg);
%}

%start prog_start
%union {
  char *op_val;
}
%token STARTBRACKET CLOSEBRACKET STARTPAREN CLOSEPAREN INTEGER ADD SUBTRACT DIVIDE MULTIPLICATION ASSIGNMENT LESSTHAN GREATERTHAN EQUAL NOTEQUAL LESSTHANEQUAL GREATERTHANEQUAL OUTPUT INPUT DO WHILE RETURN FUNCTION ELSE IF ENDLINE TRUE FALSE COMMA ARRAY STARTBRACE ENDBRACE
%token <op_val> NUMBER 
%token <op_val> IDENTIFIER
%type <op_val> declaration
%type <op_val> statements
%type <op_val> statement
%%
prog_start: %empty /* epsilon */ {}
    | functions {}
    ;

functions: function {}
    | function functions {}
    ;

function: FUNCTION IDENTIFIER STARTPAREN args CLOSEPAREN STARTBRACKET statements CLOSEBRACKET {
    // main code generation should occure here
    printf("func %s\n",$2);
    // args
    // statements
    printf("%s\n", $7);
    printf("endfunc %s\n",$2);
}
    ;

args: arg {}
    | arg COMMA args {}
    | %empty /* epsilon */ {}
    ;

arg: INTEGER IDENTIFIER {}
    | expression {}
    ;

statements: %empty /* epsilon */ {$$ = "";}
    | statement ENDLINE statements {
        char* temp = strdup($1);
        char* temp2 = strdup($3);

        $$ = strcat(temp,temp2);
    }
    | conditionals statements {}
    | whileloop statements {}
    | dowhile statements {}
    ;

statement: declaration {
        $$ = $1;
    }
    | assignment {}
    | expression {}
    | io {}
    | return {}
    ;

declaration: INTEGER IDENTIFIER {
        char temp[]= ". ";
        char* ident = strdup($2);

        // . IDENT
        $$ = strdup(strcat(temp, ident));
    }
    | INTEGER ARRAY {}
    ;

function_call: IDENTIFIER STARTPAREN args CLOSEPAREN {}
    ;

assignment: IDENTIFIER ASSIGNMENT expression {}
    | declaration ASSIGNMENT expression {}
    | ARRAY ASSIGNMENT expression {}
    ;

io: OUTPUT IDENTIFIER {}
    | INPUT IDENTIFIER {}
    ;

expression: expression addop term {}
    | term {}
    | STARTBRACKET arraynumbers CLOSEBRACKET
    ;
arraynumbers: NUMBER {}
    | NUMBER COMMA arraynumbers {}
    | %empty /* epsilon */ {}
    ;

addop: ADD {}
    | SUBTRACT {}
    ;

term: term multop factor {}
    | factor {}
    ;

multop: MULTIPLICATION {}
    | DIVIDE {}

factor: STARTPAREN expression CLOSEPAREN {} 
    | NUMBER {}
    | IDENTIFIER {}
    | function_call {}
    | ARRAY {}
    ;

conditionals: IF STARTPAREN boolean CLOSEPAREN STARTBRACKET statements CLOSEBRACKET condition {}
    ;

condition: %empty /* epsilon */ {}
    | ELSE STARTBRACKET statements CLOSEBRACKET {}
    ;

boolean: TRUE  {}
    | FALSE {}
    | expression boolop expression {}
    ;

boolop: EQUAL {}
    | LESSTHAN  {}
    | LESSTHANEQUAL {}
    | GREATERTHAN   {}
    | GREATERTHANEQUAL  {}
    | NOTEQUAL  {}
    ;

whileloop: WHILE STARTPAREN boolean CLOSEPAREN STARTBRACKET statements CLOSEBRACKET {}

dowhile: DO STARTBRACKET statements CLOSEBRACKET WHILE STARTPAREN boolean CLOSEPAREN ENDLINE {}
    ;

return: RETURN expression {}  
    ; 
 %%
main(int argc, char *argv[]){
    FILE *fp = fopen(argv[1],"r");
    yyin = fp;
    yyparse();
}
int yyerror(char *error) {
    printf("Error at line %d, position %d: %s", lineNum, charPos, error);
}
void yyerror(const char *msg)
{
   printf("Error at line %d, position %d: %s", lineNum, charPos, msg);
   exit(1);
}