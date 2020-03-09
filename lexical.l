%{
  #include<stdio.h>
  int line_counter=0;
  #ifdef DEBUG
  #define TOKEN(T) printf("%s: '%s'\n", #T, yytext);
  #else
  #include"y.tab.h"
  #define TOKEN(T) \
  yylval.str=strdup(yytext);\
  return T;
  #endif
  int savestate;
%}
EOL \r\n|\r|\n
SPACE [ \t\f]
%s H1MODE H2MODE H3MODE H4MODE H5MODE H6MODE
%s QOUTEMODE BOLDMODE BOLDMODE2 ITALICMODE ITALICMODE2
%x IMGMODE IMGATTRMODE QLMODE
%%
 /*标题*/
^={SPACE}+ {BEGIN H1MODE;TOKEN(LH1);}
^=={SPACE}+ {BEGIN H2MODE;TOKEN(LH2);}
^==={SPACE}+ {BEGIN H3MODE;TOKEN(LH3);}
^===={SPACE}+ {BEGIN H4MODE;TOKEN(LH4);}
^====={SPACE}+ {BEGIN H5MODE;TOKEN(LH5);}
^======{SPACE}+ {BEGIN H6MODE;TOKEN(LH6);}
<H1MODE>({SPACE}+=)?$ {BEGIN INITIAL;TOKEN(RH1)}
<H2MODE>({SPACE}+==)?$ {BEGIN INITIAL;TOKEN(RH2)}
<H3MODE>({SPACE}+===)?$ {BEGIN INITIAL;TOKEN(RH3)}
<H4MODE>({SPACE}+====)?$ {BEGIN INITIAL;TOKEN(RH4)}
<H5MODE>({SPACE}+=====)?$ {BEGIN INITIAL;TOKEN(RH5)}
<H6MODE>({SPACE}+======)?$ {BEGIN INITIAL;TOKEN(RH6)}
 /*整行标记*/
^NOTE:{SPACE}* {TOKEN(NOTE);}
^TIP:{SPACE}* {TOKEN(TIP);}
^WARNING:{SPACE}* {TOKEN(WARN);}
^IMPORTANT:{SPACE}* {TOKEN(IMPT);}
^CAUTION:{SPACE}* {TOKEN(CAUTN);}
^"[bibliography]"{SPACE}* {TOKEN(QTSOURCE);}
^({SPACE}*{EOL})+ {TOKEN(EMPTY_LINE);}
^"-"{SPACE}+/[^ \t\f\r\n] {TOKEN(UL);}

 /*忽略注释*/
"//".*$ {}
 /*图片, 引用*/

 /*行内标记*/
[`{}\[\]] {TOKEN(yytext[0]);}

 /*斜体*/
<INITIAL,BOLDMODE2,H1MODE,H2MODE,H3MODE,H4MODE,H5MODE,H6MODE>_/_*{SPACE}*[^_[:space:]][^\r\n]*_ {savestate=YY_START; BEGIN ITALICMODE; TOKEN(LITALIC);}
<ITALICMODE>_ {TOKEN(CHAR);}
<ITALICMODE>[^_] {BEGIN ITALICMODE2;yyless(0);}
<ITALICMODE2>_/[^_] {BEGIN savestate; TOKEN(RITALIC);}
 /*粗体*/
<INITIAL,ITALICMODE2,H1MODE,H2MODE,H3MODE,H4MODE,H5MODE,H6MODE>"*"/"*"*{SPACE}*[^*[:space:]][^\r\n]*"*" {savestate=YY_START; BEGIN BOLDMODE; TOKEN(LBOLD);}
<BOLDMODE>"*" {TOKEN(CHAR);}
<BOLDMODE>[^*] {BEGIN BOLDMODE2;yyless(0);}
<BOLDMODE2>"*"/[^*] {BEGIN savestate; TOKEN(RBOLD);}

"<<" {TOKEN(LQT);} /*left quote*/
">>" {TOKEN(RQT);} /*right quote*/
"[[[" {TOKEN(L_THREE_SB)} /*left three square bracket*/
"]]]" {TOKEN(R_THREE_SB)}

^image::/[^\r\n\[]+\[[^\r\n]*\] {BEGIN IMGMODE; TOKEN(IMG);}
<IMGMODE>[^[]+ {BEGIN IMGATTRMODE; TOKEN(IMG_PATH);}
<IMGATTRMODE>"[" {}
<IMGATTRMODE>"title=" { TOKEN(IMG_TITLE);}
<IMGATTRMODE>"caption=" { TOKEN(IMG_CAPTION);}
<IMGATTRMODE>"width=" {TOKEN(IMG_WIDTH);}
<IMGATTRMODE>"hight=" {TOKEN(IMG_HIGHT);}
<IMGATTRMODE>\"[^\r\n"]+\" {
  char*str=malloc(strlen(yytext)-1);
  int i=0;
  while(yytext[i+2]){
    str[i]=yytext[i+1];
    i++;
  }
  str[i]='\0';
#ifdef DEBUG
  printf("IMG_ATTR_VALUE: '%s'\n", str);
#else
  yylval.str=strdup(str);
  return IMG_ATTR_VALUE;
#endif
  }
<IMGATTRMODE>"]" {BEGIN INITIAL;}
<IMGATTRMODE>. {}
 /*
^image {TOKEN(IMG);}
:: {TOKEN(TWO_COLONS);}
title {TOKEN(IMG_TITLE);}
caption {TOKEN(IMG_CAPTION;)}
[=,] {TOKEN(yytext[0]);}
 */



{SPACE}"+"$ {TOKEN(CR);}
{EOL} {TOKEN(EOL);}
{SPACE}+ {TOKEN(SPACE);}
\\. {TOKEN(ESCAPE);} /*转义*/
 /*其它字符组成普通文本*/
. {TOKEN(CHAR);}


 /*跨行*/
```
 /*^"[bibliography]"$ {BEGIN BIBLMODE; TOKEN(BIB_SOURCE);}
<BIBLMODE>"- [[[" {TOKEN(BIB_SOURCE_ITEM);} */


 /* [^[:space:]]+ {TOKEN("TEXT:%s",yytext);} */
%%
int yywrap(){
    return 1;
}
