%{
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <stdarg.h>

extern int yylex(void);
extern void yyerror(char *s);
char *str_concat(char *a, char *b);
char *str_format(char *format, ...);
void p(char * str){ }
int main(int argc, char **argv);
int img_caption_counter=1;
int qoute_counter=1;
char* qoute_arr[1000];
char* img_caption_str=NULL;
char* img_title_str=NULL;

extern FILE *yyin, *yyout;
%}

%union{
    char *str;
};

%token <str> LH1 LH2 LH3 LH4 LH5 LH6 RH1 RH2 RH3 RH4 RH5 RH6 EMPTY_LINE QTSOURCE
%token <str> PARA NOTE TIP WARN IMPT CAUTN BIB_SOURCE BIB_SOURCE_ITEM TWO_COLONS UL
%token <str> STAR UDL CODE LQT RQT CR LCB RCB LSB RSB CHAR EOL SPACE IMG_ATTR_VALUE
%token <str> LBOLD RBOLD LITALIC RITALIC L_THREE_SB R_THREE_SB IMG IMG_PATH IMG_TITLE IMG_CAPTION IMG_HIGHT IMG_WIDTH ESCAPE

%type <str> text inline_item inline_item_list block file content header paragraph tight_bolck block_list img_attrs image qtsource_list

%%
 /*inline item*/
file: content{
    char *file_header="<!DOCTYPE html>\n"
                      "<html>\n"
                      "<head>\n"
                      "<meta charset=\"utf-8\">\n"
                      "<title></title>\n"
                      "</head>\n"
                      "<body>\n";

    char *file_footer="</body>\n"
                      "</html>\n";

    $$=str_format("%s%s%s",file_header,$1,file_footer);
    fprintf(yyout, "%s", $$);
    }
    ;

content: {$$="";}
       | content block_list {$$=str_format("%s%s",$1,$2);}
       | content tight_bolck {$$=str_format("%s%s",$1,$2);}
       ;

block_list: block {$$=$1;}
          | block_list EMPTY_LINE {$$=$1;}
          | block_list EMPTY_LINE block {$$=str_format("%s%s",$1,$3);}
          | {$$="";}
          ;

block: paragraph {$$=str_format("<p>%s</p>\n", $1);p($$);}
     | NOTE paragraph {$$=str_format("<table style=\"background:#66CDAA\"><tbody><tr><td>%s</td><td>%s</td></tr></tbody></table>\n",$1,$2);}
     | TIP paragraph {$$=str_format("<table style=\"background:#66CDAA\"><tbody><tr><td>%s</td><td>%s</td></tr></tbody></table>\n",$1,$2);}
     | WARN paragraph {$$=str_format("<table style=\"background:#66CDAA\"><tbody><tr><td>%s</td><td>%s</td></tr></tbody></table>\n",$1,$2);}
     | IMPT paragraph {$$=str_format("<table style=\"background:#66CDAA\"><tbody><tr><td>%s</td><td>%s</td></tr></tbody></table>\n",$1,$2);}
     | CAUTN paragraph {$$=str_format("<table style=\"background:#66CDAA\"><tbody><tr><td>%s</td><td>%s</td></tr></tbody></table>\n",$1,$2);}
     | QTSOURCE EOL qtsource_list {
       char *tmp=malloc(1000);
       tmp[0]='\0';
       for(int i = 1; i < qoute_counter; i++) {
         strcat(tmp,qoute_arr[i]);
       }
       $$=str_format("<ul>%s</ul>",tmp);
     }
     ;

qtsource_list: qtsource_item {}
             | qtsource_list qtsource_item {}
             ;

qtsource_item: UL L_THREE_SB inline_item_list R_THREE_SB inline_item_list EOL {
               int i;
               for(i = 1; i < qoute_counter; i++) {
                 //printf("$3='%s', qoute_arr[%d]='%s'", $3, i, qoute_arr[i]);
                 if(!strcmp($3, qoute_arr[i]))
                   break;
               }
               qoute_arr[i] = str_format("<li><a name=\"%s\"/>[%d] %s</li>\n",$3, i ,$5);
             }
             ;


tight_bolck: header {$$=$1;}
           | image {$$=$1;}
           ;

image: IMG IMG_PATH img_attrs EOL {
       $$=str_format("<img src=\"%s\"%s />\n", $2, $3);
       if(img_title_str){
         if(!img_caption_str){
           img_caption_str=str_format("Figure %d.",img_caption_counter);
           img_caption_counter++;
         }
         $$=str_format("%s<div style=\"text-align:center\">%s %s</div>\n",$$, img_caption_str, img_title_str);
       }
       img_caption_str=NULL;
       img_title_str=NULL;
     }
     ;


img_attrs: {$$="";}
         | img_attrs IMG_CAPTION IMG_ATTR_VALUE {img_caption_str=$3;}
         | img_attrs IMG_TITLE IMG_ATTR_VALUE { img_title_str=$3;}
         | img_attrs IMG_WIDTH IMG_ATTR_VALUE {$$=str_format("%s,width=\"%s\"",$1,$3);}
         | img_attrs IMG_HIGHT IMG_ATTR_VALUE {$$=str_format("%s,hight=\"%s\"",$1,$3);}

header: LH1 inline_item_list RH1 EOL {$$=str_format("<h1>%s</h1>\n",$2);}
      | LH2 inline_item_list RH2 EOL {$$=str_format("<h2>%s</h2>\n",$2);}
      | LH3 inline_item_list RH3 EOL {$$=str_format("<h3>%s</h3>\n",$2);}
      | LH4 inline_item_list RH4 EOL {$$=str_format("<h4>%s</h4>\n",$2);}
      | LH5 inline_item_list RH5 EOL {$$=str_format("<h5>%s</h5>\n",$2);}
      | LH6 inline_item_list RH6 EOL {$$=str_format("<h6>%s</h6>\n",$2);}
      ;


paragraph: paragraph inline_item_list EOL {$$=str_format("%s%s ",$1,$2);}
         | inline_item_list EOL {$$=str_format("%s ",$1);}
         ;

inline_item_list: inline_item_list inline_item{$$=str_format("%s%s",$1,$2);p($$);}
                | inline_item{$$=$1;}
                ;
inline_item: text {
             $$=$1;
           }
           | LBOLD inline_item_list RBOLD {
             $$=str_format("<b>%s</b>",$2);
           }
           | LITALIC inline_item_list RITALIC {
             $$=str_format("<i>%s</i>",$2);
           } /* '_' 斜体 */
           | LQT inline_item_list RQT {
             $$=str_format("<a href=\"#%s\">[%d]</a>", $2, qoute_counter);
             qoute_arr[qoute_counter]=$2;
             qoute_counter++;
           }
           | CR {$$="<br/>\n";}
           | SPACE {$$=" ";}
           ;

text: CHAR {$$=$1;}
    | text CHAR { $$=str_format("%s%s",$1,$2); }
    ;


%%


char *str_format(char *format, ...){
  char *_str = NULL;
  va_list args;

  _str = (char *)malloc(100000);
  va_start(args, format);
  vsprintf(_str, format, args);
  va_end(args);
  return _str;
}

int main(int argc, char **argv){
  FILE *input,*output;

  if(argc>1) {
    input=fopen(argv[1], "r");
    if(argc>2)
      output=fopen(argv[2], "rw");
    else {
      output=fopen(str_format("%s%s",argv[1],".html"),"rw");
    }
  } else {
    input=stdin;
    output=stdout;
  }

	if (!input) {
		return -1;
	}
	yyin = input;
  yyout= output;
  return yyparse();
}
