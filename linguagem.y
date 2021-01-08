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
  char vet[3]; 
  char outro_vet[3];
  int n = 0; // contador
%}
%union {int num; char *id;}
%token <id> ENTRADA SAIDA FIM ENQUANTO FACA INC ZERA SE ENTAO SENAO DEC VEZES
%token <id> ID NUM
%type <id> cmd cmds varlist
%%
program:
  ENTRADA varlist SAIDA varlist cmds FIM {
    // ABRINDO ARQUIVO EXTERNO
    FILE *arq_externo = fopen("arq_externo", "w");
    if (arq_externo == NULL) 
      exit(1); // ERRO LENDO ARQUIVO
    char aux[15];
    char* final = malloc(strlen($1) + strlen($2) +strlen($3) +strlen($4) + strlen($5) + strlen($6) + 5);
    int length = 15 * n;
    final = realloc(final, strlen($1) + strlen($2) +strlen($3) +strlen($4) + strlen($5) + strlen($6) + 5 + length);
    strcpy(final, $1); strcat(final, " ");
    strcat(final, $2); strcat(final, " ");
    while(n) {
      sprintf(vet, "%d", n);
      strcpy(aux, "__INT_VAR_");
      strcat(aux, vet);
      strcat(final, aux);
      strcat(final, " ");
	    n--;
    }
    strcat(final, $3); strcat(final, " ");
    strcat(final, $4); strcat(final, "\n");
    strcat(final, $5);
    strcat(final, $6);
    fprintf(arq_externo, "%s", final);
    fclose(arq_externo);
    printf("Funcionou direito!\n");
    exit(0);
  }
;
varlist:
  varlist ID {
    char* final = malloc(strlen($1) + strlen($2) + 2);
    strcpy(final, $1);
    strcat(final, " ");
    strcat(final, $2);
    $$ = final;
  }
  | ID {$$ = $1;}
;

cmds:
  cmd cmds {
    char* final = malloc(strlen($1) + strlen($2) + 1);
    strcpy(final, $1); 
    strcat(final, $2); 
    $$ = final;
  }
  | cmd {$$ = $1;}
;
cmd:
  ENQUANTO ID FACA cmds FIM {
    char* final = malloc(strlen($1) + strlen($2) + strlen($3) + strlen($4) + strlen($5) + 5);
    strcpy(final, $1); strcat(final, " ");
    strcat(final, $2); strcat(final, " ");
    strcat(final, $3); strcat(final, "\n");
    strcat(final, $4);
    strcat(final, $5); strcat(final, "\n");
    $$ = final;
  }
  | SE ID ENTAO cmds FIM {
    char* final = malloc(65 + strlen($4));
    n++;
    sprintf(vet, "%d", n);
    strcpy(final, "__INT_VAR_");
    strcat(final, vet);
    strcat(final, " = ");
    strcat(final, $2);
    strcat(final, "\nENQUANTO __INT_VAR_");
    strcat(final, vet);
    strcat(final, " FACA\n");
    strcat(final, $4);
    strcat(final, "ZERA(__INT_VAR_");
    strcat(final, vet);
    strcat(final, ")\nFIM\n");
    $$ = final;
  }
  | SE ID ENTAO cmds SENAO cmds FIM {
    char* final = malloc(170 + strlen($4) + strlen($6));
    n++; 
    sprintf(vet, "%d", n);
    n++; 
    sprintf(outro_vet, "%d", n);
    strcpy(final, "__INT_VAR_");
    strcat(final, vet);
    strcat(final, " = ");
    strcat(final, $2);
    strcat(final, "\nZERA(__INT_VAR_");
    strcat(final, outro_vet);
    strcat(final, ")\nINC(__INT_VAR_");
    strcat(final, outro_vet);
    strcat(final, ")\n");
    strcat(final, "ENQUANTO __INT_VAR_");
    strcat(final, vet);
    strcat(final, " FACA\n");
    strcat(final, $4);
    strcat(final, "ZERA(__INT_VAR_");
    strcat(final, vet);
    strcat(final, ")\nZERA(__INT_VAR_");
    strcat(final, outro_vet);
    strcat(final, ")\nFIM\n");
    strcat(final, "ENQUANTO __INT_VAR_");
    strcat(final, outro_vet);
    strcat(final, " FACA\n");
    strcat(final, $6);
    strcat(final, "ZERA(__INT_VAR_");
    strcat(final, outro_vet);
    strcat(final, ")\nFIM\n");
    $$ = final;
  }
  | FACA ID VEZES cmds FIM{
    char* final = malloc(64 + strlen($4));
    n++;
    sprintf(vet, "%d", n);
    strcpy(final, "__INT_VAR_");
    strcat(final, vet);
    strcat(final, " = ");
    strcat(final, $2);
    strcat(final, "\nENQUANTO __INT_VAR_");
    strcat(final, vet);
    strcat(final, " FACA\n");
    strcat(final, $4);
    strcat(final, "DEC(__INT_VAR_");
    strcat(final, vet);
    strcat(final, ")\n");
    strcat(final, "FIM\n");
    $$ = final;
  }
  | ID '=' ID {
    char* final = malloc(strlen($1) + strlen($3) + 5); 
    strcpy(final, $1);
    strcat(final, " = ");
    strcat(final, $3);
    strcat(final, "\n"); 
    $$ = final;
  }
  | ID '=' NUM {
    char* final = malloc(strlen($1) + strlen($3) + 5);
    strcpy(final, $1);
    strcat(final, " = ");
    strcat(final, $3);
    strcat(final, "\n"); 
    $$ = final;
  }
  | DEC '(' ID ')' {
    char* final = malloc(strlen($1) + strlen($3) + 4);
    strcpy(final, $1);
    strcat(final, "(");
    strcat(final, $3);
    strcat(final, ")\n"); 
    $$ = final;
  }
  | INC '(' ID ')' {
    char* final = malloc(strlen($1) + strlen($3) + 4);
    strcpy(final, $1);
    strcat(final, "(");
    strcat(final, $3);
    strcat(final, ")\n"); 
    $$ = final;
  }
  | ZERA '(' ID ')' {
    char* final = malloc(strlen($1) + strlen($3) + 4);
    strcpy(final, $1);
    strcat(final, "(");
    strcat(final, $3);
    strcat(final, ")\n"); 
    $$ = final;
  }
;
%%
void yyerror(){
  //fprintf(stderr, "erro linha: %d\n", nova_linha);
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
