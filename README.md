# CS152-Project-Group3

### Language Name: Petits Programmeurs Français

### Compiler Name: Petit Compilateur Français

### File Extension: .ppf

## Language Specification

| Language Features | Code Examples |
| -----------------:| -------------:|
| Integer scalar Variables | ent num; ent x;| 
| One-dimensional arrays of integers | ent arr[5]; ent arr[5] = {1,2,3,4,5}|
| Assignment statements | ent num -> 5; ent y -> 23; |
| Arithmetic operators (e.g., "+", "-", "*", "/") |ent x-> 2 + 4; ent y -> 3-3 ;ent k -> 6/3; |
| Relational operators (e.g., "<", "==", ">", "!=") | 5 == 5 , 2 < 7, 2 > 7, 6 >= 2, 6 <= 2, 6 ~= 9|
| While or Do-While loops | tandis ( True ){do something}, tandis (x < 3){do something}, faire{do something}tandis(x ~= 7)|
| If-then-else statements | si(5 == 5) { do something } autre { do something else } |
| Read and write statements | contribution >> var; sortir << var;|
| Comments | #This is a test comment |
| Functions | fonction addNumbers(ent x, ent y) { ent res = x + y; revenir res; } |

| Symbol in Language | Token Name |
| -----------------:| -------------:|
| 0-9 | NUMBER |
| (A-Z OR a-z) | WORD |
| word with optional number following it with no spaces | IDENTIFIER | 
| { | STARTBRACKET |
| } | CLOSEBRACKET |
| ; | ENDLINE |
| ( | STARTPAREN |
| ) | CLOSEPAREN |
| ent | INTEGER |
| # | COMMENT |
| + | ADD |
| - | SUBTRACT |
| / | DIVIDE |
| * | MULTIPLICATION |
| -> | ASSIGNMENT |
| < | LESSTHAN |
| > | GREATERTHAN |
| == | EQUAL |
| ~= | NOTEQUAL |
| <= | LESSTHANEQUAL |
| >= | GREATERTHANEQUAL |
| si | IF |
| autre | ELSE |
| fonction | FUNCTION |
| revenir | RETURN |
| tandis | WHILE |
| faire | DO| 
| contribution | INPUT |
| sortir | OUTPUT |

## Some Language Rules
  A valid identifier can start with a lower case or upper case letter. An identifier may contain a number, but only after the last letter the last character. Identifiers also don't have a length limit. The language is case sensitive. Whitespaces are ignored and are not significant. We will signify that a line of code has ended with a semicolon and code blocks will be wraped in curley braces ex: { # some code }.
