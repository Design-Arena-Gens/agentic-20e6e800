// Title: Simple Parameterizable ALU
// Description: N-bit ALU supporting logic ops and add/sub with flags.

module alu #(
  parameter N = 8
) (
  input  wire [N-1:0] a,
  input  wire [N-1:0] b,
  input  wire [2:0]   op,   // 000:ADD 001:SUB 010:AND 011:OR 100:XOR 101:SLT
  output reg  [N-1:0] y,
  output reg          carry,
  output reg          zero
);
  wire [N:0] add = {1'b0, a} + {1'b0, b};
  wire [N:0] sub = {1'b0, a} + {1'b0, ~b} + 1'b1;

  always @* begin
    y = {N{1'b0}};
    carry = 1'b0;
    case (op)
      3'b000: begin y = add[N-1:0]; carry = add[N]; end
      3'b001: begin y = sub[N-1:0]; carry = sub[N]; end // carry=borrow out
      3'b010: y = a & b;
      3'b011: y = a | b;
      3'b100: y = a ^ b;
      3'b101: y = ($signed(a) < $signed(b)) ? {{(N-1){1'b0}}, 1'b1} : {N{1'b0}};
      default: y = {N{1'b0}};
    endcase
    zero = (y == {N{1'b0}});
  end
endmodule
