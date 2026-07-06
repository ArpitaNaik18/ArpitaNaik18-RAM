`include "defines.sv"

class ram_monitor;


  // Transaction Handle
  ram_transaction mon_trans;

  // Mailbox : Monitor -> Scoreboard
  mailbox #(ram_transaction) mbx_ms;

  // Virtual Interface
  virtual ram_if.MON vif;

 

  covergroup mon_cg;

    DATA_OUT : coverpoint mon_trans.data_out
    {
      bins dout = {[0:255]};
    }

  endgroup



  function new(
      virtual ram_if.MON vif,
      mailbox #(ram_transaction) mbx_ms
  );

    this.vif    = vif;
    this.mbx_ms = mbx_ms;

    mon_cg = new();

  endfunction


  task start();
 repeat(4) @(vif.mon_cb);

    for(int i=0;i<`no_of_trans;i++) begin

      mon_trans = new();

      @(vif.mon_cb);

      mon_trans.data_out = vif.mon_cb.data_out;
      mon_trans.address  = vif.mon_cb.address;

      $display("[%0t] MONITOR : data_out=%0d address=%0d",
                $time,
                mon_trans.data_out,
                mon_trans.address);

      // Send transaction to scoreboard
      mbx_ms.put(mon_trans);

      // Sample coverage
      mon_cg.sample();

      $display("OUTPUT FUNCTIONAL COVERAGE = %0.2f%%",
                mon_cg.get_coverage());

      @(vif.mon_cb);

    end

  endtask

endclass
