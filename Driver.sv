class counter_driver extends uvm_driver #(counter_txn);

  `uvm_component_utils(counter_driver)

  virtual counter_if vif;

  function new(string name = "counter_driver",
               uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual counter_if)::get(
          this, "", "vif", vif))
      `uvm_fatal("DRV", "Virtual interface not configured")
  endfunction

  task drive_dut(counter_txn tx);

    @(vif.driver_cb);

    vif.driver_cb.rst     <= tx.rst;
    vif.driver_cb.enable  <= tx.enable;
    vif.driver_cb.up_down <= tx.up_down;

    `uvm_info("DRV",
      $sformatf("Driving rst=%0b enable=%0b up_down=%0b",
                tx.rst, tx.enable, tx.up_down),
      UVM_MEDIUM)

  endtask

  task run_phase(uvm_phase phase);

    counter_txn tx;

    `uvm_info("DRV", "Driver started", UVM_LOW)

    forever begin
      seq_item_port.get_next_item(tx);
      drive_dut(tx);
      seq_item_port.item_done();
    end

  endtask

endclass
