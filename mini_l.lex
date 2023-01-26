%{
#include <stdio.h>
%}

NUMBER [0-9]+
IDENTIFIER [[a-zA-Z]*]
STARTBRACKET [{]
CLOSEBRACKET [}]
ENDLINE [;]
STARTPAREN [(]
CLOSEPAREN [)]
INTEGER "ent"
COMMENT "#"
ADD [+]
SUBTRACT "-"
DIVIDE "/"
MULTIPLICATION ""
ASSIGNMENT "->"
LESSTHAN   "<"
GREATERTHAN ">"
EQUAL       "=="
NOTEQUAL    "~="
LESSTHANEQUAL "<="
GREATERTHANEQUAL ">="
OUTPUT "sortir <<"
INPUT "contribution >>"
DO "faire"
WHILE "tandis"
RETURN "revenir"
FUNCTION "fonction"
ELSE "autre"
IF "si"
SPACE [" "] 

%%
{NUMBER} {printf("NUMBER %s\n", yytext);}
{IDENTIFIER} {printf("IDENTIFIER %s\n", yytext);}
{STARTBRACKET} {printf("STARTBRACKET %s\n", yytext);}
{CLOSEBRACKET} {printf("CLOSEBRACKET %s\n", yytext);}
{STARTPAREN} {printf("STARTPAREN %s\n", yytext);}
{CLOSEPAREN} {printf("CLOSEPAREN %s\n", yytext);}
{INTEGER}  {printf("INTEGER %s ", yytext);}
{COMMENT} {printf("COMMENT %s \n", yytext);}
{ADD} {printf("ADD %s \n", yytext);}
{SUBTRACT} {printf("SUBTRACT %s \n", yytext);}
{DIVIDE} {printf("DIVIDE %s \n", yytext);} 
{MULTIPLICATION} {printf("MULTIPLICATION %s \n", yytext);} 
{ASSIGNMENT} {printf("ASSIGNMENT %s \n", yytext);}
{LESSTHAN}   {printf("LESSTHAN %s \n", yytext);}
{GREATERTHAN} {printf("GREATERTHAN %s \n", yytext);}
{EQUAL}       {printf("EQUAL %s \n", yytext);}
{NOTEQUAL}    {printf("NOTEQUAL %s \n", yytext);}
{LESSTHANEQUAL} {printf("LESSTHANEQUAL %s \n", yytext);}
{GREATERTHANEQUAL} {printf("GREATERTHANEQUAL %s \n", yytext);}
{OUTPUT} {printf("OUTPUT %s \n", yytext);}
{INPUT} {printf("INPUT %s \n", yytext);}
{DO} {printf("DO %s \n", yytext);}
{WHILE} {printf("WHILE %s \n", yytext);}
{RETURN} {printf("RETURN %s \n", yytext);}
{FUNCTION} {printf("FUNCTION %s \n", yytext);}
{ELSE} {printf("ELSE KEYWORD\n" );}
{IF} {printf("IF KEYWORD\n");}
{ENDLINE} {printf("ENDLINE %s\n",yytext);}
{SPACE}
. {printf("Not reconized %s\n",yytext);}
%%

main(int argc, char *argv[]){
    FILE *fp = fopen(argv[1],"r");
    yyin = fp;
    yylex();
}