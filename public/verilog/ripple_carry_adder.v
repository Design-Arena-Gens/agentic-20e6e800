// Title: Parameterizable Ripple-Carry Adder
// Description: N-bit adder using Verilog's vector addition; synthesizes to a ripple-carry.

module ripple_carry_adder #(
  parameter N = 8
) (
  input  wire [N-1:0] a,
  input  wire [N-1:0] b,
  input  wire         cin,
  output wire [N-1:0] sum,
  output wire         cout
);
  assign {cout, sum} = a + b + cin;
endmodule
