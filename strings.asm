# STRINGS - Juan Gonzalez Arranz y Tomas Carretero Alarcon - T1
.data
entrada:	.space 128
operacion:	.space 128
cadena1:	.space 128
cadena2:	.space 128
salidaMsg:	.space 128
lenMsg:		.asciiz "len"
lwcMsg:		.asciiz "lwc"
upcMsg:		.asciiz "upc"
catMsg:		.asciiz "cat"
cmpMsg:		.asciiz "cmp"
chrMsg:		.asciiz "chr"
rchrMsg:	.asciiz "rchr"
strMsg:		.asciiz "str"
revMsg:		.asciiz "rev"
repMsg:		.asciiz "rep"
mayorMsg:	.asciiz "MAYOR"
menorMsg:	.asciiz "MENOR"
igualMsg:	.asciiz "IGUAL"
entradaIncorrecta: .asciiz "ENTRADA INCORRECTA"
.text
main:	li $v0, 8		#Entrada
	la $a0, entrada
	la $a1, 127
	syscall
	la $a0, entrada
	la $a1, operacion
	la $a2, cadena1
	la $a3, cadena2
	jal prep		#Separar el operador, la cadena1 y la cadena2
	beq $v0, 1, incorr	#Hay un error de sintaxis
	beq $v0, 2, lenCHK	#Solo hay un par�metro: buscar funcion a partir de las que solo admiten uno
#IDENTIFICACI�N DE OPERACION
catCHK:	la $a0, operacion
	la $a1, catMsg
	jal cmp
	bne $v0, $zero, cmpCHK
	la $a0, cadena1
	la $a1, cadena2
	la $a2, salidaMsg
	jal cat
	j cargarSalida
	
cmpCHK:	la $a0, operacion
	la $a1, cmpMsg
	jal cmp
	bne $v0, $zero, chrCHK
	la $a0, cadena1
	la $a1, cadena2
	jal cmp
	bne $v0, $zero, cmpMen
	la $a0, igualMsg
	j cmpPrint
cmpMen:	bne $v0, -1, cmpMay
	la $a0, menorMsg
	j cmpPrint
cmpMay:	la $a0, mayorMsg
cmpPrint:j salida

chrCHK:	la $a0, operacion
	la $a1, chrMsg
	jal cmp
	bne $v0, $zero, rchrCHK
	la $a0, cadena1
	la $a1, cadena2
	jal chr
	move $a0, $v0
	la $a1, salidaMsg
	jal bin2hex
	j cargarSalida
	
rchrCHK:la $a0, operacion
	la $a1, rchrMsg
	jal cmp
	bne $v0, $zero, strCHK
	la $a0, cadena1
	la $a1, cadena2
	jal rchr
	move $a0, $v0
	la $a1, salidaMsg
	jal bin2hex
	j cargarSalida
		
strCHK:	la $a0, operacion
	la $a1, strMsg
	jal cmp
	bne $v0, $zero, repCHK
	la $a0, cadena1
	la $a1, cadena2
	jal str
	move $a0, $v0
	la $a1, salidaMsg
	jal bin2hex
	j cargarSalida
	
repCHK:	la $a0, operacion
	la $a1, repMsg
	jal cmp
	bne $v0, $zero, lenCHK
	la $a0, cadena1
	la $a1, cadena2
	la $a2, salidaMsg
	jal rep
	beq $v0, 1, incorr
	j cargarSalida

#FUNCIONES CON SOLO 1 PAR�METRO
lenCHK:	la $a0, operacion
	la $a1, lenMsg
	jal cmp
	bne $v0, $zero, lwcCHK
	la $a0, cadena1
	jal len
	move $a0, $v0
	la $a1, salidaMsg
	jal bin2hex
	j cargarSalida

lwcCHK:	la $a0, operacion
	la $a1, lwcMsg
	jal cmp
	bne $v0, $zero, upcCHK
	la $a0, cadena1
	la $a1, salidaMsg
	jal lwc
	j cargarSalida
	
upcCHK:	la $a0, operacion
	la $a1, upcMsg
	jal cmp
	bne $v0, $zero, revCHK
	la $a0, cadena1
	la $a1, salidaMsg
	jal upc
	j cargarSalida
	
revCHK:	la $a0, operacion
	la $a1, revMsg
	jal cmp
	bne $v0, $zero, incorr
	la $a0, cadena1
	la $a1, salidaMsg
	jal rev
	j cargarSalida
	
incorr: la $a0, entradaIncorrecta
	j salida

cargarSalida:la $a0, salidaMsg
salida:	li $v0, 4
	syscall
	li $v0, 10
	syscall

#---------------------------------FUNCIONES---------------------------------
#PREPARADOR DE CADENAS: $a0 - cadenaOrignal, $a1 - op, $a2 - cad1, $a3 - cad2
prep:	lb $t0, 0($a0)			#Se comprueba cada palabra, primero su primer car�cter y luego el resto
	addi $a0, $a0, 1
	beq $t0, 32, finPreE		#Cualquiera de estos casos significa que no hay operador
	beq $t0, 9, finPreE
	beq $t0, $zero, finPreE
	beq $t0, 10, finPreE
	sb $t0, 0($a1)
	addi $a1, $a1, 1
opPrep:	lb $t0, 0($a0)
	addi $a0, $a0, 1
	beq $t0, 32, c1Prep		#Se acab� operador
	beq $t0, 9, c1Prep		#Se acab� operador
	beq $t0, $zero, finPreE	#Error de sintaxis
	beq $t0, 10, finPreE		#Error de sintaxis
	sb $t0, 0($a1)
	addi $a1, $a1, 1
	j opPrep
c1Prep:	lb $t0, 0($a0)			#Primer par�metro
	addi $a0, $a0, 1
	beq $t0, 32, c1Prep		#No hemos llegado todav�a
	beq $t0, 9, c1Prep		
	beq $t0, $zero, finPreE	#Cualquiera de estos casos significa que no hay primer par�metro
	beq $t0, 10, finPreE
	sb $t0, 0($a2)
	addi $a2, $a2, 1
c1PrepB:lb $t0, 0($a0)
	addi $a0, $a0, 1
	beq $t0, 32, c2Prep		#Se acab� primer par�metro
	beq $t0, 9, c2Prep
	beq $t0, $zero, finPre1	#No hay segundo par�metro
	beq $t0, 10, finPre1		#No hay segundo par�metro
	sb $t0, 0($a2)
	addi $a2, $a2, 1
	j c1PrepB
c2Prep:	lb $t0, 0($a0)			#Segundo par�metro
	addi $a0, $a0, 1
	beq $t0, 32, c2Prep		#No hemos llegado todav�a
	beq $t0, 9, c2Prep		#No hemos llegado todav�a
	beq $t0, $zero, finPreE	#Error de sintaxis
	beq $t0, 10, finPreE		#Error de sintaxis
	sb $t0, 0($a3)
	addi $a3, $a3, 1
c2PrepB:lb $t0, 0($a0)
	addi $a0, $a0, 1
	beq $t0, $zero, finPre		#Se acab�
	beq $t0, 10, finPre
	beq $t0, 32, finPreE		#Error de sintaxis: hay m�s de dos par�metros
	beq $t0, 9, finPreE		#Error de sintaxis: hay m�s de dos par�metros
	sb $t0, 0($a3)
	addi $a3, $a3, 1
	j c2PrepB
finPre:	sb $zero, 0($a1)		#Aseguramos el terminador de cadena por si acaso
	sb $zero, 0($a2)
	sb $zero, 0($a3)
	move $v0, $zero
	jr $ra
finPreE:li $v0, 1			#Error
	jr $ra
finPre1:li $v0, 2			#Solo un par�metro
	jr $ra
#FIN PREPARADOR DE CADENAS

#COMIENZO FUNCI�N DECIMAL A HEX: $a0 - n�mero, $a1 - direcci�n salida.
bin2hex:move $t0, $zero			#Contador de car�cter
bucB2H:	beq $t0, 8, finB2H		#Cuando sea 8, se termina
	addi $t0, $t0, 1		
	andi $t1, $a0, 0xF0000000	#Solo queremos los 4 primeros bits (un car�cter hexadecimal)
	srl $t1, $t1, 28		#Desplazamos los 4 primeros bits a las posiciones de menor peso
	sll $a0, $a0, 4			#Desplazamos el n�mero original 4 bits a la izquierda
	blt $t1, 10, numB2H		#Si el n�mero obtenido es <10, entonces es un n�mero. Si no, hay que escribir una letra
letB2H:	addi $t1, $t1, 87		#Las letras comienzan en la 97 con la a
	sb $t1, 0($a1)
	addi $a1, $a1, 1
	j bucB2H
numB2H:	addi $t1, $t1, 48		#Los n�meros comienzan en el 48 con el 0
	sb $t1, 0($a1)
	addi $a1, $a1, 1
	j bucB2H
finB2H:	sb $zero, 0($a1)		#No es estrictamente necesario en este caso pero lo hacemos por si acaso la memoria no est� inicializada
	jr $ra
#FIN FUNCI�N DECIMAL A HEX

#COMIENZO DE LA FUNCI�N LEN: $a0 - cadena de entrada, $v0 - n�mero 
len:	move $v0, $a0
bucLen:	lb $t1, 0($a0)
	beq $t1, $zero, finLen		#Sumamos 1 hasta que nos encontremos con un car�cter nulo
	addi $a0, $a0, 1
	j bucLen
finLen:	sub $v0, $a0, $v0
	jr $ra
#FIN DE LA FUNCI�N LEN

#COMIENZO DE FUNCI�N LWC: $a0 - cadenaOG, $a1 - cadena salida
lwc:	lb $t0, 0($a0)			
	beq $t0, $zero, finLwc		#Si es \0, hemos terminado
	blt $t0, 65, saveLwc		#Si es menor o mayor que los caracteres en may�sculas no hay que hacer nada
	bgt $t0, 90, saveLwc
	addi $t0, $t0, 32		#Lo pasamos a min�sculas
saveLwc:sb $t0, 0($a1)
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j lwc
finLwc:	sb $zero, 0($a1)		#No es estrictamente necesario en este caso pero lo hacemos por si acaso la memoria no est� inicializada
	jr $ra
#FIN FUNCI�N LWC
#COMIENZO FUNCI�N UPC: $a0 - cadenaOG, $a1 - cadena salida
upc:	lb $t0, 0($a0)
	beq $t0, $zero, finUpc		#Si es \0, hemos terminado
	blt $t0, 97, saveUpc		#Si es menor o mayor que los caracteres en min�sculas no hay que hacer nada
	bgt $t0, 122, saveUpc
	addi $t0, $t0, -32		#Lo pasamos a may�sculas
saveUpc:sb $t0, 0($a1)
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j upc
finUpc:	sb $zero, 0($a1)		#No es estrictamente necesario en este caso pero lo hacemos por si acaso la memoria no est� inicializada
	jr $ra
#FIN FUNCI�N UPC
#COMIENZO FUNCI�N CAT: $a0 - cadena1, $a1 - cadena2, $a2 - cadena salida
cat:	lb $t0, 0($a0)			#Copia de la cadena A
	beq $t0, $zero, copBCat
	sb $t0, 0($a2)
	addi $a0, $a0, 1
	addi $a2, $a2, 1
	j cat
copBCat:lb $t0, 0($a1)			#Copia de la cadena B
	beq $t0, $zero, finCat
	sb $t0, 0($a2)
	addi $a1, $a1, 1
	addi $a2, $a2, 1
	j copBCat
finCat:	sb $zero, 0($a2)		#No es estrictamente necesario en este caso pero lo hacemos por si acaso la memoria no est� inicializada
	jr $ra
#FIN FUNCI�N CAT
#COMIENZO FUNCI�N CHR: $a0 - cadena1, $a1 - cadena2. Resultado en $v0.
chr:	lb $t0, 0($a0)			#Inicializamos el registro $t0, con el car�cter a buscar
	li $v0, 1			#El registro $v0 contiene la primera posici�n del car�cter en la cadena
	
bucChr:lb $t1, 0($a1)			
	beq $t0, $t1, outChr		#Sale del bucle si el car�cter es el buscado
	addi $v0, $v0, 1		
	addi $a1, $a1, 1		
	bne $t1, $zero, bucChr		#Permanece en el bucle si el car�cter seleccionado no es el terminador de cadena, si es este la cadena no contiene el char buscado
	move $v0, $zero		
outChr:jr $ra
#FIN FUNCI�N CHR
#COMIENZO FUNCI�N RCHR: $a0 - cadena1, $a1 - cadena2. Resultado en $v0.
rchr: 	lb $t0, 0($a0)			#Inicializamos el registro $t0, con el car�cter a buscar
	move $v0, $zero			#El registro $v0, empieza en 0 pues en principio el car�cter no est� en la cadena
	move $t2, $zero			#El registro $t2 contiene la posici�n del car�cter en la cadena donde busco
	
bucRchr:lb $t1, 0($a1)			#Cargo el car�cter y compruebo si es el buscado
	beq $t1, $zero, outRchr		#El bucle termina si y s�lo si recorre la cadena entera
	addi $a1, $a1, 1
	addi $t2, $t2, 1		
	bne $t1, $t0, bucRchr		#Si el car�cter es distinto del buscado reitera directo, en caso contrario (igual) guarda la posici�n en $v0 y reitera
	move $v0, $t2
	j bucRchr	
outRchr:jr $ra
#FIN FUNCI�N RCHR
#COMIENZO FUNCI�N STR: $a0 - cadena1, $a1 - cadena2. Resultado en $v0
str:	move $t3, $a0 			#Hago una copia de las direcciones iniciales de cada cadena y cargo el primer car�cter a buscar
	move $t4, $a1
	move $t5, $a1
bucStr:	lb $t0, 0($t3)			#Comparo cada caracter
	lb $t1, 0($t4)
	beq $t0, $zero, eqStr		#Si el car�cter de la subcadena es \0, entonces est� contenida en la cadena
	beq $t1, $zero, noEncStr	#Si el car�cter de la cadena grande es \0, entonces la subcadena no est� en la cadena
	bne $t0, $t1, resetStr		#Si no son iguales, hay que resetear la b�squeda
	addi $t4, $t4, 1
	addi $t3, $t3, 1
	j bucStr

resetStr:move $t3, $a0			#El reseteo es volver a la posici�n inicial de la subcadena
	addi $a1, $a1, 1		#Y volver a la posici�n inicial anterior de la cadena +1
	move $t4, $a1
	j bucStr

eqStr:	sub $v0, $t3, $a0		#C�lculo de la posici�n
	sub $v0, $t4, $v0
	sub $v0, $v0, $t5
	addi $v0, $v0, 1
	jr $ra
noEncStr: move $v0, $zero
	jr $ra
#FIN FUNCI�N STR
#COMIENZO FUNCI�N REV: $a0 - cadena, $a1 - cadena salida
rev:	move $t0, $a0		
contRev:lb $t1, 0($t0)			#Direcci�n de cadena en $a0. Tenemos que encontrar la direcci�n del �ltimo car�cter, $t0
	addi $t0, $t0, 1
	bne $t1, $zero, contRev
	addi $t0, $t0, -2		#El car�cter final estar� 2 lugares antes del siguiente al \0
outRev:	lb $t1, 0($t0)			#Intercambio primero-ultimo
	sb $t1, 0($a1)
	addi $t0, $t0, -1
	addi $a1, $a1, 1
	bge $t0, $a0, outRev
	sb $zero, 0($a1)		#No es estrictamente necesario en este caso pero lo hacemos por si acaso la memoria no est� inicializada
	jr $ra
#FIN FUNCI�N REV
#COMIENZO DE LA FUNCI�N REP: $a0 - cadena, $a1 - cadena con numero, $a2 - cadena salida
rep:	move $v0, $zero			#Obtenci�n del n�mero binario
	move $t1, $zero			
	lb $t0, 0($a1)
	beq $t0, 48, errorRep		#No puede empezar por 0
	
bucRep:	lb $t0, 0($a1)
	beq $t0, $zero, repRep		#Fin del n�mero (Si es m�s grande que 32 bits nos quedamos con los de la derecha)
	addi $a1, $a1, 1
	sll $t1, $t1, 4
	blt $t0, 48, errorRep		#Por debajo de los n�meros - ERROR
	blt $t0, 58, numRep		#Por debajo del 9, incluido
	blt $t0, 65, errorRep		#Por debajo de la A - ERROR
	blt $t0, 71, mayRep		#Por debajo de la F, incluida
	blt $t0, 97, errorRep		#Por debajo de la a - ERROR
	blt $t0, 103, minRep		#Por debajo de la f, incluida
errorRep:li $v0, 1
	jr $ra
numRep: addi $t0, $t0, -48		#Es un n�mero
	or $t1, $t1, $t0
	j bucRep
mayRep:addi $t0, $t0, -55		#Es una letra may�scula
	or $t1, $t1, $t0
	j bucRep
minRep:addi $t0, $t0, -87		#Es una letra min�scula
	or $t1, $t1, $t0
	j bucRep
	
repRep:	move $a1, $a0			#Guardamos el comienzo de la cadena
bucBRep:lb $t0, 0($a0)			#La recorremos entera
	beq $t0, $zero, fCadRep	#Si es car�cter \0, la iteraci�n ha terminado
	sb $t0, 0($a2)
	addi $a0,$a0, 1
	addi $a2, $a2, 1
	j bucBRep
fCadRep:addi $t1, $t1, -1		#Siguiente iteraci�n
	beq $t1, $zero, finRep
	move $a0, $a1
	j bucBRep
finRep:	sb $zero, 0($a2)		#No es estrictamente necesario en este caso pero lo hacemos por si acaso la memoria no est� inicializada
	jr $ra
#FIN FUNCI�N REP
#COMIENZO DE LA FUNCI�N CMP: $a0 - cadena1, $a1 - cadena2. Resultado en $v0.
cmp:	lb $t0, 0($a0)			#Cargo el car�cter correspondiente de cada cadena. 
	lb $t1, 0($a1)
	beq $t0, $t1, eqCmp		#Si son iguales hay que comprobar si se ha llegado al final en ambas
	blt $t0, $t1,menCmp		#Si la primera cadena es la m�s peque�a se llama a menor. Si no lo es, entonces es mayor
	li $v0, 1
	jr $ra
eqCmp: 	addi $a0, $a0, 1		#Incremento los registros para los proximos caracteres de cada cadena. 
	addi $a1, $a1, 1
	bne $t0, $zero, cmp		#Si las cadenas enteras son iguales y est� en el terminador de cadena entonces hemos terminado. 
	move $v0, $zero	
	jr $ra			
menCmp:	li $v0, -1 
	jr $ra
#FIN DE LA FUNCI�N CMP
