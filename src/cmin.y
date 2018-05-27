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
            { printf("%3d: FROM BISON DECLARATION-LIST\n", line_number); }
;
declaration-list:
      declaration-list declaration
            { printf("%3d: FROM BISON DECLARATION-LIST DECLARATION\n", line_number); }
      | declaration
            { printf("%3d: FROM BISON DECLARATION\n", line_number); }
;
declaration:
      var-declaration
        { printf("%3d: FROM BISON VAR-DECLARATION\n", line_number); }
      | fun-declaration
        { printf("%3d: FROM BISON FUN-DECLARATION\n", line_number); }
;
var-declaration:
      type_specifier ID ';'
      | type_specifier ID '[' NUM ']' ';'
      | type_specifier ID { printf("Missing semicolon(;) on line %3d\n",line_number); return 1;}
      | type_specifier ID '[' NUM ']' { printf("Missing semicolon(;) on line %3d\n",line_number); return 1;}
      | type_specifier ID '[' NUM  { printf("Missing closing paranthesis(]) on line %3d\n",line_number); return 1;}
      | type_specifier ID NUM ']' { printf("Missing opening paranthesis([) on line %3d\n",line_number); return 1;}
;
type_specifier:
      VOID
         { printf("%3d: FROM BISON VOID\n", line_number); }
   |  INT
         { printf("%3d: FROM BISON INT\n", line_number); }
;
fun-declaration:
      type_specifier ID '(' params ')' compound-stmt
      | type_specifier ID '(' params  compound-stmt { printf("Missing closing paranthesis(')') on line %3d\n",line_number); return 1;}
      | type_specifier ID params ')'  compound-stmt { printf("Missing opening paranthesis('(') on line %3d\n",line_number); return 1;}
      | type_specifier ID '(' ')'  compound-stmt { printf("Missing parameters for the function, if there is no parameters use VOID line %3d\n",line_number); return 1;}
      | type_specifier     { printf("Missing function name on line %3d\n",line_number); return 1;}
;
params:
      param_list
      | VOID
;
param_list:
      param_list ',' param
      | param
      | param_list param { printf("Missing comma(,) on line %3d\n",line_number); return 1;}
;
param:
      type_specifier ID
      | type_specifier ID '[' ']'
      | type_specifier ID '['  { printf("Missing closing paranthesis(]) on line %3d\n",line_number); return 1;}
      | type_specifier ID ']'  { printf("Missing opening paranthesis([) on line %3d\n",line_number); return 1;}
;
compound-stmt:
      '{' local-declarations statement-list '}'
      | local-declarations statement-list '}' { printf("Missing opening paranthesis({) on line %3d\n",line_number); return 1;}
      |'{' local-declarations statement-list  { printf("Missing closing paranthesis(}) on line %3d\n",line_number); return 1;}
;
local-declarations:
      local-declarations var-declaration
      | %empty
;
statement-list:
      statement-list statement
      | %empty
;
statement:
      expression-stmt
      | compound-stmt
      | selection-stmt
      | iteration-stmt
      | return-stmt
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
