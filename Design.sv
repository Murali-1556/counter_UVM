module counter (
  input  logic       clk,
  input  logic       rst,
  input  logic       enable,
  input  logic       up_down,
  output logic [3:0] dout
);

  always_ff @(posedge clk) begin
    if (rst)
      dout <= 4'd0;
    else if (enable) begin
      if (up_down) begin
        if (dout == 4'd11)
          dout <= 4'd0;
        else
          dout <= dout + 1'b1;
      end
      else begin
        if (dout == 4'd0)
          dout <= 4'd11;
        else
          dout <= dout - 1'b1;
      end
    end
  end

endmodule
