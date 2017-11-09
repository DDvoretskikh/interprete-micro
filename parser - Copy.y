%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
extern void yyerror(char *s);
extern int lineas;
extern int cantvariables;

extern struct variable{
    int valor;
    char* nombre;
} variables[20];

int agregarValorId(char*, int);
int obtenerValorDeTabla(char*);

%}

%union{
	int entero;
    char* nombre;
}


%token <entero> CONSTANTE

%token <nombre> IDENTIFICADOR
%token <nombre>MAS
%token <nombre>MENOS
%token <nombre>ASIGNACION
%token <nombre>PARENTESIS_IZQUIERDO
%token <nombre>PARENTESIS_DERECHO
%token <nombre>PUNTOYCOMA
%token <nombre>COMA
%token <nombre>SALTO
%token <nombre>INICIO
%token <nombre>ESCRIBIR
%token <nombre>LEER
%token <nombre>FIN

%left ASIGNACION
%left MAS
%left MENOS

%type <entero> Expresion
%type <entero> Asignacion
%type <entero> Variable

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


Expresion: Variable                  { $$= $1;}
		 | CONSTANTE                 { $$= $1; }
		 | Expresion MAS Expresion   { $$=$1 + $3;}
		 | Expresion MENOS Expresion { $$=$1 - $3;}
		 | MENOS Expresion           { $$=-$2; }
		 | PARENTESIS_IZQUIERDO Expresion PARENTESIS_DERECHO { $$=$2; }
		 ;

Variable: IDENTIFICADOR {$$ = obtenerValorDeTabla($1);}
            ;


Asignacion: IDENTIFICADOR ASIGNACION Expresion {$$ = agregarValorId($1,$3);  }
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

int obtenerValorDeTabla(char* nombre){
    int i;
    for(i=0; i< cantvariables; i++){
        if(strcmp(variables[i].nombre, nombre)){
            return variables[i].valor;
        }
    }
    return 0;
}

int agregarValorId(char* nombre, int valor){
    int i;
    for(i=0; i< cantvariables; i++){
        if(strcmp(variables[i].nombre,nombre)){
            variables[i].valor = valor;
            return valor;
        }
    }
    exit(0);
}




