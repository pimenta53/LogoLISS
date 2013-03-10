%{
%}

PROGRAM					"PROGRAM"
DECLARATIONS			"DECLARATIONS"
STATEMENTS				"STATEMENTS"
INTEGER					"INTEGER"
BOOLEAN					"BOOLEAN"
ARRAY						"ARRAY"
TRUE_						"TRUE"
FALSE_					"FALSE"
SIZE						"SIZE"
FORWARD					"FORWARD"
BACKWARD					"BACKWARD"
RRIGHT					"RRIGHT"
RLEFT						"RLEFT"
PEN						"PEN"
UP							"UP"
DOWN						"DOWN"
GOTO						"GOTO"
WHERE						"WHERE"
SUCC						"SUCC"
PRED						"PRED"
SAY						"SAY"
ASK						"ASK"
IF							"IF"
THEN						"THEN"
ELSE						"ELSE"
WHILE						"WHILE"
ARROW						"->"
OR							"||"
AND						"&&"
EQUAL						"=="
DIF						"!="
MMULT						"**"
LE							"<="
GE							">="
IN							"in"			

%option yylineno 
%%
\/\/.*										{}
{PROGRAM}									{return(PROGRAM);}
{DECLARATIONS}								{return(DECLARATIONS);}
{STATEMENTS}								{return(STATEMENTS);}
{INTEGER}									{yylval.s = strdup(yytext);return(INTEGER);}
{BOOLEAN}									{yylval.s = strdup(yytext);return(BOOLEAN);}
{ARRAY}										{return(ARRAY);}
{TRUE_}										{yylval.s = strdup(yytext);return(TRUE_);}
{FALSE_}										{yylval.s = strdup(yytext);return(FALSE_);}
{SIZE}										{return(SIZE);}
{FORWARD}									{return(FORWARD);}
{BACKWARD}									{return(BACKWARD);}
{RRIGHT}										{return(RRIGHT);}
{RLEFT}										{return(RLEFT);}
{PEN}											{return(PEN);}
{UP}											{return(UP);}
{DOWN}										{return(DOWN);}
{GOTO}										{return(GOTO);}
{WHERE}										{return(WHERE);}
{SUCC}										{return(SUCC);}
{PRED}										{return(PRED);}
{SAY}											{return(SAY);}
{ASK}											{return(ASK);}
{IF}											{return(IF);}
{THEN}										{return(THEN);}
{ELSE}										{return(ELSE);}
{WHILE}										{return(WHILE);}
{ARROW}										{return(ARROW);}
{OR}											{return(OR);}
{AND}											{return(AND);}
{EQUAL}										{return(EQUAL);}
{DIF}											{return(DIF);}
{MMULT}										{return(MMULT);}
{LE}											{return(LE);}
{GE}											{return(GE);}
{IN}											{return(IN);}
-?[0-9]+										{yylval.s = strdup(yytext); return(NUMBER); }
[a-zA-Z][a-zA-Z0-9_]*					{yylval.s = strdup(yytext); return(IDENTIFIER); }
\"([^"\n]|\\\")*\"						{yylval.s = strdup(yytext); return(STRING);}
[<=>\-,;!?/()\[\]\{\}*+]				{return(yytext[0]);}
[\ \n\t\r]+ 								{;}
<*>.|\n										{fprintf(stderr,"ERRO %s\n",yytext);}
%%

int yywrap(){
   return 1;
}

