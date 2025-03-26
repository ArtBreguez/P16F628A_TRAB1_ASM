; ******************************************************************************
; * Algoritmo de Controle de LEDs - PIC16F628A                                 *
; * Autor: ARTHUR G. BREGUEZ  & JOAO VICTOR      Data: 26/03/2025              *
; ******************************************************************************

#include <P16F628A.INC>                     ; Inclui definicoes do PIC16F628A

; ============================================================================== 
; CONFIGURACOES DO MICROCONTROLADOR
; ==============================================================================
    __CONFIG _BODEN_ON & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _MCLRE_ON & _HS_OSC

; ==============================================================================
; DEFINICOES DE BANCOS DE MEMORIA
; ==============================================================================
#define BANK0  BCF STATUS,RP0               ; Seleciona Banco 0
#define BANK1  BSF STATUS,RP0               ; Seleciona Banco 1

; ============================================================================== 
; VARIAVEIS
; ==============================================================================
    CBLOCK 0x20                             ; Endereco inicial das variaveis
        DELAY_VAR1                          ; Variavel auxiliar para delays
        DELAY_VAR2                          ; Variavel auxiliar para delays
        INPUT_VALUE                         ; Armazena o valor de 3 bits lidos dos botoes
    ENDC

; ============================================================================== 
; INICIO DO PROGRAMA
; ==============================================================================
    ORG 0x00                                ; Define origem do programa em 0x00
    GOTO INICIO                             ; Pula para a rotina de inicializacao

; ============================================================================== 
; ROTINA PRINCIPAL
; ==============================================================================
INICIO:
    BANK1                                   ; Acessa Banco 1 para configuracao
    MOVLW   b'00001110'                     ; RA1, RA2 e RA3 como entrada
    MOVWF   TRISA                           
    MOVLW   b'00000000'                     ; PORTB como saida
    MOVWF   TRISB                           
    BANK0                                   ; Retorna ao Banco 0
    CLRF    PORTB                           ; Inicializa PORTB em 0
    CLRF    INPUT_VALUE                     ; Inicializa variavel de entrada como 0

    ; Acende LED RB0 e aguarda
    BSF     PORTB, 0                        ; Acende LED RB0
    CALL    DELAY                           ; Aguarda t segundos
    BCF     PORTB, 0                        ; Apaga LED RB0
    BTFSC   PORTA, 1                        ; Verifica se RA1 esta pressionado
    BSF     INPUT_VALUE, 0                  ; Define bit 0 de INPUT_VALUE se RA1 estiver pressionado

    ; Acende LED RB1 e aguarda
    BSF     PORTB, 1                        ; Acende LED RB1
    CALL    DELAY                           ; Aguarda t segundos
    BCF     PORTB, 1                        ; Apaga LED RB1
    BTFSC   PORTA, 2                        ; Verifica se RA2 esta pressionado
    BSF     INPUT_VALUE, 1                  ; Define bit 1 de INPUT_VALUE se RA2 estiver pressionado

    ; Acende LED RB2 e aguarda
    BSF     PORTB, 2                        ; Acende LED RB2
    CALL    DELAY                           ; Aguarda t segundos
    BCF     PORTB, 2                        ; Apaga LED RB2
    BTFSC   PORTA, 3                        ; Verifica se RA3 esta pressionado
    BSF     INPUT_VALUE, 2                  ; Define bit 2 de INPUT_VALUE se RA3 estiver pressionado

    GOTO    INICIO                          ; Reinicia o processo

; ============================================================================== 
; ROTINA DE DELAY (t segundos)
; ==============================================================================
DELAY:
    MOVLW   0xFF                            ; Ajuste fino do tempo de espera
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

    END                                     ; Fim do programa