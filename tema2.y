%{
	#include <stdio.h>
     #include <string.h>

	int yylex();
	int yyerror(const char *msg);

     int EsteCorecta = 1;
	char msg[500];

	class TVAR
	{
	     char* nume;
	     int valoare;
	     TVAR* next;
	  
	  public:
	     static TVAR* head;
	     static TVAR* tail;

	     TVAR(char* n, int v = -1);
	     TVAR();
	     int exists(char* n);
             void add(char* n, int v = -1);
             int getValue(char* n);
	     void setValue(char* n, int v);
	};

	TVAR* TVAR::head;
	TVAR* TVAR::tail;

	TVAR::TVAR(char* n, int v)
	{
	 this->nume = new char[strlen(n)+1];
	 strcpy(this->nume,n);
	 this->valoare = v;
	 this->next = NULL;
	}

	TVAR::TVAR()
	{
	  TVAR::head = NULL;
	  TVAR::tail = NULL;
	}

	int TVAR::exists(char* n)
	{
	  TVAR* tmp = TVAR::head;
	  while(tmp != NULL)
	  {
	    if(strcmp(tmp->nume,n) == 0)
	      return 1;
            tmp = tmp->next;
	  }
	  return 0;
	 }

         void TVAR::add(char* n, int v)
	 {
	   TVAR* elem = new TVAR(n, v);
	   if(head == NULL)
	   {
	     TVAR::head = TVAR::tail = elem;
	   }
	   else
	   {
	     TVAR::tail->next = elem;
	     TVAR::tail = elem;
	   }
	 }

         int TVAR::getValue(char* n)
	 {
	   TVAR* tmp = TVAR::head;
	   while(tmp != NULL)
	   {
	     if(strcmp(tmp->nume,n) == 0)
	      return tmp->valoare;
	     tmp = tmp->next;
	   }
	   return -1;
	  }

	  void TVAR::setValue(char* n, int v)
	  {
	    TVAR* tmp = TVAR::head;
	    while(tmp != NULL)
	    {
	      if(strcmp(tmp->nume,n) == 0)
	      {
		tmp->valoare = v;
	      }
	      tmp = tmp->next;
	    }
	  }

	TVAR* ts = NULL;

%}

%locations

%union 
{ char* val;
 int vint; }


%token TOK_PLUS TOK_MINUS TOK_MULTIPLY TOK_DIVIDE TOK_LEFT TOK_RIGHT TOK_DECLARE TOK_PRINT TOK_ERROR TOK_ATR TOK_READ TOK_WRITE TOK_FOR TOK_DO TOK_TO TOK_PROGRAM TOK_BEGIN TOK_END TOK_INTEGER TOK_VAR 
 
%token <vint>TOK_INT 
%token <val>TOK_ID
%start S

%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE

%%
S : 
    |
    P ';' S 
    | 
    error ';' S 
       { EsteCorecta = 0; }
    ;



P : TOK_PROGRAM NM TOK_VAR DLT TOK_BEGIN SLT TOK_END
	|
	error NM TOK_VAR DLT TOK_BEGIN SLT TOK_END 
	{ EsteCorecta = 0; }
	|
	error TOK_VAR DLT TOK_BEGIN SLT TOK_END 
	{ EsteCorecta = 0; }
	|
	error DLT TOK_BEGIN SLT TOK_END 
	{ EsteCorecta = 0; }
	|
	error TOK_BEGIN SLT TOK_END 
	{ EsteCorecta = 0; }
	|
	error SLT TOK_END 
	{ EsteCorecta = 0; }
	|
	error TOK_END 
	{ EsteCorecta = 0; }
	;


NM : TOK_ID
	;
DLT : D
	|
	DLT ';' D
	;
D : IDL ':' T
	;
T : TOK_INTEGER
	;
IDL : TOK_ID
	{
	if(ts == NULL) ///daca nu exista adaug
	{
		ts = new TVAR();
		ts->add($1);
	}
        else ///asta este codul luat din exemplul 4
	{
	  if(ts->exists($1) == 1)
	  {
	    ts->setValue($1,83);
	  }
	  else
	  {
	    sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
	    yyerror(msg);
	    YYERROR; ///aici poate un alt else
	  }
	}
	}
	|
	IDL ',' TOK_ID
	{
	if(ts == NULL) ///daca nu exista adaug
	{
		ts = new TVAR();
		ts->add($3);
	}
        else ///asta este codul luat din exemplul 4
	{
	  if(ts->exists($3) == 1)
	  {
	    ts->setValue($3,84);
	  }
	  else
	  {
	    sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $3);
	    yyerror(msg);
	    YYERROR;///aici poate un alt else
	  }
	}
	}
	;
SLT : ST
	|
	SLT ';' ST
	;
ST : A
	| 
	R 
	| 
	W 
	| 
	FR;
A : TOK_ID TOK_ATR E
 { //asta sigur e bun pt ca e luat tot din exercitiul 4
	if(ts != NULL)
	{
	  if(ts->exists($1) != 1)
	  {
	    sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
	    yyerror(msg);
	    YYERROR;
	  }
	}
	else
	{
	  sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
	  yyerror(msg);
	  YYERROR;
	}
      };
	
E : T
	|
	E TOK_PLUS T 
   	|
   	E TOK_MINUS T
	;
    
T : F
	|
	T TOK_MULTIPLY F
    	|
    	T TOK_DIVIDE F;
F : TOK_ID
	{
		if(ts != NULL)
	{
	  if(ts->exists($1) != 1)
	  {
	    sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
	    yyerror(msg);
	    YYERROR;
	  }
	}
	else
	{
	  sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
	  yyerror(msg);
	  YYERROR;
	}
	}
	|
	TOK_INT 
	| 
  	TOK_LEFT E TOK_RIGHT
	;
R : TOK_READ TOK_LEFT IDL TOK_RIGHT
	;
W : TOK_WRITE TOK_LEFT IDL TOK_RIGHT
	;
FR : TOK_FOR IXE TOK_DO BDY 
	;
IXE : TOK_ID TOK_ATR E TOK_TO E
 {//asta sigur e bun pt ca e luat tot din exercitiul 4
	if(ts != NULL)
	{
	  if(ts->exists($1) != 1)
	  {
	    sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
	    yyerror(msg);
	    YYERROR;
	  }
	}
	else
	{
	  sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
	  yyerror(msg);
	  YYERROR;
	}
}
	;
BDY : ST
	|
	TOK_BEGIN SLT TOK_END
    ;
%%

int main()
{
	yyparse();
	
	if(EsteCorecta == 1)
	{
		printf("CORECTA\n");		
	}	

       return 0;
}

int yyerror(const char *msg)
{
	printf("Error: %s\n", msg);
	return 1;
}
