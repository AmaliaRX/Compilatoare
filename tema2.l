%{
	#include "tema2.tab.h"

	int lineNo = 1;
	int colNo = 1;
%}

%%
"+"		{ colNo++; return TOK_PLUS; }
"-"		{ colNo++; return TOK_MINUS; }
"*"		{ colNo++; return TOK_MULTIPLY; }
"DIV"		{ colNo++; return TOK_DIVIDE; }
"("		{ colNo++; return TOK_LEFT; }
")"		{ colNo++; return TOK_RIGHT; }
","		{ colNo++; return ','; }
":="		{ colNo++; return TOK_ATR; }
":"		{ colNo++; return ':'; }
";"		{ colNo++; return ';'; }
"."		{ colNo++; return '.'; }
"READ"		{ colNo++; return TOK_READ; }
"WRITE"		{ colNo++; return TOK_WRITE; }
"FOR"		{ colNo++; return TOK_FOR; }
"DO"		{ colNo++; return TOK_DO; }
"TO"		{ colNo++; return TOK_TO; }
"PROGRAM"	{ colNo++; return TOK_PROGRAM; }
"BEGIN"		{ colNo++; return TOK_BEGIN; }
"END"		{ colNo++; return TOK_END; }
"INTEGER"	{ colNo++; return TOK_INTEGER; }
"VAR"		{ colNo++; return TOK_VAR;}
0|[1-9][0-9]*		{ colNo+=strlen(yytext); yylloc.first_line = lineNo; yylloc.first_column = colNo;  yylval.vint = atoi(yytext); return TOK_INT; }
[a-zA-Z][a-zA-Z0-9]*	{ colNo+=strlen(yytext); yylloc.first_line = lineNo; yylloc.first_column = colNo;  yylval.val = new char[strlen(yytext)+1]; strcpy(yylval.val,yytext); return TOK_ID;}
.		{ colNo++; return TOK_ERROR; }
\r\n			{ lineNo++; colNo=1; }
\n				{ lineNo++; colNo=1; }
%%
