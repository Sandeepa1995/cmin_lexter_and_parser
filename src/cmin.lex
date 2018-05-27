%{
#include "cmin.tab.h"
extern int line_number;
void yyerror (char const *s,int errorCode,int lin_no) {
  if(errorCode==1){
    fprintf (stderr, "%s at line %3d from '%s'\n", "Syntax Error",yylineno,yytext);
  }else if(errorCode==2){
    fprintf (stderr, "Unknown character '%s' at line %d\n", s,lin_no);
  }else if(errorCode==3){
    fprintf (stderr, "Invalid definition of identifier '%s' at line %d\n", s,lin_no);
  }else if(errorCode==4){
    fprintf (stderr, "Unterminated comment '%s' at line %d\n", s,lin_no);
  }else if(errorCode==5){
    fprintf (stderr, "Unstarted Comment '%s' at line %d\n", s,lin_no);
    }
 }
%}
%option noyywrap
%option yylineno

%%
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]       { /* DO NOTHING */ }
[/][*]                                    {yyerror(yytext,4,line_number); return ERROR;}
[*][/]                                    {yyerror(yytext,5,line_number); return ERROR;}

"else"         		{ printf("FROM FLEX ELSE %s\n", yytext); return ELSE; }
"if"           		{ printf("FROM FLEX IF %s\n", yytext); return IF; }
"int"          		{ printf("FROM FLEX INT %s\n", yytext); return INT; }
"return"       		{ printf("FROM FLEX RETURN %s\n", yytext); return RETURN; }
"void"         		{ printf("FROM FLEX VOID %s\n", yytext); return VOID; }
"while"        		{ printf("FROM FLEX WHILE %s\n", yytext); return WHILE; }

">="            	{printf("FROM FLEX SYMBOL %s\n", yytext);return GE;}
"<="            	{printf("FROM FLEX SYMBOL %s\n", yytext);return LE;}
"=="            	{printf("FROM FLEX SYMBOL %s\n", yytext);return EQ;}
"!="            	{printf("FROM FLEX SYMBOL %s\n", yytext);return NE;}
"+"	            	{printf("FROM FLEX SYMBOL %s\n", yytext);return *yytext;}
"-"            		{printf("FROM FLEX SYMBOL %s\n", yytext);return *yytext;}
"*"            		{printf("FROM FLEX SYMBOL %s\n", yytext);return *yytext;}
"/"            		{printf("FROM FLEX SYMBOL %s\n", yytext);return *yytext;}
"<"            		{printf("FROM FLEX SYMBOL %s\n", yytext);return *yytext;}
">"            		{printf("FROM FLEX SYMBOL %s\n", yytext);return *yytext;}
"="            		{printf("FROM FLEX SYMBOL %s\n", yytext);return *yytext;}
";"            		{printf("FROM FLEX SYMBOL %s\n", yytext);return *yytext;}
","            		{printf("FROM FLEX SYMBOL %s\n", yytext);return *yytext;}
"{"            		{printf("FROM FLEX SYMBOL %s\n", yytext);return *yytext;}
"}"            		{printf("FROM FLEX SYMBOL %s\n", yytext);return *yytext;}
"("            		{printf("FROM FLEX SYMBOL %s\n", yytext);return *yytext;}
")"            		{printf("FROM FLEX SYMBOL %s\n", yytext);return *yytext;}
"["            		{printf("FROM FLEX SYMBOL %s\n", yytext);return *yytext;}
"]"            		{printf("FROM FLEX SYMBOL %s\n", yytext);return *yytext;}


[ \t\r]+       	{}
[\n] 			{ line_number++;}

[a-zA-Z]+ 		{ printf("FROM FLEX ID: %s\n", yytext); return ID;}
[0-9]+		 	  { printf("FROM FLEX NUM: %s\n", yytext); return NUM;}
[_a-zA-Z0-9]* { yyerror(yytext,3,line_number); return ERROR;}

.             { yyerror(yytext,2,line_number); return ERROR;}

%%
