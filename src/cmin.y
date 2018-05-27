%{
   #include <stdarg.h>
   #include "src/cmin_shared.h"
   #define YYSTYPE char *
%}

%locations

%token INT
%token VOID
%token ID
%token NUM
%token IF
%token ELSE
%token WHILE
%token RETURN
%token EQ
%token NE
%token LE
%token GE
%token ERROR

%% /* Grammar rules and actions follow */
program:
      declaration-list
            { printf("%3d: From Bison :- DECLARATION-LIST\n", line_number); }
;
declaration-list:
      declaration-list declaration
            { printf("%3d: From Bison :- DECLARATION-LIST DECLARATION\n", line_number); }
      | declaration
            { printf("%3d: From Bison :- DECLARATION\n", line_number); }
;
declaration:
      var-declaration
        { printf("%3d: From Bison :- VAR-DECLARATION\n", line_number); }
      | fun-declaration
        { printf("%3d: From Bison :- FUN-DECLARATION\n", line_number); }
;
var-declaration:
      type_specifier ID ';' { printf("%3d: From Bison :- TYPE_SPECIFIER ID;\n", line_number); } 
      | type_specifier ID '[' NUM ']' ';' { printf("%3d: From Bison :- TYPE_SPECIFIER ID [NUM];\n", line_number); }
      | type_specifier ID { int line_numbe = line_number; if(line_char==1) {line_numbe--;} 
            printf("Missing semicolon(;) on line %3d with TYPE_SPECIFIER ID\n",line_numbe); return 1; }
      | type_specifier ID '[' NUM ']' { int line_numbe = line_number; if(line_char==1) {line_numbe--;} 
            printf("Missing semicolon(;) on line %3d with TYPE_SPECIFIER ID [NUM]\n",line_numbe); return 1;}
      | type_specifier ID '[' NUM  { int line_numbe = line_number; if(line_char==1) {line_numbe--;} 
            printf("Missing closing paranthesis(]) on line %3d\n",line_numbe); return 1;}
      | type_specifier ID NUM ']' { int line_numbe = line_number; if(line_char==1) {line_numbe--;} 
            printf("Missing opening paranthesis([) on line %3d\n",line_numbe); return 1;}
      | type_specifier ID '[' ']' { int line_numbe = line_number; if(line_char==1) {line_numbe--;} 
            printf("Missing the number of objects to create in the array on line %3d\n",line_numbe); return 1;}
;
type_specifier:
      VOID
         { printf("%3d: From Bison :- VOID\n", line_number); }
   |  INT
         { printf("%3d: From Bison :- INT\n", line_number); }
;
fun-declaration:
      type_specifier ID '(' params ')' compound-stmt  { printf("%3d: From Bison :- TYPE_SPECIFIER ID ( PARAMS ) COMPOUND-STMT\n", line_number); }
      | type_specifier ID '(' params  compound-stmt { int line_numbe = line_number; if(line_char==1) {line_numbe--;}
                  printf("Missing closing paranthesis(')') on line %3d\n",line_numbe); return 1;}
      | type_specifier ID params ')'  compound-stmt { int line_numbe = line_number; if(line_char==1) {line_numbe--;}
            printf("Missing opening paranthesis('(') on line %3d\n",line_numbe); return 1;}
      | type_specifier ID '(' ')'  compound-stmt { int line_numbe = line_number; if(line_char==1) {line_numbe--;}
            printf("Missing parameters for the function, if there are no parameters use VOID on line %3d\n",line_numbe); return 1;}
      | type_specifier     { int line_numbe = line_number; if(line_char==1) {line_numbe--;}
            printf("Missing function name on line %3d\n",line_numbe); return 1;}
;
params:
      param_list { printf("%3d: From Bison :- PARAM_LIST\n", line_number); }
      | VOID { printf("%3d: From Bison :- VOID\n", line_number); }
;
param_list:
      param_list ',' param { printf("%3d: From Bison :- PARAM_LIST , PARAM\n", line_number); }
      | param { printf("%3d: From Bison :- PARAM\n", line_number); }
      | param_list param { int line_numbe = line_number; if(line_char==1) {line_numbe--;}
            printf("Missing comma(,) on line %3d\n",line_numbe); return 1;}
;
param:
      type_specifier ID { printf("%3d: From Bison :- TYPE_SPECIFIER ID\n", line_number); }
      | type_specifier ID '[' ']' { printf("%3d: From Bison :- TYPE_SPECIFIER ID []\n", line_number); }
      | type_specifier ID '['  { printf("Missing closing paranthesis(]) on line %3d\n",line_number); return 1;}
      | type_specifier ID ']'  { printf("Missing opening paranthesis([) on line %3d\n",line_number); return 1;}
;
compound-stmt:
      '{' local-declarations statement-list '}' { printf("%3d: From Bison :- { LOCAL-DECLARATIONs STATEMENT-LIST }\n", line_number); }
      | local-declarations statement-list '}' { printf("Missing opening paranthesis({) on line %3d\n",line_number); return 1;}
      |'{' local-declarations statement-list  { printf("Missing closing paranthesis(}) on line %3d\n",line_number); return 1;}
;
local-declarations:
      local-declarations var-declaration { printf("%3d: From Bison :- LOCAL-DECLARATIONs VAR-DECLARATION\n", line_number); }
      | %empty { printf("%3d: From Bison :- empty\n", line_number); }
;
statement-list:
      statement-list statement { printf("%3d: From Bison :- STATEMENT-LIST STATEMENT\n", line_number); }
      | %empty { printf("%3d: From Bison :- empty\n", line_number); }
;
statement:
      expression-stmt { printf("%3d: From Bison :- EXPRESSION-STMT\n", line_number); }
      | compound-stmt { printf("%3d: From Bison :- COMPOUND-STMT\n", line_number); }
      | selection-stmt { printf("%3d: From Bison :- SELECTION-STMT\n", line_number); }
      | iteration-stmt { printf("%3d: From Bison :- ITERATION-STMT\n", line_number); }
      | return-stmt { printf("%3d: From Bison :- RETURN-STMT\n", line_number); }
;
expression-stmt:
      expression ';' { printf("%3d: From Bison :- EXPRESSION ;\n", line_number); }
      | ';' { printf("%3d: From Bison :- ;\n", line_number); }
      | expression { printf("Missing semicolon(;) on line %3d with EXPRESSION\n",line_number); return 1;}
;
selection-stmt:
      IF '(' expression ')' statement { printf("%3d: From Bison :- IF (EXPRESSION) STATEMENT\n", line_number); }
      | IF '(' expression ')' statement ELSE statement { printf("%3d: From Bison :- IF (EXPRESSION) STATEMENT ELSE STATEMENT\n", line_number); }
      | IF '(' ')' statement  { printf("Missing if condition on line %3d\n",line_number); return 1;}
      | IF '(' expression statement     { printf("Missing closing paranthesis(')') on line %3d\n",line_number); return 1;}
      | IF  expression ')' statement    { printf("Missing opening paranthesis('(') on line %3d\n",line_number); return 1;}
;
iteration-stmt:
      WHILE '(' expression ')' statement { printf("%3d: From Bison :- WHILE (EXPRESSION) STATEMENT\n", line_number); }
      | WHILE '(' expression statement { printf("Missing closing paranthesis(')') on line %3d\n",line_number); return 1;}
      | WHILE expression ')' statement { printf("Missing opening paranthesis('(') on line %3d\n",line_number); return 1;}
      | WHILE '(' ')' statement        { printf("Missing stopping condition on WHILE  line %3d\n",line_number); return 1;}
;
return-stmt:
      RETURN ';' { printf("%3d: From Bison :- RETURN ;\n", line_number); }
      | RETURN expression ';' { printf("%3d: From Bison :- RETURN EXPRESSION ;\n", line_number); }
      | RETURN      { printf("Missing semicolon(;) on line %3d\n",line_number); return 1;}
      | RETURN expression     { printf("Missing semicolon(;) on line %3d\n",line_number); return 1;}
;
expression:
      var '=' expression { printf("%3d: From Bison :- VAR = EXPRESSION\n", line_number); }
      | simple-expression { printf("%3d: From Bison :- SIMPLE-EXPRESSION\n", line_number); }
;
var:
      ID { printf("%3d: From Bison :- ID\n", line_number); }
      | ID '[' expression ']' { printf("%3d: From Bison :- ID [ EXPRESSION ]\n", line_number); }
;
simple-expression:
      additive-expression relop additive-expression { printf("%3d: From Bison :- ADDITIVE-EXPRESSION RELOP ADDITIVE-EXPRESSION\n", line_number); }
      | additive-expression { printf("%3d: From Bison :- ADDITIVE-EXPRESSION\n", line_number); }
      | additive-expression relop { printf("Missing additive expression on line %3d with ADDITIVE-EXPRESSION RELOP\n",line_number); return 1;}
;
relop:
      '<' { printf("%3d: From Bison :- <\n", line_number); }
      | LE { printf("%3d: From Bison :- <=\n", line_number); }
      | '>' { printf("%3d: From Bison :- >\n", line_number); }
      | GE { printf("%3d: From Bison :- >=\n", line_number); }
      | EQ { printf("%3d: From Bison :- ==\n", line_number); }
      | NE { printf("%3d: From Bison :- !=\n", line_number); }
;
additive-expression:
      additive-expression addop term  { printf("%3d: From Bison :- ADDITIVE-EXPRESSION ADDOP TERM\n", line_number); }
      | term  { printf("%3d: From Bison :- TERM\n", line_number); }
      | additive-expression addop { printf("Missing term on line %3d with ADDITIVE-EXPRESSION ADDOP \n",line_number); return 1;}
;
addop:
      '+'  { printf("%3d: From Bison :- +\n", line_number); }
      | '-'  { printf("%3d: From Bison :- -\n", line_number); }
;
term:
      term mulop factor { printf("%3d: From Bison :- TERM MULOP FACTOR\n", line_number); }
      | factor  { printf("%3d: From Bison :- FACTOR\n", line_number); }
;
mulop:
      '*'  { printf("%3d: From Bison :- *\n", line_number); }
      | '/'  { printf("%3d: From Bison :- /\n", line_number); }
;
factor:
      '(' expression ')' { printf("%3d: From Bison :- ( EXPRESSION )\n", line_number); }
      | var { printf("%3d: From Bison :- VAR\n", line_number); }
      | call { printf("%3d: From Bison :- CALL\n", line_number); }
      | NUM { printf("%3d: From Bison :- NUM\n", line_number); }
;
call:
      ID '(' args ')' { printf("%3d: From Bison :- ID ( ARGS )\n", line_number); }
;
args:
      arg-list { printf("%3d: From Bison :- ARG-LIST\n", line_number); }
      | %empty { printf("%3d: From Bison :- Empty\n", line_number); }
;
arg-list:
      arg-list ',' expression { printf("%3d: From Bison :- ARG-LIST , EXPRESSION\n", line_number); }
      | expression { printf("%3d: From Bison :- EXPRESSION\n", line_number); }
      | arg-list expression  {printf("Missing comma(',') on line %3d after ARG-LIST\n",line_number); return 1;}
      | arg-list ',' {printf("Missing expression on line %3d after comma\n",line_number); return 1;}
;
%%

main ()
{
  if (yyparse ()==0){
      printf("Valid Syntax");
      return 0;
  }else{
      printf("Invalid Syntax");
      return 1;
  };
}
