; ******************************************************************************
; * Algoritmo de Controle de LEDs - PIC16F628A                                  *
; * Autor: ARTHUR G. BREGUEZ                     Data: 22/03/2025               *
; ******************************************************************************

#include <P16F628A.INC>                     ; Inclui definições do PIC16F628A

; ============================================================================== 
; CONFIGURAÇÕES DO MICROCONTROLADOR
; ==============================================================================
    __CONFIG _BODEN_ON & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _MCLRE_ON & _HS_OSC

; ==============================================================================
; DEFINIÇÕES DE BANCOS DE MEMÓRIA
; ==============================================================================
#define BANK0  BCF STATUS,RP0               ; Seleciona Banco 0
#define BANK1  BSF STATUS,RP0               ; Seleciona Banco 1

; ============================================================================== 
; VARIÁVEIS
; ==============================================================================
    CBLOCK 0x20                             ; Endereço inicial das variáveis
        DELAY_VAR1                          ; Variável auxiliar para controle do loop externo do delay
        DELAY_VAR2                          ; Variável auxiliar para controle do loop interno do delay
    ENDC

; ============================================================================== 
; INÍCIO DO PROGRAMA
; ==============================================================================
    ORG 0x00                                ; Define origem do programa em 0x00
    GOTO INICIO                             ; Pula para a rotina de inicialização

; ============================================================================== 
; ROTINA PRINCIPAL
; ==============================================================================
INICIO:
    BANK1                                   ; Acessa Banco 1 para configurar os registradores
    MOVLW   b'00001110'                     ; Configura RA1, RA2 e RA3 como entradas
    MOVWF   TRISA                           ; Define os bits correspondentes do TRISA
    MOVLW   b'00000000'                     ; Configura todas as portas de PORTB como saída
    MOVWF   TRISB                           ; Define os bits correspondentes do TRISB
    BANK0                                   ; Retorna ao Banco 0
    CLRF    PORTB                           ; Garante que todos os LEDs estejam apagados inicialmente

    ; Acende LED RB0 e aguarda
    BSF     PORTB, 0                        ; Acende LED RB0
    CALL    DELAY                           ; Chama a rotina de delay para esperar t segundos
    BCF     PORTB, 0                        ; Apaga LED RB0
    
    ; Acende LED RB1 e aguarda
    BSF     PORTB, 1                        ; Acende LED RB1
    CALL    DELAY                           ; Chama a rotina de delay para esperar t segundos
    BCF     PORTB, 1                        ; Apaga LED RB1
    
    ; Acende LED RB2 e aguarda
    BSF     PORTB, 2                        ; Acende LED RB2
    CALL    DELAY                           ; Chama a rotina de delay para esperar t segundos
    BCF     PORTB, 2                        ; Apaga LED RB2

    GOTO    INICIO                          ; Reinicia o processo

; ============================================================================== 
; ROTINA DE DELAY (t segundos)
; ==============================================================================
DELAY:
    MOVLW   0xFF                            ; Carrega 255 no registrador W para definir o número de iterações do loop externo
    MOVWF   DELAY_VAR1                      ; Armazena esse valor na variável DELAY_VAR1
DELAY_LOOP1:
    MOVLW   0xFF                            ; Carrega 255 no registrador W para definir o número de iterações do loop interno
    MOVWF   DELAY_VAR2                      ; Armazena esse valor na variável DELAY_VAR2
DELAY_LOOP2:
    DECFSZ  DELAY_VAR2, F                   ; Decrementa DELAY_VAR2 e verifica se chegou a zero
    GOTO    DELAY_LOOP2                     ; Se não chegou a zero, continua no loop interno
    DECFSZ  DELAY_VAR1, F                   ; Decrementa DELAY_VAR1 e verifica se chegou a zero
    GOTO    DELAY_LOOP1                     ; Se não chegou a zero, reinicia o loop externo
    RETURN                                  ; Se ambos os loops terminarem, retorna para a rotina principal

    END                                     ; Fim do programa
