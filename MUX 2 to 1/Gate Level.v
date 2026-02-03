module mux2to1_gate (
    input i0,                                   // entrada 0
    input i1,                                   // entrada 1
    input seletor,                              // "chave seletora"
    output reg y
);

    wire seletor_not;                           // fio para o sinal de seleção invertido
    wire terminal1;                             // fio para a saída da primeira porta AND
    wire terminal2;                             // fio para a saída da segunda porta AND


    // portas primitivas:
        not ( seletor_not, seletor );                 // inversor do sinal do seletor
        and ( terminal1, i0, seletor_not );           // i0 AND !seletor
        and ( terminal2, i1, seletor );               // i1 AND seletor
        or ( y, terminal1, terminal2);                // term1 OR term2


endmodule