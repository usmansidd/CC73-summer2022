DIGIT       [0-9]
LETTER      [a-zA-Z_]
EXPONENTIAL [Ee][+-]?{DIGIT}+
FS          (f|F|l|LETTER)
IS          (u|U|l|LETTER)*

%{

    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include "y.tab.h"

    /*Data structures*/
    struct symrec{
        char *name;             //Symbol name
        int type;               //Symbol type
        double value;           //Variable lookahead value
        int function;           //Function
        struct symrec *next;    //Next register pointer
    };

    typedef struct symrec symrec;

    /*Symbol table*/
    extern symrec *sym_table;

    /*Symbol table interactions*/
    symrec *putsym ();
    symrec *getsym ();

    int line_number;            //Line number
    void comment(void);         //Comments
    void line_comment(void);    //Line comment
    void count();               //Counter

%}
