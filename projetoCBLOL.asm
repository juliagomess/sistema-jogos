.data
	menu1: .asciiz "\nPara começar registre os times\n"
	menu2: .asciiz "\nBEM VINDO\n================================\nVocê deseja:\n1. Registrar resultados\n2. Editar informações dos times\nSua escolha: "
	menu3: .asciiz "\nREGISTRO DE RESULTADOS\n================================\nDigite o número do time:\n"
	menu4: .asciiz "\nEDIÇÃO DE INFORMAÇÕES\n================================\nVocê deseja alterar:\n1. Nome de time\n2. Informações de um jogo\nOBS: Para alterar vitórias/derrotas de um time, é preciso alterar informações de um jogo\nSua escolha: "
	menu5: .asciiz "\nDigite o número do(s) time(s) que deseja fazer a alteração:\n"
	msg1: .asciiz "Nome do time "
	msg2: .asciiz ": "
	msg3: .asciiz "\nVencedor: "
	msg4: .asciiz "Perdedor: "
	msg5: .asciiz "Esses times já jogaram juntos!\n"
	msg6: .asciiz "Resultado registrado com sucesso!\n"
	msg7: .asciiz "\nTime que deseja alterar: "
	msg8: .asciiz "\nNome antigo: "
	msg9: .asciiz "Novo nome: "
	msg10: .asciiz "Nome alterado com sucesso!\n"
	msg11: .asciiz "\nPara alterar um jogo digite o novo vencedor e o novo perdedor"
	msg12: .asciiz "Esse jogo ainda não aconteceu!\n"
	msg13: .asciiz "Jogo alterado com sucesso!\n"
	msg14: .asciiz "Não foi preciso fazer alterações!\n"
	prim: .asciiz "1. "
	seg: .asciiz "2. "
	resultado1: .asciiz "\nSEMIFINAIS\n================================\n"
	resultado2: .asciiz "\nREBAIXADOS\n================================\n"
	resultado3: .asciiz "\nDESCLASSIFICADOS\n================================\n"
	resultado4: .asciiz "\nQUARTAS DE FINAL\n================================\n"
	fim: .asciiz "\nFIM DO PROGRAMA"
	ponto: .asciiz ". "
	times: .space 200
	infospartidas: .space 90
	vitorias: .space 10
	derrotas: .space 10
.text
.globl main
main:
	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, menu1			# imprime o menu
	syscall

	add $t0,$t0,$zero		# zera o contador para fazer o registro dos times
	la $a2,times			# guarda o endereço do array de times
	jal RegistroTime		# faz o registro dos times

	la $a3,infospartidas		# guarda o endereço das informações das partidas atualizado
	la $s5,infospartidas		# vai guarda o final do endereço das informações 
	addi $s5,$s5,90
	Loop:
		jal Menu		# mostra as opções do menu
		bne $s5,$a3,Loop	# repete enquanto não registrar todos os jogos (serão 45 jogos no total)

	jal Semifinais 

	jal Rebaixados

	# jal Desclassificados

	# jal Quartas

	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, fim			# imprime o fim
	syscall
	
	li $v0,10			# acaba o programa
	syscall

RegistroTime:
	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, msg1			# imprime o menu
	syscall
	li $v0, 1 			# codigo syscall pra escrever inteiros
	addi $a0,$t0,1	 		# imprime o time a ser registrado
	syscall
	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, msg2			# imprime os dois pontinhos
	syscall		
	li $v0, 8			# codigo syscall pra ler strings
	move $a0,$a2			# guarda a string no endereço do array de times
	la $a1,20			# reserva 20 espaços pra cada nome de time
	syscall

	addi $a2,$a2,20			# vai pra proxima posição do array
	addi $t0,$t0,1			# incrementa o contador dos times
	bne $t0, 10, RegistroTime	# repete enquanto não registrar todos os times

	jr $ra				# retorna pra main

Menu: 
	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, menu2			# imprime o menu
	syscall
	li $v0, 5			# codigo syscall pra ler inteiros
	syscall
	add $t0,$zero,$v0		# passa a escolha pro $t0

	addi $t2,$zero,2		# pra fazer a comparação $t2=10
	slt $t1,$t2,$t0			# se $t0>2 $t1=1
	slti $t3,$t0,1			# se $t0<1 $t1=1
	or $t1,$t3,$t1			# verifica se a opção é valida
	beq $t1,1,Menu			# se não for faz o salto

	beq $t0,1,RegistroResult	# salta se escolher registrar resultado
	j Edita				# se não, edita

RegistroResult:
	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, menu3			# imprime o menu
	syscall
	
	add $s7,$ra,$zero		# guarda o endereço de retorno de menu
	jal Lista				# imprime a lista de times
	move $ra,$s7			# devolve o endereço de retorno de menu
	Vencedor:
		li $v0, 4 		# codigo syscall pra escrever strings
		la $a0, msg3		# pergunta o vencedor
		syscall
		li $v0, 5		# codigo syscall pra ler inteiros
		syscall
		add $s0,$zero,$v0	# passa o vencedor pra $s0

		addi $t2,$zero,10	# pra fazer a comparação $t2=2
		slt $t1,$t2,$s0		# se $s0>10 $t1=1
		slti $t3,$s0,1		# se $s0<1 $t1=1
		or $t1,$t3,$t1		# verifica se a opção é valida
		beq $t1,1,Vencedor	# se não for faz o salto

	Perdedor:
		li $v0, 4 		# codigo syscall pra escrever strings
		la $a0, msg4		# pergunta o perdedor
		syscall
		li $v0, 5		# codigo syscall pra ler inteiros
		syscall
		add $s1,$zero,$v0	# passa o perdedor pra $s1

		addi $t2,$zero,10	# pra fazer a comparação $t2=10
		slt $t1,$t2,$s1		# se $s1>10 $t1=1
		slti $t3,$s1,1		# se $s1<1 $t1=1
		or $t1,$t3,$t1		# verifica se a opção é valida
		beq $t1,1,Perdedor	# se não for faz o salto

	beq $s0,$s1,Vencedor		# se digitar o mesmo time pra perdedor e pra vencedor

	la $a2,infospartidas		# guarda o endereço das informacoes das partidas pra percorrer
	bne $a2,$a3,VerificaPartida	# se o endereço não for o mesmo -> tem partidas registradas

	beq $s6,1,ErroEdita		# se não foi registrado nenhum resultado, não tem jogo pra editar
	j RegPartida			# se for -> nenhuma partida foi registrada ainda

VerificaPartida:
	slt $t0,$s0,$s1			# se vencedor<perdedor $t0=1
	beq $t0,1,Continua		
	add $t1,$zero,$s1		# passa pra $t1 o perdedor
	add $t2,$zero,$s0		# passa pra $t2 o vencedor
	j Continua2
Continua:
	add $t1,$zero,$s0		# passa pra $t1 o vencedor
	add $t2,$zero,$s1		# passa pra $t2 o perdedor
Continua2:
	lb $t3,0($a2)			# guarda em $t3 o vencedor de uma partida
	addi $a2,$a2,1			# pega o perdedor da partida
	lb $t4,0($a2)			# guarda em $t4 o perdedor de uma partida
	slt $t0,$t3,$t4			# se vencedor<perdedor $t0=1
	beq $t0,1,Termina
	add $t5,$zero,$t3		# passa o vencedor pra um reg temporario
	add $t3,$zero,$t4		# passa pra $t3 o perdedor
	add $t4,$zero,$t5		# passa pra $t4 o vencedor
Termina:
	sub $t5,$t1,$t3			# subtrai os menores pra ver se são iguais
	slti $t0,$t5,0			# seta se for negativo
	sub $t6,$t2,$t4			# subtrai os maiores pra ver se são iguais
	slti $t1,$t6,0			# seta se for negativo
	or $t0,$t1,$t0			# ve se algum deles é negativo
	beq $t0,1,NaoErro		# pra não acontecer de somar numero  negativo e dar 0

	add $t7,$t5,$t6			# soma os resultados
	beq $t7,0,Erro			# se der 0 -> esses times ja jogaram juntos
	NaoErro:
		addi $a2,$a2,1			# vai pra proxima partida
		bne $a2,$a3,VerificaPartida	# salta caso tenha mais partidas pra verificar
		beq $s6,1,ErroEdita		# se percorreu tudo e não achou -> os times não jogaram juntos ainda
		j RegPartida			# registra a partida dps de percorrer todas registradas
	
Erro:
	beq $s6,1,RetornoEdita
	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, msg5			# imprime mensagem de erro
	syscall 
	jr $ra				# retorna pra main

ErroEdita:
	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, msg12			# imprime mensagem de erro
	syscall 
RetornoEdita:
	jr $ra				# retorna pra EditaJogo, com o perdedor da partida no endereço de $a2

RegPartida:
	la $s2, vitorias		# carrega o endereço de vitorias
	la $s3, derrotas		# carrega o endereço de derrotas

	sb $s0,0($a3)			# coloca o vencedor em primeiro da partida
	sub $t2,$s0,1
	add $s2,$s2,$t2			# pega a posição das vitórias do time
	lb $t1,0($s2)			# $t1 recebe a qntdade de vitórias do time

	addi $t1,$t1,1			# incrementa vitorias
	sb $t1,0($s2)			# guarda a qntadade de vitorias
	addi $a3,$a3,1			# vai pro segundo da partida

	sb $s1,0($a3)			# coloca o perdedor em segundo da partida
	sub $t2,$s1,1
	add $s3,$s3,$t2			# pega a posição das derrotas do time
	lb $t1,0($s3)			# $t1 recebe a qntdade de derrotas do time
	addi $t1,$t1,1			# incrementa derrotas
	sb $t1,0($s3)			# guarda a qntadade de derrotas
	addi $a3,$a3,1			# vai pra proxima partida

	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, msg6			# imprime mensagem de sucesso
	syscall
	jr $ra				# retornando pra onde foi chamado

Edita:
	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, menu4			# imprime o menu
	syscall
	li $v0, 5			# codigo syscall pra ler inteiros
	syscall

	addi $t2,$zero,2		# pra fazer a comparação $t2=2
	slt $t1,$t2,$v0			# se $s0>2 $t1=1
	slti $t3,$v0,1			# se $s0<1 $t1=1
	or $t1,$t3,$t1			# verifica se a opção é valida
	beq $t1,1,Edita			# se não for faz o salto

	add $s0,$zero,$v0		# passa a escolha pro $s0

	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, menu5			# imprime o menu
	syscall

	add $s7,$ra,$zero		# guarda o endereço de retorno de menu
	jal Lista				# imprime a lista de times
	move $ra,$s7			# devolve o endereço de retorno de menu

	beq $s0,2,EditaJogo		# caso escolha editar os dados de um jogo
	Time:
		li $v0, 4 		# codigo syscall pra escrever strings
		la $a0, msg7		# pergunta o time que vai ser alterado
		syscall
		li $v0, 5		# codigo syscall pra ler inteiros
		syscall

		add $s1,$zero,$v0	# passa o time pra $s1
		addi $t2,$zero,10	# pra fazer a comparação $t2=10
		slt $t1,$t2,$v0		# se $v0>10 $t1=1
		slti $t3,$v0,1		# se $v0<1 $t1=1
		or $t1,$t3,$t1		# verifica se a opção é valida
		beq $t1,1,Time		# se não for faz o salto

	j EditaNome

EditaJogo:
	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, msg11			# mostra mensagem pedindo o vencedor e o perdedor
	syscall

	addi $s6,$zero,1		# flag pra mostra que as proximas chamadas deverão retorna pra edição
	add $s7,$ra,$zero		# guarda o endereço de retorno de menu
	jal Vencedor			
	move $ra,$s7			# devolve o endereço de retorno de menu

	beq $a3,$a2,Fim			# não achou o jogo, vai pro final
	lb $t1,0($a2)			# $t1=perdedor antigo
	beq $t1,$s1,NaoEdita		# se o perdedor antigo for igual ao novo, não tem o que alterar

	la $s2, vitorias		# carrega o endereço de vitorias
	la $s3, derrotas		# carrega o endereço de derrotas
	sub $t4,$t1,1			# para usa como vetor
	add $s2,$s2,$t4			# pega a posição das vitórias do novo vencedor
	lb $t3,0($s2)			# $t3=vitorias do novo vencedor
	addi $t3,$t3,1			# acrescenta uma vitoria
	sb $t3,0($s2)			# guarda a nova contagem de vitorias
	add $s3,$s3,$t4			# pega a posição das derrotas do novo vencedor
	lb $t3,0($s3)			# $t3=derrotas do novo vencedor
	sub $t3,$t3,1			# tira uma derrota
	sb $t3,0($s3)			# guarda a nova contagem de derrotas

	sub $a2,$a2,1			# volta pra pega o vencedor antigo
	lb $t2,0($a2)			# $t2=vencedor antigo

	la $s2, vitorias		# carrega o endereço de vitorias
	la $s3, derrotas		# carrega o endereço de derrotas
	sub $t4,$t2,1
	add $s2,$s2,$t4			# pega a posição das vitórias do novo perdedor
	lb $t3,0($s2)			# $t3=vitorias do novo perdedor
	sub $t3,$t3,1			# tira uma vitoria
	sb $t3,0($s2)			# guarda a nova contagem de vitorias
	add $s3,$s3,$t4			# pega a posição das derrotas do novo perdedor
	lb $t3,0($s3)			# $t3=derrotas do novo perdedor
	addi $t3,$t3,1			# acrescenta uma derrota
	sb $t3,0($s3)			# guarda a nova contagem de derrotas

	sb $t1,0($a2)			# guarda o perdedor em primeiro, se tornando o vencedor
	addi $a2,$a2,1			# vai pra segunda posição da partida pra guarda o novo perdedor
	sb $t2,0($a2)			# guarda o perdedor em primeiro, se tornando o vencedor

	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, msg13			# mostra mensagem de sucesso
	syscall
	j Fim

	NaoEdita:
		li $v0, 4 		# codigo syscall pra escrever strings
		la $a0, msg14		# mostra mensagem de não edição
		syscall
	Fim:
		add $s6,$zero,$zero	# retorna a flag ao seu estado natural
		jr $ra			# retorna pra main

EditaNome:
	la $a2,times			# carrega o endereço do vetor de times
	sub $t1,$s1,1			
	mul $t2,$t1,20			
	add $a2,$a2,$t2			# acha a posição do nome do time

	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, msg8			# mostra o nome antigo
	syscall
	li $v0, 4 			# codigo syscall pra escrever strings
	move $a0,$a2			# escreve o nome do time
	syscall
	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, msg9			# pergunta o novo nome
	syscall
	li $v0, 8			# codigo syscall pra ler strings
	move $a0,$a2			# guarda a string no endereço do array de times
	la $a1,20			# reserva 20 espaços pra cada nome de time
	syscall
	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, msg10			# mostra o nome antigo
	syscall

	jr $ra				# retorna pra main

Lista:
	add $t0,$zero,$zero		# zera o contador
	la $a2, times			# guarda o endereço do array de times
ListaDnv:
	li $v0, 1 			# codigo syscall pra escrever inteiros
	addi $a0,$t0,1	 		# imprime o numero do time
	syscall
	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, ponto			# imprime espaço
	syscall
	li $v0, 4 			# codigo syscall pra escrever strings
	move $a0,$a2			# escreve o nome do time
	syscall
	
	addi $a2,$a2,20			# vai pro proximo time
	addi $t0,$t0,1			# inrementa o contador
	bne $t0, 10, ListaDnv		# repete enquanto não imprimir todos os times

	jr $ra				# retorna pra quem chamou

Semifinais:
	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, resultado1		# imprime mensagem de semifinais
	syscall

	Repete:
	add $t2,$zero,$zero		# zera o contador do loop de fora
	Procura1:
		la $s2,vitorias			# carrega o endereço de vitorias
		add $t0,$zero,$zero		# zera o contador do loop de dentro
		beq $s6,1,Max
		add $t1,$zero,$zero		# zera o contador maior
		j Comeca
		Max:
			addi $t1,$zero,9	# maximiza o contador menor
		Comeca:
		add $s4,$zero,$zero		# vai guarda a equipe com maior/menor numero de vitorias
		Procura2:
			beq $t2,0,Prim1		# se for o primeiro laço não precisa comparar
			beq $s4,$s0,Falso2	# se for a mesma equipe do primeiro laço
			Prim1:
				lb $t3,0($s2)		# $t3 recebe o numero de vitórias 
				beq $s6,1,Menor		# flag pra ver se quer achar o menor ou maior
				slt $t4,$t1,$t3		# $t4=1 se maior<elemento
				j Maior
				Menor:
					slt $t4,$t3,$t1		# $t4=1 se elemento<menor
				Maior:
				beq $t4,0,Falso2		# se for falso, continua
				add $t1,$zero,$t3		# se for verdade, maior/menor=elemento
				beq $t2,0,Prim2			# se for o primeiro laço vai guarda em $s0
				add $s1,$zero,$s4		# guarda a segunda equipe com maior/menor numero de vitorias
				j Falso2
				Prim2:
					add $s0,$zero,$s4	# guarda a equipe com maior/menor numero de vitorias
				Falso2:
					addi $s2,$s2,1		# vitorias da prox equipe
					addi $t0,$t0,1		# incrementa o contador do laco de dentro
					addi $s4,$s4,1		# incrementa o contador pra acha a equipe
		bne $t0,10,Procura2
		addi $t2,$t2,1					# incrementa o contador de fora
	bne $t2,2,Procura1

	
	la $a2, times			# guarda o endereço do array de times
	mul $t1,$s0,20			# pega o endereço do nome do time
	add $a2,$a2,$t1			# pega o time com maior numero de vitorias

	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, prim			# imprime 1.
	syscall
	li $v0, 4 			# codigo syscall pra escrever strings
	move $a0,$a2			# escreve o nome do time
	syscall

	la $a2, times			# guarda o endereço do array de times
	mul $t1,$s1,20			# pega o endereço do nome do time
	add $a2,$a2,$t1			# pega o segundo time com maior numero de vitorias

	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, seg			# imprime 2.
	syscall
	li $v0, 4 			# codigo syscall pra escrever strings
	move $a0,$a2			# escreve o nome do time
	syscall

	jr $ra				# retorna pra main

Rebaixados:
	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, resultado2		# imprime mensagem de rebaixados
	syscall

	addi $s6,$zero,1		# flag pra achar o menor

	add $s7,$ra,$zero		# guarda o endereço de retorno de menu
	jal Repete
	move $ra,$s7			# devolve o endereço de retorno de menu

	add $s6,$zero,$zero		# volta do estado natural da flag

	jr $ra				# retorna pra main

Desclassificados:
	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, resultado3		# imprime mensagem de desclassificados
	syscall

	jr $ra				# retorna pra main

Quartas:
	li $v0, 4 			# codigo syscall pra escrever strings
	la $a0, resultado4		# imprime mensagem de quartas de final
	syscall

	jr $ra				# retorna pra main