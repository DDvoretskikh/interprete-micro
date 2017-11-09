%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
extern void yyerror(char *s);
extern int lineas;
extern char* yytext;



struct variable{
    int valor;
    char id[50];
} variables[20];

int cantvariables = 0;

void agregarValorId(char*, int);
int obtenerValorDeTabla(char*);
int existeIdentificador(char*);
int existeIdentificadorLex(char*);
void agregarIdentificador(char*);


%}

%union{
	int entero;
    char* nombre;
}


%token <entero> CONSTANTE
%token <nombre>IDENTIFICADOR
%token <nombre> MAS
%token <nombre> MENOS
%token <nombre> ASIGNACION
%token <nombre> PARENTESIS_IZQUIERDO
%token <nombre> PARENTESIS_DERECHO
%token <nombre> PUNTOYCOMA
%token <nombre> COMA
%token <nombre> SALTO
%token <nombre> INICIO
%token <nombre> ESCRIBIR
%token <nombre> LEER
%token <nombre> FIN


%left ASIGNACION
%left MAS
%left MENOS


%type <entero> Expresion
%type <entero> VariableAsig
%type <nombre> Variable
%type <nombre> Asignar

%start Programa

%%

Programa: INICIO ListaDeSentencias FIN
        ;
ListaDeSentencias: Sentencia PUNTOYCOMA
	             | Sentencia PUNTOYCOMA ListaDeSentencias
	             ;
Sentencia: Asignar
		 | Lectura
		 | Escritura
		 ;

ListaDeIdentificadores: IDENTIFICADOR                               {printf("lista id \n");agregarIdentificador(yytext);}
					  | ListaDeIdentificadores COMA IDENTIFICADOR   {printf("lista id \n");agregarIdentificador($3);}
					  ;
ListaDeExpresiones: Expresion
				  | ListaDeExpresiones COMA Expresion
				  ;


Variable: IDENTIFICADOR {agregarIdentificador(yytext);$$ = yytext ;printf("VariableIDParaAsignar: %s \n", yytext); }
            ;
VariableAsig: IDENTIFICADOR {$$ = obtenerValorDeTabla($1);printf("VariableID: %s \n", $1);}
            ;

Expresion: CONSTANTE                 { $$= $1;}
         | VariableAsig              { $$= $1;}
		 | Expresion MAS Expresion   { $$=$1 + $3;}
		 | Expresion MENOS Expresion { $$=$1 - $3;}
		 | MENOS Expresion           { $$=-$2; }
		 | PARENTESIS_IZQUIERDO Expresion PARENTESIS_DERECHO { $$=$2; }
		 ;



Asignar: Variable ASIGNACION Expresion
		  ;

Lectura: LEER PARENTESIS_IZQUIERDO ListaDeIdentificadores PARENTESIS_DERECHO
            ;
Escritura: ESCRIBIR PARENTESIS_IZQUIERDO ListaDeExpresiones PARENTESIS_DERECHO
		 ;

%%

void yyerror(char *s)
{
  printf("Ha ocurrido un Error. %s en linea %d \n",s,lineas);
}

int main(int argc, char **argv)
{
	if(argc>1)
		yyin=fopen(argv[1], "rt");
	else
		yyin=stdin;

	yyparse();

	printf("Fin del analisis. \n");
	printf("Numero de lineas analizadas: %d \n", lineas);

	return 0;
}

int obtenerValorDeTabla(char* id){
    int i;
    printf("obtValorDeTablaLeido : %s \n", id);
    printf("cantvariables : %d \n", cantvariables);

    for(i=0; i< cantvariables; i++){
        char* unacosa;
        strcpy(unacosa,variables[i].id);
        if((strcmp(id, unacosa) == 0)){
            printf("obtvalortabla: %s, %d \n", variables[i].id, variables[i].valor);
            return variables[i].valor;
        }
    }
    yyerror("El identificador no ha sido declarado antes. Error semantico \n");
    exit(0);
}


void agregarValorId(char* nombre, int valor){
    int i;
    printf("AgregoValorID: %s \n", nombre);
    for(i=0; i< cantvariables; i++){
        if(strcmp(variables[i].id, nombre) == 0){
            variables[i].valor = valor;
        }
    }
}

void  agregarIdentificador(char* nombre){
        if(!existeIdentificadorLex(nombre)){
            strcpy(variables[cantvariables].id, nombre);
            printf("Agrego ID: %s \n",variables[cantvariables].id);
            variables[cantvariables].valor = 0;
            ++cantvariables;
            printf("CantVariablesCreadas: %d", cantvariables);
        }
}
int existeIdentificadorLex(char* id){
	int i;
	 for(i=0; i< cantvariables; i++){
        if(strcmp(variables[i].id, id) == 0){
           return 1;
        }
    }
    return 0;
}

int existeIdentificador(char* id){
	int i;
	 for(i=0; i< cantvariables; i++){
        if(strcmp(variables[i].id, id)==0){
            printf("extID: El identificador %s ha sido correctamente declarado. \n ", variables[i].id);
        }
    }
	 yyerror("extId: El identificador no ha sido declarado antes. Error semantico \n");
	 exit(0);
}

