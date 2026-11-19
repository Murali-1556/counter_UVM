class counter_agent extends uvm_agent;

  `uvm_component_utils(counter_agent)

  uvm_active_passive_enum active = UVM_ACTIVE;

  counter_sequencer seqr;
  counter_driver    drv;
  counter_monitor   mon;

  function new(string name = "counter_agent",
               uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(uvm_active_passive_enum)::get(
          this, "", "active", active))
      active = UVM_ACTIVE;

    mon = counter_monitor::type_id::create("mon", this);

    if (active == UVM_ACTIVE) begin
      seqr = counter_sequencer::type_id::create("seqr", this);
      drv  = counter_driver::type_id::create("drv", this);
    end

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (active == UVM_ACTIVE)
      drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass
