%{
#include <stdio.h>
%}

NUMBER [0-9]+
IDENTIFIER [[A-Za-z]+NUMBER*]
STARTBRACKET [{]
CLOSEBRACKET [}]
ENDLINE [;]
STARTPAREN [(]s
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

%%
{NUMBER} {printf("NUMBER %s", yytext);}
{IDENTIFIER} {printf("IDENTIFIER %s", yytext);}
{STARTBRACKET} {printf("STARTBRACKET %s", yytext);}
{CLOSEBRACKET} {printf("CLOSEBRACKET %s", yytext);}
{STARTPAREN} {printf("STARTPAREN %s", yytext);}
{CLOSEPAREN} {printf("CLOSEPAREN %s", yytext);}
{INTEGER}  {printf("INTEGER %s ", yytext);}
{COMMENT} {printf("COMMENT %s ", yytext);}
{ADD} {printf("ADD %s ", yytext);}
{SUBTRACT} {printf("SUBTRACT %s ", yytext);}
{DIVIDE} {printf("DIVIDE %s ", yytext);} 
{MULTIPLICATION} {printf("MULTIPLICATION %s ", yytext);} 
{ASSIGNMENT} {printf("ASSIGNMENT %s ", yytext);}
{LESSTHAN}   {printf("LESSTHAN %s ", yytext);}
{GREATERTHAN} {printf("GREATERTHAN %s ", yytext);}
{EQUAL}       {printf("EQUAL %s ", yytext);}
{NOTEQUAL}    {printf("NOTEQUAL %s ", yytext);}
{LESSTHANEQUAL} {printf("LESSTHANEQUAL %s ", yytext);}
{GREATERTHANEQUAL} {printf("GREATERTHANEQUAL %s ", yytext);}
{OUTPUT} {printf("OUTPUT %s ", yytext);}
{INPUT} {printf("INPUT %s ", yytext);}
{DO} {printf("DO %s ", yytext);}
{WHILE} {printf("WHILE %s ", yytext);}
{RETURN} {printf("RETURN %s ", yytext);}
{FUNCTION} {printf("FUNCTION %s ", yytext);}
{ELSE} {printf("ELSE KEYWORD" );}
{IF} {printf("IF KEYWORD");}
{ENDLINE} {printf("ENDLINE %s",yytext);}
%%

main(int argc, char *argv[]){
    FILE *fp = fopen(argv[1],"r");
    yyin = fp;
    yylex();
}