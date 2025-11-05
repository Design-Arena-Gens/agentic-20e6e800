// Title: UART Transmitter (8N1)
// Description: Simple UART TX for 8 data bits, no parity, 1 stop bit.

module uart_tx #(
  parameter CLKS_PER_BIT = 16
) (
  input  wire       clk,
  input  wire       rst_n,       // active-low sync reset
  input  wire       tx_start,
  input  wire [7:0] tx_data,
  output reg        txd,
  output reg        tx_busy
);
  localparam IDLE  = 3'd0,
             START = 3'd1,
             DATA  = 3'd2,
             STOP  = 3'd3;

  reg [2:0]  state;
  reg [3:0]  bit_idx;
  reg [15:0] clk_cnt; // supports CLKS_PER_BIT up to 65535
  reg [7:0]  shreg;

  wire bit_done = (clk_cnt == CLKS_PER_BIT-1);

  always @(posedge clk) begin
    if (!rst_n) begin
      state   <= IDLE;
      txd     <= 1'b1; // idle high
      tx_busy <= 1'b0;
      bit_idx <= 4'd0;
      clk_cnt <= 16'd0;
      shreg   <= 8'h00;
    end else begin
      case (state)
        IDLE: begin
          txd     <= 1'b1;
          tx_busy <= 1'b0;
          clk_cnt <= 16'd0;
          bit_idx <= 4'd0;
          if (tx_start) begin
            shreg   <= tx_data;
            state   <= START;
            tx_busy <= 1'b1;
          end
        end
        START: begin
          txd <= 1'b0; // start bit
          if (bit_done) begin
            clk_cnt <= 16'd0;
            state   <= DATA;
          end else begin
            clk_cnt <= clk_cnt + 16'd1;
          end
        end
        DATA: begin
          txd <= shreg[0];
          if (bit_done) begin
            clk_cnt <= 16'd0;
            shreg   <= {1'b0, shreg[7:1]};
            if (bit_idx == 4'd7) begin
              bit_idx <= 4'd0;
              state   <= STOP;
            end else begin
              bit_idx <= bit_idx + 4'd1;
            end
          end else begin
            clk_cnt <= clk_cnt + 16'd1;
          end
        end
        STOP: begin
          txd <= 1'b1; // stop bit
          if (bit_done) begin
            state   <= IDLE;
            clk_cnt <= 16'd0;
          end else begin
            clk_cnt <= clk_cnt + 16'd1;
          end
        end
      endcase
    end
  end
endmodule
