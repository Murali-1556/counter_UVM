`timescale 1ns/1ps

interface counter_if(input logic clk);

  logic rst;
  logic enable;
  logic up_down;
  logic [3:0] dout;

  // Driver clocking block
  clocking driver_cb @(posedge clk);
    default input #1step output #0;
    output rst;
    output enable;
    output up_down;
  endclocking

  // Monitor clocking block
  clocking monitor_cb @(posedge clk);
    default input #1step;
    input rst;
    input enable;
    input up_down;
    input dout;
  endclocking

endinterface
