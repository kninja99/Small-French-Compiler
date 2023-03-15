%{
#include <stdio.h>
#include <string>
#include <string.h>
#include "CodeNode.h"
#include <vector>
#include <iostream>
extern FILE* yyin;
extern int lineNum;
extern int charPos;
int argCount = 0;
extern int yylex(void);
void yyerror(const char *msg);

enum Type { Integer, Array };
struct Symbol {
  std::string name;
  Type type;
};
struct Function {
  std::string name;
  std::vector<Symbol> declarations;
};

std::vector <Function> symbol_table;
// list of reserved word
std::string keyWords[] = {"sortir","contribution","faire", "tandis", "revenir", "fonction","autre", "si", "true","false", "ent"};

std::vector <std::string> tokenList(keyWords, keyWords + 11);

bool findReserveWord(std::string word) {
    for(int i = 0; i < tokenList.size(); i++) {
        if(tokenList[i] == word) {
            return true;
        }
    }
    return false;
}

Function *get_function() {
  int last = symbol_table.size()-1;
  return &symbol_table[last];
}

bool findFunction(std::string func) {
    for(int i = 0; i < symbol_table.size(); i++) {
        if(symbol_table[i].name == func) {
            return true;
        }
    }
    return false;
}

bool find(std::string &value) {
  Function *f = get_function();
  for(int i=0; i < f->declarations.size(); i++) {
    Symbol *s = &f->declarations[i];
    if (s->name == value) {
      return true;
    }
  }
  return false;
}

Type findType(std::string &word) {
    Function *f = get_function();
    for(int i=0; i < f->declarations.size(); i++) {
        Symbol *s = &f->declarations[i];
        if (s->name == word) {
            return s->type;
        }
  }
}

void add_function_to_symbol_table(std::string &value) {
  Function f; 
  f.name = value; 
  symbol_table.push_back(f);
}

void add_variable_to_symbol_table(std::string &value, Type t) {
  Symbol s;
  s.name = value;
  s.type = t;
  Function *f = get_function();
  f->declarations.push_back(s);
}

void print_symbol_table(void) {
  printf("symbol table:\n");
  printf("--------------------\n");
  for(int i=0; i<symbol_table.size(); i++) {
    printf("function: %s\n", symbol_table[i].name.c_str());
    for(int j=0; j<symbol_table[i].declarations.size(); j++) {
      printf("  locals: %s\n", symbol_table[i].declarations[j].name.c_str());
    }
  }
  printf("--------------------\n");
}

std::string returnTempVarName(){
    static int count = 0;
    std::string varName("_temp");
    char strCount[2];
    sprintf(strCount,"%d",count);
    varName += std::string(strCount);
    count++;
    return varName;
}

std::string returnLoopCount() {
    static int loopCount = 0;
    int curr_count = loopCount;
    loopCount++;

    return std::to_string(curr_count);
}

std::string returnIfCount() {
    static int ifCount = 0;
    int curr_count = ifCount;
    ifCount++;

    return std::to_string(curr_count);
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
%token STARTBRACKET CLOSEBRACKET STARTPAREN CLOSEPAREN INTEGER ADD SUBTRACT DIVIDE MULTIPLICATION MOD ASSIGNMENT LESSTHAN GREATERTHAN EQUAL NOTEQUAL LESSTHANEQUAL GREATERTHANEQUAL OUTPUT INPUT DO WHILE RETURN FUNCTION ELSE IF ENDLINE TRUE FALSE COMMA STARTBRACE ENDBRACE
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
%type <code_node> whileloop
%type <code_node> boolean
%type <op_val> boolop
%type <op_val> addop
%type <op_val> multop
%type <code_node> function_call
%type <code_node> function_call_args
%type <code_node> funcIdent
%type <code_node> conditionals
%type <code_node> condition
%%
prog_start: %empty /* epsilon */ {yyerror("Main was not declared");}
    | functions {
        CodeNode *code_node = $1;
        // finished implementing function rule
        if(!findFunction(std::string("main"))) {
            yyerror("Main was not declared");
        }
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
funcIdent: FUNCTION IDENTIFIER{
    CodeNode *node = new CodeNode;
    std::string val = $2;
    node -> name = val;
    if(findReserveWord(val)) {
        std::string err = std::string(val) + std::string(" can not be named as a reserved word");
        yyerror(err.c_str());
    }
    add_function_to_symbol_table(val);
    $$ = node;
}

function: funcIdent STARTPAREN args CLOSEPAREN STARTBRACKET statements CLOSEBRACKET {
    CodeNode *node = new CodeNode;
    CodeNode *statements = $6;
    std::string func_name = $1 -> name;
    node -> code = "";

    // add the "func IDENTIFIER"
    node -> code += std::string("func ") + func_name + std::string("\n");
    // args
    node -> code += $3 -> code;
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
        node -> name = arg -> name + std::string(",") +args -> name;
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
        node -> name = $2;
        node -> code = std::string(". ") + $2 + std::string("\n");
        // assignment
        node -> code += std::string("= ") + $2 + std::string(", ") +returnArgument() + std::string("\n");
        Type t = Integer;
        if(findReserveWord(node -> name)) {
            std::string err = node -> name + std::string(" can not be named as a reserved word");
            yyerror(err.c_str());
        }   
        add_variable_to_symbol_table(node -> name,t);
        $$ = node;
    }
    /* | expression {
        $$ = $1;
    } */
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
    | conditionals statements {
        CodeNode *node = new CodeNode;
        CodeNode *condition = $1;
        CodeNode *statement = $2;
        node -> code = condition -> code + statement -> code;
        $$ = node;
    }
    | whileloop statements {
        CodeNode *node = new CodeNode;
        CodeNode *loop = $1;
        CodeNode *statement = $2;

        node -> code = loop -> code + statement -> code;
        $$ = node;
    }
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
        Type t = Integer;
        std::string ident = $2;
        node -> code = std::string(". ") + $2;
        node -> name = ident;
        if(findReserveWord(ident)) {
            std::string err = ident + std::string(" can not be named as a reserved word");
            yyerror(err.c_str());
        }

        if(find(ident)) {
            std::string err = std::string(ident) + std::string(" Symbol already declared");
            yyerror(err.c_str());
        }

        add_variable_to_symbol_table(ident,t);

        $$ = node;
    }
    // for array declaration 
    | INTEGER IDENTIFIER STARTBRACE NUMBER ENDBRACE {
        CodeNode *node = new CodeNode;
        std::string ident = $2;
        std::string size = $4;
        Type t = Array;
        node -> code = std::string(".[] " + ident + std::string(", ") + size);

        if(findReserveWord(ident)) {
            std::string err = ident + std::string(" can not be named as a reserved word");
            yyerror(err.c_str());
        }

        if(find(ident)) {
            std::string err = std::string(ident) + std::string(" Symbol already declared");
            yyerror(err.c_str());
        }
        // size check
        if(std::stoi(size) <= 0) {
            std::string err = std::string(ident) + std::string(" array size has to be declared as a size greater than 0");
            yyerror(err.c_str());
        }
        add_variable_to_symbol_table(ident,t);
        $$ = node;
    }
    ;

function_call: IDENTIFIER STARTPAREN function_call_args CLOSEPAREN {
        CodeNode *node = new CodeNode;
        CodeNode *args = $3;
        std::string ident = $1;
        std::string temp = returnTempVarName();
        node -> name = temp;
        // construct params
        node -> code = args -> code;
        // make temp var and store
        node -> code += std::string(". ") + temp + std::string("\n");
        node -> code += std::string("call ") + $1 + std::string(", ") + temp + std::string("\n");
        if(!findFunction(ident)) {
            std::string err = std::string(ident) + std::string(" function has not been defined");
            yyerror(err.c_str());
        }
        $$ = node; 
    }
    ;

function_call_args: expression {
        CodeNode *node = new CodeNode;
        CodeNode *expression = $1;
        node -> code = expression -> code;
        node -> code += std::string("param ") + expression -> name + std::string("\n");
        $$ = node;
    }
    | expression COMMA function_call_args {
        CodeNode *node = new CodeNode;
        CodeNode *expression = $1;
        CodeNode *expression2 = $3;
        node -> code = std::string("param ") + expression -> name + std::string("\n");
        node -> code += expression2 -> code;
        $$ = node;
    }
    | %empty {
        CodeNode *node = new CodeNode;
        node -> code = std::string("");
        $$ = node;
    }
    ;
assignment: IDENTIFIER ASSIGNMENT expression {
        // = a, b
        CodeNode *node = new CodeNode;
        std::string ident = $1;
        CodeNode *expression = $3;
        node->code = $3->code;
        node -> code += std::string("= ") + ident + std::string(", ") + expression -> name;
        if(!find(ident)) {
            std::string err = std::string(ident) + std::string(" Variable used without being declared");
            yyerror(err.c_str());
        }
        Type t = Integer;
        if(findType(ident) != t) {
            std::string err = std::string(ident) + std::string(" Variable is a array not an int");
            yyerror(err.c_str());
        } 
        $$ = node;
    }
    | declaration ASSIGNMENT expression {
        CodeNode *node = new CodeNode;
        CodeNode *decl = $1;
        CodeNode *expression = $3;
        // init values
        node->code = decl -> code+ std::string("\n") + $3 -> code; 
        // assignment
        node -> code += std::string("= ") + decl -> name + std::string(", ") + expression -> name;

        $$ = node;
    }
    // for array assignment
    | IDENTIFIER STARTBRACE NUMBER ENDBRACE ASSIGNMENT expression{
        CodeNode *node = new CodeNode;
        std::string ident = $1;
        std::string mem = $3;
        CodeNode *expression = $6;
        node -> code = expression -> code;
        node -> code += std::string("[]= ") + ident + std::string(", ") + mem;
        node -> code += std::string(", ") + expression -> name;
        if(!find(ident)) {
            std::string err = std::string(ident) + std::string(" Variable used without being declared");
            yyerror(err.c_str());
        }
        // data type check
        Type t = Array;
        if(findType(ident) != t) {
            std::string err = std::string(ident) + std::string(" Variable is a int not an array");
            yyerror(err.c_str());
        } 
        $$ = node;
    }
    ;

io: OUTPUT IDENTIFIER {
        CodeNode *node = new CodeNode;
        std::string ident = $2;
        node->code = std::string(".> ") + std::string($2);
        // decl check
        if(!find(ident)) {
            std::string err = std::string(ident) + std::string(" Variable used without being declared");
            yyerror(err.c_str());
        }
        // data type check
        Type t = Integer;
        if(findType(ident) != t) {
            std::string err = std::string(ident) + std::string(" Variable is an array not an int");
            yyerror(err.c_str());
        } 
        $$ = node;
    }
    // array outputs
    | OUTPUT IDENTIFIER STARTBRACE NUMBER ENDBRACE {
        CodeNode *node = new CodeNode;
        std::string tempVar = returnTempVarName();
        std::string ident = $2;
        std::string mem = $4;
        node-> code = std::string(". ") + tempVar + std::string("\n");
        // array access =[] dst, src, index
        node -> code += std::string("=[] ") + tempVar + std::string(", ") + ident;
        node -> code += std::string(", ") + mem + std::string("\n");
        // print statement
        node -> code += std::string(".> ") + tempVar;
        if(!find(ident)) {
            std::string err = std::string(ident) + std::string(" Variable used without being declared");
            yyerror(err.c_str());
        }
        Type t = Array;
        if(findType(ident) != t) {
            std::string err = std::string(ident) + std::string(" Variable is an int not an array");
            yyerror(err.c_str());
        } 
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

factor: STARTPAREN expression CLOSEPAREN {
        $$ = $2;
    } 
    | NUMBER {
        CodeNode *node = new CodeNode;
        node -> name = $1;
        $$ = node;
    }
    | IDENTIFIER {
        CodeNode *node = new CodeNode;
        node -> name = $1;
        if(!find(node -> name)){
            std::string err = node -> name + std::string(" Variable used without being declared");
            yyerror(err.c_str());
        }
        Type t = Integer;
        if(findType(node -> name) != t) {
            std::string err = node -> name + std::string(" Variable is an array not an int");
            yyerror(err.c_str());
        } 
        $$ = node;
    }
    | function_call {
        $$ = $1;
    }
    | IDENTIFIER STARTBRACE NUMBER ENDBRACE {
        CodeNode *node = new CodeNode;
        std::string temp =  returnTempVarName();
        std::string ident = $1;
        std::string mem = $3;
        node -> name = temp;
        // declaring temp variable
        node -> code = std::string(". ") + temp + std::string("\n");
        // accessing memory
        node -> code += std::string("=[] ") + temp + std::string(", ") + ident + std::string(", ") + mem + std::string("\n");
        if(!find(ident)){
            std::string err = node -> name + std::string(" Variable used without being declared");
            yyerror(err.c_str());
        }
        Type t = Array;
        if(findType(ident) != t) {
            std::string err = std::string(ident) + std::string(" Variable is an int not an array");
            yyerror(err.c_str());
        } 

        $$ = node;
    }
    ;

conditionals: IF STARTPAREN boolean CLOSEPAREN STARTBRACKET statements CLOSEBRACKET condition {
        CodeNode *node = new CodeNode;
        CodeNode *boolOp = $3;
        CodeNode *statement = $6;
        CodeNode *elseCondition = $8;
        std::string ifCount = returnIfCount();
        std::string ifTrue = std::string("if_true" + ifCount);
        node -> code = boolOp -> code;
        node -> code += std::string("?:= " + ifTrue + ", " + boolOp->name + "\n");
        // could need a conditional check
        if(elseCondition != NULL) {
            node -> code += std::string(":= " + elseCondition -> name + ifCount + "\n");
        }
        else {
            node -> code += std::string(":= " + std::string("endif" + ifCount) + "\n");
        }
        // ---> if statement
        node -> code += std::string(": " + ifTrue + "\n");
        node -> code += statement -> code;
        if(elseCondition == NULL) {
            node -> code += std::string(": " + std::string("endif")+ ifCount + "\n");
        }
        // else statement
        if(elseCondition != NULL) {
            node -> code += std::string(":= " + std::string("endif"+ ifCount) + "\n");
            node -> code += std::string(": " + elseCondition -> name + ifCount + "\n");
            node -> code += elseCondition -> code;
            node -> code += std::string(": " + std::string("endif" + ifCount) + "\n");
        }
        $$ = node;
    }
    ;

condition: %empty /* epsilon */ {
        CodeNode *node = new CodeNode;
        $$ = NULL;
    }
    | ELSE STARTBRACKET statements CLOSEBRACKET {
        CodeNode *node = new CodeNode;
        CodeNode *statement = $3;
        std::string elseName = std::string("else");
        node -> name = elseName;
        node -> code = statement -> code;
        $$ = node;
    }
    ;

boolean: TRUE  {}
    | FALSE {}
    | expression boolop expression {
        CodeNode *node = new CodeNode;
        std::string boolop = $2;
        std::string temp = returnTempVarName();
        CodeNode *exp1 = $1;
        CodeNode *exp2 = $3;
        node -> name = temp;
        node -> code = std::string(". ") + temp + std::string("\n");
        node ->code += boolop + std::string(" ") + temp + std::string(", ") + exp1 -> name;
        node -> code += std::string(", ") + exp2 -> name + std::string("\n");

        $$ = node;
    }
    ;

boolop: EQUAL {
        char op[] = "==";
        $$ = op;
    }
    | LESSTHAN  {
        char op[] = "<";
        $$ = op;
    }
    | LESSTHANEQUAL {
        char op[] = "<=";
        $$ = op;
    }
    | GREATERTHAN   {
        char op[] = ">";
        $$ = op;
    }
    | GREATERTHANEQUAL  {
        char op[] = ">=";
        $$ = op;
    }
    | NOTEQUAL  {
        char op[] = "!=";
        $$ = op;
    }
    ;

whileloop: WHILE STARTPAREN boolean CLOSEPAREN STARTBRACKET statements CLOSEBRACKET {
    CodeNode *node = new CodeNode;
    CodeNode *truth = $3;
    CodeNode *statement = $6;
    std::string counter = returnLoopCount();
    std::string loopBody = std::string("loopbody") + counter;
    std::string beginLoop = std::string("beginloop") + counter;
    std::string endLoop = std::string("endloop") + counter;
    node -> code = std::string(": ") + beginLoop + std::string("\n");
    node -> code += truth -> code;
    node -> code += std::string("?:= ") + loopBody + std::string(", ") + truth -> name + std::string("\n");
    node -> code += std::string(":= ") + endLoop + std::string("\n");
    // loop body
    node -> code += std::string(": ") + loopBody + std::string("\n");
    node -> code += statement -> code;
    node -> code += std::string(":= ") + beginLoop + std::string("\n");
    node -> code += std::string(": ") + endLoop + std::string("\n");
    $$ = node;
}

dowhile: DO STARTBRACKET statements CLOSEBRACKET WHILE STARTPAREN boolean CLOSEPAREN ENDLINE {}
    ;

return: RETURN expression {
        CodeNode *node = new CodeNode;
        CodeNode *expression = $2;
        node -> code = expression -> code + std::string("ret ") + expression -> name;
        $$ = node;
    }  
    ; 
 %%
main(int argc, char *argv[]){
    FILE *fp = fopen(argv[1],"r");
    yyin = fp;
    yyparse();
    print_symbol_table();
}
int yyerror(char *error) {
    printf("Error at line %d, position %d: %s", lineNum, charPos, error);
}
void yyerror(const char *msg)
{
   printf("Error at line %d, position %d: %s", lineNum, charPos, msg);
   exit(1);
}
