%{
#include <math.h>
#include <stdio.h>
extern FILE *yyin;
extern void yyerror(char *s);
extern int lineas;

%}

%union{
	int entero;
}

%token <entero> IDENTIFICADOR
%token <entero> CONSTANTE
%token MAS
%token MENOS
%token ASIGNACION
%token PARENTESIS_IZQUIERDO
%token PARENTESIS_DERECHO
%token PUNTOYCOMA
%token COMA
%token SALTO
%token INICIO
%token ESCRIBIR
%token LEER
%token FIN

%left ASIGNACION
%left MAS
%left MENOS

%type <entero> Expresion
%type <entero> Asignacion
%start Programa

%%

Programa: INICIO ListaDeSentencias FIN
        ;
ListaDeSentencias: Sentencia PUNTOYCOMA
	             | Sentencia PUNTOYCOMA ListaDeSentencias
	             ;
Sentencia: Asignacion
		 | Lectura
		 | Escritura
		 ;

ListaDeIdentificadores: IDENTIFICADOR
					  | ListaDeIdentificadores COMA IDENTIFICADOR
					  ;
ListaDeExpresiones: Expresion
				  | ListaDeExpresiones COMA Expresion
				  ;

Expresion: IDENTIFICADOR             { $$=$1; }
		 | CONSTANTE                 { $$=$1; }
		 | Expresion MAS Expresion   { $$=$1+$3; }
		 | Expresion MENOS Expresion { $$=$1-$3; }
		 | MENOS Expresion           { $$=-$2; }
		 | PARENTESIS_IZQUIERDO Expresion PARENTESIS_DERECHO { $$=$2; }
		 ;
Asignacion: IDENTIFICADOR ASIGNACION Expresion {$$ = $1 = $3;}
		  ;

Lectura: LEER PARENTESIS_IZQUIERDO ListaDeIdentificadores PARENTESIS_DERECHO
            ;
Escritura: ESCRIBIR PARENTESIS_IZQUIERDO ListaDeExpresiones PARENTESIS_DERECHO
		 ;

%%

void yyerror(char *s)
{
  printf("Error sintactico %s \n",s);
}

int main(int argc, char **argv)
{
	if(argc>1)
		yyin=fopen(argv[1], "rt");
	else
		yyin=stdin;

	yyparse();

	printf("Fin del analisis sintactico. \n");
	printf("Numero de lineas analizadas: %d \n", lineas);

	return 0;
}
