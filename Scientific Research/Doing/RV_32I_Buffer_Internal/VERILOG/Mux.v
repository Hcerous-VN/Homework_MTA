module Mux_Branch(
    input [63:0] a,
    input [63:0] b,
    input [63:0] sel2,
    input sel1,
    output [63:0] c
);
    assign c = (sel1 == 1'b0 && sel2 == 64'd1) ? b : a;
endmodule
