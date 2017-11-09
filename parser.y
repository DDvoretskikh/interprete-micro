%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
extern void yyerror(char *s);
extern int lineas;
extern char* yytext;

extern int cantnombres;
extern struct nombreId{
    char id[50];
}nombresid[50];


struct variable{
    int valor;
    char id[50];
} variables[20];

int cantvariables = 0;
int valorvariable = 0;

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
%type <entero> ExpresionEscritura
%type <entero> VariableEscritura


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

ListaDeIdentificadores: IDENTIFICADOR                               {printf("Ingrese valor de %s: \n",yytext);
                                                                        scanf("%d", &valorvariable);
                                                                        agregarIdentificador(yytext);
                                                                        agregarValorId(yytext,valorvariable);
                                                                        cantnombres = 0;}
					  | ListaDeIdentificadores COMA IDENTIFICADOR   {printf("Ingrese valor de %s: \n",yytext);
                                                                        scanf("%d", &valorvariable);
                                                                        agregarIdentificador($3);
                                                                        agregarValorId($3,valorvariable);
                                                                        cantnombres = 0;}
					  ;
ListaDeExpresiones: ExpresionEscritura                          {printf(" Resultado: %d \n", $1);}
				  | ListaDeExpresiones COMA ExpresionEscritura  {printf(" Resultado: %d \n", $3);}
				  ;

VariableAsig: IDENTIFICADOR {$$ = obtenerValorDeTabla($1);}
            ;

VariableEscritura: IDENTIFICADOR {$$ = obtenerValorDeTabla(nombresid[0].id);
                                    cantnombres=0;}
            ;
ExpresionEscritura: CONSTANTE        { $$= $1;printf("Valor de operacion: %d\n",$1);}
         | VariableEscritura         { $$= $1;}
		 | ExpresionEscritura MAS ExpresionEscritura   { $$=$1 + $3; printf("Operacion:+\n");}
		 | ExpresionEscritura MENOS ExpresionEscritura { $$=$1 - $3; printf("Operacion: - \n");}
		 | MENOS ExpresionEscritura { printf("Signo de operacion: - \n"); $$=-$2;}
		 | PARENTESIS_IZQUIERDO ExpresionEscritura PARENTESIS_DERECHO {printf("(");$$=$2; printf(")");}
		 ;

Expresion:   CONSTANTE                 { $$= $1; }
                    | VariableAsig              { $$= $1;}
		 | Expresion MAS Expresion   { $$=$1 + $3; }
		 | Expresion MENOS Expresion { $$=$1 - $3;}
		 | MENOS Expresion           { $$=-$2; }
		 | PARENTESIS_IZQUIERDO Expresion PARENTESIS_DERECHO { $$=$2; }
		 ;


Asignar: IDENTIFICADOR ASIGNACION Expresion {agregarIdentificador(nombresid[0].id);
                                             printf("VariableIDParaAsignar: %s \n",nombresid[0].id);
                                             agregarValorId(nombresid[0].id, $3);
                                             cantnombres = 0;}
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
	else{
        printf("Falta elegir un archivo. \n");
        exit(0);
	}


	yyparse();
    printf("Cantidad de variables creadas: %d \n", cantvariables);
	printf("Fin del analisis. \n");
	printf("Numero de lineas analizadas: %d \n", lineas);

	return 0;
}

int obtenerValorDeTabla(char* id){
    int i;
    printf("obtValorDeTablaLeido : %s \n", id);

    for(i=0; i< cantvariables; i++){
        char* unacosa;
        strcpy(unacosa,variables[i].id);
        if((strcmp(id, unacosa) == 0)){
            return variables[i].valor;
        }
    }
    yyerror("El identificador no ha sido declarado antes. Error semantico \n");
    exit(0);
}


void agregarValorId(char* nombre, int valor){
    int i;
    for(i=0; i< cantvariables; i++){
        if(strcmp(variables[i].id, nombre) == 0){
            variables[i].valor = valor;
            printf("Se agrego valor correctamente. Valor: %d \n", variables[i].valor);
        }
    }
}

void  agregarIdentificador(char* nombre){
        if(!existeIdentificadorLex(nombre)){
            strcpy(variables[cantvariables].id, nombre);
            printf("Agrego ID: %s \n",variables[cantvariables].id);
            variables[cantvariables].valor = 0;
            ++cantvariables;
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



