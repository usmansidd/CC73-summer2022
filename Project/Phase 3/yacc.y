%{
	#include <stdio.h>
    	#include <stdlib.h>
    	#include <string.h>
    	#define _GNU_SOURCE
	#define INTEGER 10
	#define CHARACTER 20
	#define FLOATT 30
	#define DOUBBLE 40
	#define FUNCC 50
	#define CONSTANTT 60
	#define TRUE 1
	#define FALSE 0
    

    /*Data structures for links in symbol lookahead*/
    struct symrec{
        char *name;             //Symbol name
        int type;               //Symbol type
        double value;           //Variable lookahead value
		int data_type;
        int function;           //Function
		int is_const;
        struct symrec *next;    //Next register pointer
    };

    typedef struct symrec symrec;

    /*Symbol table*/
    extern symrec *sym_table;

    /*Symbol table interactions*/
    symrec *putsym ();
    symrec *getsym ();

    extern int yylex(void);
    extern FILE *yyin;      //Source file to be translated
    extern char *yytext;    //Recognizes input tokens
    extern int line_number; //Line number
	extern char *get_type(int type);
	extern int check_const_var(char *name);
	extern int check_type_op(char *name1, char *name2, char op);

    FILE *yy_output;        //Object file
    
    symrec *sym_table = (symrec *)0;
    symrec *s;
    symrec *symtable_set_type;
    
    int yyerror(char *s);       //Error function

    int is_function=0;          //Is a function (flag)
	int is_switch = FALSE;
	int dimension = 0;
    int error=0;                //Error flag
    int global = 0;             //Global var falg
    int ind = 0;                //Indentation
	int current_type;
	int current_op;
	char type_aux[100];
    //int function_definition = 0;//Funcion definition flag

    /*Creates an indentation*/
    void indent(){
        int temp_ind = ind;
        while (temp_ind > 0){
            fprintf(yy_output, "\t");
            temp_ind -= 1;
        }
    }

    void print(char *token) {
        fprintf(yy_output,token);
    }

%}

%union
{
	int type;
	double value;
	char *name;
	int data_type;
	struct symrec *tptr;
}

/*Op and exp tokens*/
%token INC_OP DEC_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN
%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR CONTINUE BREAK RETURN

/*Types tokens*/
%token <name> IDENTIFIER CONSTANT PRINTFF STR CHARACTER
%token <type> CHAR INT SIGNED UNSIGNED FLOAT DOUBLE CONST VOID

/*Other*/
%type <type> type_specifier declaration_specifiers type_qualifier
%type <name> init_direct_declarator direct_declarator declarator init_declarator init_declarator_list function_definition
%type <name> parameter_type_list parameter_list parameter_declaration array_list array_declaration
%type <name> initializer initializer_list
%type <tptr> declaration

%left INC_OP DEC_OP

%nonassoc IF_AUX
%nonassoc ELSE

%start translation_unit

%%

/*If it is an identifier, saves it into the file*/
// @todo: colocar los demas tipos
primary_expr
	: IDENTIFIER { fprintf(yy_output, "%s", yytext); if(current_op) strcpy(type_aux,$1);}
	| CHARACTER { fprintf(yy_output, "%s", yytext); }
	| STR { fprintf(yy_output, "%s", yytext); }
	| CONSTANT { fprintf(yy_output, "%s", yytext); }
	/* | declaration */
	| '(' { print("("); } expr ')' { print(")"); }
	;

/*Tokens into the file*/
postfix_expr
	: primary_expr
	| postfix_expr '[' { print("["); }  expr ']' { print("]"); }
	| postfix_expr '(' { print("("); } ')' { print(")"); }
	| postfix_expr '(' { print("("); } argument_expr_list ')' { print(")"); }
	| postfix_expr INC_OP { if(check_const_var(yyval.name)) yyerrok; fprintf(yy_output, "+=1"); } //var++
	| postfix_expr DEC_OP { if(check_const_var(yyval.name)) yyerrok; fprintf(yy_output, "-=1"); } //var--
	| INC_OP IDENTIFIER { if(check_const_var($2)) yyerrok; fprintf(yy_output, "%s+=1", $2); } //++var
	| DEC_OP IDENTIFIER { if(check_const_var($2)) yyerrok; fprintf(yy_output, "%s-=1", $2); } //--var
	;

/*Arguments*/
argument_expr_list
	: assignment_expr
	| argument_expr_list ',' { fprintf(yy_output, ", "); } assignment_expr
	;

/*Multiplication, division and mod operators*/
multiplicative_expr
    : postfix_expr
	| multiplicative_expr '*' { print("*"); current_op=TRUE; } postfix_expr {current_op=FALSE; if (check_type_op(yyval.name, type_aux, '*')) yyerrok; }
    | multiplicative_expr '*' { print("*"); } error { yyerrok;}
    | multiplicative_expr '/' { print("/"); current_op=TRUE;} postfix_expr {current_op=FALSE; if (check_type_op(yyval.name, type_aux, '/')) yyerrok; }
    | multiplicative_expr '/' { print("/"); } error { yyerrok;}
    | multiplicative_expr '%' { print(" %% "); } postfix_expr
    | multiplicative_expr '%' { print(" %% "); } error { yyerrok;}
    ;

/*Addition and subtraction*/
additive_expr
	: multiplicative_expr
	| additive_expr '+' { print("+"); current_op=TRUE; } multiplicative_expr {current_op=FALSE; if (check_type_op(yyval.name, type_aux, '+')) yyerrok; }
	| additive_expr '-' { print("-"); current_op=TRUE; } multiplicative_expr {current_op=FALSE; if (check_type_op(yyval.name, type_aux, '-')) yyerrok; }
    | additive_expr '+' { print("+"); } error { yyerrok;}
	| additive_expr '-' { print("-"); } error { yyerrok;}
	;

/*Relation operators*/
relational_expr
	: additive_expr
    | relational_expr '<' { print("<"); } additive_expr
	| relational_expr '>' { print(">"); } additive_expr
	| relational_expr '<' { print("<"); } error {yyerrok;}
	| relational_expr '>' { print(">"); } error {yyerrok;}
	| relational_expr LE_OP { print("<="); } additive_expr
	| relational_expr GE_OP { print(">="); } additive_expr
	;

/*Equal amd not equal*/
equality_expr
	: relational_expr
    | equality_expr EQ_OP { print("=="); } relational_expr
	| equality_expr NE_OP { print("!="); } relational_expr
	| equality_expr EQ_OP { print("=="); } error {yyerrok;}
	| equality_expr NE_OP { print("!="); } error {yyerrok;}
    ;

/*'Logic AND' operator*/
logical_and_expr
	: equality_expr
	| logical_and_expr AND_OP { fprintf(yy_output, " and "); } equality_expr
	| logical_and_expr AND_OP { fprintf(yy_output, " and "); } error {yyerrok;}
    ;

/*'Logic OR' operator*/
logical_or_expr
	: logical_and_expr
	| logical_or_expr OR_OP { fprintf(yy_output, " or "); } logical_and_expr
    | logical_or_expr OR_OP { fprintf(yy_output, " or "); } error {yyerrok;}
    ;

/*Conditional expr*/
conditional_expr
	: logical_or_expr
	| logical_or_expr '?' { fprintf(yy_output, " ? "); } expr ':' { fprintf(yy_output, " : "); } conditional_expr
	;

/*Assignment expr*/
assignment_expr
	: conditional_expr 
	/* | unary_expr assignment_operator assignment_expr */
	| postfix_expr assignment_operator assignment_expr
    | error assignment_operator assignment_expr {yyerrok;}
	;

/*Assignment operators*/
assignment_operator
	: '=' { if(check_const_var(yyval.name)) yyerrok; fprintf(yy_output, " = "); } 
	| MUL_ASSIGN { if(check_const_var(yyval.name)) yyerrok; fprintf(yy_output, " *= "); }
	| DIV_ASSIGN { if(check_const_var(yyval.name)) yyerrok; fprintf(yy_output, " /= "); }
	| MOD_ASSIGN { if(check_const_var(yyval.name)) yyerrok; fprintf(yy_output, " %%= "); }
	| ADD_ASSIGN { if(check_const_var(yyval.name)) yyerrok; fprintf(yy_output, " += "); }
	| SUB_ASSIGN { if(check_const_var(yyval.name)) yyerrok; fprintf(yy_output, " -= "); }
	;
