#	$1 	:= at
#	$2 	:= v0
#	$3 	:= Cor branca
#	$4 	:= a0
#	$5 	:= Auxiliar de mapeamento
#	$6 	:= S2 J1
#	$7 	:= Altura dos jogadores
#	$8 	:= Largura dos jogadores
#	$9 	:= S2 J2
#	$10 	:= S2 atual da bola
#	$11	:= Altura e largura da bola
#	$12	:= Numero de pixels da tela
#	$13	:= S2 anterior da bola
#	$14	:= Limite superior
#	$15	:= Dificuldade
#	$16	:= Cor preta
#	$17	:= variável
#	$22	:= Cor atual
#	$26	:= Placar J1
#	$27	:= Placar J2
#
#	Demais: variáveis
#
############################################################################################################################

.text

main:	
	jal 	dificuldade
	jal 	defJog1
	jal 	defJog2
	jal 	defBola	
	jal 	cores
	jal 	fundo	
	jal 	jogador1
	jal 	jogador2
	jal 	bola
movimentos:
	addi	$22, $zero, 0xFFFFFE
	jal	placar
	jal 	moveJog1
	jal 	moveJog2
	jal 	moveBola
	li 	$v0, 32
	li 	$a0, 50
	syscall
	j	movimentos
	
dificuldade:
	li	$15, 10
	jr	$ra
	
cores:		
	li	$16, 0x000000 		#Preto
	li	$3, 0xFFFFFF 		#Branco
	addi	$22, $3, 0		#Seta cor em uso: Branco
	jr 	$ra
	
fundo:		
	li 	$12, 8192		#Número de pixels da tela
	addi 	$5, $12, 0		#Mapeamento
	lui	$5, 0x1001 		#Início
	li	$14, 3072		#Limite superior
	jr 	$ra
	
defJog1:
	li 	$6, 10292 		#Coração jogador 1
	li 	$7, 16			#Altura jogadores
	li 	$8, 3			#Largura jogadores
	jr 	$ra
	
defJog2:
	li 	$9, 10688 		#Coração jogador 2
	jr	$ra
	
defBola:
	li 	$10, 15608		#Coração atual bola
	li	$13, 14076		#Coração anterior bola
	li	$11, 3			#Altura e largura da bola
	jr	$ra
	
jogador1:
	addi	$23, $ra, 0
	jal	fundo			#Reseta posição inicial
	addi	$ra, $23, 0
	add	$5, $5, $6		#Posiciona o S2 do jogador 1
	sw	$22, ($5)		#Pinta a posição do S2 do jogador 1
	addi	$25, $8, 0		#Seta o temp 25 para largura do jogador
	addi	$24, $7, 0		#Seta o temp 24 para altura do jogador
	bne	$25, $0, pntJ1x		#Constrói o jogador 1  para a direita
contJ1:
	addi	$24, $24, -1		#Decresce contador de altura
	bne	$24, $0, pntJ1y		#Constrói o jogador 1 para baixo
	jr 	$ra
	
jogador2:
	addi	$23, $ra, 0
	jal	fundo			#Reseta posição inicial
	addi	$ra, $23, 0	
	add	$5, $5, $9		#Posiciona o S2 do jogador 2
	sw	$22, ($5)		#Pinta a posição do S2 do jogador 2
	addi	$25, $8, 0		#Seta o temp 25 para largura do jogador
	addi	$24, $7, 0		#Seta o temp 24 para altura do jogador
	bne	$25, $0, pntJ2x		#Constrói o jogador 2  para a direita
contJ2:
	addi	$24, $24, -1		#Decresce contador de altura
	bne	$24, $0, pntJ2y		#Constrói o jogador 2 para baixo
	jr 	$ra

bola:
	addi	$23, $ra, 0
	jal 	fundo			#Reseta posição inicial
	addi	$ra, $23, 0	
	add	$5, $5, $10		#Posiciona o S2 da bola
	sw	$22, ($5)		#Pinta a posição do S2 do jogador 2
	addi	$25, $11, -1		#Seta o temp 25 para largura da bola
	addi	$24, $11, 0		#Seta o temp 24 para altura da bola
	bne	$25, $0, pntBolax	#Constrói a bola para a direita
contBola:
	addi	$24, $24, -1		#Decresce contador de altura
	bne	$24, $0, pntBolay	#Constrói a bola para baixo
	jr 	$ra

pntJ1x:
	beqz 	$25, contJ1		#Se terminou essa linha, vai pra linha de baixo
	addi 	$5, $5, 4		#Acertao pixel que vai pintar para o próximo
	sw 	$22, ($5)		#Pinta o próximo pixel
	addi	$25, $25, -1		#Decresce o contador de largura
	j 	pntJ1x			#Loop
	
pntJ1y:	
	mul	$25, $8, -4
	addi	$25, $25, 512
	add 	$5, $5, $25		#Pula uma linha
	sw 	$22, ($5)		
	addi	$25, $8, 0		
	bne 	$25, $0, pntJ1x		
	
pntJ2x:
	beqz 	$25, contJ2		#Se terminou essa linha, vai pra linha de baixo
	addi 	$5, $5, 4		#Acertao pixel que vai pintar para o próximo
	sw 	$22, ($5)		#Pinta o próximo pixel
	addi	$25, $25, -1		#Decresce o contador de largura
	j 	pntJ2x			#Loop
	
pntJ2y:
	mul	$25, $8, -4
	addi	$25, $25, 512
	add 	$5, $5, $25
	sw 	$22, ($5)	
	addi	$25, $8, 0	
	bne 	$25, $0, pntJ2x
	
pntBolax:
	beqz 	$25, contBola
	addi 	$5, $5, 4
	sw 	$22, ($5)
	addi	$25, $25, -1
	j 	pntBolax
	
pntBolay:
	mul	$25, $11, -4
	addi	$25, $25, 516
	add 	$5, $5, $25
	sw 	$22, ($5)	
	addi	$25, $11, -1
	bne 	$25, $0, pntBolax
	
moveJog1:
	addi	$21, $ra, 0
	addi 	$22, $16, 0
	jal 	jogador1
	jal	moveS2J1
	sw	$zero, 68719411204($zero)
	addi	$22, $3, 0
	jal	jogador1
	addi	$ra, $21, 0
	jr 	$ra

moveJog2:
	addi	$21, $ra, 0
	addi 	$22, $16, 0	
	jal 	jogador2
	jal	moveS2J2
	addi	$22, $3, 0	
	jal	jogador2
	addi	$ra, $21, 0
	jr 	$ra
	
moveBola:
	addi	$21, $ra, 0
	addi 	$22, $16, 0
	jal	bola	
	jal	moveS2Bola
	addi	$22, $3, 0	
	jal	bola
	addi	$ra, $21, 0
	jr 	$ra
	
moveS2J1:
	lw	$17, 68719411204($zero)
	beq	$17, 119, subindoJ1
	beq	$17, 115, descendoJ1
	jr	$ra
	
subindoJ1:
	addi	$6, $6, -2048
	jr	$ra
	
descendoJ1:
	addi	$6, $6, 2048
	jr	$ra
	
moveS2J2:
	addi	$23, $ra, 0
	li	$25, 0
	addi	$19, $9, 0
	div	$24, $7, $15
	mul	$24, $24, 512
	add	$19, $19, $24
	li	$24, 0	
	addi	$20, $10, 0
	jal	distJxTeto
	jal	distBolaTeto
	addi	$ra, $23, 0	
	blt	$25, $24, subindoJ2
	blt	$24, $25, descendoJ2
	jr	$ra
	
distJxTeto:
	blt	$19, $14, return
	addi	$19, $19, -512
	addi	$24, $24, 1
	j	distJxTeto
	
distBolaTeto:
	blt	$20, $14, return
	addi	$20, $20, -512
	addi	$25, $25, 1
	j	distBolaTeto	
	
subindoJ2:
	sub	$25, $24, $25
	bgt	$25, $15, finalizaSubidaJ2
	jr	$ra
	
finalizaSubidaJ2:
	addi	$9, $9, -1024
	jr	$ra
	
descendoJ2:
	sub	$25, $25, $24
	bgt	$25, $15, finalizaDescidaJ2
	jr	$ra
	
finalizaDescidaJ2:
	addi	$9, $9, 1024
	jr	$ra
	
moveS2Bola:
	addi	$23, $ra, 0
	li	$25, 0
	li	$24, 0
	addi	$20, $10, 0	
	addi	$19, $13, 0
	addi	$19, $24, 0
	addi	$20, $25, 0
	li	$25, 0
	addi	$24, $10, 0	
	bgt	$10, $13, descendo
	blt	$10, $13, subindo
	
descendo:
	addi	$25, $25, 1
	addi	$24, $24, -508
	beq 	$24, $13, proxPosDE
	addi	$24, $24, -8
	beq	$24, $13, proxPosDD
	addi	$24, $24, 4
	j	descendo
	
subindo:
	addi	$25, $25, 1
	addi	$24, $24, 516
	beq 	$24, $13, proxPosSE
	addi	$24, $24, -8
	beq	$24, $13, proxPosSD
	addi	$24, $24, 4	
	j	subindo	
	
proxPosDE:
	mul	$24, $25, 512
	add	$24, $24, $10
	addi	$24, $24, -4
	bgt	$24, 32252, quicarDE
	
	addi	$20, $24, 0
	jal	fundo
	jal	verifGolxDefesaJ1DE
	addi	$ra, $23, 0
	
	addi	$13, $10, 0
	addi	$10, $24, 0
	jr	$ra
	
quicarDE:
	mul	$25, $25, -512
	addi	$13, $24, 4
	add	$10, $24, $25
	jr	$ra
	
verifGolxDefesaJ1DE:
	#add	$20, $20, 8
	addi	$19, $ra, 0
	addi	$18, $20, 0
	jal	distGolJx
	addi	$ra, $19, 0
	beq	$18, 60, golJ2emJ1
	addi	$18, $19, 0
	add	$5, $5, $20
	lw	$22, ($5)
	beq	$22, $3, defesaDE
	addi	$5, $5, 512
	lw	$22, ($5)
	beq	$22, $3, defesaDE
	addi	$5, $5, 512
	lw	$22, ($5)
	beq	$22, $3, defesaDE
	jr 	$ra
	
proxPosDD:
	mul	$24, $25, 512
	add	$24, $24, $10
	addi	$24, $24, 4
	bgt	$24, 32252, quicarDD
	addi	$20, $24, 0
	jal	fundo
	jal	verifGolxDefesaJ2DD
	addi	$ra, $23, 0
	addi	$13, $10, 0
	addi	$10, $24, 0
	jr	$ra
	
quicarDD:
	mul	$25, $25, -512
	addi	$13, $24, -4
	add	$10, $24, $25
	jr	$ra
	
verifGolxDefesaJ2DD:
	add	$20, $20, 8
	addi	$19, $ra, 0
	addi	$18, $20, 0
	jal	distGolJx
	addi	$ra, $19, 0
	beq	$18, 452, golJ1emJ2
	addi	$18, $19, 0
	add	$5, $5, $20
	lw	$22, ($5)
	beq	$22, $3, defesaDD
	addi	$5, $5, 512
	lw	$22, ($5)
	beq	$22, $3, defesaDD
	addi	$5, $5, 512
	lw	$22, ($5)
	beq	$22, $3, defesaDD
	jr 	$ra
	
proxPosSE:
	mul	$24, $25, -512
	add	$24, $24, $10
	addi	$24, $24, -4
	blt	$24, $14, quicarSE
	
	addi	$20, $24, 0
	jal	fundo
	jal	verifGolxDefesaJ1SE
	addi	$ra, $23, 0
	
	addi	$13, $10, 0
	addi	$10, $24, 0
	jr	$ra
	
quicarSE:
	mul	$25, $25, 512
	addi	$13, $24, 4
	add	$10, $24, $25
	jr	$ra
	
verifGolxDefesaJ1SE:
	#add	$20, $20, 8
	addi	$19, $ra, 0
	addi	$18, $20, 0
	jal	distGolJx
	addi	$ra, $19, 0
	beq	$18, 60, golJ2emJ1
	addi	$18, $19, 0
	add	$5, $5, $20
	lw	$22, ($5)
	beq	$22, $3, defesaSE
	addi	$5, $5, 512
	lw	$22, ($5)
	beq	$22, $3, defesaSE
	addi	$5, $5, 512
	lw	$22, ($5)
	beq	$22, $3, defesaSE
	jr 	$ra

proxPosSD:
	mul	$24, $25, -512
	add	$24, $24, $10
	addi	$24, $24, 4
	blt	$24, $14, quicarSD

	addi	$20, $24, 0
	jal	fundo
	jal	verifGolxDefesaJ2SD
	addi	$ra, $23, 0
	
	addi	$13, $10, 0
	addi	$10, $24, 0
	jr	$ra
	
quicarSD:
	mul	$25, $25, 512
	addi	$13, $24, -4
	add	$10, $24, $25
	jr	$ra
	
verifGolxDefesaJ2SD:
	add	$20, $20, 8
	addi	$19, $ra, 0
	addi	$18, $20, 0
	jal	distGolJx
	addi	$ra, $19, 0
	beq	$18, 452, golJ1emJ2
	addi	$18, $19, 0
	add	$5, $5, $20
	lw	$22, ($5)
	beq	$22, $3, defesaSD
	addi	$5, $5, 512
	lw	$22, ($5)
	beq	$22, $3, defesaSD
	addi	$5, $5, 512
	lw	$22, ($5)
	beq	$22, $3, defesaSD
	jr 	$ra
	
defesaDD:
	li	$25, 0
	addi	$19, $9, 0
	div	$24, $7, 2
	mul	$24, $24, 512
	add	$19, $19, $24
	li	$24, 0	
	addi	$20, $10, 0
	jal	distJxTeto
	jal	distBolaTeto
	addi	$ra, $18, 0
	sub	$25, $24, $25
	div	$24, $7, 3
	bge	$25, $24, defesaDD1
	mul	$24, $24, -1
	ble	$25, $24, defesaDD1
	div	$24, $24, -2
	bge	$25, $24, defesaDD2
	mul	$24, $24, -1
	ble	$25, $24, defesaDD2
	j	defesaDD3
	
defesaDD1:
	addi	$24, $10, 0
	addi	$10, $10, -1532
	jr	$ra
	
defesaDD2:
	addi	$24, $10, 0
	addi	$10, $10, -1020
	jr	$ra
	
defesaDD3:
	addi	$24, $10, 0
	addi	$10, $10, -508
	jr	$ra
	
defesaSD:
	li	$25, 0
	addi	$19, $9, 0
	div	$24, $7, 2
	mul	$24, $24, 512
	add	$19, $19, $24
	li	$24, 0	
	addi	$20, $10, 0
	jal	distJxTeto
	jal	distBolaTeto
	addi	$ra, $18, 0
	sub	$25, $24, $25
	div	$24, $7, 3
	bge	$25, $24, defesaSD1
	mul	$24, $24, -1
	ble	$25, $24, defesaSD1
	div	$24, $24, -2
	bge	$25, $24, defesaSD2
	mul	$24, $24, -1
	ble	$25, $24, defesaSD2
	j	defesaSD3
	
defesaSD1:
	addi	$24, $10, 0
	addi	$10, $10, 1540
	jr	$ra
	
defesaSD2:
	addi	$24, $10, 0
	addi	$10, $10, 1028
	jr	$ra
	
defesaSD3:
	addi	$24, $10, 0
	addi	$10, $10, 516
	jr	$ra
	
defesaSE:
	li	$25, 0
	addi	$19, $6, 0
	div	$24, $7, 2
	mul	$24, $24, 512
	add	$19, $19, $24
	li	$24, 0	
	addi	$20, $10, 0
	jal	distJxTeto
	jal	distBolaTeto
	addi	$ra, $18, 0
	sub	$25, $24, $25
	div	$24, $7, 3
	bge	$25, $24, defesaSE1
	mul	$24, $24, -1
	ble	$25, $24, defesaSE1
	div	$24, $24, -2
	bge	$25, $24, defesaSE2
	mul	$24, $24, -1
	ble	$25, $24, defesaSE2
	j	defesaSE3
	
defesaSE1:
	addi	$24, $10, 0
	addi	$10, $10, 1532
	jr	$ra
	
defesaSE2:
	addi	$24, $10, 0
	addi	$10, $10, 1020
	jr	$ra
	
defesaSE3:
	addi	$24, $10, 0
	addi	$10, $10, 508
	jr	$ra
	
defesaDE:
	li	$25, 0
	addi	$19, $6, 0
	div	$24, $7, 2
	mul	$24, $24, 512
	add	$19, $19, $24
	li	$24, 0	
	addi	$20, $10, 0
	jal	distJxTeto
	jal	distBolaTeto
	addi	$ra, $18, 0
	sub	$25, $24, $25
	div	$24, $7, 3
	bge	$25, $24, defesaDE1
	mul	$24, $24, -1
	ble	$25, $24, defesaDE1
	div	$24, $24, -2
	bge	$25, $24, defesaDE2
	mul	$24, $24, -1
	ble	$25, $24, defesaDE2
	j	defesaDE3
	
defesaDE1:
	addi	$24, $10, 0
	addi	$10, $10, -1540
	jr	$ra
	
defesaDE2:
	addi	$24, $10, 0
	addi	$10, $10, -1028
	jr	$ra
	
defesaDE3:
	addi	$24, $10, 0
	addi	$10, $10, -516
	jr	$ra
	
distGolJx:
	blt	$18, 512, return
	addi	$18, $18, -512
	j	distGolJx
	
golJ1emJ2:
	jal	reset
	jal	placarSobeJ1
	j	movimentos
	
golJ2emJ1:
	jal	reset
	jal	placarSobeJ2
	j	movimentos
	
reset:
	addi	$20, $ra, 0
	addi	$22, $16, 0
	jal	jogador1
	jal	bola
	jal	jogador2
	jal 	defJog1
	jal	defJog2
	jal 	defBola
	addi	$22, $3, 0
	jal	jogador1
	jal	bola
	jal	jogador2
	addi	$ra, $20, 0
	jr	$ra

placarSobeJ1:
	addi	$20, $ra, 0
	addi	$22, $16, 0
	jal 	placar
	addi	$26, $26, 1
	beq	$26, 4, jog1Win
	addi	$22, $zero, 0xFFFFFE
	jal 	placar
	addi	$ra, $20, 0
	jr	$ra
	
placarSobeJ2:
	addi	$20, $ra, 0
	addi	$22, $16, 0
	jal 	placar
	addi	$27, $27, 1
	beq	$27, 4, jog2Win
	addi	$22, $zero, 0xFFFFFE
	jal 	placar
	addi	$ra, $20, 0
	jr	$ra
	
placar:
	beq	$26, 0, jog10
	beq	$26, 1, jog11
	beq	$26, 2, jog12
	beq	$26, 3, jog13
contPlacar:
	addi 	$5, $12, 0		#Mapeamento
	lui	$5, 0x1001 		#Início
	addi	$5, $5, 760
	sw	$22, ($5)
	addi	$5, $5, 1024
	sw	$22, ($5)
	li	$17, 3072
	addi 	$5, $12, 0		#Mapeamento
	lui	$5, 0x1001 		#Início
	addi	$5, $5, 3072
	sw	$22, ($5)
	
linha:
	beq	$17, 3580, contPlacar2
	addi	$17, $17, 4
	addi	$5, $5, 4
	sw	$22, ($5)
	j	linha
	
contPlacar2:
	beq	$27, 0, jog20
	beq	$27, 1, jog21
	beq	$27, 2, jog22
	beq	$27, 3, jog23
	#beq	$27, 4, jog2Win
	
jog10:
	addi 	$5, $12, 0		#Mapeamento
	lui	$5, 0x1001 		#Início
	addi	$5, $5, 232
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	
	addi	$5, $5, 504
	sw	$22, ($5)
	addi	$5, $5, 8
	sw	$22, ($5)
	
	addi	$5, $5, 504
	sw	$22, ($5)
	addi	$5, $5, 8
	sw	$22, ($5)
	
	addi	$5, $5, 504
	sw	$22, ($5)
	addi	$5, $5, 8
	sw	$22, ($5)
	
	addi	$5, $5, 504
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4	
	sw	$22, ($5)
	j	contPlacar
	
jog11:
	addi 	$5, $12, 0		#Mapeamento
	lui	$5, 0x1001 		#Início
	addi	$5, $5, 240
	sw	$22, ($5)
	
	addi	$5, $5, 512
	sw	$22, ($5)
	
	addi	$5, $5, 512
	sw	$22, ($5)
	
	addi	$5, $5, 512
	sw	$22, ($5)
	
	addi	$5, $5, 512	
	sw	$22, ($5)
	j	contPlacar
	
jog12:
	addi 	$5, $12, 0		#Mapeamento
	lui	$5, 0x1001 		#Início
	addi	$5, $5, 232
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	
	addi	$5, $5, 512
	sw	$22, ($5)
	
	addi	$5, $5, 504
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	
	addi	$5, $5, 504
	sw	$22, ($5)
	
	addi	$5, $5, 512
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4	
	sw	$22, ($5)
	j	contPlacar
	
jog13:
	addi 	$5, $12, 0		#Mapeamento
	lui	$5, 0x1001 		#Início
	addi	$5, $5, 232
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	
	addi	$5, $5, 512
	sw	$22, ($5)
	
	addi	$5, $5, 504
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	
	addi	$5, $5, 512
	sw	$22, ($5)
	
	addi	$5, $5, 504
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4	
	sw	$22, ($5)
	j	contPlacar
	
jog20:
	addi 	$5, $12, 0		#Mapeamento
	lui	$5, 0x1001 		#Início
	addi	$5, $5, 256
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	
	addi	$5, $5, 504
	sw	$22, ($5)
	addi	$5, $5, 8
	sw	$22, ($5)
	
	addi	$5, $5, 504
	sw	$22, ($5)
	addi	$5, $5, 8
	sw	$22, ($5)
	
	addi	$5, $5, 504
	sw	$22, ($5)
	addi	$5, $5, 8
	sw	$22, ($5)
	
	addi	$5, $5, 504
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4	
	sw	$22, ($5)
	jr	$ra
	
jog21:
	addi 	$5, $12, 0		#Mapeamento
	lui	$5, 0x1001 		#Início
	addi	$5, $5, 264
	sw	$22, ($5)
	
	addi	$5, $5, 512
	sw	$22, ($5)
	
	addi	$5, $5, 512
	sw	$22, ($5)
	
	addi	$5, $5, 512
	sw	$22, ($5)
	
	addi	$5, $5, 512	
	sw	$22, ($5)
	jr	$ra
	
jog22:
	addi 	$5, $12, 0		#Mapeamento
	lui	$5, 0x1001 		#Início
	addi	$5, $5, 256
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	
	addi	$5, $5, 512
	sw	$22, ($5)
	
	addi	$5, $5, 504
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	
	addi	$5, $5, 504
	sw	$22, ($5)
	
	addi	$5, $5, 512
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4	
	sw	$22, ($5)
	jr	$ra
	
jog23:
	addi 	$5, $12, 0		#Mapeamento
	lui	$5, 0x1001 		#Início
	addi	$5, $5, 256
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	
	addi	$5, $5, 512
	sw	$22, ($5)
	
	addi	$5, $5, 504
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	
	addi	$5, $5, 512
	sw	$22, ($5)
	
	addi	$5, $5, 504
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4	
	sw	$22, ($5)
	jr	$ra
	
jog1Win:
	addi	$20, $ra, 0
	addi	$22, $16, 0
	jal	jogador1
	jal	bola
	jal	jogador2
	#jal	placar
	addi	$22, $3, 0
	jal 	P
	jal	I
	jal	win
	j	fim
	
jog2Win:
	addi	$20, $ra, 0
	addi	$22, $16, 0
	jal	jogador1
	jal	bola
	jal	jogador2
	#jal	placar
	addi	$22, $3, 0
	jal 	P
	jal	II
	jal	win
fim:	
	j	fim
	
P:
	addi	$23, $ra, 0
	jal 	fundo
	addi	$ra, $23, 0
	addi	$5, $5, 7312
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 492
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 484
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 20
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 484
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 20
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 484
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 20
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 484
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 484
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 492
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	jr	$ra
	
I:
	addi	$23, $ra, 0
	jal	fundo			
	addi	$ra, $23, 0
	addi	$5, $5, 7356		
	sw	$22, ($5)		
	addi	$25, $zero, 1		
	addi	$24, $zero, 14		
	bne	$25, $0, pnt1x		
cont1:
	addi	$24, $24, -1		
	bne	$24, $0, pnt1y		
	jr 	$ra
	
pnt1x:
	beqz 	$25, cont1		
	addi 	$5, $5, 4		
	sw 	$22, ($5)		
	addi	$25, $25, -1		
	j 	pnt1x			
	
pnt1y:	
	addi	$25, $zero, -4
	addi	$25, $25, 512
	add 	$5, $5, $25		
	sw 	$22, ($5)		
	addi	$25, $zero, 1		
	bne 	$25, $0, pnt1x	
	
II:
	addi	$23, $ra, 0
	jal	fundo			
	addi	$ra, $23, 0
	addi	$5, $5, 7356		
	sw	$22, ($5)	
	addi	$5, $5, 4
	sw	$22, ($5)		
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 500
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 512
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 496
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 500
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 496
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 512
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 500
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	
win:
	addi	$23, $ra, 0
	jal	fundo			
	addi	$ra, $23, 0
	addi	$5, $5, 7392		
	sw	$22, ($5)	
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 512
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 512
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 512
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 500
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 500
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 504
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -2044
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -516
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -516
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -512
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -524
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -524
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -520
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 2052
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 512
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 500
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 500
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 504
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -2044
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -516
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -516
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -512
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -516
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -516
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -512
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -516
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -516
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, -516
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)

	addi	$23, $ra, 0
	jal	fundo			
	addi	$ra, $23, 0
	addi	$5, $5, 7476		
	sw	$22, ($5)		
	addi	$25, $zero, 1		
	addi	$24, $zero, 14		
	bne	$25, $0, pntWin1x		
contWin1:
	addi	$24, $24, -1		
	bne	$24, $0, pntWin1y		
	j 	contWin2
	
pntWin1x:
	beqz 	$25, contWin1		
	addi 	$5, $5, 4		
	sw 	$22, ($5)		
	addi	$25, $25, -1		
	j 	pntWin1x			
	
pntWin1y:	
	addi	$25, $zero, -4
	addi	$25, $25, 512
	add 	$5, $5, $25		
	sw 	$22, ($5)		
	addi	$25, $zero, 1		
	bne 	$25, $0, pntWin1x
	
contWin2:
	addi	$23, $ra, 0
	jal	fundo			
	addi	$ra, $23, 0
	addi	$5, $5, 7496		
	sw	$22, ($5)		
	addi	$25, $zero, 1		
	addi	$24, $zero, 14		
	bne	$25, $0, pntWin2x		
contWin22:
	addi	$24, $24, -1		
	bne	$24, $0, pntWin2y		
	j	contWin3
	
pntWin2x:
	beqz 	$25, contWin22		
	addi 	$5, $5, 4		
	sw 	$22, ($5)		
	addi	$25, $25, -1		
	j 	pntWin2x			
	
pntWin2y:	
	addi	$25, $zero, -4
	addi	$25, $25, 512
	add 	$5, $5, $25		
	sw 	$22, ($5)		
	addi	$25, $zero, 1		
	bne 	$25, $0, pntWin2x	
	
contWin3:
	addi	$23, $ra, 0
	jal	fundo			
	addi	$ra, $23, 0
	addi	$5, $5, 7504
	sw 	$22, ($5)
	addi	$5, $5, 512
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 512
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 512
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 512
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 508
	sw	$22, ($5)
	addi	$5, $5, 4
	sw	$22, ($5)
	addi	$5, $5, 512
	sw	$22, ($5)
	addi	$5, $5, 4
	addi	$23, $ra, 0
	jal	fundo			
	addi	$ra, $23, 0
	addi	$5, $5, 7524		
	sw	$22, ($5)		
	addi	$25, $zero, 1		
	addi	$24, $zero, 14		
	bne	$25, $0, pntWin4x		
contWin4:
	addi	$24, $24, -1		
	bne	$24, $0, pntWin4y		
	jr	$ra
	
pntWin4x:
	beqz 	$25, contWin4		
	addi 	$5, $5, 4
	li	$22, 0xFFFFFE		
	sw 	$22, ($5)		
	addi	$25, $25, -1		
	j 	pntWin4x			
	
pntWin4y:	
	addi	$25, $zero, -4
	addi	$25, $25, 512
	add 	$5, $5, $25		
	sw 	$22, ($5)		
	addi	$25, $zero, 1			
	bne 	$25, $0, pntWin4x
	
return:
	jr	$ra
