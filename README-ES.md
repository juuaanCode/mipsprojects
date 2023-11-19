# Aprendiendo MIPS
[![en](https://img.shields.io/badge/lang-en-red.svg)](/README.md)

Este repositorio contiene mi trabajo en dos asignaturas de Ingeniería Informática en la Universidad de Valladolid, _Fundamentos de Computadoras_ y _Arquitectura y Organización de Computadoras_. Aprender a programar en ensamblador para la arquitectura MIPS fue una parte integral de estas asignaturas.

La primera parte del proyecto se centra en la realización de diferentes operaciones con strings. La segunda está diseñada para la resolución de un sistema de ecuaciones. 
El código se desarrolló conjuntamente con Tomás Carretero, otro estudiante.

## Proyecto #1: strings
Este programa recibe una sola línea de caracteres de la entrada estándar y la subdivide en 2 o 3 subcadenas para extraer un comando y parámetros de entrada.
La entrada debe seguir el esquema siguiente: `[\<op>] [\<input1>] [\<input2>]`. El resultado se devolverá por salida estándar. La siguiente tabla muestra todas las diferentes operaciones disponibles:

|   Op    | input1  |   input2  |   Output  |
|---------|---------|-----------|-----------|
| `len`     | String  |           | Número de caracteres en hexadecimal.|
| `lwc`     | String  |           | Cadena en minúsculas.|
| `upc`     | String1 |           | Cadena en mayúsculas.|
| `cat`     | String1 | String2   | Concatenación de las cadenas.|
| `cmp`     | String1 | String2   | "IGUAL", "MAYOR" o "MENOR" comparando carácter a carácter en ASCII en cada cadena.
| `chr`     | String1 | String2   | Índice del primer carácter de String1 en String2, en hexadecimal.
| `rchr`    | String1 | String2   | Lo mismo que `chr` pero empezando desde el último carácter de String2.
| `str`     | String1 | String2   | Índice de String1 en String2, en hexadecimal.
| `rev`     | String  |           | String al revés.
| `rep`     | String  | NumberHex | String repetida tantas veces como el número indique.

Los números de la entrada solo serán aceptados si no tienen 0s a la izquierda y sin el "0x".

| Ejemplo   | ¿Permitido?  |
|-----------|-------|
| 1a        | ✅    |
| 1A        | ✅    |
| 0x0000001a| ❌    |
| 0x01A     | ❌    |
| 01A       | ❌    |

Para la salida se podrán imprimir o solo los dígitos significativos o todo el registro, incluidos todos los ceros.

| Ejemplo   | ¿Permitido?  |
|-----------|-------|
| 0000001a  | ✅    |
| 0000001A  | ✅    |
| 1a        | ✅    |
| 1A        | ✅    |
| 0x0000001a| ❌    |
| 01A       | ❌    |

En caso de que se dé el número insuficiente de argumentos, cadenas vacías o el formato de número incorrecto, se imprimirá por salida _ENTRADA INCORRECTA_.

### Algunos ejemplos
| Entrada | Salida |
|-------|-------|
| `len HELLO WORLD` | 5 |
| `rep HELLO 4`     | HELLOHELLOHELLOHELLO |
| `HELLO WORLD`     | ENTRADA INCORRECTA |
| `cmp MUN MUNDO`   | MENOR |

## Projecto #2: systems
El objetivo con este programa es resolver sistemas de ecuaciones con dos variables. El código de este fichero funciona como una _librería_, en el sentido de que es simplemente una colección de funciones y no hay un `main`.

Hay 2 estructuras _definidas_ en este proyecto: una para ecuaciones y otra para la solución.

### String2Ecuacion
Esta función transforma texto a una ecuación. Toma dos parámetros de entrada: la dirección para la cadena de entrada y la dirección para la ecuación de salida. Puede detectar sintaxis incorrecta, overflows e incluso un número no soportado de variables.

### Solucion2String
Esta función toma dos parámetros: uno para la dirección de la solución y otro para generar una cadena de caracteres con ella. Es importante mencionar que sistemas incompatibles o indeterminados también estan soportados, imprimiendo `INCOMPATIBLE` o `INDETERMINADO` en cada caso.

### ResuelveSistema
Esta función es la principal. Toma 3 argumentos: uno para cada ecuación y otro para la dirección donde imprimir la solución, todas tratadas como strings. Se encargará de las transformaciones necesarias usando las funciones explicadas y llamará también a la función Cramer para calcular la solución.

### Cramer
Esta función no está implementada, pero el profesor se encargó de proveerla. El código por tanto la usa, pero no está en el repositorio. Se encargaba de computar la solución de un sistema dadas dos ecuaciones.

### Algunos ejemplos
| Entrada | Salida |
|-------|--------|
| $t-s=0$ <br> $2t+s=3$ | $t=1\ \ s=1$ |
| $t+z=0$ <br> $2t+s=3$ | _ERROR 5 - SISTEMA INVALIDO_ <br> (demasiadas variables)