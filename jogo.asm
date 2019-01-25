	; Biblioteca Irvine

	INCLUDE Irvine32.inc
	INCLUDE win32.inc

	desenhaespaco proto, posicao:byte


	.data


	ti 	BYTE " ------------------------------------------------------ ", 0; 57 caracteres
		BYTE "|    /0000000                  /00  /000000   /000000  |", 0; tela inicial
		BYTE "|    00__  00                | 00 /00__  00 /00__  00  |", 0
		BYTE "|    00  \ 00  /000000   /0000000| 00  \__/| 00  \__/  |", 0
		BYTE "|    00  | 00 /00__  00 /00__  00| 00 /0000| 00 /0000  |", 0
		BYTE "|    00  | 00| 00  \ 00| 00  | 00| 00|_  00| 00|_  00  |", 0
		BYTE "|    00  | 00| 00  | 00| 00  | 00| 00  \ 00| 00  \ 00  |", 0
		BYTE "|    0000000/|  000000/|  0000000|  000000/|  000000/  |", 0
		BYTE "|   _______/  \______/  \_______/ \______/  \______/   |", 0
		BYTE "|                                                      |", 0
		BYTE "|      Digite uma tecla para a dificuldade:            |", 0
		BYTE "|   1- Easy 2 - Medium 3 - Hard ou 4 - Instrucoes      |", 0
		BYTE " ------------------------------------------------------ ", 0; 13 linhas
		
ajuda 	BYTE " ------------------------------------------------------ ", 0; 57 caracteres
		BYTE "|                                                      |", 0; tela inicial
		BYTE "|                     INSTRUCOES:                      |", 0
		BYTE "|    SELECIONE A DIFICULDADE USANDO UM DOS NUMEROS:    |", 0
		BYTE "|               1      2     OU    3                   |", 0
		BYTE "|    1 - FACIL/VELOCIDADE BAIXA                        |", 0
		BYTE "|    2 - MEDIO/VELOCIDADE MEDIA                        |", 0
		BYTE "|    3 - DIFICIL/VELOCIDADE ALTA                       |", 0
		BYTE "|        UTILIZE AS TECLAS 'A' E 'D' PARA              |", 0
		BYTE "|            MOVIMENTAR O PERSONAGEM                   |", 0
		BYTE "|                     BOM JOGO!                        |", 0
		BYTE "|         PRESSIONE 1 PARA VOLTAR A TELA INICIAL       |", 0
		BYTE " ------------------------------------------------------ ", 0; 13 linhas

	personagem 	byte "_\|/^", 0; 6 caracteres
				byte " (_oo", 0; personagem do jogo
				byte "  |  ", 0
				byte " /|\ ", 0
				byte "  |  ", 0
				byte "  LL ", 0; linhas = 6

	bomba  	byte "     ,--.!,", 0; 12 caracteres
			byte "  __/   -*-", 0; bomba do jogo
			byte ",d08b.  '|`", 0
			byte "0088MM     ", 0
			byte "`9MMP'     ", 0; linha = 5

	explosao 	byte "           _.-^^---....,,--      ", 0; 34 caracteres
				byte "       _--                  --_  ", 0; explosão quando a bomba atinge o personagem
				byte "      <                        >)", 0
				byte "      |                         |", 0
				byte "       \._                   _./ ", 0
				byte "          ```--. . , ; .--'''    ", 0
				byte "                | |   |          ", 0
				byte "             .-=||  | |=-.       ", 0
				byte "             `-=#$%&%$#=-'       ", 0
				byte "                | ;  :|          ", 0
				byte "       _____.,-#%&$@%#&#~,._____ ", 0


	gameover 	byte  "      _____          __  __ ______    ______      ________ _____  _       ", 0; 75caracteres
				byte  "     / ____|   /\   |  \/  |  ____|  / __ \ \    / /  ____|  __ \| |      ", 0; tela final do jogo
				byte  "    | |  __   /  \  | \  / | |__    | |  | \ \  / /| |__  | |__) | |      ", 0
				byte  "    | | |_ | / /\ \ | |\/| |  __|   | |  | |\ \/ / |  __| |  _  /| |      ", 0
				byte  "    | |__| |/ ____ \| |  | | |____  | |__| | \  /  | |____| | \ \|_|      ", 0
				byte  "     \_____/_/    \_\_|  |_|______|  \____/   \/   |______|_|  \_(_)      ", 0
				byte  " ________________________________________________________________________ ", 0
				byte  "|________________________________________________________________________|", 0
				
	totalpontuacao byte "                      SUA PONTUACAO FINAL FOI: ",0 ;48 CARACTERES

	strPlacar byte "Pontuacao: ", 0; 12 caracteres
	
	espaco byte " ", 0
	linhanula byte "                                                                 ",0
	
	levelSel byte ?
	
	xBomba byte ?
	yBomba byte 1
	xPerson byte 28
	yPerson byte 20
	
	align dword
	placar dword 0
	qtdObj dword 0

	.code
	main PROC
	
	inicio :
		mov placar, 0
		mov qtdObj, 0
		mov eax, 48
		call randomrange
		mov xbomba, al
		mov yBomba, 1
		mov xperson, 29
		mov ecx, 13
		mov dl,0
		mov dh,0
		call gotoxy
		mov edx, OFFSET ti
		mov eax, red + (white * 16); muda o fundo para branco e a fonte para vermelho
		call SetTextColor

	loopInicial :
		call WriteString; mostra na tela o nome do jogo e as opções de dificuldade
		call crlf
		add edx, 57
		loop loopInicial

	leituraDificuldade : ; usuário entra com o nível de dificuldade desejado
		mov eax, 0
		call ReadChar ; uma nova tela será mostrada após inserir um número válido
		push eax
		mov eax, red + (black * 16); muda o fundo para preto e a fonte para vermelho
		call SetTextColor
		call clrscr
		pop eax
		mov  levelSel, al
		sub levelSel, 48; passa o lvl selecionado de ascii para decimal
		cmp levelsel, 4
		je telaajuda
		cmp levelSel, 3
		je level3
		cmp levelSel, 2
		je level2
		cmp levelSel, 1
		je level1
		jmp inicio

	verificalevel :
		cmp levelSel, 3
		je level3
		cmp levelSel, 2
		je level2
		cmp levelSel, 1
		je level1

	level1 :
		mov eax, 130 ;o delay determina a velocidade em que a bomba desce
		call delay
		call readkey
		jz movimentacaobomba
		call moveperson

	level2 :
		mov eax, 100
		call delay
		call readkey
		jz movimentacaobomba
		call moveperson

	level3:
		mov eax, 75
		call delay
		call readkey
		jz movimentacaobomba
		call moveperson

	movimentacaobomba:
		mov  dl,0  ;column
		mov  dh,0  ;row
		call Gotoxy
		mov edx, OFFSET strPlacar; imprime o placar no canto superior da tela
		call writestring
		mov eax, placar
		call writedec
		mov cl, ybomba
		cmp cl, 1 ;verifica se está na primeira linha
		je posicao0 ;se estiver, não precisa limpar caracteres da bomba anterior
		mov dl, 0
		mov dh, yBomba
		sub dh, 1
		call gotoxy
		invoke desenhaespaco, 70
		
	posicao0 :
		mov dl, 0
		mov dh, yBomba
		call gotoxy
		mov edx, offset bomba
		mov bh, xBomba
		mov cl, bh
		add cl, 12
		mov bl, 70 ;verifica a quantidade de espaços necessarios a serem desenhados apos a bomba
		sub bl, cl
		mov cl, 5
	desenhaBomba :
		invoke desenhaespaco, bh; adiciona espaço até a posição onde está a bomba na tela
		call WriteString; desenha a bomba na tela
		invoke desenhaespaco, bl
		call crlf
		add edx, 12
		loop desenhaBomba

	mov dl, 0
	mov dh, yPerson
	call gotoxy
	
	mov edx, offset personagem
	mov ecx, 6
	mov bl, xperson
	mov bh, 60
	sub bh, bl
	desenhaperson:
		invoke desenhaespaco, bl
		call writestring
		invoke desenhaespaco, bh
		call crlf
		add edx, 6
		loop desenhaperson

	mov al, ybomba
	cmp al, 15
	jz checaconflito; se chegou no final do console, cria nova bomba e soma um no placar
	jmp movebomba
	
	checaconflito :
		mov al, xBomba
		add al, 5 ;adiciona 12 que é o tamanho da bomba no eixo x
		cmp al, xPerson
		jae checax1person
		jmp checax2person
	
	;verifica as duas opções de posição de explosão
	checax1person :
		sub al, 5
		cmp al, xperson; verifica se a bomba esta no range do personagem, se estiver explode
		jbe explodiu
	
	checax2person :
		mov dl, xPerson
		add dl, 5
		cmp al, dl
		ja novabomba
		sub dl, 5
		cmp al, dl
		jae explodiu
		jmp novabomba
	
	movebomba :
		inc yBomba; incrementa a posição y da bomba
		mov eax, 3
		call randomrange; escolhe um movimento para fazer
		cmp eax, 0
		jz movebombaesquerda
		cmp eax, 1
		jz movebombadireita
		cmp eax, 2
		jz verificalevel
	
	movebombadireita : ; os movimentos verificam se a posição está no extremo do console
		add xbomba, 8 ; se estiver desce uma posição e faz o movimento contrario do que foi sorteado
		cmp xbomba, 54
		jbe verificalevel
		sub xbomba, 8
		jmp verificalevel
		
	movebombaesquerda :
		sub xbomba, 8
		cmp xbomba, 8
		jge verificalevel
		add xBomba, 8
		jmp verificalevel
	
	novabomba :
		inc qtdObj; calcula a pontuação de acordo com o lvl escolhido
		mov edx, 0
		mov eax, qtdObj
		mul levelSel
		mov placar, eax
		mov eax, 48
		call randomrange; cria uma nova bomba
		mov xbomba, al
		mov yBomba, 1
		mov dl, 0 ; limpa a bomba da tela quando chega no final
		mov dh, 15
		call gotoxy
		mov ecx, 5
		mov eax, 100
		mov edx, offset linhanula
		call delay
		limpaultima:
			call writestring
			call crlf
			loop limpaultima
		jmp verificalevel


	explodiu :
		mov eax, lightred + (lightgray * 16); muda o fundo para preto e a fonte para vermelho
		call SetTextColor
		call Clrscr
		mov edx, OFFSET explosao
		mov ecx, 11
		
		loopExplosao:
			call WriteString; desenha a explosao da bomba na tela
			call crlf
			add edx, 34
			loop loopExplosao
			mov eax, 2500; espera 2 segundos para aparecer gameover
			call delay
			jmp fimDeJogo

	fimDeJogo :
		mov eax, red + (black * 16); muda o fundo para preto e a fonte para vermelho
		call SetTextColor
		call Clrscr
		mov edx, OFFSET gameover
		mov ecx, 9
		
		loopGO:
			call WriteString; escreve gameover na tela
			call crlf
			add edx, 75
			loop loopGO
			mov dl, 47
			mov dh, 8
			call gotoxy
			mov eax, placar
			call writedec
			mov eax, 4000; delay de 3 segundos para voltar a tela inicial
			call Delay
			call clrscr
			jmp inicio
	
	telaajuda:
		mov ecx, 13
		mov edx, offset ajuda
		mov eax, red + (white * 16); muda o fundo para branco e a fonte para vermelho
		call SetTextColor
		call clrscr
		loopajuda:
			call WriteString; mostra na tela o nome do jogo e as opções de dificuldade
			call crlf
			add edx, 57
			loop loopajuda
		call readchar
		cmp al, 49
		je inicio
		jmp telaajuda
		
	quit:
	
	exit
	main ENDP

	; função para incrementar posicao do personagem
	moveperson PROC
		cmp al, "d"
		je movedir
		cmp al, "a"
		je moveesq
		
		movedir :
			add xperson, 4
			cmp xPerson, 54
			jbe quit
			sub xperson, 4
			jmp quit
		moveesq :
			sub xperson, 4
			cmp xPerson, 0
			jge quit
			add xperson, 4
			jmp quit

	quit :
	ret
	moveperson endp


	; função para inserir espaço e fazer a movimentacao dos objetos na tela
	desenhaespaco PROC uses ecx edx, posicao:byte
		mov ecx, 0
		mov cl, posicao
		mov edx, OFFSET espaco
		loopespaco :
			call writestring
			loop loopespaco
		ret
	desenhaespaco endp

	END main