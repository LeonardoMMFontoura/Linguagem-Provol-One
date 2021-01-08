%{
  #include <stdio.h>
  #include <string.h>
  #include "linguagem.tab.h"
  int nova_linha = 1;
%}
variavel    ([_a-zA-Z][_a-zA-Z0-9]*)
numero      ([0-9]+)
%%
ENTRADA     {yylval.id=strdup(yytext); return (ENTRADA);}
SAIDA       {yylval.id=strdup(yytext); return (SAIDA);}
FIM         {yylval.id=strdup(yytext); return (FIM);}
ENQUANTO    {yylval.id=strdup(yytext); return (ENQUANTO);}
FACA        {yylval.id=strdup(yytext); return (FACA);}
VEZES		    {yylval.id=strdup(yytext); return (VEZES);}
SE			    {yylval.id=strdup(yytext); return (SE);}
ENTAO		    {yylval.id=strdup(yytext); return (ENTAO);}
SENAO		    {yylval.id=strdup(yytext); return (SENAO);}
INC         {yylval.id=strdup(yytext); return (INC);}
DEC         {yylval.id=strdup(yytext); return (DEC);}
ZERA        {yylval.id=strdup(yytext); return (ZERA);}
[=()]       {return yytext[0];}
{variavel}       {yylval.id=strdup(yytext); return (ID);}
{numero}    {yylval.id=strdup(yytext); return (NUM);}
[\n]        {nova_linha++;}
.           ;
%%
