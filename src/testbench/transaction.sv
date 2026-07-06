class ram_transaction;

  rand bit [7:0] data_in;
  rand bit       write_enb;
  rand bit       read_enb;
  rand bit [4:0] address;

  // DUT Output
  bit [7:0] data_out;


  constraint wr_rd_c {
    {write_enb, read_enb} inside {
      2'b00,
      2'b01,
      2'b10,
      2'b11
    };
  }


  virtual function ram_transaction copy();

    copy = new();

    copy.data_in   = this.data_in;
    copy.write_enb = this.write_enb;
    copy.read_enb  = this.read_enb;
    copy.address   = this.address;
    copy.data_out  = this.data_out;

    return copy;

  endfunction

endclass
