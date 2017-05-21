%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	
	char s[100];

	char key_store[50][50];
	int key_counter=0;
	int key_fetched_flag=0;

	char identification_store[50][50];
	int identification_counter=0;
	int identification_fetched_flag=0;

	char operator_store[7][7];
	int operator_counter=0;
	int operator_fetech_flag=0;
	
	char punctuation_store[7][7];
	int punctuation_counter=0;
	int punctuation_fetech_flag=0;
	
	int stm=0;
%}

%%
number|print|method|loop|if|elif|else {
	key_fetched_flag++;
	int i=0;
	strcpy(s, yytext);

	if(key_counter>0){
		for (i=0; i<key_counter; i++){
			if(!strcmp(key_store[i], s))
				break;
		}
	}
	if(i==key_counter)
		strcpy(key_store[key_counter++], s);
}

MyHeader1|MyHeader2  {printf("Library found %s.\n", yytext);}

[(].*[)] {printf("Function found\n");}

assign|<=|>=|==|!=|[+]|[-]|[*]|[/]|[>]|[<]  { 
	operator_fetech_flag++;
	int i=0;
	strcpy(s, yytext);

	if(operator_counter>0){
		for(i=0; i<operator_counter; i++){
			if(!strcmp(operator_store[i], s))
				break;
		}
	}

	if(i==operator_counter)
		strcpy(operator_store[operator_counter++], s);
}

[`]|[:]|[;]  { 
	punctuation_fetech_flag++;
	int i=0;
	strcpy(s, yytext);

	if(punctuation_counter>0){
		for(i=0; i<punctuation_counter; i++){
			if(!strcmp(punctuation_store[i], s))
				break;
		}
	}

	if(i==punctuation_counter)
		strcpy(punctuation_store[punctuation_counter++], s);
}

[A-Za-z]+[_]?[0-9]*    {
	identification_fetched_flag++;
	int i=0;
	strcpy(s, yytext);

	if(identification_counter>0)
	{
	   for (i=0;i<identification_counter;i++)
			 if(!strcmp(identification_store[i], s))
			 break;
	}

	if(i==identification_counter)
		strcpy(identification_store[identification_counter++], s);
}

"}" {
	int i;
	printf("\n\n--------------------------------------------------------\n");
	printf("\nKeywords: %d\n", key_counter);
	for (i=0; i<key_counter; i++){
		printf("%s\n",key_store[i]);
	}
	printf("\n");

	printf("Variables: %d\n", identification_counter);
	for (i=0;i<identification_counter;i++){
		printf("%s\n",identification_store[i]);
	}
	printf("\n");

	printf("Operators: %d\n", operator_counter);
	for (i=0;i<operator_counter;i++){
		printf("%s\n",operator_store[i]);
	}
	printf("\n");
	
	printf("Punctuations: %d\n", punctuation_counter);
	for (i=0;i<punctuation_counter;i++){
		printf("%s\n",punctuation_store[i]);
	}
}

["].*["]   printf("");

[ ]*  printf("");

[-][-].*  printf("single line comment found: %s\n", yytext);

"$"(.*|\n)*"$"  printf("Multiple line comment found: %s\n", yytext);

.   printf("");

\n   printf("");
%%

int yywrap(){
	return 1;
}

int main(){
	yyin=freopen("input.c", "r", stdin);
	yyout=freopen("output.txt", "w", stdout);
	yylex();
	return 0;
}
