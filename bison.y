%{
#include <stdio.h>
extern FILE* yyin;
%}

%start prog_start
%token EMP

%%
prog_start: %empty /* epsilon */ {printf("prog_start-> epsilon");}
%%
main(int argc, char *argv[]){
    FILE *fp = fopen(argv[1],"r");
    yyin = fp;
    yyparse();
}
int yyerror(){}