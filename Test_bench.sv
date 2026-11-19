`timescale 1ns/1ps
`include "counter_pkg.sv"
`include "counter_if.sv"
module top;

  import uvm_pkg::*;
  import counter_pkg::*;

  logic clk = 0;

  // Clock: 10 ns period
  always #5 clk = ~clk;

  // Interface
  counter_if intf(clk);

  // DUT
  counter dut (
    .clk     (clk),
    .rst     (intf.rst),
    .enable  (intf.enable),
    .up_down (intf.up_down),
    .dout    (intf.dout)
  );

  // Initial values
  initial begin
    intf.rst     = 1'b1;
    intf.enable  = 1'b0;
    intf.up_down = 1'b1;
  end

  // Waveform dump
  initial begin
    $dumpfile("counter_wave.vcd");
    $dumpvars(0, top);
  end

  // Configure and start UVM
  initial begin

    uvm_config_db#(virtual counter_if)::set(
      null, "uvm_test_top.*", "vif", intf
    );

    uvm_config_db#(uvm_active_passive_enum)::set(
      null, "uvm_test_top.env.agent", "active", UVM_ACTIVE
    );

    `uvm_info("TOP", "Starting Mod-12 Counter Test", UVM_LOW)

    run_test("counter_test");

  end

endmodule
