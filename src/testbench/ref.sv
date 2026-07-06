`include "defines.sv"

class ram_reference_model;


  ram_transaction ref_trans;

  mailbox #(ram_transaction) mbx_dr;
  mailbox #(ram_transaction) mbx_rs;

  virtual ram_if.REF_SB vif;

  bit [7:0] MEM [bit [31:0]];


  function new(
      mailbox #(ram_transaction) mbx_dr,
      mailbox #(ram_transaction) mbx_rs,
      virtual ram_if.REF_SB vif
  );

    this.mbx_dr = mbx_dr;
    this.mbx_rs = mbx_rs;
    this.vif    = vif;

  endfunction



  task start();

    for(int i=0;i<`no_of_trans;i++) begin

      mbx_dr.get(ref_trans);

      @(vif.ref_cb);

      if(ref_trans.write_enb && !ref_trans.read_enb)
        MEM[ref_trans.address] = ref_trans.data_in;

      $display("[%0t] REF MODEL : MEM[%0d] = %0d",
                $time,
                ref_trans.address,
                MEM[ref_trans.address]);
  $display("[%0t] REF MODEL : data_out = %0d",
                $time,
                ref_trans.data_out);

      mbx_rs.put(ref_trans);

    end

  endtask

endclass
