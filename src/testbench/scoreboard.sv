`include "defines.sv"

class ram_scoreboard;



  ram_transaction ref2sb_trans;
  ram_transaction mon2sb_trans;

  mailbox #(ram_transaction) mbx_rs;
  mailbox #(ram_transaction) mbx_ms;

  bit [7:0] ref_mem [bit [31:0]];
  bit [7:0] mon_mem [bit [31:0]];

  int MATCH = 0;
  int MISMATCH = 0;


  function new(mailbox #(ram_transaction) mbx_rs,
               mailbox #(ram_transaction) mbx_ms);

    this.mbx_rs = mbx_rs;
    this.mbx_ms = mbx_ms;

  endfunction



  task start();

    for(int i=0;i<`no_of_trans;i++) begin

      ref2sb_trans = new();
      mon2sb_trans = new();

      fork

        begin
          mbx_rs.get(ref2sb_trans);
          ref_mem[ref2sb_trans.address] = ref2sb_trans.data_out;

          $display("[%0t] SCOREBOARD REF : address=%0d data=%0d",
                    $time,
                    ref2sb_trans.address,
                    ref2sb_trans.data_out);
end

        begin
          mbx_ms.get(mon2sb_trans);
          mon_mem[mon2sb_trans.address] = mon2sb_trans.data_out;

          $display("[%0t] SCOREBOARD MON : address=%0d data=%0d",
                    $time,
                    mon2sb_trans.address,
                    mon2sb_trans.data_out);
        end

      join

      compare_report();

    end

  endtask


  task compare_report();

  static bit force_once = 0;

  // Force one mismatch only once
  if (!force_once) begin
    force_once = 1;
    mon_mem[mon2sb_trans.address] = ~ref_mem[ref2sb_trans.address];
  end

  if (ref_mem[ref2sb_trans.address] == mon_mem[mon2sb_trans.address]) begin

    $display("SCOREBOARD REF=%0d MON=%0d",
              ref_mem[ref2sb_trans.address],
              mon_mem[mon2sb_trans.address]);

    MATCH++;
    $display("DATA MATCH SUCCESSFUL MATCH=%0d", MATCH);

  end
  else begin
$display("SCOREBOARD REF=%0d MON=%0d",
              ref_mem[ref2sb_trans.address],
              mon_mem[mon2sb_trans.address]);

    MISMATCH++;
    $display("DATA MATCH FAILED MISMATCH=%0d", MISMATCH);

  end

endtask

endclass

                  
