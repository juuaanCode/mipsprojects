# Learning MIPS
[![es](https://img.shields.io/badge/lang-es-red.svg)](/README-ES.md)

This repository contains my work for two subjects of Computer Science at University of Valladolid, _Fundamentos de Computadoras_ (Computer Fundamentals) and _Arquitectura y Organización de Computadoras_ (Computer Architecture and Organization). Learning how to code in assembly for the MIPS architecture was a fundamental part of both subjects.

The first project focuses on making different operations with strings. The second one is designed to resolve a system of equations. Keep in mind the code is written in Spanish and developed in colaboration with Tomás Carretero, another student.

## Project #1: strings
This program takes a single line of characters from standard input and subdivides it into 2 or 3 substrings depending on the context to extract a command and input parameters.
The input must follow the following scheme: `[\<op>] [\<input1>] [\<input2>]`. The result is delivered via standard output. The following table states all the different operations available:

|   Op    | input1  |   input2  |   Output  |
|---------|---------|-----------|-----------|
| `len`     | String  |           | Number of characters in hex.|
| `lwc`     | String  |           | String in lowercase.|
| `upc`     | String1 |           | String in uppercase.|
| `cat`     | String1 | String2   | Concatenation of both strings.|
| `cmp`     | String1 | String2   | "IGUAL", "MAYOR" or "MENOR" comparing character per character in ASCII of each string.
| `chr`     | String1 | String2   | Index of first character of String1 on String2, in hex.
| `rchr`    | String1 | String2   | Same as `chr` but starting from the last character of String2.
| `str`     | String1 | String2   | Index of String1 inside String2 in hex.
| `rev`     | String  |           | Reversed String.
| `rep`     | String  | NumberHex | String repeated as many times as the number implies.

Numbers on input will only be accepted if they do not have 0s on the left and without "0x". 

| Example   | Accepted?  |
|-----------|-------|
| 1a        | ✅    |
| 1A        | ✅    |
| 0x0000001a| ❌    |
| 0x01A     | ❌    |
| 01A       | ❌    |

For output either only the significant digits will be printed or all the 0s on the register.

| Example   | Accepted?  |
|-----------|-------|
| 0000001a  | ✅    |
| 0000001A  | ✅    |
| 1a        | ✅    |
| 1A        | ✅    |
| 0x0000001a| ❌    |
| 01A       | ❌    |

In case not enough arguments, empty strings or wrong number format is given, _ENTRADA INCORRECTA_ will be printed.

### Some examples
| Input | Output |
|-------|-------|
| `len HELLO WORLD` | 5 |
| `rep HELLO 4`     | HELLOHELLOHELLOHELLO |
| `HELLO WORLD`     | ENTRADA INCORRECTA |
| `cmp MUN MUNDO`   | MENOR |

## Project #2: systems
The objective with this program is to resolve systems of equations with two variables. The code in this second file works as a _library_, in the sense that it is just a collection of different functions (there is no `main`).

There are 2 structures _defined_ in this project: one for ecuations and another for the solution.

### String2Ecuacion
This function transforms simple text into an ecuation. It takes 2 input parameters: the address for the input string and the address for the output ecuation.
It can detect wrong sintax, overflows and even an unsupported number of variables.

### Solucion2String
Two parameters are used on this function: one for the solution address and another for the output string to be generated. It will transform a solution structure into something readable. It is important to note that incompatible and indeterminate systems are also supported, returning a string `INCOMPATIBLE` or `INDETERMINADO` in each case.

### ResuelveSistema
This is the main function that makes everything work. It takes 3 arguments in: one for each ecuation and one for the address of the output, all treated as strings. It will manage the several transformations using the functions explained above and call the Cramer function needed for the calculation.

### Cramer
This function was not implemented but was provided by the professor, so it is not present in the repository even if the code uses it. It computed the solution of a system when its two ecuations were given.

### Some examples
| Input | Output |
|-------|--------|
| $t-s=0$ <br> $2t+s=3$ | $t=1\ \ s=1$ |
| $t+z=0$ <br> $2t+s=3$ | _ERROR 5 - SISTEMA INVALIDO_ <br> (too many variables)