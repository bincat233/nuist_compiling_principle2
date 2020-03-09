/* A Bison parser, made by GNU Bison 3.3.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2019 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    LH1 = 258,
    LH2 = 259,
    LH3 = 260,
    LH4 = 261,
    LH5 = 262,
    LH6 = 263,
    RH1 = 264,
    RH2 = 265,
    RH3 = 266,
    RH4 = 267,
    RH5 = 268,
    RH6 = 269,
    EMPTY_LINE = 270,
    QTSOURCE = 271,
    PARA = 272,
    NOTE = 273,
    TIP = 274,
    WARN = 275,
    IMPT = 276,
    CAUTN = 277,
    BIB_SOURCE = 278,
    BIB_SOURCE_ITEM = 279,
    TWO_COLONS = 280,
    UL = 281,
    STAR = 282,
    UDL = 283,
    CODE = 284,
    LQT = 285,
    RQT = 286,
    CR = 287,
    LCB = 288,
    RCB = 289,
    LSB = 290,
    RSB = 291,
    CHAR = 292,
    EOL = 293,
    SPACE = 294,
    IMG_ATTR_VALUE = 295,
    LBOLD = 296,
    RBOLD = 297,
    LITALIC = 298,
    RITALIC = 299,
    L_THREE_SB = 300,
    R_THREE_SB = 301,
    IMG = 302,
    IMG_PATH = 303,
    IMG_TITLE = 304,
    IMG_CAPTION = 305,
    IMG_HIGHT = 306,
    IMG_WIDTH = 307,
    ESCAPE = 308
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 23 "parser.y" /* yacc.c:1927  */

    char *str;

#line 116 "y.tab.h" /* yacc.c:1927  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
