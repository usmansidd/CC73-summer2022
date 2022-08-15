# Phase 3

## Phase Name
C code to Python Code Converter

## Heading


## What is happening
YACC short for Yet Another Compiler Compiler creates parser. As we know and as we have seen in the previous phase the output of the flex is in tokens. 
Yacc takes those tokens and parses them in the Grammer provided. Usually what happens is that this phenomenon is used in converting HLL(high level language) to Machine language but in out project it is converting Mini C(details in Phase 1) to python.
In Yacc our given CFG is converted to a C code implementation. This new file is our parser/compiler. 

## Features
The phase can convert the code in mini C language to that of python. It does the following by using regular expressions in Flex and using grammars in Yacc. 

## Organization of Files
File Name | Details
------------ | -------------
Code Folder | Contains the input i.e the code to convert the language of
Output | Contains the output of the program i.e python code
lex.l | Flex code
lex.yy.c| Flex compilation file
yacc.y | Yacc code



## Takeaways
-> Got a better understanding of how the compilers work  
-> Deeper understanding of how errors are caught in a compiler  
-> Understanding of grammars and parsing  

## Sample Video

https://user-images.githubusercontent.com/73800301/184659760-519e28dc-2f99-407e-bd4a-b45001ea4fcb.mp4

### How to run
1) Make sure Yacc and Flex is installed
2) Download all the files 
3) Open terminal
4) Navigate to the folder of the project 
5) Compile flex code
6) Compile yacc code
7) Run the executable file in terminal
8) Select the file in code folder as an input
9) Select a path for output
10) Press enter. The output will be the in the requested file

### Pre-Requisites
--> Flex  
--> Yacc  




