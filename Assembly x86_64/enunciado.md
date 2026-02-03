# Binary Exponentiation (x86-64 Assembly)

Este projeto consiste na implementação do algoritmo de **Exponenciação Binária (Binary Exponentiation)** utilizando puramente linguagem **Assembly x86-64**.

O código foi desenvolvido como parte do desafio técnico do **Trainee CoreTech**, com o objetivo de demonstrar domínio sobre a arquitetura de computadores, manipulação direta de memória e conformidade com a ABI do Linux.

## 🚀 Sobre o Algoritmo

A exponenciação binária (ou exponenciação por quadrados) é um método eficiente para calcular potências de um número. Diferente da abordagem ingênua que possui complexidade $O(N)$, este algoritmo reduz o número de multiplicações para $O(\log N)$ utilizando a representação binária do expoente.

A lógica implementada segue a definição recursiva:

$$
a^n = \begin{cases} 
1 & \text{se } n = 0 \\
(a^{\frac{n}{2}})^2 & \text{se } n > 0 \text{ e par} \\
(a^{\frac{n}{2}})^2 \cdot a & \text{se } n > 0 \text{ e ímpar}
\end{cases}
$$

## 🛠️ Conceitos Técnicos Abordados

A implementação destaca os seguintes conceitos avançados de Assembly e Arquitetura de Computadores:

* **Recursão em Assembly:** Gerenciamento manual do fluxo de execução e chamadas de função aninhadas.
* **System V AMD64 ABI:** Estrita observância das convenções de chamada do Linux, incluindo:
    * **Alinhamento da Stack:** Garantia de alinhamento de 16 bytes antes de chamadas `call` para compatibilidade com a `libc`.
    * **Preservação de Registradores:** Uso correto de registradores *callee-saved* (como `RBX`, `R12`) para manter o estado entre chamadas recursivas.
* **Integração com C (libc):** Uso das funções `fscanf` e `fprintf` para entrada e saída de dados formatados.
* **Manipulação de Tipos:** Tratamento de extensão de sinal e zero (`movsx`, `movzx`) para operações entre tipos de tamanhos mistos (`int8_t`, `uint8_t` e `int64_t`).

## 📋 Entrada e Saída

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