module mux2to1_rtl (
    input i0,                                   // entrada 0
    input i1,                                   // entrada 1
    input seletor,                              // "chave seletora"
    output y
);

    assign y = ( seletor ) ? i1 : i0;

endmodule