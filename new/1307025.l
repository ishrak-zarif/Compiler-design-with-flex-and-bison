%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "1307025.tab.h"

%}

%%

[-]?[0-9]*[.]?[0-9]+ 	{ yylval.flt = atof(yytext); return NUM; }
[a-z]	{ yylval.dec = *yytext - 'a'; return ID; }
"main method" { return MAIN; }
"assign" { return ASSIGN; }
"if"	{ return IF; }
"else"	{ return ELSE; }
"var"	{ return VAR; }
[~].+ { return HEADER; }
"sin" { return SIN; }
"cos" { return COS; }
"tan" { return TAN; }
"log" { return LOG; }
"print" { return PRINT; }
"fact" { return FACT; }
"gcd" { return GCD; }
"lcm" { return LCM; }
"loop" { return LOOP; }
"switch" { return SWITCH; }
"case" { return CASE; }
"default" { return DEFAULT; }
[-+/*^<>,(){}:`]	{ return *yytext; }
[ \t\n]*	{}
"--".+ {}
"$*"(.*|\n)*"*$" {}
.	{ yyerror("Unknown Character.\n"); }

%%

int main(){
	freopen("input.txt", "r", stdin);
	freopen("output.txt", "w", stdout);
	yyparse();
	return 0;
}
