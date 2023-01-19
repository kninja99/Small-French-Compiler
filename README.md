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
| While or Do-While loops | tandis ( True ){do something}; tandis (x < 3){do something}|
| If-then-else statements | si(5 == 5) { do something: } autre { do something else: } |
| Read and write statements | contribution >> var; sortir << var;|
| Comments | #This is a test comment |
| Functions | fonction addNumbers(ent x, ent y) { ent res = x + y; revenir res; } |

| Symbol in Language | Token Name |
| -----------------:| -------------:|
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

