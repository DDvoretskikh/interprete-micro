%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int lineas = 0;

struct nombreId{
    char id[50];
}nombresid[50];
int cantnombres = 0 ;

void esCorrectoIdentificador(char*);
void guardarNombre(char*);

%}

%option noyywrap

espacio [ \t]+
digito [0-9]
constante {digito}+
letra [a-zA-Z]
identificador {letra}+



%%

{espacio} 			{/* Ignoramos espacios en blanco */}
"inicio"			{return(INICIO);}
"fin"				{return(FIN);}
"leer"				{return(LEER);}
"escribir"			{return(ESCRIBIR);}

":="				{return(ASIGNACION);}
"+"					{return(MAS);}
"-"					{return(MENOS);}
"("					{return(PARENTESIS_IZQUIERDO);}
")"					{return(PARENTESIS_DERECHO);}
'\n'				{return(SALTO);}
","					{return(COMA);}
";"					{lineas++;return(PUNTOYCOMA);}
{constante}			{yylval.entero=atoi(yytext); return(CONSTANTE);}
{identificador}		{yylval.nombre = yytext;
                     printf("yytext: %s \n", yytext);
                     esCorrectoIdentificador(yytext);
                     guardarNombre(yytext);
                     return(IDENTIFICADOR);}
. 					{printf("Error lexico en la linea %d \n", lineas);}
%%

void esCorrectoIdentificador(char* yytext){
    if(strlen(yytext) > 32 ){
        printf("Error lexico en la linea %d. Ha superado la longitud para un identificador \n", lineas);
    }
}

void guardarNombre(char* id){
    strcpy(nombresid[cantnombres].id, id);
    ++cantnombres;
}


