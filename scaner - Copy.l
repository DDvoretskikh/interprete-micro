%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int lineas = 0;
int cantvariables = 0;

struct variable{
    int valor;
    char* nombre;
} variables[20];

int esCorrectoIdentificador(char*);

%}

%option noyywrap

espacio [ \t]+
digito [0-9]
constante {digito}+
identificador ([a-zA-Z])([a-zA-Z0-9])*



%%

{espacio} 			{/* Ignoramos espacios en blanco */}
"inicio"			{return(INICIO);}
"fin"				{return(FIN);}
"leer"				{return(LEER);}
"escribir"			{return(ESCRIBIR);}
{identificador}		{strcpy(yylval.nombre,yytext); esCorrectoIdentificador(yytext); return(IDENTIFICADOR);}
{constante}			{yylval.entero=atoi(yytext); return(CONSTANTE);}



":="				{return(ASIGNACION);}
"+"					{return(MAS);}
"-"					{return(MENOS);}
"("					{return(PARENTESIS_IZQUIERDO);}
")"					{return(PARENTESIS_DERECHO);}
'\n'				{return(SALTO);}
","					{return(COMA);}
";"					{lineas++;return(PUNTOYCOMA);}
. 					{printf("Error lexico en la linea %d /n", lineas);}
%%

int esCorrectoIdentificador(char* id){
    if(strlen(id) > 32 ){
        printf("Error lexico en la linea %d. Ha superado la longitud para un identificador \n", lineas);
        exit(0);
    }else{
        strcpy(variables[cantvariables].nombre , id);
        variables[cantvariables].valor = 0;
        cantvariables++;
        return 1;
    }


}


