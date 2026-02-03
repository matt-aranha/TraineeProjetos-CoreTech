# 🚀 Portfólio de Projetos - Trainee CoreTech (UFS)

Este repositório documenta as atividades práticas desenvolvidas durante o processo de trainee da **CoreTech - Liga de Hardware e Robótica da Universidade Federal de Sergipe**. Os projetos abaixo demonstram a aplicação de conceitos fundamentais de Arquitetura de Computadores e Descrição de Hardware.

---

## 🛠️ Atividade 1: Exponenciação Binária em Assembly x86-64

### Descrição do Desafio
Este projeto consiste na implementação do algoritmo de **Exponenciação Binária (Binary Exponentiation)** utilizando puramente linguagem **Assembly x86-64**.

O código foi desenvolvido como parte do desafio técnico do **Trainee CoreTech**, com o objetivo de demonstrar domínio sobre a arquitetura de computadores, manipulação direta de memória e conformidade com a ABI do Linux.

### 🚀 Sobre o Algoritmo

A exponenciação binária (ou exponenciação por quadrados) é um método eficiente para calcular potências de um número. Diferente da abordagem ingênua que possui complexidade $O(N)$, este algoritmo reduz o número de multiplicações para $O(\log N)$ utilizando a representação binária do expoente.

A lógica implementada segue a definição recursiva:

$$
a^n = \begin{cases} 
1 & \text{se } n = 0 \\
(a^{\frac{n}{2}})^2 & \text{se } n > 0 \text{ e par} \\
(a^{\frac{n}{2}})^2 \cdot a & \text{se } n > 0 \text{ e ímpar}
\end{cases}
$$

### 🛠️ Conceitos Técnicos Abordados

A implementação destaca os seguintes conceitos avançados de Assembly e Arquitetura de Computadores:

* **Recursão em Assembly:** Gerenciamento manual do fluxo de execução e chamadas de função aninhadas.
* **System V AMD64 ABI:** Estrita observância das convenções de chamada do Linux, incluindo:
    * **Alinhamento da Stack:** Garantia de alinhamento de 16 bytes antes de chamadas `call` para compatibilidade com a `libc`.
    * **Preservação de Registradores:** Uso correto de registradores *callee-saved* (como `RBX`, `R12`) para manter o estado entre chamadas recursivas.
* **Integração com C (libc):** Uso das funções `fscanf` e `fprintf` para entrada e saída de dados formatados.
* **Manipulação de Tipos:** Tratamento de extensão de sinal e zero (`movsx`, `movzx`) para operações entre tipos de tamanhos mistos (`int8_t`, `uint8_t` e `int64_t`).

### 📋 Entrada e Saída

O programa lê um número $N$ de casos de teste, seguido por $N$ linhas contendo a base e o expoente no formato `base^expoente`.

**Exemplo de Entrada:**
```text
5
-2^3
0^2
-5^6
3^6
-3^27
```

**Saída Esperada:**
```text
-8
0
15625
729
-7625597484987
```

---

## ⚡ Atividade 2: Descrição de Hardware com Verilog (Multiplexador 2:1)

### Descrição do Desafio
O desafio consistiu em projetar um **Multiplexador (MUX) 2:1** utilizando a linguagem de descrição de hardware **Verilog**. O objetivo principal foi demonstrar a compreensão dos três níveis de abstração no design digital: **Comportamental**, **RTL** e **Portas Lógicas**.

### 1. Nível Comportamental (Behavioral Level)
Neste nível, descrevemos **o que** o circuito faz, sem detalhar a implementação física. Utiliza-se blocos procedurais (`always`) que monitoram alterações nos sinais de entrada.

```verilog
module mux2to1_behaviroal (
    input i0,       // entrada 0
    input i1,       // entrada 1
    input seletor,  // "chave seletora"
    output reg y
);
    always @( i0 or i1 or seletor ) begin
        if ( seletor == 1'b0 )
            y = i0;
        else
            y = i1;
    end
endmodule
```
***Análise Prática:*** A execução ocorre linha a linha dentro do bloco `always`. É o nível mais alto de abstração, ideal para descrever algoritmos complexos de controle.

### 2. Nível de Registrador-Transferência (RTL - Register-Transfer Level)
Aqui utilizei o fluxo de dados contínuo. O bloco `assign` funciona como uma "solda" digital: qualquer alteração na entrada reflete instantaneamente na saída.
```verilog
module mux2to1_rtl (
    input i0,       // entrada 0
    input i1,       // entrada 1
    input seletor,  // "chave seletora"
    output y
);
    assign y = ( seletor ) ? i1 : i0;
endmodule
```
***Análise Prática:*** Este nível é mais próximo do hardware real do que o comportamental, definindo como os dados fluem entre registradores e operadores lógicos/condicionas.

### 3. Nível de Porta Lógica (Gate Level)
O nível mais baixo de abstração antes do layout físico. O circuito é construído conectando **primitivas** de portas lógicas baseadas na equação booleana do MUX: $Y = (i0 \cdot \overline{S}) + (i1 \cdot S)$.
```verilog
module mux2to1_gate (
    input i0,       // entrada 0
    input i1,       // entrada 1
    input seletor,  // "chave seletora"
    output reg y
);
    wire seletor_not;  // fio para o sinal de seleção invertido
    wire terminal1;    // fio para a saída da primeira porta AND
    wire terminal2;    // fio para a saída da segunda porta AND

    // portas primitivas:
    not ( seletor_not, seletor );          // inversor do sinal do seletor
    and ( terminal1, i0, seletor_not );    // i0 AND !seletor
    and ( terminal2, i1, seletor );        // i1 AND seletor
    or ( y, terminal1, terminal2);         // term1 OR term2
endmodule
```
***Análise Prática:*** Define a estrutura exata do circuito ("netlist"). É a representação fiel de como os transistores lógicos serão organizados para satisfazer a lógica booleana: "A saída é verdadeira se (i0 for 1 e S for 0) OU se (i1 for 1 e S for 1)".
