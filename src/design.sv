module RAM(
    input        clk,
    input        reset,        // Active low reset
    input  [4:0] address,
    input  [7:0] data_in,
    input        write_enb,
    input        read_enb,
    output reg [7:0] data_out
);

    // RAM Memory
    reg [7:0] memory [0:31];

   
    always @(posedge clk)
    begin
        if (!reset)
        begin
           
            memory[address] <= 8'b0;
        end
        else if (write_enb && !read_enb)
        begin
            memory[address] <= data_in;
        end
    end


    always @(posedge clk)
    begin
        if (!reset)
        begin
            data_out <= 8'b0;
        end
        else if (read_enb && !write_enb)
        begin
            data_out <= memory[address];
        end
        else
        begin
            data_out <= 8'bz;
        end
    end

endmodule
