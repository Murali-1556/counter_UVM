class counter_txn extends uvm_sequence_item;

  bit         clk;
  bit    rst;
  rand bit    enable;
  rand bit    up_down;
  logic [3:0] dout;

  `uvm_object_utils(counter_txn)

  //constraint c_rst {
    //rst dist {0 := 9, 1 := 1};
 // }

  constraint c_enable {
    enable dist {0 := 1, 1 := 99};
  }

  constraint c_direction {
    up_down dist {0 := 1, 1 := 1};
  }

  constraint c_reset_enable {
    if (rst)
      enable == 0;
  }

  function new(string name = "counter_txn");
    super.new(name);
  endfunction

endclass
