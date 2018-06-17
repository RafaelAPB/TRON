;===============================================================================
; ZONA I: Definicao de constantes
;===============================================================================

SP_INICIAL		EQU	FDFFh

INT_MASK		EQU	1000101010000011b
INT_PORT		EQU	FFFAh

IO_CURSOR		EQU	FFFCh
IO_WRITE		EQU	FFFEh

LCD_WRITE		EQU	FFF5h
LCD_CURSOR		EQU	FFF4h

Linha1LCD		EQU	8000h								;Posicao do 'TEMP.MAX: 0000s'
Linha2LCD		EQU	8010h								;Posicao do 'J1: 00'
Linha3LCD		EQU	801Ah								;Posicao do 'J2: 00'

DezenasJ1		EQU	8014h 								;Dezenas de J1
UnidadesJ1		EQU	8015h  								;Unidades de J1		

DezenasJ2		EQU	801Eh 								;Dezenas de J2
UnidadesJ2		EQU	801Fh 								;Unidades de J2

PosicaoTMAX1	EQU	800Ch								;Posicao do X0XX do TEMP.MAX
PosicaoTMAX2	EQU	800Dh								;Posicao do XX0X do TEMP.MAX
PosicaoTMAX3	EQU	800Eh								;Posicao do XXX0 do TEMP.MAX

PosTexto1		EQU	0B1Fh								;Posicoes da mensagem de boas vindas
PosTexto2		EQU	0C1Bh
PosCanto1		EQU	0110h								;Posicoes do canto do espaco de jogo
PosCanto2		EQU	0141h
PosCanto3		EQU	1610h
PosCanto4		EQU 1641h
PosMotaX		EQU	0B17h								;Posicoes iniciais das motas
PosMota#		EQU	0B37h								

FIM_TEXTO		EQU	'@'									

COUNT_TIMER 	EQU FFF6h								
CONTROLO_TIMER 	EQU FFF7h
TIME			EQU 1d									
IO_DISPLAY      EQU FFF0h
DELAY_COUNT     EQU 0200h
NIBBLE_MASK     EQU 000fh
NUM_NIBBLES     EQU 4
BITS_PER_NIBBLE EQU 4

TNivel2			EQU	000Ah								;Tempo a que muda para o nivel 4 - 10 segundos
TNivel3			EQU	0014h								;Tempo a que muda para o nivel 4 - 20 segundos
TNivel4			EQU	0028h								;Tempo a que muda para o nivel 4 - 40 segundos
TNivel5			EQU	003Ch								;Tempo a que muda para o nivel 5 - 60 segundos

FNivel1			EQU	0007h								;Velocidade dos jogadores no Nivel 1
FNivel2			EQU	0005h								;Velocidade dos jogadores no Nivel 2
FNivel3			EQU	0003h								;Velocidade dos jogadores no Nivel 3
FNivel4			EQU	0002h								;Velocidade dos jogadores no Nivel 4
FNivel5			EQU	0001h								;Velocidade dos jogadores no Nivel 5

PORT_LED		EQU	FFF8h								;Porto 	que controla os leds
LEDNivel2		EQU	000Fh								;Liga os 4 leds no nivel 2
LEDNivel3		EQU	00FFh								;Liga os 8 leds no nivel 3
LEDNivel4		EQU	0FFFh								;Liga os 12 leds no nivel 4
LEDNivel5		EQU	FFFFh								;Liga os 16 leds no nivel 5

FimJogoPos1		EQU	0B22h   							;Posicao da mensagem de fim de jogo, a segunda linha nao necessita, pois e igual a primeira mensagem

PortPausa		EQU	0080h								;Interruptor que ativa o modo Pausa
PosPausa1		EQU	0B06h								;Posicao em que aparece escrito o Pausa do lado esquerdo
PosPausa2		EQU	0B45h								;Posicao em que aparece escrito o Pausa do lado direito
PORT_INTERS	 	EQU	FFF9h								;Porto que verifica os interruptores

;===============================================================================
; ZONA II: Definicao de variaveis
;===============================================================================

				ORIG	8000h
VarTexto1		STR		'Bem-vindo ao TRON',FIM_TEXTO
VarTexto2		STR		'Pressione I1 para comecar',FIM_TEXTO
Msg1LCD			STR		'TEMPO MAX: 0000s'
Msg2LCD			STR		'J1: 00'
Msg3LCD			STR 	'J2: 00'
CANTO			STR		'+',FIM_TEXTO
LINHA			STR		'-',FIM_TEXTO
COLUNA			STR		'|',FIM_TEXTO
MOTA_X			STR		'X',FIM_TEXTO
MOTA_#			STR		'#',FIM_TEXTO
LIMPA			STR		' ',FIM_TEXTO
FimJogo1		STR		'Fim do Jogo',FIM_TEXTO
FimJogo2		STR		'Pressione I1 para recomecar',FIM_TEXTO
Pausa			STR		'Pausa',FIM_TEXTO

Contador        WORD    0000h							;Contador do relogio que conta e segundos e escreve o tempo em segundos
ContaRelogio	WORD	0000h							;Contador para mudar de nivel e acender leds
Relogio			WORD	0000h							;Contador para ativar o contador do relogio que conta a frequencia do nivel
Relogio1		WORD	0000h							;Contador para ativar o contador do relogio que conta em segundos
Estado			WORD	0000h							;Contador para iniciar o jogo
MovMotaX		WORD	0B17h							;Variavel que guarda sempre a posicao da mota X
MovMota#		WORD	0B37h							;Variavel que guarda sempre a posicao da mota #

FNivel			WORD	0007h							;Contador da frequencia a que decorre o nivel
	
Vitorias# 		WORD	0000h							;Numero de vitorias do #
VitoriasX		WORD 	0000h							;Numero de vitorias do X
Jogou#			WORD	0000h							;Verifica se foi o # que jogou
JogouX			WORD	0000h							;Verifica se foi o X que jogou
TempoMAX		WORD	0000h							;Variavel que guarda o valor do tempo maximo
PreGameOverC	WORD	0000h							;Contador do PreGameOver
PosicoesIguais	WORD	0000h							;Flag que verifica se as posicoes dos X e # sao iguais

Matriz			TAB		044Ch							;Posicoes de memoria reservadas para o espaco de jogo


;===============================================================================
; ZONA III: Tabela de interrupcoes
;===============================================================================

			ORIG	FE00h
INT0		WORD	EsquerdaX
INT1		WORD	Comeca
			
			ORIG	FE07h
INT7		WORD	Esquerda#
			
			ORIG	FE09h
INT9		WORD	Direita#
			
			ORIG	FE0Bh
INTB		WORD	DireitaX

			ORIG	FE0Fh
INT15		WORD	ContaSegundos


;===============================================================================
; ZONA IV: Codigo Principal
;===============================================================================
		
				ORIG	0000h
Inicio:         MOV     R1, SP_INICIAL
                MOV     SP, R1
				MOV		R1, INT_MASK
				MOV		M[INT_PORT], R1
				ENI
				MOV		R4,0100h					;Tipo de movimento inicial do X (para cima)
				MOV		R5,0001h					;Tipo de movimento inicial do # (para baixo)
				CALL    LimpaJanela
				CALL	EcraInicial
				CALL	DesenhaString1LCD
				CALL	DesenhaString2LCD
				CALL	DesenhaString3LCD
				MOV		M[Estado],R0				; coloca o Estado a zero	
				ENI	
CicloInicio:	CMP		M[Estado],R0
				BR.Z	CicloInicio
				MOV 	R1, TIME
				MOV		M[COUNT_TIMER], R1
				MOV 	R1, 1 
				MOV 	M[CONTROLO_TIMER], R1
Jogo:	 		CALL    LimpaJanela
				CALL	EscCantos
				CALL	EscLinhas
				CALL	EscColunas
				CALL	EscMotas
Fim:			CALL	VerificaNivel
				MOV		R1,M[Relogio]
				AND		R1,000Fh
				CMP		R1,M[FNivel]				;Altera tempo em que se move
				BR.Z	Rens
Fim2:			MOV		R1,M[Relogio1]
				AND		R1,000Fh
				CMP		R1,000Ah
				BR.Z	Incrementa
				MOV		R1,PortPausa
				CMP		M[PORT_INTERS],R1
				JMP.Z	RotPausa
				CALL	EscCont
				BR		Fim
				
Incrementa:		INC		M[Contador]
				INC  	M[ContaRelogio]
				MOV		M[Relogio1],R0
				JMP		Fim
				
Rens:			CMP		M[PreGameOverC],R0
				JMP.NZ	GameOver
				CALL	DirecoesX
				CALL	Direcoes#
				MOV		M[Relogio],R0
				JMP		Fim2
	
;===============================================================================
; ZONA III.I: Zona de interrupcoes
;===============================================================================

Comeca: 		PUSH	R1
				MOV		R1,1
				MOV		M[Estado],R1
				POP		R1
				RTI
	
ContaSegundos:	MOV 	R1, TIME
				MOV 	M[COUNT_TIMER], R1
				MOV 	R1, 1 
				MOV 	M[CONTROLO_TIMER], R1
				INC		M[Relogio]
				INC		M[Relogio1]
				RTI
				
EsquerdaX:		ROL	R4,4
				RTI
				
DireitaX:		ROR	R4,4
				RTI
				
Esquerda#:		ROL	R5,4
				RTI

Direita#:		ROR	R5,4
				RTI
				
				
;===============================================================================
;EcraInicial: Rotina que escreve a mensagem de texto inicial.
;		Entradas: --
;		Saidas: --
;		Efeitos: --
;===============================================================================

EcraInicial: 	PUSH	R1
				MOV		R1, PosTexto1
				PUSH	VarTexto1
				PUSH	R1
				CALL	EscString
				MOV		R1, PosTexto2
				PUSH	VarTexto2
				PUSH	R1
				CALL	EscString
				POP		R1
				RET
				
;===============================================================================
; LimpaJanela: Rotina que limpa a janela de texto e as posicoes de memoria
;				ocupadas pelo ecr
;		Entradas: --
;		Saidas: --
;		Efeitos: --
;===============================================================================

LimpaJanela:	PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R3,FFFFh			
				MOV		M[IO_CURSOR], R3
				MOV		R4,M[LIMPA]
				MOV		R1,0110h
				MOV		R2,16h
				MOV		R3,33h
CicloColuna:	DEC		R3
				CMP		R3,R0
				BR.Z	ProxLinha
				MOV		M[IO_CURSOR],R1
				MOV		M[IO_WRITE],R4
				INC		R1
				BR		CicloColuna
ProxLinha:		MOV		R3,33h
				DEC		R2
				SUB		R1,0032h
				ADD		R1,0100h
				CMP		R2,R0
				BR.NZ	CicloColuna
				MOV		R4, Matriz
				MOV		R3, 044Ch
LimpaMatriz:	MOV		M[R4],R0
				INC 	R4
				DEC		R3
				CMP		R3,R0
				BR.NZ	LimpaMatriz
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET

;===============================================================================
; EscString: Rotina que efectua a escrita de uma cadeia de caracter, terminada
;            pelo caracter FIM_TEXTO, na janela de texto numa posicao 
;            especificada. Pode-se definir como terminador qualquer caracter 
;            ASCII. 
;               Entradas: pilha - posicao para escrita do primeiro carater 
;                         pilha - apontador para o inicio da "string"
;               Saidas: ---
;               Efeitos: ---
;===============================================================================

EscString:      PUSH    R1
                PUSH    R2
				PUSH	R3
                MOV     R2, M[SP+6]   ; Apontador para inicio da "string"
                MOV     R3, M[SP+5]   ; Localizacao do primeiro carater
Ciclo:          MOV     M[IO_CURSOR], R3
                MOV     R1, M[R2]
                CMP     R1, FIM_TEXTO
                BR.Z    FimEsc
                MOV     M[IO_WRITE], R1
                INC     R2
                INC     R3
                BR      Ciclo
FimEsc:         POP     R3
                POP     R2
                POP     R1
                RETN    2                ; Actualiza STACK

;===============================================================================
; EscCantos
;===============================================================================

EscCantos:	MOV		R1, CANTO
			PUSH	R1
			PUSH	PosCanto1
			CALL	EscString
			PUSH	R1
			PUSH	PosCanto2
			CALL	EscString
			PUSH	R1
			PUSH	PosCanto3
			CALL	EscString
			PUSH	R1
			PUSH	PosCanto4
			CALL	EscString
			RET

;===============================================================================
; EscLinhas
;===============================================================================

EscLinhas:		MOV		R1, LINHA
				MOV		R2, PosCanto1
				MOV		R7, PosCanto3
				INC		R2
				INC		R7
CicloLinha1:	PUSH	R1
				PUSH	R2
				MOV		R3,R2
				CALL	VerificaColisoes
				CALL	EscString
				INC		R2
				CMP		R2, PosCanto2
				BR.NZ	CicloLinha1
CicloLinha2:	PUSH	R1
				PUSH	R7
				MOV		R3,R7
				CALL	VerificaColisoes
				CALL	EscString
				INC		R7
				CMP		R7, PosCanto4
				BR.NZ	CicloLinha2
				RET

;===============================================================================
; EscColunas
;===============================================================================

EscColunas:		MOV		R1, COLUNA
				MOV		R2, PosCanto1
				MOV		R7, PosCanto2
				ADD		R2, 0100h
				ADD		R7, 0100h
CicloColuna1:	PUSH	R1
				PUSH	R2
				MOV		R3,R2
				CALL	VerificaColisoes
				CALL	EscString
				ADD		R2, 0100h
				CMP		R2, PosCanto3
				BR.NZ	CicloColuna1
CicloColuna2:	PUSH	R1
				PUSH	R7
				MOV		R3,R7
				CALL	VerificaColisoes
				CALL	EscString
				ADD		R7, 0100h
				CMP		R7, PosCanto4
				BR.NZ	CicloColuna2
				RET

;===============================================================================
; EscMotas
;===============================================================================


EscMotas:	PUSH	MOTA_X
			PUSH	PosMotaX
			MOV		R3,PosMotaX
			CALL	VerificaColisoes
			CALL	EscString
			PUSH	MOTA_#
			PUSH	PosMota#
			MOV		R3,PosMota#
			CALL	VerificaColisoes
			CALL	EscString
			RET
			
			
;===============================================================================		
; EscreveCaracterLCD: escreve um caracter em cada posicao do LCD
;       Entradas: M[SP+5] - posicao
;				  M[SP+4] - caracter
;       Saidas: --- 
;       Efeitos: escreve o caracter no LCD.
;===============================================================================

EscreveCaracterLCD:	PUSH	R1
					PUSH	R2
					MOV		R1,M[SP+5]	;posicao
					MOV		R2,M[SP+4]	;caracter
					MOV		M[LCD_CURSOR],R1
					MOV		M[LCD_WRITE],R2
					POP		R2
					POP		R1
					RETN	2
					
;===============================================================================
; EscreveStringLCD: rotina que escreve uma string no LCD
;       Entradas: M[SP+7] - posicao
;				  M[SP+6] - string 
;				  M[SP+5] - tamanho da string
;       Saidas: --- 
;       Efeitos: escreve a string na placa
;===============================================================================

EscreveStringLCD:	PUSH	R1
					PUSH	R2
					PUSH	R3
					MOV		R1,M[SP+7]
					MOV		R2,M[SP+6]
					MOV		R3,M[SP+5]
CicloStringLCD:		PUSH	R1
					PUSH	M[R2]
					CALL	EscreveCaracterLCD
					INC		R1
					INC		R2
					DEC		R3
					BR.NZ	CicloStringLCD
					POP		R3
					POP		R2
					POP		R1
					RETN	3

DesenhaString1LCD:	PUSH	R1
					PUSH	R2
					PUSH	R3
					MOV		R1, Linha1LCD
					MOV		R2, Msg1LCD
					MOV		R3, 16
					PUSH	R1
					PUSH	R2
					PUSH	R3
					CALL	EscreveStringLCD		
					POP		R3
					POP		R2
					POP		R1
					RET

DesenhaString2LCD:	PUSH	R1
					PUSH	R2
					PUSH	R3
					MOV		R1,Linha2LCD
					MOV		R2,Msg2LCD
					MOV		R3, 6
					PUSH	R1
					PUSH	R2
					PUSH	R3
					CALL	EscreveStringLCD
					POP		R3
					POP		R2
					POP		R1
					RET

DesenhaString3LCD:	PUSH	R1
					PUSH	R2
					PUSH	R3
					MOV		R1,Linha3LCD
					MOV		R2,Msg3LCD
					MOV		R3, 6
					PUSH	R1
					PUSH	R2
					PUSH	R3
					CALL	EscreveStringLCD
					POP		R3
					POP		R2
					POP		R1
					RET
					
;===============================================================================
; EscCont: Rotina que efectua a escrita do contador
;===============================================================================

EscCont:        PUSH    R1
                PUSH    R2
                PUSH    R3
                DSI
                MOV     R2, NUM_NIBBLES
                MOV     R3, IO_DISPLAY
Ciclo2:       	MOV     R1, M[Contador]
                AND     R1, NIBBLE_MASK
				TEST 	R2, 0001h
				BR.Z	Funcionasff
				TEST	R2, 0001h
				BR.NZ	Funcionasff2
Funcionasff:	CMP		R1, 000ah
				JMP.NN	JUMPA
				JMP		Volta
Funcionasff2:	CMP		R1, 0006h
				JMP.NN	JUMPA2
Volta:			MOV     M[R3], R1
                ROR     M[Contador], BITS_PER_NIBBLE
                INC     R3
                DEC     R2
                BR.NZ   Ciclo2
                ENI
                POP     R3
                POP     R2
                POP     R1
                RET		

JUMPA:			MOV		R7, 0006h
				ADD		M[Contador], R7
				JMP		Volta

JUMPA2:			PUSH	R1
				PUSH	R7
				MOV 	R7, 0010h
				SUB		R7,R1
				ADD		M[Contador], R7
				POP		R7
				POP		R1
				JMP		Volta
				
;===============================================================================
;Direcoes_X
;===============================================================================

DirecoesX:	CMP		R4,1000h
			CALL.Z	MoveEsquerdaX
			CMP		R4,0100h
			CALL.Z	MoveCimaX
			CMP		R4,0010h
			CALL.Z	MoveDireitaX
			CMP		R4,0001h
			CALL.Z	MoveBaixoX
			RET

;===============================================================================
;Direcoes_#
;===============================================================================

Direcoes#:	CMP		R5,1000h
			CALL.Z	MoveEsquerda#
			CMP		R5,0100h
			CALL.Z	MoveCima#
			CMP		R5,0010h
			CALL.Z	MoveDireita#
			CMP		R5,0001h
			CALL.Z	MoveBaixo#
			RET

;===============================================================================
;Move mota_x
;===============================================================================

MoveCimaX:		MOV		R1,M[MovMotaX]
				SUB		R1,0100h
				MOV		M[MovMotaX],R1
				MOV		R3,R1
				INC		M[JogouX]
				CALL	VerificaColisoes
				CMP		M[PreGameOverC],R0
				BR.NZ	FMoveCimaX
				PUSH	MOTA_X
				PUSH	R1
				CALL	EscString
				DEC		M[JogouX]
FMoveCimaX:		RET

MoveBaixoX:		MOV		R1,M[MovMotaX]
				ADD		R1,0100h
				MOV		M[MovMotaX],R1
				MOV		R3,R1
				INC		M[JogouX]
				CALL	VerificaColisoes
				CMP		M[PreGameOverC],R0
				BR.NZ	FMoveBaixoX
				PUSH	MOTA_X
				PUSH	R1
				CALL	EscString
				DEC		M[JogouX]
FMoveBaixoX:	RET

MoveEsquerdaX:	MOV		R1,M[MovMotaX]
				DEC		R1
				MOV		M[MovMotaX],R1
				MOV		R3,R1
				INC		M[JogouX]
				CALL	VerificaColisoes
				CMP		M[PreGameOverC],R0
				BR.NZ	FMoveEsquerdaX
				PUSH	MOTA_X
				PUSH	R1
				CALL	EscString
				DEC		M[JogouX]
FMoveEsquerdaX:	RET

MoveDireitaX:	MOV		R1,M[MovMotaX]
				INC		R1
				MOV		M[MovMotaX],R1
				MOV		R3,R1
				INC		M[JogouX]
				CALL	VerificaColisoes
				CMP		M[PreGameOverC],R0
				BR.NZ	FMoveDireitaX
				PUSH	MOTA_X
				PUSH	R1
				CALL	EscString
				DEC		M[JogouX]
FMoveDireitaX:	RET

;===============================================================================
;Move mota_#
;===============================================================================

MoveBaixo#:		MOV		R1,M[MovMota#]
				ADD		R1,0100h
				MOV		M[MovMota#],R1
				MOV		R3,R1
				INC		M[Jogou#]
				CALL	VerificaColisoes
				MOV 	R2,M[PreGameOverC]
				CMP		R2,1
				BR.P	FMoveBaixo#
				PUSH	MOTA_#
				PUSH	R1
				CALL	EscString
				DEC		M[Jogou#]
FMoveBaixo#:	RET

MoveCima#:		MOV		R1,M[MovMota#]
				SUB		R1,0100h
				MOV		M[MovMota#],R1
				MOV		R3,R1
				INC		M[Jogou#]
				CALL	VerificaColisoes
				MOV 	R2,M[PreGameOverC]
				CMP		R2,1
				BR.P	FMoveCima#
				PUSH	MOTA_#
				PUSH	R1
				CALL	EscString
				DEC		M[Jogou#]
FMoveCima#:		RET

MoveEsquerda#:	MOV		R1,M[MovMota#]
				DEC		R1
				MOV		M[MovMota#],R1
				MOV		R3,R1
				INC		M[Jogou#]
				CALL	VerificaColisoes
				MOV 	R2,M[PreGameOverC]
				CMP		R2,1
				BR.P	FMoveEsquerda#
				PUSH	MOTA_#
				PUSH	R1
				CALL	EscString
				DEC		M[Jogou#]
FMoveEsquerda#:	RET

MoveDireita#:	MOV		R1,M[MovMota#]
				INC		R1
				MOV		M[MovMota#],R1
				MOV		R3,R1
				INC		M[Jogou#]
				CALL	VerificaColisoes
				MOV 	R2,M[PreGameOverC]
				CMP		R2,1
				BR.P	FMoveDireita#
				PUSH	MOTA_#
				PUSH	R1
				CALL	EscString
				DEC		M[Jogou#]
FMoveDireita#:	RET

;===============================================================================
;Muda Nivel
;===============================================================================

VerificaNivel:	MOV		R1,M[ContaRelogio]
				CMP		R1,TNivel2
				BR.Z	RotNivel2
				CMP		R1,TNivel3
				BR.Z	RotNivel3
				CMP		R1,TNivel4
				BR.Z	RotNivel4
				CMP		R1,TNivel5
				BR.Z	RotNivel5
				RET

RotNivel2:		MOV		R2,FNivel2
				MOV		R3,LEDNivel2
				MOV    	M[PORT_LED],R3
				MOV		M[FNivel],R2
				RET

RotNivel3:		MOV		R2,FNivel3
				MOV		R3,LEDNivel3
				MOV    	M[PORT_LED],R3
				MOV		M[FNivel],R2
				RET
				
RotNivel4:		MOV		R2,FNivel4
				MOV		R3,LEDNivel4
				MOV    	M[PORT_LED],R3
				MOV		M[FNivel],R2
				RET

RotNivel5:		MOV		R2,FNivel5
				MOV		R3,LEDNivel5
				MOV    	M[PORT_LED],R3
				MOV		M[FNivel],R2
				RET				
				
				
;===============================================================================
;VerificaColisoes
;===============================================================================

VerificaColisoes:	PUSH	R1
					PUSH	R2
					PUSH	R3
					PUSH	R4
					PUSH 	R5
					PUSH 	R6
					MOV		R1,R3		;Copio as coordenadas para o R1
					AND		R1,FF00h	;Separo as linhas
					AND		R3,00FFh	;Separo as colunas
					
					SUB		R1,0100h	;Obtenho a linha em que quero escrever
					SHR		R1,8		;Para poder efetuar o algoritmo
	
					
					MOV		R2,32h		;Numero de colunas
					SUB		R3,0010h	;Obtenho a coluna em que quero escrever
					ADD		R3,Matriz	
					MUL		R2,R1
					ENI
					ADD		R3,R1
					CMP		M[R3],R0
					BR.NZ	PreGameOver
					MOV		R1,1
					MOV		M[R3],R1
SaiPreGameOver:		POP 	R6
					POP		R5
					POP 	R4
					POP		R3
					POP		R2
					POP		R1
					RET
					
					
PreGameOver:		MOV 	R4,M[JogouX]		
					MOV 	R5,M[Jogou#]
					MOV 	R6,M[PreGameOverC]
					CMP		R4,1
					BR.Z 	Potato
					MOV 	R6,2
					BR 		PotatoFim
Potato:				CMP		R5,1
					BR.Z 	Potato2
					MOV 	R6,1
					BR 		PotatoFim
Potato2:			MOV 	R6,3
PotatoFim:			MOV 	M[PreGameOverC],R6
					BR		SaiPreGameOver						
					
					
VerificaPosicoes:		MOV		R1,M[MovMota#]
						MOV		R2,M[MovMotaX]
						CMP		R1,R2
						BR.Z	RotPosicoesI
						RET
RotPosicoesI:			INC		M[PosicoesIguais]
						RET
					
;===============================================================================
;GameOver
;===============================================================================

GameOver:		PUSH	FimJogo1
				PUSH	FimJogoPos1
				CALL	EscString
				PUSH	FimJogo2
				PUSH	PosTexto2
				CALL	EscString
				
				CALL	VerificaPosicoes
				CMP		M[PosicoesIguais],R0
				JMP.NZ	Empate
			
				CMP		M[JogouX],R0
				BR.Z 	Banana
				CMP		M[Jogou#],R0
				JMP.NZ	Empate
				CALL	AtualizaPontuacao#
				BR		VoltaGameOver
Banana:			CALL	AtualizaPontuacaoX

VoltaGameOver:	CALL	VerificaTempoMax
				CALL	AtualizaLCD
				MOV		R4,0100h
				MOV		R5,0001h
				MOV		R1,0B17h
				MOV		M[MovMotaX],R1
				MOV		R1,0B37h
				MOV		M[MovMota#],R1
				MOV		M[Relogio],R0
				MOV		M[Relogio1],R0
				MOV		M[Contador],R0
				MOV		M[ContaRelogio],R0
				MOV		M[PORT_LED],R0
				MOV		M[PreGameOverC],R0
				MOV		M[PosicoesIguais],R0
				MOV		M[JogouX],R0
				MOV		M[Jogou#],R0
				MOV		R1,FNivel1
				MOV		M[FNivel],R1
				MOV		M[Estado],R0
Stop:			CMP		M[Estado],R0
				JMP.NZ	Jogo
				BR		Stop

;===============================================================================
;Empate
;===============================================================================	

Empate:		CALL	AtualizaPontuacao#
			CALL	AtualizaPontuacaoX
			JMP		VoltaGameOver
				
				
;===============================================================================
;VerificaTempoMax
;===============================================================================

VerificaTempoMax:	PUSH	R1
					PUSH	R2
					MOV		R1,M[Contador]
					MOV		R2,M[TempoMAX]
					CMP		R2,R1
					BR.N	AtualizaTempoMax
					POP		R2
					POP		R1
					RET
					
AtualizaTempoMax:	MOV		R1,M[Contador]
					MOV		R2,R1
					AND		R2,0F00h
					CMP		R2,0100h
					BR.NZ	CicloTempoMax
					ADD		R1,0060h
					AND		R1,00FFh
CicloTempoMax:		MOV		M[TempoMAX],R1
					POP		R2
					POP		R1
					RET


;===============================================================================
;AtualizacaoPontuacao
;===============================================================================

AtualizaPontuacaoX:		PUSH	R1
						PUSH	R2
						PUSH	R3
						MOV		R1,M[VitoriasX]
						MOV		R3,R0
						BR		InicioAtualiza
AtualizaPontuacao#:		PUSH	R1
						PUSH	R2
						PUSH	R3
						MOV		R1,M[Vitorias#]
						MOV		R3,0001h
						BR		InicioAtualiza
InicioAtualiza:			MOV		R2,R1
						INC		R2
						AND		R2,000fh
						CMP		R2,000Ah
						BR.Z	CicloAtualiza
						INC		R1
						BR		FimAtualiza
CicloAtualiza:			MOV		R2,R1
						ADD		R2,0010h
						AND		R2,00F0h
						CMP		R2,00A0h
						BR.Z	FimAtualiza
						ADD		R1,0010h
						AND		R1,FFF0h
						BR		FimAtualiza
FimAtualiza:			CMP		R3,R0
						BR.Z	AtualizaVitoriasX
						MOV		M[Vitorias#],R1
						BR		SaiAtualiza
AtualizaVitoriasX:		MOV		M[VitoriasX],R1
						BR		SaiAtualiza
SaiAtualiza:			POP		R3
						POP		R2
						POP		R1
						RET

;===============================================================================
;AtualizaLCD
;===============================================================================

AtualizaLCD:	PUSH	R1
				PUSH	R2
				PUSH 	R3
				MOV		R1,M[TempoMAX]
				MOV		R2,R1
				AND		R2,0F00h
				SHR		R2,8
				ADD		R2,0030h
				MOV		R3,PosicaoTMAX1
				PUSH	R3
				PUSH	R2
				CALL	EscreveCaracterLCD
				MOV		R2,R1
				AND		R2,00F0h
				SHR		R2,4
				ADD		R2,0030h
				MOV		R3,PosicaoTMAX2
				PUSH	R3
				PUSH	R2
				CALL	EscreveCaracterLCD
				MOV		R2,R1
				AND		R2,000Fh
				ADD		R2,0030h
				MOV		R3,PosicaoTMAX3
				PUSH	R3
				PUSH	R2
				CALL	EscreveCaracterLCD
				MOV		R1,M[VitoriasX]
				MOV		R2,R1
				AND		R2,00F0h
				SHR 	R2,4
				ADD		R2,0030h
				MOV		R3,DezenasJ1
				PUSH	R3
				PUSH	R2
				CALL	EscreveCaracterLCD
				MOV		R2,R1
				AND		R2,000Fh
				ADD		R2,0030h
				MOV		R3,UnidadesJ1
				PUSH	R3
				PUSH	R2
				CALL	EscreveCaracterLCD
				MOV		R1,M[Vitorias#]
				MOV		R2,R1
				AND		R2,00F0h
				SHR		R2,4
				ADD		R2,0030h
				MOV		R3,DezenasJ2
				PUSH	R3
				PUSH	R2
				CALL	EscreveCaracterLCD
				MOV		R2,R1
				AND		R2,000Fh
				ADD		R2,0030h
				MOV		R3,UnidadesJ2
				PUSH	R3
				PUSH	R2
				CALL	EscreveCaracterLCD
				POP		R3
				POP 	R2
				POP		R1
				RET

;===============================================================================
;RotPausa
;===============================================================================

RotPausa:		PUSH	Pausa
				PUSH	PosPausa1
				CALL	EscString
				PUSH	Pausa
				PUSH	PosPausa2
				CALL	EscString
				MOV		R1,PortPausa
Repete:         CMP     M[PORT_INTERS],R0
                BR.NZ   Repete
				CALL	ApagaPausa
				CALL	Fim
				
;===============================================================================
;ApagaPausa
;===============================================================================

ApagaPausa:		PUSH	R1
				PUSH	R2
				PUSH	R3
				MOV		R1,LIMPA
				MOV		R2,0B06h
				MOV		R3,6h
PrimeiraPausa:	DEC		R3
				CMP		R3,R0
				BR.Z	SegundaPausa
				PUSH	R1
				PUSH	R2
				CALL	EscString
				INC		R2
				BR		PrimeiraPausa
SegundaPausa:	MOV		R2,0B45h
				MOV		R3,6h
Repete2Pausa:	DEC		R3
				CMP		R3,R0
				BR.Z	FimApagaPausa
				PUSH	R1
				PUSH	R2
				CALL	EscString
				INC		R2
				BR		Repete2Pausa
FimApagaPausa:	POP		R3
				POP		R2
				POP		R1
				RET


;A fazer:
; - Empate (comparando posicoes do jogador)