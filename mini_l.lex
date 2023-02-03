%{
#include <stdio.h>
#include "y.tab.h"
int lineNum = 1;
int charPos = 0;
%}

NUMBER [0-9]+
STARTBRACKET [{]
CLOSEBRACKET [}]
ENDLINE [;]
STARTPAREN [(]
CLOSEPAREN [)]
INTEGER "ent"
COMMENT ^#.*
ADD [+]
SUBTRACT "-"
DIVIDE "/"
MULTIPLICATION "*"
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
TRUE "true"
FALSE "false"
IDENTIFIER [a-zA-Z]+[a-zA-Z0-9]*
INVALID [0-9]+[a-zA-Z0-9]+
NEWLINE \n

%%\
{NUMBER} {printf("NUMBER %s\n", yytext); charPos+=yyleng;}
{STARTBRACKET} {printf("STARTBRACKET %s\n", yytext); charPos+=yyleng;}
{CLOSEBRACKET} {printf("CLOSEBRACKET %s\n", yytext); charPos+=yyleng;}
{STARTPAREN} {printf("STARTPAREN %s\n", yytext); charPos+=yyleng;}
{CLOSEPAREN} {printf("CLOSEPAREN %s\n", yytext); charPos+=yyleng;}
{INTEGER}  {printf("INTEGER %s \n", yytext); charPos+=yyleng;}
{ADD} {printf("ADD %s \n", yytext); charPos+=yyleng;}
{SUBTRACT} {printf("SUBTRACT %s \n", yytext); charPos+=yyleng;}
{DIVIDE} {printf("DIVIDE %s \n", yytext); charPos+=yyleng;} 
{MULTIPLICATION} {printf("MULTIPLICATION %s \n", yytext); charPos+=yyleng;} 
{ASSIGNMENT} {printf("ASSIGNMENT %s \n", yytext); charPos+=yyleng;}
{LESSTHAN}   {printf("LESSTHAN %s \n", yytext); charPos+=yyleng;}
{GREATERTHAN} {printf("GREATERTHAN %s \n", yytext); charPos+=yyleng;}
{EQUAL}       {printf("EQUAL %s \n", yytext); charPos+=yyleng;}
{NOTEQUAL}    {printf("NOTEQUAL %s \n", yytext); charPos+=yyleng;}
{LESSTHANEQUAL} {printf("LESSTHANEQUAL %s \n", yytext); charPos+=yyleng;}
{GREATERTHANEQUAL} {printf("GREATERTHANEQUAL %s \n", yytext); charPos+=yyleng;}
{OUTPUT} {printf("OUTPUT %s \n", yytext); charPos+=yyleng;}
{INPUT} {printf("INPUT %s \n", yytext); charPos+=yyleng;}
{DO} {printf("DO %s \n", yytext); charPos+=yyleng;}
{WHILE} {printf("WHILE %s \n", yytext); charPos+=yyleng;}
{RETURN} {printf("RETURN %s \n", yytext); charPos+=yyleng;}
{FUNCTION} {printf("FUNCTION %s \n", yytext); charPos+=yyleng;}
{ELSE} {printf("ELSE KEYWORD\n" ); charPos+=yyleng;}
{IF} {printf("IF KEYWORD\n"); charPos+=yyleng;}
{ENDLINE} {printf("ENDLINE %s\n",yytext); charPos+=yyleng;}
{SPACE} {}
{TRUE} {printf("TRUE TOKEN %s\n",yytext); charPos+=yyleng;}
{FALSE} {printf("FALSE TOKEN %s\n",yytext); charPos+=yyleng;}
{IDENTIFIER} {printf("IDENTIFIER %s\n", yytext); charPos+=yyleng;}
{COMMENT} {}
{NEWLINE} {++lineNum; charPos = 0;}
{INVALID} {printf("ERROR at line %d pos %d in %s\n",lineNum,charPos,yytext);}
. {printf("ERROR at line %d pos %d in %s\n",lineNum,charPos,yytext);}
%%