%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define pi 3.14159265358979323846264

double sym[26];
double default_val;
double switch_val;
double flag=0;

%}

%union{
	int dec;
	double flt;
}

%token<dec> ID
%token<flt> NUM
%token VAR MAIN IF ELSE HEADER SIN COS TAN LOG PRINT FACT GCD LCM ASSIGN SWITCH CASE DEFAULT LOOP
%type<flt> statement expression start
%nonassoc IFX
%nonassoc ELSE
%left '<' '>'
%left '+' '-'
%left '*' '/'
%right '^'
%left UMINUS
%left FACT

%%

program: headers MAIN '(' ')' '{' fstatement '}'
	;
	
headers: /* empty */
	| headers HEADER
	;

fstatement: /* empty */
	| fstatement statement
	;
	
statement: '`'
	| declaration '`'
	| expression '`' { 
						printf("%lf\n", $1); 
					}
	| ID ASSIGN expression '`' { 
								sym[$1] = $3; 
								}
	| IF ':' expression ':' expression '`' %prec IFX { 
													if($3)
														printf("value of expression in IF: %lf\n", $5);
													else
														printf("condition value zero in IF block\n");
													 }
	| IF ':' expression ':' expression '`' ELSE expression '`' {
																if($3)
																		printf("value of expression in IF: %lf\n", $5);
																else
																		printf("value of expression in ELSE: %lf\n", $8);
																}
	| switchcase { 
					if(flag == 0)
					printf("%lf\n", default_val); 
				}
	| LOOP '(' expression ':' ID ':' expression ')' '(' expression '`' ')' {
																			int i;
																			for(i=$3; i<=$7; i++)
																				printf("value of expression in loop: %lf\n", $10);
																			}
	;

declaration : VAR ids
	;
	

ids : ids ',' ID
	| ID
	;

expression: NUM { $$ = $1; }
	| ID { $$ = sym[$1]; }
	| expression '+' expression { $$ = $1 + $3; }
	| expression '-' expression { $$ = $1 - $3; }
	| expression '*' expression { $$ = $1 * $3; }
	| expression '/' expression { 
									if($3)
										$$ = $1 / $3; 
									else{
										$$ = 0;
										printf("\ndivision by zero\n");
									}
								}
	| expression '^' expression { $$ = pow($1,$3); }
	| '-' expression %prec UMINUS { $2 = -$2; }
	| expression '<' expression { $$ = $1 < $3; }
	| expression '>' expression { $$ = $1 > $3; }
	| '(' expression ')' { $$ = $2; }
	| FACT '(' NUM ')' { $$ = factorial((int)$3) }
	| GCD '(' NUM ',' NUM ')' { $$ = GCD_fn($3, $5) }
	| LCM '(' NUM ',' NUM ')' { $$ = LCM_fn($3, $5) }
	| SIN '(' expression ')' { $$ = sin($3 * pi / 180); }
	| COS '(' expression ')' { $$ = cos($3 * pi / 180); }
	| TAN '(' expression ')' { $$ = tan($3 * pi / 180); }
	| LOG '(' expression ')' { $$ = log10($3); }
	| PRINT '(' expression ')' { $$ = $3; }
	;

switchcase:	 start DEFAULT ':' expression '`' { default_val = $4; }
	;
	
start:	 SWITCH '(' expression ')' ':' { switch_val = $3; }
	| start CASE '(' expression ')' ':' expression '`' {
															if($4 == switch_val){
																printf("%lf\n", $7);
																flag=1;
															}
														}

%%

int yywrap(){
	return 1;
}

yyerror(char *s){
	printf("%s\n", s);
}

int factorial(int num){
	int i;
    long x=1;
	for(i=1; i<=num; i++){
        x=x*i;
    }
	return x;
}

int GCD_fn(double n1, double n2){
	int i, gcd, mul, n3, n4;
	n3=(int)n1;
	n4=(int)n2;
	mul=(n3*n4);
	for(i=1; i <= n3 && i <= n4; ++i)
	{
		if(n3%i==0 && n4%i==0)
		    gcd = i;
	}
	return gcd;
}

int LCM_fn(double n1, double n2){
	int i, gcd, mul, lcm, n3, n4;
	n3=(int)n1;
	n4=(int)n2;
	mul=(n3*n4);
	for(i=1; i <= n3 && i <= n4; ++i)
	{
		if(n3%i==0 && n4%i==0)
		    gcd = i;
	}
	lcm=(mul/gcd);
	return lcm;
}