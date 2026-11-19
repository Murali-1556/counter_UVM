class counter_sequence extends uvm_sequence #(counter_txn);

  `uvm_object_utils(counter_sequence)

  function new(string name = "counter_sequence");
    super.new(name);
  endfunction

  task body();

    counter_txn tx;

    `uvm_info("SEQ", "Sequence started", UVM_LOW)

    repeat (60) begin

      tx = counter_txn::type_id::create("tx");

      start_item(tx);

      if (!tx.randomize())
        `uvm_fatal("SEQ", "Randomization failed")

      finish_item(tx);

      `uvm_info("SEQ",
        $sformatf("rst=%0b enable=%0b up_down=%0b",
                  tx.rst, tx.enable, tx.up_down),
        UVM_MEDIUM)

    end

    `uvm_info("SEQ", "Sequence completed", UVM_LOW)

  endtask

endclass
