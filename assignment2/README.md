PROJECT REPORT\
(FLEX PROGRAM)

1.	**Project Background and Description:**\
Flex GCC is used :\
Code is executed on CMD (C code)\
“A flex program that will accept a valid ISO standard email address and international phone number.”\

Email ISO Standard : John@iso.org\
In Our Email Address Program, An Email address is accepted according to ISO standards following : [A to Z], [0-9]. While special characters like "?" or "!" or any other characters are not accepted.\
example321@gmail.com --> Accepted !\
example##@gmail.com --> Not Accepted


Phone Number ISO Standard:\
"+" Sign\
Your Country Code/international Code : "44", "1", "92" etc.\
Phone Number</br>
In Our Phone Number  Program, A Phone Number is accepted according to ISO Standards following : "+",[0-9] digits and the numbers limits are '14'. If limit exceeds after '14', It will give Invalid Numbers Error\
+92034164859120 --> Accepted !\
+9203416485912011 --> Not Accpeted!

2. **Problems and Issues:**\
First of all, required libraries must be installed before executing the code. Our block of code was not running without “yywrap()” for “email address” code.
It was asking for a wrap reference. So wrap up library is installed to execute our code without any hurdles.

There were no problems found in our “phone number” program and it was executed properly. However, we added some conditions to improve our code.

