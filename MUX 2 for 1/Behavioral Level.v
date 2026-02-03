module mux2to1_behaviroal (
    input i0,                                   // entrada 0
    input i1,                                   // entrada 1
    input seletor,                              // "chave seletora"
    output reg y
);

    always @( i0 or i1 or seletor ) begin
        if ( seletor == 1'b0 )
            y = i0;

        else
            y = i1;
    end

endmodule