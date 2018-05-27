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
;                                                                             
type_specifier:                                                                      
      VOID                                                                          
         { printf("%3d: FROM BISON VOID\n", line_number); }                         
   |  INT                                                                            
         { printf("%3d: FROM BISON INT\n", line_number); }                           
;   
fun-declaration:
      type_specifier ID '(' params ')' compound-stmt
;
params:
      param_list 
      | VOID
;
param_list:
      param_list ',' param 
      | param
;
param:
      type_specifier ID 
      | type_specifier ID '[' ']'
;
compound-stmt:
      '{' local-declarations statement-list '}'
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
;
iteration-stmt:
      WHILE '(' expression ')' statement
;
return-stmt: 
      RETURN ';' 
      | RETURN expression ';'
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