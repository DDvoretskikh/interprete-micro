%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct simbolo {
	char* id;
	int valor;
};

extern void yyerror(char *s);
extern int yylineno;

void mensajeFin(void);


%}

%union{
	char* stringVal
	int enteroVal;
}

%token <stringVal> IDENTIFICADOR 
%token <enteroVal> CONSTANTE MAS MENOS ASIGNACION PARENTESIS_IZQUIERDO PARENTESIS_DERECHO PUNTOYCOMA COMA SALTO INICIO ESCRIBIR LEER FIN

%left MAS MENOS

%type <entero> Expresion
%type <entero> Asignacion

%start Programa

%%

Programa: INICIO ListaDeSentencias FIN {mensajeFin();}
        ;

ListaDeSentencias: Sentencia PUNTOYCOMA SALTO
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

Expresion: IDENTIFICADOR             { buscarValorEnTabla($1) }
		 | CONSTANTE                 { $$ = $1; }
		 | Expresion MAS Expresion   { $$ = $1 + $3; }
		 | Expresion MENOS Expresion { $$ = $1 - $3; }		 		 
		 | MENOS Expresion           { $$ = -$2; }
		 | PARENTESIS_IZQUIERDO Expresion PARENTESIS_DERECHO { $$ = $2; }
		 ;

Asignacion: IDENTIFICADOR ASIGNACION Expresion {$$ = $1 = $3;}
		  ;

Lectura: LEER PARENTESIS_IZQUIERDO ListaDeIdentificadores PARENTESIS_DERECHO
       ;

Escritura: ESCRIBIR PARENTESIS_IZQUIERDO ListaDeExpresiones PARENTESIS_DERECHO
		 ;

%%

void mensajeFin() {
	printf("Entrada correcta! /n");
	exit(0);
}

int buscarValorEnTabla($1) {
	//El %1 es un struct de tipo simbolo
	//Buscamos en la tabla si exsite el $1.id
		//Si existe, mostramos $1.valor
		//Si no existe, mostramos errorIdentificadorNoDeclarado

}

void errorIdentificadorNoDeclarado(char* s) {
	printf("Error semantico: %s no es un identificador declarado. Linea: %d /n", s, yylineno);
	exit(0);
}

void errorPalabraReservada(char* s) {
	printf("Error semantico: %s es una palabra reservada. Linea: %d /n", s, yylineno)
}

void cargarIdentificadores(char* vector[], struct simbolo tabla) {
	int i = 0;
	int valor;

	while(vector[i] != '\0') {
		printf("Ingrese el valor de %s /n", vector[i]);
		scanf("%d", &valor);

		//Buscar si existe el id del identificador en la tabla
			//Si existe, reemplazar el valor del mismo
			//Si no existe, cargar identificador en la tabla con su valor 


		i++;
	}
}

void escribirValores(char* vector[], struct simbolo tabla) {
	int i = 0;

	int valor = //Buscar el valor del identificador que esta en vector[i] 
	printf("%d /n", valor);
	i++;

	while(vector[i] != '\0') {
		valor = //Buscar el valor del identificador que esta en vector[i] 
		printf(", %d /n", valor);
		i++;
	}
}