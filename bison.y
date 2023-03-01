%{
#include <stdio.h>
#include <string>
#include <string.h>
#include "CodeNode.h"
extern FILE* yyin;
extern int lineNum;
extern int charPos;

extern int yylex(void);
void yyerror(const char *msg);
%}

%start prog_start
%union {
  struct CodeNode *code_node;
  char *op_val;
}
%token STARTBRACKET CLOSEBRACKET STARTPAREN CLOSEPAREN INTEGER ADD SUBTRACT DIVIDE MULTIPLICATION ASSIGNMENT LESSTHAN GREATERTHAN EQUAL NOTEQUAL LESSTHANEQUAL GREATERTHANEQUAL OUTPUT INPUT DO WHILE RETURN FUNCTION ELSE IF ENDLINE TRUE FALSE COMMA ARRAY STARTBRACE ENDBRACE
%token <op_val> NUMBER 
%token <op_val> IDENTIFIER
%type <code_node> functions
%type <code_node> function
%%
prog_start: %empty /* epsilon */ {}
    | functions {
        CodeNode *code_node = $1;
        // seg faulting on print statement...idk why
        printf("$s\n", code_node -> code.c_str());
    }
    ;

functions: function {
    CodeNode *code_node = $1;
    $$ = code_node;
}
    | function functions {
        CodeNode *code_node1 = $1;
        CodeNode *code_node2 = $2;
        CodeNode *node = new CodeNode;
        node -> code = code_node1 -> code + code_node2 -> code;
        $$ = node;
    }
    ;

function: FUNCTION IDENTIFIER STARTPAREN args CLOSEPAREN STARTBRACKET statements CLOSEBRACKET {
    CodeNode *node = new CodeNode;
    std::string func_name = $2;
    node -> code = "";
    // add the "func IDENTIFIER"
    node -> code += std::string("func") + func_name + std::string("\n");
    // args

    // statements

    // end function
    node -> code += std::string("endfunc");
}
    ;

args: arg {}
    | arg COMMA args {}
    | %empty /* epsilon */ {}
    ;

arg: INTEGER IDENTIFIER {
        
    }
    | expression {}
    ;

statements: %empty /* epsilon */ {}
    | statement ENDLINE statements {

    }
    | conditionals statements {}
    | whileloop statements {}
    | dowhile statements {}
    ;

statement: declaration {
       
    }
    | assignment {
        
    }
    | expression {}
    | io {}
    | return {}
    ;

declaration: INTEGER IDENTIFIER {
        
    }
    | INTEGER ARRAY {}
    ;

function_call: IDENTIFIER STARTPAREN args CLOSEPAREN {}
    ;

assignment: IDENTIFIER ASSIGNMENT expression {
        
        
    }
    | declaration ASSIGNMENT expression {}
    | ARRAY ASSIGNMENT expression {}
    ;

io: OUTPUT IDENTIFIER {}
    | INPUT IDENTIFIER {}
    ;

expression: expression addop term {

    }
    | term {
          
    }
    | STARTBRACKET arraynumbers CLOSEBRACKET {}
    ;
arraynumbers: NUMBER {}
    | NUMBER COMMA arraynumbers {}
    | %empty /* epsilon */ {}
    ;

addop: ADD {
        
    }
    | SUBTRACT {
        
    }
    ;

term: term multop factor {}
    | factor {}
    ;

multop: MULTIPLICATION {}
    | DIVIDE {}

factor: STARTPAREN expression CLOSEPAREN {} 
    | NUMBER {
        
    }
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
