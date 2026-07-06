`include "defines.sv"

class ram_driver;

 ram_transaction drv_trans;

  mailbox #(ram_transaction) mbx_gd;
  mailbox #(ram_transaction) mbx_dr;

  virtual ram_if.DRV vif;


  covergroup drv_cg;

    WRITE   : coverpoint drv_trans.write_enb { bins wrt[] = {0,1}; }
    READ    : coverpoint drv_trans.read_enb  { bins rd[]  = {0,1}; }
    DATA_IN : coverpoint drv_trans.data_in   { bins data  = {[0:255]}; }
    ADDRESS : coverpoint drv_trans.address   { bins addr  = {[0:31]}; }

    WRXRD : cross WRITE, READ;

  endgroup



  function new(mailbox #(ram_transaction) mbx_gd,
               mailbox #(ram_transaction) mbx_dr,
               virtual ram_if.DRV vif);

    this.mbx_gd = mbx_gd;
    this.mbx_dr = mbx_dr;
    this.vif    = vif;

    drv_cg = new();

  endfunction



  task start();
 repeat(1) @(vif.drv_cb);

    for(int i=0;i<`no_of_trans;i++) begin

      mbx_gd.get(drv_trans);

      if(vif.drv_cb.reset == 0) begin

        @(vif.drv_cb);

        vif.drv_cb.write_enb <= 0;
        vif.drv_cb.read_enb  <= 0;
        vif.drv_cb.data_in   <= 0;
        vif.drv_cb.address   <= 0;

        mbx_dr.put(drv_trans);

        @(vif.drv_cb);

        $display("[%0t] DRIVER RESET : data_in=%0d write_enb=%0b read_enb=%0b address=%0d",
                  $time,
                  vif.drv_cb.data_in,
                  vif.drv_cb.write_enb,
                  vif.drv_cb.read_enb,
                  vif.drv_cb.address);

      end
      else begin

        @(vif.drv_cb);

        vif.drv_cb.write_enb <= drv_trans.write_enb;
        vif.drv_cb.read_enb  <= drv_trans.read_enb;
        vif.drv_cb.data_in   <= drv_trans.data_in;
        vif.drv_cb.address   <= drv_trans.address;

        @(vif.drv_cb);

        $display("[%0t] DRIVER : data_in=%0d write_enb=%0b read_enb=%0b address=%0d",
                  $time,
                  vif.drv_cb.data_in,
                  vif.drv_cb.write_enb,
                  vif.drv_cb.read_enb,
                  vif.drv_cb.address);

        vif.drv_cb.write_enb <= 0;
        vif.drv_cb.read_enb  <= 0;
 mbx_dr.put(drv_trans);

        drv_cg.sample();

        $display("INPUT FUNCTIONAL COVERAGE = %0.2f%%",
                 drv_cg.get_coverage());

      end

    end

  endtask

endclass
