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
      type_specifier ID ';' { printf("%3d: From Bison :- TYPE_SPECIFIER ID ;\n", line_number); }
      | type_specifier ID '[' NUM ']' ';' { printf("%3d: From Bison :- TYPE_SPECIFIER ID [NUM];\n", line_number); }
      | type_specifier ID { printf("Missing semicolon(;) on line %3d\n",line_number); return 1;}
      | type_specifier ID '[' NUM ']' { printf("Missing semicolon(;) on line %3d\n",line_number); return 1;}
      | type_specifier ID '[' NUM  { printf("Missing closing paranthesis(]) on line %3d\n",line_number); return 1;}
      | type_specifier ID NUM ']' { printf("Missing opening paranthesis([) on line %3d\n",line_number); return 1;}
      | type_specifier ID '[' ']' { printf("Missing the number of objects to create in the array on line %3d\n",line_number); return 1;}
;
type_specifier:
      VOID
         { printf("%3d: From Bison :- VOID\n", line_number); }
   |  INT
         { printf("%3d: From Bison :- INT\n", line_number); }
;
fun-declaration:
      type_specifier ID '(' params ')' compound-stmt  { printf("%3d: From Bison :- TYPE_SPECIFIER ID ( PARAMS ) COMPOUND-STMT\n", line_number); }
      | type_specifier ID '(' params  compound-stmt { printf("Missing closing paranthesis(')') on line %3d\n",line_number); return 1;}
      | type_specifier ID params ')'  compound-stmt { printf("Missing opening paranthesis('(') on line %3d\n",line_number); return 1;}
      | type_specifier ID '(' ')'  compound-stmt { printf("Missing parameters for the function, if there are no parameters use VOID on line %3d\n",line_number); return 1;}
      | type_specifier     { printf("Missing function name on line %3d\n",line_number); return 1;}
;
params:
      param_list { printf("%3d: From Bison :- PARAM_LIST\n", line_number); }
      | VOID { printf("%3d: From Bison :- VOID\n", line_number); }
;
param_list:
      param_list ',' param { printf("%3d: From Bison :- PARAM_LIST , PARAM\n", line_number); }
      | param { printf("%3d: From Bison :- PARAM\n", line_number); }
      | param_list param { printf("Missing comma(,) on line %3d\n",line_number); return 1;}
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
      expression ';'
      | ';'

;
selection-stmt:
      IF '(' expression ')' statement
      | IF '(' expression ')' statement ELSE statement
      | IF '(' ')' statement  { printf("Missing condition on IF  line %3d\n",line_number); return 1;}
      | IF '(' expression statement     { printf("Missing closing paranthesis(')') on line %3d\n",line_number); return 1;}
      | IF  expression ')' statement    { printf("Missing opening paranthesis('(') on line %3d\n",line_number); return 1;}
;
iteration-stmt:
      WHILE '(' expression ')' statement
      | WHILE '(' expression statement { printf("Missing closing paranthesis(')') on line %3d\n",line_number); return 1;}
      | WHILE expression ')' statement { printf("Missing opening paranthesis('(') on line %3d\n",line_number); return 1;}
      | WHILE '(' ')' statement        { printf("Missing stopping condition on WHILE  line %3d\n",line_number); return 1;}
;
return-stmt:
      RETURN ';'
      | RETURN expression ';'
      | RETURN      { printf("Missing semicolon(;) on line %3d\n",line_number); return 1;}
      | RETURN expression     { printf("Missing semicolon(;) on line %3d\n",line_number); return 1;}
;
expression:
      var '=' expression
      | simple-expression
;
var:
      ID
      | ID '[' expression ']'
      | ID '[' ']'      { printf("Missing parameters on line %3d\n",line_number); return 1;}
;
simple-expression:
      additive-expression relop additive-expression
      | additive-expression
;
relop:
      '<'
      | LE
      | '>'
      | GE
      | EQ
      | NE
;
additive-expression:
      additive-expression addop term
      | term
;
addop:
      '+'
      | '-'
;
term:
      term mulop factor
      | factor
;
mulop:
      '*'
      | '/'
;
factor:
      '(' expression ')'
      | var
      | call
      | NUM
;
call:
      ID '(' args ')'
;
args:
      arg-list
      | %empty
;
arg-list:
      arg-list ',' expression
      | expression
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
