%{
#include "cmin.tab.h"
extern int line_number;
extern int line_char;
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
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]       {line_number = yylineno; }
[/][*]                                    {yyerror(yytext,4,line_number); return ERROR;}
[*][/]                                    {yyerror(yytext,5,line_number); return ERROR;}

"else"         		{ printf("FROM FLEX ELSE %s\n", yytext); line_char++; return ELSE; }
"if"           		{ printf("FROM FLEX IF %s\n", yytext);  line_char++; return IF; }
"int"          		{ printf("FROM FLEX INT %s\n", yytext);  line_char++; return INT; }
"return"       		{ printf("FROM FLEX RETURN %s\n", yytext);  line_char++; return RETURN; }
"void"         		{ printf("FROM FLEX VOID %s\n", yytext);  line_char++; return VOID; }
"while"        		{ printf("FROM FLEX WHILE %s\n", yytext);  line_char++; return WHILE; }

">="            	{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return GE;}
"<="            	{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return LE;}
"=="            	{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return EQ;}
"!="            	{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return NE;}
"+"	            	{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return *yytext;}
"-"            		{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return *yytext;}
"*"            		{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return *yytext;}
"/"            		{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return *yytext;}
"<"            		{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return *yytext;}
">"            		{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return *yytext;}
"="            		{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return *yytext;}
";"            		{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return *yytext;}
","            		{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return *yytext;}
"{"            		{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return *yytext;}
"}"            		{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return *yytext;}
"("            		{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return *yytext;}
")"            		{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return *yytext;}
"["            		{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return *yytext;}
"]"            		{printf("FROM FLEX SYMBOL %s\n", yytext); line_char++; return *yytext;}


[ \t\r]+       	{}
[\n] 			{ line_number++; line_char=0;}

[a-zA-Z]+ 		{ printf("FROM FLEX ID: %s\n", yytext);  line_char++; return ID;}
[0-9]+		 	  { printf("FROM FLEX NUM: %s\n", yytext);  line_char++; return NUM;}
[_a-zA-Z0-9]* { yyerror(yytext,3,line_number); return ERROR;}

.             { yyerror(yytext,2,line_number); return ERROR;}

%%
