/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     PROGRAM = 258,
     DECLARATIONS = 259,
     STATEMENTS = 260,
     ARRAY = 261,
     SIZE = 262,
     INIT_WINDOW = 263,
     INIT_TURTLE = 264,
     FORWARD = 265,
     BACKWARD = 266,
     RRIGHT = 267,
     RLEFT = 268,
     PEN = 269,
     UP = 270,
     DOWN = 271,
     GOTO = 272,
     WHERE = 273,
     SUCC = 274,
     PRED = 275,
     SAY = 276,
     ASK = 277,
     IF = 278,
     THEN = 279,
     ELSE = 280,
     WHILE = 281,
     ARROW = 282,
     OR = 283,
     AND = 284,
     EQUAL = 285,
     DIF = 286,
     MMULT = 287,
     LE = 288,
     GE = 289,
     IN = 290,
     IDENTIFIER = 291,
     STRING = 292,
     NUMBER = 293,
     TRUE_ = 294,
     FALSE_ = 295,
     BOOLEAN = 296,
     INTEGER = 297
   };
#endif
/* Tokens.  */
#define PROGRAM 258
#define DECLARATIONS 259
#define STATEMENTS 260
#define ARRAY 261
#define SIZE 262
#define INIT_WINDOW 263
#define INIT_TURTLE 264
#define FORWARD 265
#define BACKWARD 266
#define RRIGHT 267
#define RLEFT 268
#define PEN 269
#define UP 270
#define DOWN 271
#define GOTO 272
#define WHERE 273
#define SUCC 274
#define PRED 275
#define SAY 276
#define ASK 277
#define IF 278
#define THEN 279
#define ELSE 280
#define WHILE 281
#define ARROW 282
#define OR 283
#define AND 284
#define EQUAL 285
#define DIF 286
#define MMULT 287
#define LE 288
#define GE 289
#define IN 290
#define IDENTIFIER 291
#define STRING 292
#define NUMBER 293
#define TRUE_ 294
#define FALSE_ 295
#define BOOLEAN 296
#define INTEGER 297




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 95 "logo.y"
{
	int n;
	char *s;
	Variavel *v;
}
/* Line 1529 of yacc.c.  */
#line 139 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

