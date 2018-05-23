%{                                                                                          
#include "cmin.tab.h"                                                                     
extern int line_number;
void yyerror (char const *s) {
   fprintf (stderr, "%s\n", s);
 }                                                               
%}                                                                                          
%option noyywrap                                                                            
 
%%                                        
"/*" 				{
						printf("FROM FLEX COMMENT SECTION STARTED.\n/*");
						register int c;
						for ( ; ; )
						{
							while ( (c = input()) != '*' && c != EOF ){
								printf("%c", c);
							}

							if ( c == '*' )
							{
								while ( (c = input()) == '*' ){
									printf("%c", c);
								};
								if ( c == '/' )
								break;
							}

							if ( c == EOF )
							{
								yyerror( "EOF in comment" );
								break;
							}
						}
						printf("/*\nFROM FLEX COMMENT SECTION ENDED.\n");
					}     
                                                  
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
[0-9]+		 	{ printf("FROM FLEX NUM: %s\n", yytext); return NUM;}
 
.               { yyerror("Unknown character"); return 1;}  
                                                                  
%%