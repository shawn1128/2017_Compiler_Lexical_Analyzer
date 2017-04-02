%{
	#define paragraphComment 1
	#define lineComment 2

	#include <stdio.h>
	int num_lines = 0, num_chars = 0;
	char str[100];
	int commentType;

	int yywrap();
	void print_line();
	void store_text();

%}

%x comment

%%

"/*" {  store_text();
	commentType = paragraphComment;
	BEGIN(comment);}
"//" {  store_text();
	commentType = lineComment;
	BEGIN(comment);}

<comment>[^*\n]*        {store_text();}/* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   {store_text();}/* eat up '*'s not followed by '/'s */
<comment>\n             { ++num_lines;
			  print_line();
			  if(commentType == lineComment){
				BEGIN(INITIAL);}
			}
<comment>"*"+"/"        {if(commentType == paragraphComment){
				store_text();
				BEGIN(INITIAL);
			 }else{store_text();}
			}

\n {    ++num_lines; 
	print_line();}


%%

int main(int argc, char* argv[]){
        yylex();
        printf("# of lines = %d, # of chars = %d\n",
                num_lines, num_chars);
        return 0;


}

int yywrap(){
	return 1; /*end of file*/
}

void print_line(){
	printf("%d:%s\n", num_lines, str);
	memset(str, 0, strlen(str));
	num_chars = 0;
}

void store_text(){
	strcpy(str+num_chars, yytext);
	num_chars = num_chars + yyleng;
}
