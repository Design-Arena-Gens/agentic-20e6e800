// Title: Traffic Light Controller FSM
// Description: Simple three-state Moore FSM for traffic light sequencing.

module fsm_traffic_light (
  input  wire clk,
  input  wire rst_n, // active-low sync reset
  output reg  red,
  output reg  yellow,
  output reg  green
);
  typedef enum logic [1:0] { S_RED=2'b00, S_GREEN=2'b01, S_YELLOW=2'b10 } state_t;
  state_t state, next;

  // state register
  always @(posedge clk) begin
    if (!rst_n) state <= S_RED; else state <= next;
  end

  // next-state logic (round-robin)
  always @* begin
    case (state)
      S_RED:    next = S_GREEN;
      S_GREEN:  next = S_YELLOW;
      default:  next = S_RED;
    endcase
  end

  // output logic (Moore)
  always @* begin
    red = 1'b0; yellow = 1'b0; green = 1'b0;
    case (state)
      S_RED:    red    = 1'b1;
      S_GREEN:  green  = 1'b1;
      S_YELLOW: yellow = 1'b1;
    endcase
  end
endmodule
