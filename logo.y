%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <glib-2.0/glib.h>

#define STACK_SIZE 30

/************Variaveis***********/ 
extern char *yytext;
extern int yylineno;

typedef struct vstruct{
   char *id;
   int end;
   int type;
} Variavel;

GHashTable *varsHT;
Variavel *var;

int labels[STACK_SIZE];
int varType[STACK_SIZE];
int varPt = 0;

int cl=1; 			//count label
int sp=3, gp=3;  	//stack pointer, global pointer

int janelaAberta= 0;		// vefifica se a janela ja foi aberta
int pen = 1;		// estado da caneta
int direcao = 2; 	// 0-cima; 1-direita; 2-baixo; 3-esquerda

/***********ASSINATURA FUNCOES************/
void push(int i);
int pop(int pos);
Variavel *criaVar(char *id, int type);
int matchType(int type);
void iniciaVarsTurtle();
void lerPosTurtle();
void actPosTurtle();
void mover(char *x, char *y);
void rotateEsq();
void rotateDir();
void mostarPos();

%}
%token PROGRAM
%token DECLARATIONS
%token STATEMENTS
%token ARRAY
%token SIZE
%token INIT_WINDOW
%token INIT_TURTLE
%token FORWARD
%token BACKWARD
%token RRIGHT
%token RLEFT
%token PEN
%token UP
%token DOWN
%token GOTO
%token WHERE
%token SUCC
%token PRED
%token SAY
%token ASK
%token IF
%token THEN
%token ELSE
%token WHILE
%token ARROW
%token OR AND EQUAL DIF MMULT LE GE IN

%token <s>IDENTIFIER
%token <s>STRING
%token <s>NUMBER
%token <s>TRUE_ FALSE_ BOOLEAN INTEGER

%type <n>Factor
%type <v>Var
%type <n>Constant 
%type <n>Inic_Var 
%type <n>Type 
%type <n>Value_Var 
%type <s>Elem 
%type <s>Array_Definition
%type <s>Array_Initialization 
%type <s>Variable 
%type <s>Add_Op 
%type <s>Mul_Op 
%type <s>Rel_Op
%type <n>SuccPred
%type <n>SuccOrPred

%union{
	int n;
	char *s;
	Variavel *v;
}

%start Liss

%%

/************************ Program */
Liss 						: {iniciaVarsTurtle();} 											/*inicia variaveis com as posicoes da tartaruga*/
							  PROGRAM IDENTIFIER '{' Body '}' 								{printf("stop\n"); return 0;}	
							;

Body						: DECLARATIONS Declarations STATEMENTS Statements
							;

/************************ Declarations */
Declarations 			: Declaration																											
							| Declarations Declaration											{printf("start\n");}	
							;

Declaration				: Variable_Declaration
							;

/************************ Declarations: Variables */
Variable_Declaration	: Vars ARROW Type ';'												{if(!matchType($3)) { fprintf(stderr,"ERRO: Declaracao Variavel\n"); return 0; } varPt = 0; }
							;

Vars  					: Var				 														{ g_hash_table_insert(varsHT,$1->id, $1); gp++; }
    						| Vars ',' Var	 														{ g_hash_table_insert(varsHT,$3->id, $3); gp++; }
							;

Var						: IDENTIFIER Value_Var 												{ $$=criaVar($1,$2); }
							;

Value_Var				:			  																{ $$ = 0; varType[varPt] = 0; varPt++; printf("pushi %d\n",0);}	
							| '=' Inic_Var															{ $$ = $2; varType[varPt] = $2; varPt++; }
							;

Type						: INTEGER																{$$ = 1;}
    						| BOOLEAN																{$$ = 2;}
   						| ARRAY SIZE NUMBER													{}
							;

Inic_Var					: Constant																{$$ = $1;}
        					| Array_Definition													{}
							;

Constant					: NUMBER			 														{ $$ = 1; printf("pushi %s\n",$1); }
        					| STRING																	{ $$ = 3; printf("pushs %s\n",$1); }
       					| TRUE_																	{ $$ = 2; printf("pushi 1\n"); }	
      					| FALSE_																	{ $$ = 2; printf("pushi 0\n"); }
							;

/************************* Declarations: Variables: Array_Definition */
Array_Definition		: '[' Array_Initialization ']'                          {}
							;

Array_Initialization	: Elem	
							| Array_Initialization ',' Elem	
							;
Elem						: NUMBER			
							;

/************************* Statements */
Statements				: Statement ';'				
          				| Statements Statement ';'
							;

Statement				: {criarJanela();} Turtle_Commands								/*Cria janela de 500 por 500*/
        					| Assignment
							| Conditional_Statement
       					| Iterative_Statement
							;

			

/************************* Turtle Statement */
Turtle_Commands		: Step
               		| Rotate
              			| Mode
             			| Dialogue
            			| Location
							;


Step               	: FORWARD {lerPosTurtle();} Expression 		{actPosTurtle();}		
	                  | BACKWARD {lerPosTurtle();} Expression		{printf("pushi -1\nmul\n"); actPosTurtle();}
										        
							;

Rotate             	: RRIGHT                							{rotateDir();}
                     | RLEFT                 							{rotateEsq();}
							;

Mode                 : PEN UP                							{pen = 0;}
                     | PEN DOWN              							{pen = 1;}
						   ;

Dialogue             : Say_Statement
                     | Ask_Statement
							;


Location             : GOTO NUMBER ',' NUMBER    						{ mover($2,$4); }
						   | WHERE '?'                 						{ mostarPos(); }


							
					      ;


/************************* Assignment Statement */
Assignment				: Variable '=' Expression 			{ if(g_hash_table_lookup(varsHT,$1)==NULL) 
																				{ fprintf(stderr,"ERRO: Variavel \"%s\" nao declarada.\n",$1); return 0;} 
																		  printf("storen\n"); 
																		}
							;

Variable					: IDENTIFIER Array_Acess			{ if((var = g_hash_table_lookup(varsHT,$1))==NULL)
							                                 		{ fprintf(stderr,"ERRO: Variavel \"%s\" nao declarada.\n",$1); return 0;}
							                   					  printf("%s\n%s %d\n","pushgp","pushi",var->end);
																		}
							;

Array_Acess				:
          				|'[' Single_Expression ']'
							;

/*********************** Expression */
Expression				: Single_Expression    
							| Expression Rel_Op Single_Expression	{ printf("%s\n",$2); }
							;

/******** Single_Expression */
Single_Expression		: Term			
							| Single_Expression Add_Op Term	 		{printf("%s\n",$2);}	
							;

/******** Term */
Term						: Factor		
							| Term Mul_Op Factor							{printf("%s\n",$2);}
							;

/******** Factor */
Factor					: Constant								
							| Variable										{printf("loadn\n");}
							| SuccOrPred									{}
							| '(' Expression ')'							{}
							;

/******** Operators */
Add_Op					: '+'	 											{$$ = "add";}
      					| '-' 											{$$ = "sub";}
     						| OR												{$$ = "add\npushi 0\nequal\nnot"; }
							;

Mul_Op					: '*'	 											{$$="mul";}
							| '/'			 									{$$="div";}
							| AND												{$$="mul\npushi 0\nequal\nnot";}
							| MMULT											{}
							;

Rel_Op					: EQUAL											{$$="equal";}
							| DIF 											{$$="equal\nnot";}
							| '<'												{$$="inf";}
							| '>'												{$$="sup";}
		 					| LE												{$$="infeq";}
		 					| GE												{$$="supeq";}
					 		| IN												{}
			 				;


/******** SuccOrPredd */
SuccOrPred				: SuccPred IDENTIFIER						{if((var = g_hash_table_lookup(varsHT,$2))==NULL)
                                                      			{ fprintf(stderr,"ERRO: Variavel \"%s\" nao declarada.\n",$2); return 0;}
																		 		printf("pushgp\npushi %d\nloadn\n",var->end);
																		 		if ($1==1) printf("pushi 1\nadd\n");
																		 		else printf("pushi 1\nsub\n");
																				}
							;	

SuccPred					: SUCC											{$$ = 1;}
        					| PRED											{$$ = 2;}
							;


/********************* IO Statements */
Say_Statement			: SAY '(' Expression ')' 					{printf("writes\n");}
							;

Ask_Statement			: ASK '(' STRING ',' Variable ')'		{printf("pushs%s\nwrites\nread\natoi\nstoren\n",$3);}
							;


/********************* Conditional & Iterative Statements */
Conditional_Statement	: IfThenElse_Stat
								;
Iterative_Statement		: While_Stat
								;


/******** IfThenElse_Stat */
IfThenElse_Stat		: IF Expression 								{ printf("jz label%d\n",cl); push(cl); cl++; }
						 	  THEN '{' Statements '}' 					{ printf("jump label%d\n",cl); push(cl); cl++; }
							  Else_Expression
							;

Else_Expression		:       											{ printf("label%d:\n",pop(2)); printf("label%d:\n",pop(1)); }
							| ELSE         								{ printf("label%d:\n",pop(2));}
        				 		'{' Statements '}'     					{ printf("label%d:\n",pop(1));}
			      		;


/******** While_Stat */
While_Stat				:													{printf("label%d:\n",cl);
         																		push(cl);
			         															cl++;
						        												}
								WHILE '(' Expression ')'   			{printf("jz label%d\n",cl);
											                     			push(cl);
																		         cl++;
																				}
							  '{' Statements '}'     					{printf("jump label%d\n",pop(2));
																				 printf("label%d:\n",pop(1));
																				}
	  		    			;

%%

#include "lex.yy.c"

int main(){
   varsHT = g_hash_table_new_full(g_str_hash,g_str_equal,NULL,g_free);
	yyparse();
	g_hash_table_destroy(varsHT);
	return 0;
}


int yyerror(char *s){
	fprintf(stderr,"ERRO: %s na linha:%d antes de:%s\n",s,yylineno,yytext);
	return 0;
}


void push(int i)
{
   if(sp+1 == (STACK_SIZE)) {
   	printf("Stack Overflow.\n");
	} else{
	   labels[sp] = i;
	}
	sp++;
}

int pop(int pos)
{
	int label;
	if(sp == 0 || (sp == 1 && pos == 2)) {
		printf("Stack Underflow.\n");
		return -1;
 	} else{
	   label = labels[sp-pos];
	   if (pos == 2){
	   	labels[sp-2] = labels[sp-1];
		}
		sp--;
		return label;
	} 
}

Variavel *criaVar(char *id, int type) {
		Variavel *var = malloc(sizeof(Variavel));
		var->id=strdup(id);
		var->type=type;
		var->end=gp;
}

int matchType(int type) {
	int i, match=1;
		//printf("Tipo: %d\n",type);
	for(i = 0; i < varPt; i++) {
		//printf("var: %d, i: %d\n",varType[i],i);
		if(varType[i] != type) 
			if(varType[i] != 0) match = 0;
	}
	return match;
}

int criarJanela() {
	if(janelaAberta==0){printf("%s\n","pushi 500\npushi 500\nopendrawingarea");janelaAberta=1;}
}

void lerPosTurtle() {
	printf("%s","pushgp\npushi 0\nloadn\npushgp\npushi 1\nloadn\npushgp\npushi 2\n");
}

void actPosTurtle() {
	printf("%s","storen\n");

	switch (direcao) {
		case 0:
				printf("%s","pushgp\npushi 1\npushgp\npushi 1\nloadn\npushgp\npushi 2\nloadn\nsub\nstoren\n");
				break;
		case 2:
				printf("%s","pushgp\npushi 1\npushgp\npushi 1\nloadn\npushgp\npushi 2\nloadn\nadd\nstoren\n");
				break;
		case 1:
				printf("%s","pushgp\npushi 0\npushgp\npushi 0\nloadn\npushgp\npushi 2\nloadn\nadd\nstoren\n");
				break;
		case 3:
				printf("%s","pushgp\npushi 0\npushgp\npushi 0\nloadn\npushgp\npushi 2\nloadn\nsub\nstoren\n");
				break;
	}

	printf("%s","pushgp\npushi 0\nloadn\npushgp\npushi 1\nloadn\n");
	if (pen)
		printf("%s\n","DRAWLINE\nREFRESH");
	else
		printf("%s\n","PUSHI 4\nPOPN");
}

void iniciaVarsTurtle() {
	printf("%s\n","pushi 0\npushi 0\npushi 0\n");
}

void mover(char *x, char *y) {
	printf("pushgp\npushi 0\npushi %s\nstoren\npushgp\npushi 1\npushi %s\nstoren\n",x,y);
}

void rotateDir() {
	if (direcao==3) direcao = 0;
	else direcao++;
}

void rotateEsq() {
	if (direcao==0) direcao = 3;
	else direcao--;
}


void mostarPos() {
	printf("pushgp\npushi 1\nloadn\nstri\n");
	printf("pushs \" Y: \"");
	printf("pushgp\npushi 0\nloadn\nstri\n");
	printf("pushs \"X: \"");
	printf("concat\nconcat\nconcat\nwrites\n");
}

