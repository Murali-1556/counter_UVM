class counter_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(counter_scoreboard)

  uvm_analysis_imp #(counter_txn, counter_scoreboard) ap;

  logic [3:0] expected_count;

  bit prev_rst;
  bit prev_enable;
  bit prev_up_down;

  function new(string name = "counter_scoreboard",
               uvm_component parent);
    super.new(name, parent);

    ap = new("ap", this);

    expected_count = 4'd0;

    // Initial DUT inputs in top.sv
    prev_rst      = 1'b1;
    prev_enable   = 1'b0;
    prev_up_down  = 1'b1;
  endfunction


  function void write(counter_txn tx);

    // Skip comparison while the DUT output is unknown.
    if ($isunknown(tx.dout)) begin
      `uvm_warning("SB", "DUT output is unknown. Skipping comparison.")

      // Remember inputs for the next clock cycle.
      prev_rst      = tx.rst;
      prev_enable   = tx.enable;
      prev_up_down  = tx.up_down;

      return;
    end

    // Predict the output using the inputs from the previous sample.
    if (prev_rst) begin
      expected_count = 4'd0;
    end
    else if (prev_enable) begin

      if (prev_up_down) begin
        if (expected_count == 4'd11)
          expected_count = 4'd0;
        else
          expected_count = expected_count + 1'b1;
      end

      else begin
        if (expected_count == 4'd0)
          expected_count = 4'd11;
        else
          expected_count = expected_count - 1'b1;
      end

    end

    // Compare predicted output with DUT output.
    if (tx.dout === expected_count) begin

      `uvm_info("SB",
        $sformatf(
          "PASS: Expected=%0d Actual=%0d | rst=%0b enable=%0b up_down=%0b",
          expected_count, tx.dout,
          prev_rst, prev_enable, prev_up_down
        ),
        UVM_MEDIUM
      )

    end
    else begin

      `uvm_error("SB",
        $sformatf(
          "FAIL: Expected=%0d Actual=%0d | rst=%0b enable=%0b up_down=%0b",
          expected_count, tx.dout,
          prev_rst, prev_enable, prev_up_down
        )
      )

    end

    // Save current inputs for the next comparison.
    prev_rst      = tx.rst;
    prev_enable   = tx.enable;
    prev_up_down  = tx.up_down;

  endfunction

endclass
