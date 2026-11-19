class counter_monitor extends uvm_component;

  `uvm_component_utils(counter_monitor)

  virtual counter_if vif;

  uvm_analysis_port #(counter_txn) ap;

  function new(string name = "counter_monitor",
               uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual counter_if)::get(
          this, "", "vif", vif))
      `uvm_fatal("MON", "Virtual interface not configured")
  endfunction

  task monitor_dut();

    counter_txn tx;

    @(vif.monitor_cb);

    tx = counter_txn::type_id::create("tx");

    tx.clk     = vif.clk;
    tx.rst     = vif.monitor_cb.rst;
    tx.enable  = vif.monitor_cb.enable;
    tx.up_down = vif.monitor_cb.up_down;
    tx.dout    = vif.monitor_cb.dout;

    `uvm_info("MON",
      $sformatf("clk=%0b rst=%0b enable=%0b up_down=%0b dout=%0d",
                tx.clk, tx.rst, tx.enable, tx.up_down, tx.dout),
      UVM_MEDIUM)

    ap.write(tx);

  endtask

  task run_phase(uvm_phase phase);

    `uvm_info("MON", "Monitor started", UVM_LOW)

    forever
      monitor_dut();

  endtask

endclass
