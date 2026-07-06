interface ram_if (
    input bit clk,
    input bit reset
);


  logic [7:0] data_in;
  logic [7:0] data_out;
  logic       write_enb;
  logic       read_enb;
  logic [4:0] address;


  clocking drv_cb @(posedge clk);
    default input #0 output #0;

    output data_in;
    output address;
    output write_enb;
    output read_enb;

    input reset;
  endclocking

  clocking mon_cb @(posedge clk);
    default input #0 output #0;

    input data_in;
    input data_out;
    input address;
    input write_enb;
    input read_enb;
    input reset;
  endclocking

  clocking ref_cb @(posedge clk);
    default input #0 output #0;

    input data_in;
    input address;
    input write_enb;
    input read_enb;
    input reset;
  endclocking

  modport DRV    (clocking drv_cb);
  modport MON    (clocking mon_cb);
  modport REF_SB (clocking ref_cb);

endinterface
