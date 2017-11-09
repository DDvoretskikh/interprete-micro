%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void esCorrectoIdentificador(char* s);

void yyerror(char* s);
int yyparse(void);

%}

%option yylineno

espacio [ \t]+
digito [0-9]
constante {digito}+
identificador ([a-z]|[A-Z])([a-z]|[A-Z]|[0-9])*



%%

{espacio} 			{/* Ignoramos espacios en blanco */}
"inicio"			{return(INICIO);}
"fin"				{return(FIN);}
"leer"				{return(LEER);}
"escribir"			{return(ESCRIBIR);}
{identificador}		{esCorrectoIdentificador(yytext);}
{constante}			{yylval.enteroVal=atoi(yytext); return(CONSTANTE);}

":="				{return(ASIGNACION);}
"+"					{return(MAS);}
"-"					{return(MENOS);}
"("					{return(PARENTESIS_IZQUIERDO);}
")"					{return(PARENTESIS_DERECHO);}
'\n'				{return(SALTO);}
","					{return(COMA);}
";"					{return(PUNTOYCOMA);}
. 					{printf("Error lexico en la linea %d /n", yylineno);}
%%

void esCorrectoIdentificador(char* yytext){
    if(strlen(yytext) > 32 ){
        printf("Error lexico en la linea %d. Ha superado la longitud para un identificador \n", lineas);
        exit(0)
    }
    yylval.stringVal = yytext;
    return IDENTIFICADOR;

}


void yyerror(char *s) {
  printf("Error sintactico %s \n",s);
}

int main(int argc, char **argv)
{
	if(argc == 2) {
		FILE* archivo = fopen(argv[1], "rt");
		if (archivo == NULL) {
			printf("Error al abrir el archivo. \n")
			exit(0)
		} else {
			yyin = archivo;
			yyparse();
			fclose(archivo);
		}
	}
}


