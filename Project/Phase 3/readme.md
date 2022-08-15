# Phase 2

## Phase Name
Lexical Analyzer of Mini C

## Lexical Analyzer
Lexical Analyzer is the first step in the Compiler. It takes Code Input ----> and give Token Stream Output.  
To do this the first step a Lexical Analyzer performs is to make lexemes.   
Lexemes are subsets of the code usually, lexemes are part of the code from which tokens are identified.
The Lexical Analyzer then after making lexemes matches them to their respective token classes. Tokens are usually identified using Regular Expressions (reason we are using flex in this project).  

## What is happening
The lex file outputs tokens <tokenclass,lexeme> of the given code in C language present in code.c file.  
As mentioned above to do so first have to make lexemes.  
Let me explain in the simplest way as possible how our code recognises the Lexemes. To start off the explanation one thing is that we have prioritized some of the token classes over others. So if there is a word "for" the analyzer will not say it is an identifier as "for" is a reserved keyword and have a higher priority than an identifier. The other thing we do is use whitespaces to separate lexemes in the code.
We have already explained a simple example of Keywords and Identifiers but it gets much more complicated than that as "for" can also be written as a string in a print statement. We will discuss more about issues like this in the next section and how and which rules are used to recognize each token class.

## Features
-> List the Keywords
-> How are identifiers recognized
-> Comments
-> Stings
-> Constants

## Organization of Files
File Name | Details
------------ | -------------
code.c | The code to make tokens of
lexl.l | Flex code for the Lexical Analyzer



## Takeaways


## Sample Video

https://user-images.githubusercontent.com/73800301/184659760-519e28dc-2f99-407e-bd4a-b45001ea4fcb.mp4

### How to run


### Pre-Requisites
--> Flex  




