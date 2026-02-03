; ==========================================================================================================
;    Atividade Assembly (x86_64): Implementação do algorítimo de Exponenciação Binária de forma recursiva

;      © CoreTech — Liga de Hardware e Robótica da UFS    |    © Mateus Aranha — github.com/matt-aranha
; ==========================================================================================================

extern fscanf, fprintf, stdin, stdout, exit

section .data
    ; Strings de formato para fscanf e fprintf
    fmt_n:              db "%d", 0
    fmt_scan_case:      db " %hhd^%hhd", 0          ; O espaço no início de fmt_scan_case é importante para consumir \n e \r anteriores.
    fmt_out:            db "%ld", 10, 0 


section .bss
    ; Variáveis para armazenar as leituras
    N:      resd 1                                  ; Inteiro de 4 bytes para o número de casos
    base:   resb 1                                  ; int8_t (1 byte)
    expo:   resb 1                                  ; uint8_t (1 byte)


section .text
    global main



; ----------------------------------------------------------------------------------------------------------
; Função: binpow
; Assinatura: int64_t binpow(int8_t base, uint8_t expoente)
; Argumentos RDI = base, RSI = expoente
; Retorno: RAX
; ----------------------------------------------------------------------------------------------------------

binpow:
    ; --- Caso Base ---
    cmp rsi, 0                          ; Se expoente == 0
    jne .recursive_step
    mov rax, 1                          ; Retorna 1
    ret

.recursive_step:
    ; --- Alinhamento e Preservação da Stack ---
    ; É preciso salvar registradores callee-saved (RBX, R12) para guardar a 'base' e o 'expoente' atuais durante a recursão.

    push rbx                            ; Salva o RBX. Stack: desalinhada (16B totais desde call) ==> Alinhada 16
    push r12                            ; Salva o R12. Stack: desalinhada 8
    sub rsp, 8                          ; Padding para alinhar a 16 bytes antes da call

    ; Move argumentos para registradores preservados
    mov rbx, RDI                        ; RBX = base (preservado)
    mov r12, rsi                        ; R12 = expoente original (preservado)


    ; --- Passo Recursivo ---
        ; binpow (base, expoente / 2)
        ; RDI já tem a base (nao mudou), então tem que atualizar RSI
    shr rsi, 1                          ; RSI = expoente / 2
    call binpow                         ; Retorno em RAX


    ; --- Cálculo do Resultado ---
    imul rax, rax                       ; res = res * res

        ; Verifica se o expoente original (R12) era ímpar
        test r12, 1                     ; Teste bitwise AND com 1
        jz .finish                      ; Se zero, pula a multiplicação extra

        ; Se ímpar: res = res * base
        ; A base original é int8_t, mas temos que multiplicar por 64-bit.
        ; RBX contém a base. o imul r/m64 usa todo o regiistrador.
        ; Estendendo o sinal da base armazenada em bl para um temp register
        movsx rcx, bl                   ; Estende sinal de byte para 64 bits
        imul rax, rcx                   ; RAX = RAX * RCX

.finish:
    ; --- Epílogo ---
    add rsp, 8                          ; Desfaz o padding
    pop r12                             ; Restaura R12
    pop rbx                             ; Restaura RBX
    ret



; ----------------------------------------------------------------------------------------------------------
; Função: main
; Lógica de IN/OUT e Loop
; ----------------------------------------------------------------------------------------------------------

main:
    push rbp
    mov rbp, rsp

    ; --- Leitura de N ---
    ; fscanf(stdin, "%d", &N)
    mov rdi, [rel stdin]                ; Carrega ponteiro do aquivo stdin
    lea rsi, [rel fmt_n]                ; Formato
    lea rdx, [rel N]                    ; Endereço para salvar N
    mov rax, 0                          ; Sem argumentos de vetor (XMM)
    call fscanf

    ; Como o R13D é callee-saved, usaremos como contador do loop (N)
    push r13
    mov r13d, [rel N]                   ; R13D = N

.loop_start:
    cmp r13d, 0
    jle .loop_end                       ; Se N <= 0, termina

    ; --- Leitura do Caso de Teste ---
    ; fscanf(stdin, " %hhd^%hhd", &base, &expo)
    mov rdi, [rel stdin]
    lea rsi, [rel fmt_scan_case]
    lea rdx, [rel base]                 ; Terceiro arg: endereço da base
    lea rcx, [rel expo]                 ; Quarto arg: enderelo do expoente
    mov rax, 0
    call fscanf

    ; --- Preparar Argumentos para binpow ---
        ; int64_t binpow(int8_t base, uint8_t expoente)
        ; RDI = base (com extensão de sinal pois é int8)
        ; RSI = expoente (com extensão de zero pois é uint8)
    movsx rdi, byte [rel base]          ; Move com sinal (ex: -2 vira 0xFF...FE)
    movzx rsi, byte [rel expo]          ; Move com zero (ex: 3 vira 0x00...03)

    call binpow

    ; --- Imprimir Resultado ---
    ; fprintf(stdout, "%ld\n", resultado)
    mov rdi, [rel stdout]
    lea rsi, [rel fmt_out]
    mov rdx, rax                        ; O resultado de pinpow está em RAX
    mov rax, 0
    call fprintf

    ; --- Decremento do Loop ---
    dec r13d
    jmp .loop_start

.loop_end:
    pop r13                             ; Restaurar contador

    mov rax, 0                          ; Return 0
    leave
    ret