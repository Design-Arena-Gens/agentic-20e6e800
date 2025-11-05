// Title: Synchronous Up Counter with Enable and Reset
// Description: Parameterizable N-bit counter with active-low synchronous reset and enable.

module counter #(
  parameter N = 8
) (
  input  wire           clk,
  input  wire           rst_n, // active low synchronous reset
  input  wire           en,
  output reg  [N-1:0]   q
);
  always @(posedge clk) begin
    if (!rst_n) begin
      q <= {N{1'b0}};
    end else if (en) begin
      q <= q + 1'b1;
    end
  end
endmodule
