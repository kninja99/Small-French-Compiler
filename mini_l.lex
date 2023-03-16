%{
#include <stdio.h>
#include "bison.tab.h"
int lineNum = 1;
int charPos = 0;
%}

NUMBER [0-9]+
STARTBRACKET [{]
CLOSEBRACKET [}]
BREAK "break"
ENDLINE [;]
STARTPAREN [(]
CLOSEPAREN [)]
INTEGER "ent"
COMMENT #.*$
ADD [+]
SUBTRACT "-"
DIVIDE "/"
MULTIPLICATION "*"
MOD "%"
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
COMMA ,
STARTBRACE "["
ENDBRACE "]"

%%
{STARTBRACE} {charPos+=yyleng; return STARTBRACE;}
{ENDBRACE} {charPos+=yyleng; return ENDBRACE;}
{COMMA} {charPos+=yyleng; return COMMA;}
{NUMBER} {
    charPos+=yyleng;
    char * token = new char[yyleng];
    strcpy(token, yytext);
    yylval.op_val = token;
    return NUMBER;}
{STARTBRACKET} {charPos+=yyleng; return STARTBRACKET;}
{CLOSEBRACKET} {charPos+=yyleng; return CLOSEBRACKET;}
{BREAK} {charPos += yyleng; return BREAK;}
{STARTPAREN} {charPos+=yyleng; return STARTPAREN;}
{CLOSEPAREN} {charPos+=yyleng; return CLOSEPAREN;}
{INTEGER}  {charPos+=yyleng; return INTEGER;}
{ADD} {charPos+=yyleng; return ADD;}
{SUBTRACT} {charPos+=yyleng; return SUBTRACT;}
{DIVIDE} {charPos+=yyleng; return DIVIDE;} 
{MULTIPLICATION} {charPos+=yyleng; return MULTIPLICATION;} 
{MOD} {charPos+=yyleng; return MOD;}
{ASSIGNMENT} {charPos+=yyleng; return ASSIGNMENT;}
{LESSTHAN}   {charPos+=yyleng; return LESSTHAN;}
{GREATERTHAN} {charPos+=yyleng; return GREATERTHAN;}
{EQUAL}       {charPos+=yyleng; return EQUAL;}
{NOTEQUAL}    {charPos+=yyleng; return NOTEQUAL;}
{LESSTHANEQUAL} {charPos+=yyleng; return LESSTHANEQUAL;}
{GREATERTHANEQUAL} {charPos+=yyleng; return GREATERTHANEQUAL;}
{OUTPUT} {charPos+=yyleng; return OUTPUT;}
{INPUT} {charPos+=yyleng; return INPUT;}
{DO} {charPos+=yyleng; return DO;}
{WHILE} {charPos+=yyleng; return WHILE;}
{RETURN} {charPos+=yyleng; return RETURN;}
{FUNCTION} {charPos+=yyleng; return FUNCTION;}
{ELSE} {charPos+=yyleng; return ELSE;}
{IF} {charPos+=yyleng; return IF;}
{ENDLINE} {charPos+=yyleng; return ENDLINE;}
{SPACE} {}
{TRUE} {charPos+=yyleng; return TRUE;}
{FALSE} {charPos+=yyleng; return FALSE;}
{IDENTIFIER} {
    charPos+=yyleng; 
    char * token = new char[yyleng];
    strcpy(token, yytext);
    yylval.op_val = token;
    return IDENTIFIER;}
{COMMENT} {}
{NEWLINE} {++lineNum; charPos = 0;}
{INVALID} {printf("ERROR at line %d pos %d in %s\n",lineNum,charPos,yytext);}
. {printf("ERROR at line %d pos %d in %s\n",lineNum,charPos,yytext);}
%%