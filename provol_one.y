%{
  #include <stdio.h>
  #include <string.h>
  #include <stdlib.h>
  int yylex(); 
  /*  implies the main entry point for lex, reads the input stream generates tokens, returns zero at the end of input stream.
  It is called to invoke the lexer (or scanner) and each time yylex() is called,
  the scanner continues processing the input from where it last left off.*/
  void yyerror();
  extern int nova_linha;
  extern FILE *yyin; // points to an input file which is to be scanned or tokenised
%}
%union {char *id;}
%token ENTRADA SAIDA FIM ENQUANTO FACA INC DEC ZERA
%token <id> ID NUM
%type <id> cmd cmds varlist id
%%
program:
  ENTRADA varlist SAIDA varlist cmds FIM {
    // resultado no arquivo de saida .txt
    FILE *arq_saida = fopen("arq_saida.c", "w");
    if (arq_saida == NULL) 
      exit(1); // ERRO ABRINDO ARQUIVO
    char* armazena = malloc(strlen($2) + strlen($4) + strlen($5) + 20);
    strcpy(armazena, "int main() {\n");
    strcat(armazena, $2); 
    strcat(armazena, $4); 
    strcat(armazena, $5);
    strcat(armazena, "}");
    fprintf(arq_saida, "%s", armazena);
    fclose(arq_saida);
    printf("Funcionou direito!\n");
    exit(0);
  }
;
varlist:
  varlist id {
    char* final = malloc(strlen($1) + strlen($2) + 1);
    strcpy(final, $1);
    strcat(final, $2);
    $$ = final;
  }
  | id {$$ = $1;}
;
id:
  ID {
    char* final = malloc(strlen($1) + 11);
    strcpy(final, "int ");
    strcat(final, $1); 
    strcat(final, " = 0;\n");
    $$ = final;
  }
;
cmds:
  cmd cmds {
    char* final = malloc(strlen($1) + strlen($2) + 1);
    strcpy(final, $1); 
    strcat(final, $2); 
    $$ = final;
  } | cmd {$$ = $1;}
;

cmd:
  ENQUANTO ID FACA cmds FIM {
    char* final = malloc(strlen($2) + strlen($4) + 12); 
    strcpy(final, "while(");
    strcat(final, $2); 
    strcat(final, "){\n"); 
    strcat(final, $4); 
    strcat(final, "}\n");
    $$ = final;
  }
  | ID '=' ID {
    char* final = malloc(strlen($1) + strlen($3) + 6); strcpy(final, $1);
    strcat(final, " = "); 
    strcat(final, $3); 
    strcat(final, ";\n"); 
    $$ = final;
  }
  | ID '=' NUM {
    char* final = malloc(strlen($1) + strlen($3) + 6); strcpy(final, $1);
    strcat(final, " = "); 
    strcat(final, $3); 
    strcat(final, ";\n"); 
    $$ = final;
  }
  | INC '(' ID ')' {
    char* final = malloc(strlen($3) + 5); 
    strcpy(final, $3);
    strcat(final, "++;\n"); 
    $$ = final;
  }
  | DEC '(' ID ')' {
    char* final = malloc(strlen($3) + 5); 
    strcpy(final, $3);
    strcat(final, "--;\n");
    $$ = final;
  }
  | ZERA '(' ID ')' {
    char* final = malloc(strlen($3) + 7); 
    strcpy(final, $3);
    strcat(final, " = 0;\n"); 
    $$ = final;
  }
;

%%
void yyerror(){
  fprintf(stderr, "Erro linha: %d\n", nova_linha);
};  
int main (int argc, char** argv) {
  if (argc > 1) {
    yyin = fopen(argv[1], "r");
  }
  yyparse();
  if (argc > 1) {
    fclose(yyin);
  }
  return(0);
}
