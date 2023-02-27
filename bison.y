%{
#include <stdio.h>
#include <string>
#include <vector>
#include <string.h>
extern FILE* yyin;
extern int lineNum;
extern int charPos;
%}

%start prog_start
%token NUMBER STARTBRACKET CLOSEBRACKET STARTPAREN CLOSEPAREN INTEGER ADD SUBTRACT DIVIDE MULTIPLICATION ASSIGNMENT LESSTHAN GREATERTHAN EQUAL NOTEQUAL LESSTHANEQUAL GREATERTHANEQUAL OUTPUT INPUT DO WHILE RETURN FUNCTION ELSE IF ENDLINE TRUE FALSE IDENTIFIER COMMA ARRAY STARTBRACE ENDBRACE

/* assigning type %type <type> node */ 

%type <std::string> functions function
%%
prog_start: %empty /* epsilon */ 
    | functions {printf("$1\n");}   
    ;

functions: function {$$ = $1;}
    | function functions {$$ = $1 + "\n" + $2;}
    ;
/* identifier need to be typed string so access */
function: FUNCTION IDENTIFIER STARTPAREN args CLOSEPAREN STARTBRACKET statements CLOSEBRACKET 
{
    std::string temp= "func " +"\n";
    temp += "endfunc";
    $$ = temp;
}
    ;

args: arg {}
    | arg COMMA args {}
    | %empty /* epsilon */ {}
    ;

arg: INTEGER IDENTIFIER {}
    | expression {}
    ;

statements: %empty /* epsilon */ {}
    | statement ENDLINE statements {}
    | conditionals statements {}
    | whileloop statements {}
    | dowhile statements {}
    ;

statement: declaration {}
    | assignment {}
    | expression {}
    | io {}
    | return {}
    ;

declaration: INTEGER IDENTIFIER {}
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