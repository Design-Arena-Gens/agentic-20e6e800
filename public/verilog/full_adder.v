// Title: 1-bit Full Adder
// Description: Single-bit full adder producing sum and carry-out.

module full_adder (
  input  wire a,
  input  wire b,
  input  wire cin,
  output wire sum,
  output wire cout
);
  assign {cout, sum} = a + b + cin;
endmodule
