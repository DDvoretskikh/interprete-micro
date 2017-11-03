%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int lineas = 0;
%}

%option noyywrap

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
{identificador}		{esCorrectoIdentificador(yytext); return(IDENTIFICADOR);}
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

void esCorrectoIdentificador(char* yytext){
    yylval.entero=atoi(yytext);
    if(strlen(yytext) > 32 ){
        printf("Error lexico en la linea %d. Ha superado la longitud para un identificador \n", lineas);
    }
}


