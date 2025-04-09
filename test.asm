; ******************************************************************************
; * Algoritmo de Controle de LEDs - PIC16F628A                                 *
; * Autor: ARTHUR G. BREGUEZ  & JOAO VICTOR      Data: 26/03/2025              *
; ******************************************************************************

#include <P16F628A.INC>

; ============================================================================== 
; CONFIGURACOES DO MICROCONTROLADOR
; ==============================================================================
    __CONFIG _BODEN_ON & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _MCLRE_ON & _HS_OSC

; ==============================================================================
; DEFINICOES DE BANCOS DE MEMORIA
; ==============================================================================
#define BANK0  BCF STATUS,RP0
#define BANK1  BSF STATUS,RP0

; ============================================================================== 
; VARIAVEIS
; ==============================================================================
    CBLOCK 0x20
        DELAY_VAR1
        DELAY_VAR2
        INPUT_VALUE
    ENDC

; ============================================================================== 
; INICIO DO PROGRAMA
; ==============================================================================
    ORG 0x00
    GOTO INIT

; ============================================================================== 
; ROTINA DE INICIALIZACAO
; ==============================================================================
INIT:
    BANK1
    MOVLW   b'00001110'     ; RA1, RA2, RA3 como entrada
    MOVWF   TRISA
    MOVLW   b'00000000'     ; PORTB como saida
    MOVWF   TRISB
    BANK0
    CLRF    PORTB           ; Inicializa PORTB em 0
    CLRF    INPUT_VALUE     ; Inicializa INPUT_VALUE

; ============================================================================== 
; ROTINA PRINCIPAL
; ==============================================================================
MAIN_LOOP:
    CLRF    INPUT_VALUE     ; Reseta INPUT_VALUE a cada ciclo

    ; Verifica RA1 (Bit 0)
    BSF     PORTB, 0        ; Acende RB0 temporariamente
    CALL    DELAY
    BTFSC   PORTA, 1        ; Botão RA1 pressionado (nível lógico baixo)?
    GOTO    CHECK_RA2       ; Não: pula para próxima verificação
    BSF     INPUT_VALUE, 0  ; Sim: Define bit 0
CHECK_RA2:
    BCF     PORTB, 0        ; Apaga RB0

    ; Verifica RA2 (Bit 1)
    BSF     PORTB, 1        ; Acende RB1 temporariamente
    CALL    DELAY
    BTFSC   PORTA, 2        ; Botão RA2 pressionado (nível lógico baixo)?
    GOTO    CHECK_RA3       ; Não: pula para próxima verificação
    BSF     INPUT_VALUE, 1  ; Sim: Define bit 1
CHECK_RA3:
    BCF     PORTB, 1        ; Apaga RB1

    ; Verifica RA3 (Bit 2)
    BSF     PORTB, 2        ; Acende RB2 temporariamente
    CALL    DELAY
    BTFSC   PORTA, 3        ; Botão RA3 pressionado (nível lógico baixo)?
    GOTO    UPDATE_LEDS     ; Não: pula para atualização dos LEDs
    BSF     INPUT_VALUE, 2  ; Sim: Define bit 2
    BCF     PORTB, 2        ; Apaga RB2

UPDATE_LEDS:
    ; Verifica se INPUT_VALUE ≠ 000
    MOVF    INPUT_VALUE, W  ; Carrega INPUT_VALUE em W
    ANDLW   b'00000111'     ; Máscara para os 3 bits (evita lixo)
    BZ      LEDS_OFF        ; Se INPUT_VALUE = 000, apaga LEDs

    ; Exibe o valor em RB4-RB7
    SWAPF   INPUT_VALUE, W  ; Desloca 4 bits para a esquerda
    MOVWF   PORTB           ; Atualiza PORTB (RB4-RB7)
    GOTO    MAIN_LOOP

LEDS_OFF:
    CLRF    PORTB           ; Apaga todos os LEDs
    GOTO    MAIN_LOOP

; ============================================================================== 
; ROTINA DE DELAY (Anti-bounce e estabilização)
; ==============================================================================
DELAY:
    MOVLW   0xFF
    MOVWF   DELAY_VAR1
DELAY_LOOP1:
    MOVLW   0xFF
    MOVWF   DELAY_VAR2
DELAY_LOOP2:
    DECFSZ  DELAY_VAR2, F
    GOTO    DELAY_LOOP2
    DECFSZ  DELAY_VAR1, F
    GOTO    DELAY_LOOP1
    RETURN

    END
