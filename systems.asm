# SYSTEMS - Juan Gonzalez Arranz y Tomas Carretero Alarcon - T1 
# COMIENZO STRING2ECUACION: $a0 - input_cad; $a1 - output_ec || $v0 - salida_de_error
.text
String2Ecuacion:addi $sp, $sp, -36
		sw $ra, 0($sp)			#Guardamos la direccion de retorno original en la pila
		sw $s0, 4($sp)			#Guardamos el contenido original de $s0 en la pila
		sw $s1, 8($sp)			#Guardamos el contenido original de $s1 en la pila
		sw $s2, 12($sp)			#Guardamos el contenido original de $s2 en la pila
		sw $s3, 16($sp)			#Guardamos el contenido original de $s3 en la pila
		sw $s4, 20($sp)			#Guardamos el contenido original de $s4 en la pila
		sw $s5, 24($sp)			#Guardamos el contenido original de $s5 en la pila
		sw $s6, 28($sp)			#Guardamos el contenido original de $s6 en la pila
		sw $s7, 32($sp)			#Guardamos el contenido original de $s7 en la pila
		
		move $s0, $a1 			#Guardamos direccion de salida
		move $s1, $zero			#Suma de la primera variable
		move $s2, $zero			#Suma de la segunda variable
		move $s3, $zero			#Letra de la primera variable
		move $s4, $zero 		#Letra de la segunda variable
		move $s5, $zero			#Suma del termino independiente
		li $s6, 1 			#Si $s6 es 1 est� a la izquierda del igual, si es -1 a la derecha.
						#Se usa el 0 como se�al provisional hasta que se lee algo a la derecha del igual.
		move $s7, $a0			#Guardamos la posicion inicial del lado
		
		move $a1, $zero			#No se obliga a que haya signo en el numero leido
S2ELectura:	jal atoi
		li $t2, 1
		lb $t0, 0($a0)			#Leemos el caracter siguiente
		beq $v0, $t2, S2ECheckErrorSintax	
		bne $v0, $zero, S2ESalida	#OVERFLOW DE TERMINO
		
		
		beq $s6, $zero, S2EActIgual	#Es un n�mero: si se ha leido a la derecha del igual, hay que apuntarlo
S2ECHKDespuesNum:blt $t0, 65, S2ETerIndep	#Cualquier cosa que no sea una letra es un termino independiente
		blt $t0, 91, S2ECheckVar	#Es una letra mayuscula 
		blt $t0, 97, S2EErrorSintax	#Error sintactico
		bge $t0, 123, S2EErrorSintax 	#Es una letra minuscula
		
S2ECheckVar: 	addi $a0, $a0, 1		#El siguiente numero se debe leer desde la siguiente posicion
		beq $s3, $zero, S2EPrimeraLibre
		beq $t0, $s3, S2EPrimeraExiste
		beq $s4, $zero, S2ESegundaLibre
		bne $t0, $s4, S2ENumIncog	#No ha coincidido con ninguna: m�s de 2 varibales
		j S2ESegundaExiste 		

S2EActIgual:	li $s6, -1
		j S2ECHKDespuesNum
				
S2ECheckErrorSintax:#No se ha podido leer un numero
		lb $t0, 0($a0)
		#Comprobamos si es un igual
		bne $t0, 61, S2ECheckNoIgual
		bne $s6, 1, S2ESalida		#No nos podemos encontrar dos iguales
		move $s6, $zero 		#Sera 0 hasta que se lea algo al otro lado
		addi $s7, $a0, 1		#Nueva posicion inicial
		addi $a0, $a0, 1		#Avanzamos una posicion
		move $a1, $zero 		#No obligamos leer un signo
		j S2ELectura
S2ECheckNoIgual:#Comprobamos si es un \0
		bne $t0, $zero, S2ENoZero
		bne $s6, -1, S2ESalida		#Si es un \0 a la derecha, todo bien
		j S2ECheckOverf
S2ENoZero:	#Debe ser una letra
		blt $t0, 65, S2ESalida
		blt $t0, 91, S2EVarSola
		blt $t0, 97, S2ESalida
		bge $t0, 123, S2ESalida

S2EVarSola:	li $v1, 1
		beq $a0, $s7, S2ECheckVar
		lb $t1, -1($a0)			#Cargamos el signo
		beq $t1, 43, S2ECheckVar
S2EVarSolaNeg:	bne $t1, 45, S2EErrorSintax
		li $v1, -1
		j S2ECheckVar

S2EPrimeraLibre:move $s3, $t0			#Guardamos la letra
S2EPrimeraExiste:bne $s6, -1, S2EPrimeraSuma	#Comprobar si hace falta cambiar el signo
		lui $t2, 0x8000
		subu $v1, $zero, $v1
		beq $t2, $v1, S2EOverfReduc
S2EPrimeraSuma:	slt $t1, $s1, $zero
		slt $t2, $v1, $zero
		xor $t4, $t1, $t2
		addu $s1, $s1, $v1
		li $a1, 1			#Obligamos signo en la siguiente lectura
		bne $t4, $zero, S2ELectura	#Si son de signos distintos no puede haber overflow
		beq $t2, $zero, S2EPrimSumaPosit
		#Suma de negativos debe dar negativo
		blt $zero, $s1, S2EOverfReduc
		j S2ELectura
		#Suma de positivos debe dar positivo
S2EPrimSumaPosit:blt $s1, $zero, S2EOverfReduc
		j S2ELectura
		
S2ESegundaLibre:move $s4, $t0			#Guardamos la letra
S2ESegundaExiste:bne $s6, -1, S2ESegundaSuma	#Comprobar si hace falta cambiar el signo
		lui $t2, 0x8000
		subu $v1, $zero, $v1
		beq $t2, $v1, S2EOverfReduc
S2ESegundaSuma:	slt $t1, $s2, $zero
		slt $t2, $v1, $zero
		xor $t4, $t1, $t2
		addu $s2, $s2, $v1
		li $a1, 1			#Obligamos signo en la siguiente lectura
		bne $t4, $zero, S2ELectura	#Si son de signos distintos no puede haber overflow
		beq $t2, $zero, S2ESegSumaPosit
		#Suma de negativos debe dar negativo
		blt $zero, $s2, S2EOverfReduc
		j S2ELectura
		#Suma de positivos debe dar positivo
S2ESegSumaPosit:blt $s2, $zero, S2EOverfReduc
		j S2ELectura

S2ETerIndep:	beq $s6, -1, S2EIndepSuma	#Comprobar si hace falta cambiar de signo
		lui $t2, 0x8000
		subu $v1, $zero, $v1
		beq $t2, $v1, S2EOverfReduc
S2EIndepSuma:	slt $t1, $s5, $zero
		slt $t2, $v1, $zero
		xor $t4, $t1, $t2
		addu $s5, $s5, $v1
		li $a1, 1			#Obligamos signo en la siguiente lectura
		bne $t4, $zero,  S2ELectura	#Si son de signos distintos no puede haber overflow
		beq $t2, $zero, S2EIndepSumaPosit
		#Suma de negativos debe dar negativo
		blt $zero, $s5, S2EOverfReduc
		j S2ELectura
		#Suma de positivos debe dar positivo
S2EIndepSumaPosit:blt $s5, $zero, S2EOverfReduc
		j S2ELectura


S2ECheckOverf:	beq $s3, $s4, S2ENumIncog	#Si ambas variables no estan asignadas, hay un error de cantidad de variables
		#SALIDA CORRECTA
		move $v0, $zero
		sw $s1, 0($s0)
		sw $s2, 4($s0)
		sw $s5, 8($s0)
		sw $s3, 12($s0)
		sw $s4, 16($s0)

S2ESalida:	lw $ra, 0($sp)			#Restauramos la direccion de retorno original de la pila
		lw $s0, 4($sp)			#Restauramos el contenido original de $s0 de la pila
		lw $s1, 8($sp)			#Restauramos el contenido original de $s1 de la pila
		lw $s2, 12($sp)			#Restauramos el contenido original de $s2 de la pila
		lw $s3, 16($sp)			#Restauramos el contenido original de $s3 de la pila
		lw $s4, 20($sp)			#Restauramos el contenido original de $s4 de la pila
		lw $s5, 24($sp)			#Restauramos el contenido original de $s5 de la pila
		lw $s6, 28($sp)			#Restauramos el contenido original de $s6 de la pila
		lw $s7, 32($sp)			#Restauramos el contenido original de $s7 de la pila
		addi $sp, $sp, 36
		jr $ra

S2EErrorSintax: li $v0, 1
		j S2ESalida
S2EOverfReduc: 	li $v0, 3
		j S2ESalida
S2ENumIncog: 	li $v0, 4
		j S2ESalida
#FIN STRING2ECUACION

#COMIENZO ATOI: ENTRADA -> $a0 - direccion cadena a convertir; $a1 - obligacion de signo || $v1 - numero resultado; $v0 - codigo error; $a0 - ultima posicion
.text
atoi:		li $t1, 32			#Caracter espacio
		li $t2, 45			#Caracter signo -
		li $t3, 57			#Maximo caracter ASCII para numeros
		li $t4, 48			#Minimo caracter ASCII para numeros
		li $t5, 43			#Caracter signo +
		li $t6, 10
		li $t7, 1			#Bit indicador de signo, por defecto es positivo
		li $t8, 8
		li $t9, 214748364
		move $v1, $zero			#Registro de destino
		j AtoiComienzo
	
AtoiBucUno:	addi $a0, $a0, 1
AtoiComienzo:	lb $t0, 0($a0)			#Cargamos la primera posicion
		beq $t0, $t1, AtoiBucUno	#Omitimos los espacios
		bne $t0, $t5, AtoiPosibleNeg	#Si es un signo positivo, vamos al siguiente bucle desde el siguiente digito
		addi $a0, $a0, 1
		lb $t0, 0($a0)
		j AtoiTest2
AtoiPosibleNeg:	bne $t0, $t2, AtoiNumero	#Si es un signo negativo, vamos al siguiente bucle desde el siguiente digito
		addi $a0, $a0, 1
		lb $t0, 0($a0)
		li $t7, -1
		j AtoiTest2

AtoiNumero:	bne $a1, $zero, AtoiError	#Se obliga leer un signo y no se ha hecho
AtoiTest2:	blt $t0, $t4, AtoiError
		bgt $t0, $t3, AtoiError		#Cualquier cosa que no sea un numero es un error
		j AtoiEntDirecta
		
AtoiBucDos:	blt $t0, $t4, AtoiFinBuc	#Cualquier cosa que no sea un numero es un fin
		bgt $t0, $t3, AtoiFinBuc
AtoiEntDirecta:	addi $t0, $t0, -48	

		#COMPROBACIONES DE OVERFLOW
		blt $v1, $t9, AtoiNoOverf	#Si no representa riesgo, salimos
		bgt $v1, $t9, AtoiOverf		#Si es mayor que lo que podemos gestionar, es overflow
		blt $t0, $t8, AtoiNoOverf	#Si su valor absoluto es menor que 2147483648, entonces no hay riesgo
		bne $t0, $t8, AtoiOverf		#No es posible representar 2147483649 ni -2147483649
		beq $t7, 1, AtoiOverf		#Solo se puede representar -2147483648, no 2147483648
		lui $v1, 0x8000
		addi $a0, $a0, 1
		move $v0, $zero
		jr $ra				#Cargamos -2147483648 y se acabo
			
AtoiNoOverf:	mul $v1, $v1, $t6
		addi $a0, $a0, 1
		addu $v1, $v1, $t0		#Multiplicamos el numero existente por 10 y sumamos el digito
		lb $t0, 0($a0)
		j AtoiBucDos

AtoiFinBuc:	mul $v1, $t7, $v1
		move $v0, $zero			#Salida correcta
		jr $ra
	
AtoiError:	li $v0, 1			#Salida de error
		jr $ra
AtoiOverf:	li $v0, 2			#Salida de overflow
		jr $ra
#FIN ATOI


# COMIENZO RESUELVESISTEMA: $a0 - input_ec1; $a1 - input_ec2; $a2 - output_sol || $v0 - codigo error
.data 
.align 2
ecuacion_1: 		.space 20
ecuacion_2: 		.space 20
solucion_cramer: 	.space 36
.text
ResuelveSistema:addi $sp, $sp, -12
		sw $ra, 8($sp)			#Guardamos la direccion de retorno original en la pila
		sw $s0, 4($sp)			#Guardamos el contenido original de $s0 en la pila
		sw $s1, 0($sp)			#Guardamos el contenido original de $s1 en la pila
		
		move $s0, $a1			#Almacenamos la direccion de la segunda cadena
		move $s1, $a2			#Almacenamos la direccion de salida
		la $a1, ecuacion_1
		jal String2Ecuacion

		bne $v0, $zero, RSError
	 
	 	move $a0, $s0			#Leemos la segunda ecuacion
		la $a1, ecuacion_2
		jal String2Ecuacion 
		
		bne $v0, $zero, RSError
		
		#Comprobamos que tienen las mismas incognitas
		la $t4, ecuacion_1
		la $t5, ecuacion_2
		lw $t0, 12($t4)			#Primera variable de la primera ecuacion
		lw $t1, 16($t4)			#Segunda variable de la primera ecuacion
		lw $t2, 12($t5)			#Primera variable de la segunda ecuacion
		lw $t3, 16($t5)			#Segunda variable de la segunda ecuacion
		
		bne $t0, $t2, RSDistPrimeras
		bne $t1, $t3, RSCodigo5		#Iguales las primeras y segundas, todo correcto
		j RSCorrecto
			
RSDistPrimeras:	bne $t0, $t3, RSCodigo5		#La primra de la primera y la segunda de la segunda deben ser iguales
		bne $t1, $t2, RSCodigo5		#La segunda de la primera y la primera de la segunda deben ser iguales
		#Hay que intercambiar las variables de la segunda ecuacion
		lw $t0, 0($t5)
		lw $t1, 4($t5)
		sw $t2, 16($t5)
		sw $t3, 12($t5)
		sw $t0, 4($t5)
		sw $t1, 0($t5)
		
RSCorrecto:	la $a0, ecuacion_1
		la $a1, ecuacion_2
		la $a2, solucion_cramer
		jal Cramer
	
		la $a0, solucion_cramer
		move $a1, $s1
		jal Solucion2String
		
		move $v0, $zero
RSError:  	lw $ra, 8($sp)			#Restauramos la direccino de retorno original de la pila
		lw $s0, 4($sp)			#Restauramos el contenido original de $s0 de la pila
		lw $s1, 0($sp)			#Restauramos el contenido original de $s1 de la pila
		addi $sp, $sp, 12
		jr $ra

RSCodigo5: 	li $v0, 5
		j RSError
	
# FIN ResuelveSistema.

# COMIENZO SOLUCION2STRING: $a0 - input_sol; $a1 - output_string
.data
Indeterminado:	.asciiz "INDETERMINADO"
Incompatible:	.asciiz "INCOMPATIBLE"
.text
Solucion2String:addi $sp, $sp, -12
		sw $ra, 8($sp)			#Guardamos la direccion de retorno original en la pila
		sw $s0, 4($sp)			#Guardamos el contenido original de $s0 en la pila
		sw $s1, 0($sp)			#Guardamos el contenido original de $s1 en la pila
		
		lw $t0, 0($a0)			#Obtenemos el tipo de solucion
		li $t1, 1
		li $t2, 2
		beq $t0, $t1, Sol2StrIndet
 		beq $t0, $t2, Sol2StrIncom
 		
 		move $s0, $a0
		move $s1, $a1
 		
 		lw $t0, 28($s0)			#Letra de la primera variable
 		li $t1, 61			#Caracter '='
 		sb $t0, 0($s1)		
 		sb $t1, 1($s1)	
 				
 		addi $a1, $s1, 2		#Escribimos parte entera del primer numero
 		lw $a0, 4($s0)
 		jal itoa
 		
 		lw $t1, 12($s0)			#Obtenemos la parte decimal
 		move $s1, $v0
 		beq $t1, $zero, Sol2StrSegNum	#Si no hay decimales, hemos acabado
 		li $t0, 46			#Caracter de '.'
 		lw $t1, 8($s0)			#Obtenemos el n�mero de 0s
 		sb $t0, 0($s1)			#Escribimos el punto
 		li $t0, 48			#Cargamos el 0
 		
Sol2StrCerosPrim:addi $s1, $s1, 1
		beq $t1, $zero, Sol2StrDecPrim
		addi $t1, $t1, -1
 		sb $t0, 0($s1)
 		j Sol2StrCerosPrim
 		
Sol2StrDecPrim:	lw $a0, 12($s0)
		move $a1, $s1
		jal itoa
		move $s1, $v0
		
Sol2StrSegNum:	li $t0, 32			#Escribimos el espacio
		sb $t0, 0($s1)
		
		lw $t0, 32($s0)			#Escribimos la segunda variable y el =
 		li $t1, 61
 		sb $t0, 1($s1)
 		sb $t1, 2($s1)			
 		
 		addi $a1, $s1, 3		#Escribimos parte entera del segundo numero
 		lw $a0, 16($s0)
 		jal itoa
 		
 		lw $t1, 24($s0)			#Obtenemos la parte decimal
 		move $s1, $v0
 		beq $t1, $zero, Sol2StrFin	#Si no hay decimales, hemos acabado
 		li $t0, 46			#Caracter de '.'
 		lw $t1, 20($s0)			#Obtenemos el n�mero de 0s
 		sb $t0, 0($s1)			#Escribimos el punto
 		li $t0, 48			#Cargamos el 0
 		
Sol2StrCerosSeg:addi $s1, $s1, 1
		beq $t1, $zero, Sol2StrDecSeg
		addi $t1, $t1, -1
 		sb $t0, 0($s1)
 		j Sol2StrCerosSeg
 		
Sol2StrDecSeg:	lw $a0, 24($s0)
		move $a1, $s1
		jal itoa
Sol2StrFin:	lw $s1, 0($sp)			#Restauramos el contenido original de $s1 de la pila
		lw $s0, 4($sp)			#Restauramos el contenido original de $s0 de la pila
		lw $ra, 8($sp)			#Restauramos la direccino de retorno original de la pila
Sol2StrSalidaExc:addi $sp, $sp, 12
		jr $ra
		
Sol2StrIndet:	la $t1, Indeterminado
		j Sol2StrExcep
Sol2StrIncom:	la $t1, Incompatible
Sol2StrExcep:	lb $t0, 0($t1)			#Escribimos el mensaje resultado adecuado
		addi $t1, $t1, 1
		sb $t0, 0($a1)
		addi $a1, $a1, 1
		bne $t0, $zero, Sol2StrExcep	#Cuando lleguemos al caracter \0, se ha terminado la copia
		j Sol2StrSalidaExc		#En estos casos, los registros originales no se han llegado a modificar. No es necesario recuperarlos

# FIN SOLUCION2STRING	

# COMIENZO ITOA: $a0 - numero a convertir; $a1 - direccion de la cadena resultado || $v0 - ultima posicion
.data
ItoaNumeroEspecial: .asciiz "-0"
.text
itoa:		lui $t1, 0x8000
		li $t2, 10
		beq $a0, $t1, ItoaEspecial	#En caso de que sea -2147483648 complica mucho la aritmetica, mejor tratarlo aparte
		move $t0, $a0 
		move $t1, $a1
	
ItoaCont:	div $t0, $t2			#Buscamos la ultima posicion a escribir
		mflo $t0
		addi $t1, $t1, 1
		bne $t0, $zero, ItoaCont

		ble $zero, $a0, ItoaPositivo	#Comprobamos si es negativo 
		li $t0, 45			
		sb $t0, 0($a1)			#Escribimos un - en la primera posicion
		addi $t1, $t1, 1		#En caso de ser negativo la ultima posicion avanza 1
		sub $a0, $zero, $a0		#Cambio de signo
ItoaPositivo:	sb $zero, 0($t1)		#Escribimos el terminador de cadena
		move $v0, $t1
		
ItoaBucle:  	div $a0, $t2
		mfhi $t0			#Resto -> $t0
		mflo $a0			#Cociente -> $a0
		addi $t1, $t1, -1
		addi $t0, $t0, 48		#Los numeros ASCII empiezan en el 48	
		sb $t0, 0($t1)
		bne $a0, $zero, ItoaBucle	#Si el cociente es 0, hemos terminado
		jr $ra
	
		#Caso especial
ItoaEspecial:	addi $v0, $a1, 2
		li $t0, 45
		li $t1, 48
		sb $t0, 0($a1)		#Escribimos el -
		sb $t1, 1($a1)		#Escribimos el 0
		sb $zero, 2($a1)	#Escribimos el terminador de cadena
		jr $ra
# FIN ITOA
