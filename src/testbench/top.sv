module top;
  import ram_pkg::*;
  bit clk;
  bit reset;

  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end


initial begin
    reset = 0;

    repeat (2) @(posedge clk);
    reset = 1;

    #200;
    reset = 0;

    #20;
    reset = 1;
end


  ram_if intrf(clk, reset);


  RAM DUV (
      .data_in   (intrf.data_in),
      .write_enb (intrf.write_enb),
      .read_enb  (intrf.read_enb),
      .data_out  (intrf.data_out),
      .address   (intrf.address),
       .clk       (clk),
      .reset     (reset)
  );



  ram_test tb = new(intrf.DRV, intrf.MON, intrf.REF_SB);


  initial begin
    tb.run();
  end


  initial begin
    #5000;
    $finish;
  end

endmodule

