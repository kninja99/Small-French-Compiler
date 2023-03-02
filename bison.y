%{
#include <stdio.h>
#include <string>
#include <string.h>
#include "CodeNode.h"
extern FILE* yyin;
extern int lineNum;
extern int charPos;
int argCount = 0;
extern int yylex(void);
void yyerror(const char *msg);
std::string returnTempVarName(){
    static int count = 0;
    std::string varName("_temp");
    char strCount[2];
    sprintf(strCount,"%d",count);
    varName += std::string(strCount);
    count++;
    return varName;
}

std::string returnArgument(){
    std::string argName("$");
    char strCount[2];
    sprintf(strCount,"%d",argCount);
    argName += std::string(strCount);
    argCount++;
    return argName;
}
%}

%start prog_start
%union {
  struct CodeNode *code_node;
  char *op_val;
}
%token STARTBRACKET CLOSEBRACKET STARTPAREN CLOSEPAREN INTEGER ADD SUBTRACT DIVIDE MULTIPLICATION MOD ASSIGNMENT LESSTHAN GREATERTHAN EQUAL NOTEQUAL LESSTHANEQUAL GREATERTHANEQUAL OUTPUT INPUT DO WHILE RETURN FUNCTION ELSE IF ENDLINE TRUE FALSE COMMA ARRAY STARTBRACE ENDBRACE
%token <op_val> NUMBER 
%token <op_val> IDENTIFIER
%type <code_node> functions
%type <code_node> function
%type <code_node> statements
%type <code_node> statement
%type <code_node> declaration
%type <code_node> assignment
%type <code_node> expression
%type <code_node> factor
%type <code_node> term
%type <code_node> io
%type <code_node> return
%type <code_node> args
%type <code_node> arg
%type <op_val> addop
%type <op_val> multop
%%
prog_start: %empty /* epsilon */ {}
    | functions {
        CodeNode *code_node = $1;
        // seg faulting on print statement...idk why. Might be because I havent
        // finished implementing function rule
        printf("%s\n", code_node -> code.c_str());
    }
    ;

functions: function {
    CodeNode *code_node = $1;
    CodeNode *node = new CodeNode;
    node = code_node;
    $$ = node;
}
    | function functions {
        CodeNode *code_node1 = $1;
        CodeNode *code_node2 = $2;
        CodeNode *node = new CodeNode;
        node -> code = "";
        node -> code = code_node1 -> code + code_node2 -> code;
        $$ = node;
    }
    ;

function: FUNCTION IDENTIFIER STARTPAREN args CLOSEPAREN STARTBRACKET statements CLOSEBRACKET {
    CodeNode *node = new CodeNode;
    CodeNode *statements = $7;
    std::string func_name = $2;
    node -> code = "";
    // add the "func IDENTIFIER"
    node -> code += std::string("func ") + func_name + std::string("\n");
    // args
    node -> code += $4 -> code;
    // statements
    node -> code += statements->code;

    // end function
    node -> code += std::string("endfunc\n\n");

    $$ = node;
}
    ;

args: arg {
        argCount = 0;
        $$ = $1;
    }
    | arg COMMA args {
        argCount = 0;
        CodeNode *node = new CodeNode;
        CodeNode *arg = $1;
        CodeNode *args = $3;

        node -> code += arg -> code + args -> code;
        $$ = node;
    }
    | %empty /* epsilon */ {
        CodeNode *node = new CodeNode;
        node -> code = std::string("");
        $$ = node;
    }
    ;

arg: INTEGER IDENTIFIER {
        // . ident (declaration)
        CodeNode *node = new CodeNode;
        node -> code = std::string(". ") + $2 + std::string("\n");
        // assignment
        node -> code += std::string("= ") + $2 + std::string(", ") +returnArgument() + std::string("\n");
        $$ = node;
    }
    | expression {}
    ;

statements: %empty /* epsilon */ {
        CodeNode *node = new CodeNode;
        node -> code = std::string("");
        $$ = node;
    }
    | statement ENDLINE statements {
        CodeNode *statement = $1;
        CodeNode *statements = $3;
        // building up code string
        CodeNode *node = new CodeNode;
        node -> code = statement ->code + std::string("\n") + statements -> code;
        $$ = node;
    }
    | conditionals statements {}
    | whileloop statements {}
    | dowhile statements {}
    ;

statement: declaration {
       CodeNode *node = $1;
       $$ = node;
    }
    | assignment {
        CodeNode *node = $1;
        $$ = node;
        
    }
    | expression {
        CodeNode *node = $1;
        $$ = node;
    }
    | io {
        CodeNode *node = $1;
        $$ = node;
    }
    | return {
        CodeNode *node = $1;
        $$ = node;
    }
    ;

declaration: INTEGER IDENTIFIER {
        // . ident
        CodeNode *node = new CodeNode;
        node -> code = std::string(". ") + $2;
        $$ = node;
    }
    | INTEGER ARRAY {}
    ;

function_call: IDENTIFIER STARTPAREN args CLOSEPAREN {}
    ;

assignment: IDENTIFIER ASSIGNMENT expression {
        // = a, b
        CodeNode *node = new CodeNode;
        std::string ident = $1;
        CodeNode *expression = $3;
        node->code = $3->code;
        node -> code += std::string("= ") + ident + std::string(", ") + expression -> name;

        $$ = node;
    }
    | declaration ASSIGNMENT expression {}
    | ARRAY ASSIGNMENT expression {}
    ;

io: OUTPUT IDENTIFIER {
        CodeNode *node = new CodeNode;
        node->code = std::string(".> ") + std::string($2);
        $$ = node;
}
    | INPUT IDENTIFIER {}
    ;

expression: expression addop term {
    CodeNode *node = new CodeNode;
    std::string tempVar = returnTempVarName();
    node->name = tempVar;
    node->code= $1->code + $3->code + std::string(". ") + tempVar + std::string("\n");
    node->code+= std::string($2) + std::string(" ") +tempVar + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
    $$ = node;
    }
    | term {
        CodeNode *node = $1;
        $$ = node;
    }
    | STARTBRACKET arraynumbers CLOSEBRACKET {}
    ;
arraynumbers: NUMBER {}
    | NUMBER COMMA arraynumbers {}
    | %empty /* epsilon */ {}
    ;

addop: ADD {
        char op[] = "+";
        $$ = op;
    }
    | SUBTRACT {
        char op[] = "-";
        $$ = op;
    }
    ;

term: term multop factor {
    CodeNode *node = new CodeNode;
    std::string tempVar = returnTempVarName();
    node->name = tempVar;
    node->code= $1->code + $3->code + std::string(". ") + tempVar + std::string("\n");
    node->code+= std::string($2) + std::string(" ") +tempVar + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
    $$ = node;
}
    | factor {
        CodeNode *node = $1;
    }
    ;

multop: MULTIPLICATION {
        char op[] = "*";
        $$ = op;
    }
    | DIVIDE {
        char op[] = "/";
        $$ = op;
    }
    | MOD {
        char op[] = "%";
        $$ = op;
    }

factor: STARTPAREN expression CLOSEPAREN {} 
    | NUMBER {
        CodeNode *node = new CodeNode;
        node -> name = $1;
        $$ = node;
    }
    | IDENTIFIER {
        CodeNode *node = new CodeNode;
        node -> name = $1;
        $$ = node;
    }
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
