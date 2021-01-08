%{
  #include <stdio.h>
  #include <string.h>
  #include "provol_one.tab.h"
  int nova_linha = 1;
%}
variavel   ([_a-zA-Z][_a-zA-Z0-9]*)
numero     ([0-9]+)
%%
ENTRADA     {return (ENTRADA);}
SAIDA       {return (SAIDA);}
FIM         {return (FIM);}
ENQUANTO    {return (ENQUANTO);}
FACA        {return (FACA);}
INC         {return (INC);}
DEC         {return (DEC);}
ZERA        {return (ZERA);}
[=()]       {return yytext[0];}
{variavel}  {yylval.id=strdup(yytext); return (ID);}
{numero}    {yylval.id=strdup(yytext); return (NUM);}
[\n]        {nova_linha++;}
.           ;
%%
