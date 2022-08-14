
%{

#include <stdlib.h>
#include <stdio.h>


int cmnt_strt = 0;

%}

letter [a-zA-Z]
digit [0-9]
ws  [ \t\r\f\v]+
identifier (_|{letter})({letter}|{digit}|_){0,31}
hex [0-9a-f]

 /* Exclusive states */
%x CMNT
%x PREPROC

%%
  /* Keywords*/
"int"                             {printf("\t%-30s : Data Type\n",yytext);}
"long"                            {printf("\t%-30s : Data Type\n",yytext);}
"long long"                       {printf("\t%-30s : Data Type\n",yytext);}
"short"                           {printf("\t%-30s : Data Type\n",yytext);}
"signed"                          {printf("\t%-30s : Data Type\n",yytext);}
"unsigned"                        {printf("\t%-30s : Data Type\n",yytext);}
"for"                             {printf("\t%-30s : Keyword\n",yytext);}
"break"                           {printf("\t%-30s : Keyword\n",yytext);}
"continue"                        {printf("\t%-30s : Keyword\n",yytext);}
"if"                              {printf("\t%-30s : Keyword\n",yytext);}
"else"                            {printf("\t%-30s : Keyword\n",yytext);}
"return"                          {printf("\t%-30s : Keyword\n",yytext);}

{identifier}                      {printf("\t%-30s : Identifier\n", yytext);}
{ws}                              ;
[+\-]?[0][x|X]{hex}+[lLuU]?        {printf("\t%-30s : Hex Constant\n", yytext);}
[+\-]?{digit}+[lLuU]?              {printf("\t%-30s : Dec Constant\n", yytext);}
"/*"                              {cmnt_strt = yylineno; BEGIN CMNT;}
<CMNT>.|{ws}                      ;
<CMNT>\n                          {yylineno++;}
<CMNT>"*/"                        {BEGIN INITIAL;}
<CMNT>"/*"                        {printf("Line %3d: Nested comments are not valid!\n",yylineno);}
<CMNT><<EOF>>                     {printf("Line %3d: Unterminated comment\n", cmnt_strt); yyterminate();}
^"#include"                       {BEGIN PREPROC;}
<PREPROC>"<"[^<>\n]+">"            {printf("\t%-30s : Header file\n",yytext);}
<PREPROC>{ws};
<PREPROC>\"[^"\n]+\"              {printf("\t%-30s : Header file\n",yytext);}
<PREPROC>\n                       {yylineno++; BEGIN INITIAL;}
